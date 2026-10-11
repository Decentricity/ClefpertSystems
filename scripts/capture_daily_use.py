"""Take real Chromium screenshots of every saved Prolog consultation and report.

Requires Playwright and Chromium only for screenshots, not for Prolog execution.
Complete rendered JSON is checked against saved oracle results before capture.
"""
import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import shutil
import struct

from oracles import ROOT, PrologOracle, canonical
from simulate_daily_use import save_json


def capture(output, executable=None):
    from playwright.sync_api import sync_playwright
    manifest=json.loads((output/'manifest.json').read_text())
    verification=json.loads((output/'runtime-verification.json').read_text())
    if not verification['passed'] or any(c['exit_code'] for c in verification['commands']):
        raise ValueError('Runtime verification failed or is missing')
    if manifest['oracle_fingerprint']!=PrologOracle().fingerprint():
        raise ValueError('Saved execution is stale; regenerate before screenshots')
    records={r['id']:r for r in json.loads((output/'consultations.json').read_text())}
    images=output/'screenshots';images.mkdir(exist_ok=True)
    files=[output/'index.html',output/'execution.html']
    files+=sorted(output.glob('report-*.html'))
    files+=sorted((output/'consultations').glob('*.html'))
    files+=[output/(c['id']+'.html') for c in verification['commands']]
    captures=[]
    with sync_playwright() as playwright:
        browser=playwright.chromium.launch(executable_path=executable or shutil.which('chromium'),
                                           headless=True,args=['--no-sandbox'])
        context=browser.new_context(viewport={'width':1280,'height':900},device_scale_factor=1)
        page=context.new_page()
        for i,file in enumerate(files,1):
            page.set_content(file.read_text(),wait_until='load')
            page.evaluate('document.fonts.ready')
            if file.stem in records:
                record=records[file.stem]
                if canonical(json.loads(page.locator('#input').inner_text()))!=canonical(record['inputs']):
                    raise AssertionError('Rendered inputs differ from executed inputs: '+file.name)
                if canonical(json.loads(page.locator('#output').inner_text()))!=canonical(record['answer']):
                    raise AssertionError('Rendered results differ from Prolog outputs: '+file.name)
            if file.stem.startswith('report-'):
                report=json.loads(file.with_suffix('.json').read_text())
                if canonical(json.loads(page.locator('#ambient-result').inner_text()))!=canonical(report['ambient_screen']):
                    raise AssertionError('Report ambient screen differs from source JSON')
                if canonical(json.loads(page.locator('#session-counts').inner_text()))!=canonical(report['session']['observed_session_counts']):
                    raise AssertionError('Report counts differ from executed session')
            if file.stem in {c['id'] for c in verification['commands']}:
                if page.locator('#transcript').inner_text()!=(file.with_suffix('.log').read_text()):
                    raise AssertionError('Rendered subprocess transcript was altered')
            document_height=page.evaluate('Math.max(document.body.scrollHeight,document.documentElement.scrollHeight)')
            target=images/(file.stem+'.png')
            page.screenshot(path=str(target),full_page=True,animations='disabled')
            raw=target.read_bytes()
            width,height=struct.unpack('>II',raw[16:24])
            if width!=1280 or abs(height-document_height)>2:
                raise AssertionError('Screenshot dimensions indicate cropped content: '+target.name)
            captures.append({'html':str(file.relative_to(output)), 'screenshot':str(target.relative_to(output)),
                             'html_sha256':hashlib.sha256(file.read_bytes()).hexdigest(),
                             'screenshot_sha256':hashlib.sha256(raw).hexdigest(),
                             'width':width,'height':height,'full_page':True})
            if i%10==0 or i==len(files):print(f'Captured {i}/{len(files)} complete pages',flush=True)
        browser_version=browser.version
        context.close();browser.close()
    save_json(output/'screenshots.json',{'captured_at':datetime.now(timezone.utc).isoformat(),
              'browser':'Chromium','browser_version':browser_version,
              'rendering':'Local HTML supplied to Chromium with set_content; no external resources','viewport':{'width':1280,'height':900},
              'device_scale_factor':1,'count':len(captures),'captures':captures})
    return captures


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,default=ROOT/'docs/runs/daily-use')
    parser.add_argument('--browser-executable')
    args=parser.parse_args()
    capture(args.output,args.browser_executable)


if __name__=='__main__':
    main()
