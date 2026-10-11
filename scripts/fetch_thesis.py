"""Fetch publicly served chapter PDFs via the ITB viewer; never store tokens."""
import argparse
import hashlib
import http.cookiejar
import json
from pathlib import Path
import re
import subprocess
import urllib.request

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / '.source-cache')
    args = parser.parse_args()
    manifest = json.loads((ROOT / 'docs/evidence/source-manifest.json').read_text())
    args.output.mkdir(parents=True, exist_ok=True)
    opener = urllib.request.build_opener(
        urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()))
    with opener.open(manifest['source_url'], timeout=40) as response:
        response.read()
    for chapter in manifest['chapters']:
        with opener.open(chapter['viewer_endpoint'], timeout=40) as response:
            viewer = json.load(response)['url']
        with opener.open(viewer, timeout=40) as response:
            html = response.read().decode()
        stream = re.search(r'data-url="([^"]+)"', html)
        if not stream:
            raise RuntimeError(f"No public PDF viewer for {chapter['name']}")
        with opener.open(stream.group(1), timeout=40) as response:
            data = response.read()
        if not data.startswith(b'%PDF'):
            raise RuntimeError('Library response is not a PDF')
        if hashlib.sha256(data).hexdigest() != chapter['sha256']:
            raise RuntimeError(f"Source changed: {chapter['name']}; review before replacing evidence")
        pdf = args.output / (chapter['name'] + '.pdf')
        pdf.write_bytes(data)
        subprocess.run(['pdftotext', '-layout', str(pdf), str(pdf.with_suffix('.txt'))], check=True)
        print(chapter['name'], 'verified')


if __name__ == '__main__':
    main()
