"""Execute scripted daily consultations and render traceable EIA-support reports.

The only decision engine is SWI-Prolog. Report rendering uses its saved outputs;
scripted dates/roles are synthetic, and execution timestamps are recorded separately.
"""
from __future__ import annotations
import argparse
from collections import Counter
from datetime import datetime, timezone
import hashlib
from html import escape
import json
from pathlib import Path
import subprocess
import sys

from oracles import ROOT, PrologOracle, canonical, digest, normalize_inputs

CSS = '''
:root{color-scheme:light}*{box-sizing:border-box}body{margin:0;background:#eef2f6;color:#182535;font:16px/1.55 Arial,sans-serif}
main{max-width:1180px;margin:28px auto;padding:32px;background:white;border:1px solid #d7e0e8;border-radius:10px}
h1{font-size:30px;line-height:1.25;margin:12px 0}h2{font-size:22px;border-top:1px solid #dde5ed;padding-top:24px;margin-top:32px}
h3{font-size:18px}.eyebrow{font-size:13px;color:#275f86;text-transform:uppercase;letter-spacing:1px}.note{padding:16px;background:#f5f8fb;border-left:4px solid #6386a2}
.grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}.card{padding:18px;border:1px solid #dce5ec;border-radius:6px}.big{font-size:27px;font-weight:bold}.muted{color:#526779}
pre{font:13px/1.5 monospace;white-space:pre-wrap;overflow-wrap:anywhere;padding:18px;background:#f4f7fa;border:1px solid #dce5ec;border-radius:6px}
table{border-collapse:collapse;width:100%;margin:12px 0;font-size:14px}th,td{text-align:left;vertical-align:top;border-bottom:1px solid #dde5ed;padding:10px}th{background:#f1f5f8}
.badge{display:inline-block;padding:4px 9px;border-radius:4px;background:#e7eef5;font-size:13px;font-weight:bold}.urgent_review,.exceeds_reference{background:#ffe8dc;color:#8f330a}.insufficient_data,.below_detection_limit{background:#fff0c2;color:#795800}.within_reference,.no_detected_impact,.measurable{background:#deefe5;color:#185639}
a{color:#245e92}li{margin:7px 0}code{font-family:monospace;overflow-wrap:anywhere}.footer{margin-top:28px;font-size:12px;color:#607486}.break{overflow-wrap:anywhere}
'''


def pretty(value):
    return json.dumps(value, indent=2, ensure_ascii=False, allow_nan=False)


def badge(value):
    return f'<span class="badge {escape(value, quote=True)}">{escape(value)}</span>'


def page(title, body):
    return '<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width"><title>' + escape(title) + '</title><style>' + CSS + '</style></head><body><main>' + body + '</main></body></html>'


def table(headers, rows):
    return '<table><thead><tr>' + ''.join('<th>' + escape(str(h)) + '</th>' for h in headers) + '</tr></thead><tbody>' + ''.join('<tr>' + ''.join('<td>' + str(cell) + '</td>' for cell in row) + '</tr>' for row in rows) + '</tbody></table>'


def save_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(pretty(value) + '\n')


def event_html(event):
    decision = event['answer']['target']['decision']
    body = f'<div class="eyebrow">Actual SWI-Prolog consultation · synthetic task</div><h1>{escape(event["id"])}</h1>'
    body += f'<p>{escape(event["scenario_date"])} · {escape(event["time"])} · {escape(event["role"])}</p><p>{escape(event["task"])}</p>'
    body += f'<p>{badge(decision)} · expected-decision check passed</p><div class="note">Inputs are scripted. Output and rule trace below were returned by the running Prolog oracle. Scenario time is distinct from actual execution time.</div>'
    body += '<h2>Reproduce this consultation</h2><pre>' + escape('python scripts/run_oracle.py --input docs/runs/daily-use/inputs/' + event['id'] + '.json') + '</pre>'
    body += '<h2>Input JSON</h2><pre id="input">' + escape(pretty(event['inputs'])) + '</pre>'
    body += '<h2>Full Prolog output and rule trace</h2><pre id="output">' + escape(pretty(event['answer'])) + '</pre>'
    body += '<p class="footer">Executed UTC: ' + escape(event['executed_at']) + ' · input SHA-256: ' + event['input_sha256'] + '</p>'
    return page(event['id'], body)


def build_report(day, records, fingerprint):
    session = next(r for r in records if r['inputs']['kind'] == 'assess_session')
    baseline = [r for r in records if r['inputs']['kind'] in ('assess', 'assess_concentration')
                and not r['id'].endswith('-alternative')]
    rank = {'no_detected_impact': 0, 'monitor': 1, 'mitigate': 2, 'urgent_review': 3}
    priorities = [r['answer']['target']['priority'] for r in baseline if 'priority' in r['answer']['target']]
    priority = max(priorities, key=rank.get) if priorities else None
    gaps = [{'event_id': r['id'], 'decision': r['answer']['target']['decision'],
             'reason': r['answer']['target'].get('reason'),
             'unresolved_receptors': r['answer']['target'].get('unresolved_receptors', [])}
            for r in records if r['answer']['target']['decision'] in ('insufficient_data', 'below_detection_limit')]
    actions = {canonical(m): m for r in baseline for m in r['answer']['target'].get('mitigations', [])}
    social = {canonical(s): s for r in baseline for s in r['answer']['target'].get('social_impacts', [])}
    water = next(r for r in records if r['id'].endswith('-water'))
    alternative = next(r for r in records if r['id'].endswith('-alternative'))
    ambient = next(r for r in records if r['inputs']['kind'] == 'screen_ambient')
    return {'report_type': 'synthetic_environmental_impact_assessment_support', 'day_id': day['id'],
            'scenario_date': day['scenario_date'], 'title': day['title'], 'site': 'Synthetic Cement Works',
            'review_status': 'human_review_required', 'highest_reconstructed_baseline_priority': priority,
            'data_quality_and_evidence_gaps': gaps, 'documented_mitigation_recommendations': [actions[k] for k in sorted(actions)],
            'documented_social_context': [social[k] for k in sorted(social)],
            'water_scenario': water['answer']['target'], 'alternative_scenario': alternative['answer']['target'],
            'ambient_screen': ambient['answer']['target'], 'session': session['answer']['target'],
            'source_event_ids': [r['id'] for r in records], 'consultations': records,
            'oracle_fingerprint': fingerprint,
            'limitations': ['Synthetic inputs and scripted roles, not real measurements or observed human use',
                            'Historical importance scores and Warner-Preston aggregation are approximate/inferred',
                            'Instrument fixtures do not calibrate synthetic magnitude inputs',
                            'Alternative inputs do not establish measured mitigation effectiveness',
                            'US ambient screening reviews supplied statistical summaries, not daily readings or legal attainment',
                            'Fixed thesis methodology grades, including NEPA conformity, do not certify compliance']}


def report_html(report):
    body = '<div class="eyebrow">Daily environmental impact assessment support</div><h1>' + escape(report['title']) + '</h1>'
    body += '<p>' + escape(report['site']) + ' · synthetic workday ' + escape(report['scenario_date']) + '</p>'
    body += '<div class="note"><strong>Scripted simulation — human review required.</strong> This is an assessment-support report from an approximate reconstructed expert system, not a statutory EIA. The magnitude fixtures, observations and ambient summaries are synthetic and independent.</div>'
    body += '<h2>Review summary</h2><div class="grid"><div class="card"><div class="muted">Highest reconstructed baseline priority</div>' + badge(report['highest_reconstructed_baseline_priority'] or 'unresolved') + '</div><div class="card"><div class="muted">Consultations executed</div><div class="big">' + str(len(report['consultations'])) + '</div></div><div class="card"><div class="muted">Data-quality/evidence flags</div><div class="big">' + str(len(report['data_quality_and_evidence_gaps'])) + '</div></div></div>'
    rows = []
    for r in report['consultations']:
        t = r['answer']['target']
        rows.append([escape(r['time']), escape(r['role']), f'<a href="consultations/{r["id"]}.html">{escape(r["inputs"]["kind"])}</a>', badge(t['decision'])])
    body += '<h2>Consultation ledger</h2>' + table(['Time', 'Role', 'Prolog workflow', 'Returned decision'], rows)
    body += '<h2>Air and water findings: reconstructed scoring</h2>'
    rows = []
    for r in report['consultations']:
        if r['inputs']['kind'] not in ('assess', 'assess_concentration'):
            continue
        t = r['answer']['target']
        details = ', '.join(t.get('unresolved_receptors', [])) or t.get('reason') or 'Documented pathways covered'
        rows.append([escape(r['id']), escape(r['inputs']['pollutant']), escape(str(t.get('maximum_score', 'unresolved'))), badge(t['decision']), escape(details)])
    body += table(['Consultation', 'Pollutant', 'Max inferred score', 'Decision', 'Evidence'], rows)
    body += '<p>Numerical priorities use POC score bands. Historical concentration units remain unspecified. Missing facts never become a no-impact finding.</p>'
    body += '<h2>Water pathways and alternative scenario</h2>'
    paths = report['water_scenario'].get('indirect_impacts', [])
    body += '<ul>' + ''.join('<li>' + escape(' → '.join(p['path'])) + '</li>' for p in paths) + '</ul>' if paths else '<p>No indirect effects triggered by this supplied magnitude.</p>'
    body += table(['Scenario', 'Decision', 'Maximum inferred score'], [[escape(name), badge(t['decision']), str(t.get('maximum_score', 'unresolved'))] for name,t in [('Baseline',report['water_scenario']),('Lower supplied-magnitude alternative',report['alternative_scenario'])]])
    body += '<p>The alternative is a separate synthetic input, not evidence that an intervention achieved this change.</p>'
    body += '<h2>Documented process recommendations</h2>'
    actions = report['documented_mitigation_recommendations']
    body += table(['Process', 'Recommendation returned by Prolog'], [[escape(a['process']),escape(a['action'])] for a in actions]) if actions else '<p>No mitigation was triggered by the baseline cases.</p>'
    body += '<h2>Social context returned by Prolog</h2>'
    body += table(['Process', 'Factor / importance', 'Documented potential consequences'], [[escape(s['process']), escape(s['factor'])+' / '+str(s['importance']), '<br>'.join(escape(c) for c in s['consequences']) or 'Unresolved in KB'] for s in report['documented_social_context']])
    body += '<p>Social pathways are contextual potential effects, independent of pollutant magnitude; they are not verified effects or numerical priority contributions.</p>'
    body += '<h2>Current US ambient reference screen</h2><pre id="ambient-result">' + escape(pretty(report['ambient_screen'])) + '</pre>'
    body += '<p>The supplied summary retains its declared averaging/statistical period. Daily desk review does not turn a multi-year summary into a daily reading. This screen does not determine legal attainment or Indonesian compliance.</p>'
    body += '<h2>Data-quality and unresolved evidence</h2>' + table(['Consultation', 'Flag', 'Reason / receptors'], [[escape(g['event_id']), badge(g['decision']), escape(g['reason'] or ', '.join(g['unresolved_receptors']) or 'Below documented detection limit')] for g in report['data_quality_and_evidence_gaps']])
    session = report['session']
    body += '<h2>Session-derived Warner–Preston review</h2><p>Six historical analyses were executed again by Prolog inside the session. Ambient screening and instrumentation are reviewed separately.</p>'
    body += '<pre id="session-counts">' + escape(pretty(session['observed_session_counts'])) + '</pre>'
    body += table(['Aspect', 'Inferred grade'], [[escape(k),escape(v)] for k,v in session['method_assessment']['aspect_grades'].items()])
    body += table(['Criterion', 'Inferred grade'], [[escape(k),escape(v)] for k,v in session['method_assessment']['criterion_grades'].items()])
    body += '<p>Criterion/aggregation logic is a marked reconstruction. Fixed thesis answers, including NEPA conformity, are not independent compliance certification.</p>'
    body += '<h2>Audit and review boundaries</h2><ul>' + ''.join('<li>' + escape(x) + '</li>' for x in report['limitations']) + '</ul>'
    body += '<p>Full inputs, results and rule traces are available through the consultation ledger and companion report JSON. No language model generated these decisions or report findings.</p><p class="footer break">Oracle fingerprint: ' + report['oracle_fingerprint'] + '</p>'
    return page(report['title'],body)


def verify_reports(reports, records, oracle, rejections, checks):
    fresh = oracle.evaluate_many([r['inputs'] for r in records])
    for r, answer in zip(records, fresh, strict=True):
        if canonical(r['answer']) != canonical(answer):
            raise AssertionError('Fresh Prolog replay differs: ' + r['id'])
        checks.append({'check': r['id'] + ':fresh_oracle_replay', 'passed': True})
    for report in reports:
        by_id = {r['id']:r for r in report['consultations']}
        session_record = next(r for r in report['consultations'] if r['inputs']['kind']=='assess_session')
        for inputs, target in zip(session_record['inputs']['cases'], report['session']['analyses'], strict=True):
            match = next(r for r in by_id.values() if canonical(r['inputs'])==canonical(inputs))
            if canonical(target) != canonical(match['answer']['target']):
                raise AssertionError('Report session differs from individual consultation')
            checks.append({'check': report['day_id'] + ':session_analysis_matches:' + match['id'], 'passed': True})
        if report['session']['observed_session_counts']['measurements'] != 6:
            raise AssertionError('Session measurement count is not six executed analyses')
        if len(report['session']['method_assessment']['criterion_grades']) != 20:
            raise AssertionError('Missing methodology criteria')
        if report['day_id']=='day-05' and report['documented_mitigation_recommendations']:
            raise AssertionError('Zero exposure incorrectly produces baseline mitigation')
        checks.append({'check': report['day_id'] + ':report_and_session_integrity', 'passed': True})
    if len(rejections)!=4 or not all(r['rejected'] for r in rejections):
        raise AssertionError('Malformed requests were not all rejected')
    return {'passed':True, 'accepted_consultations':len(records), 'reports':len(reports),
            'rejected_requests':len(rejections), 'fresh_replay_matches':len(fresh),
            'check_count':len(checks), 'checks':checks}


def run(plan_path, output):
    plan = json.loads(plan_path.read_text())
    output.mkdir(parents=True,exist_ok=True)
    for name in ['inputs','outputs','consultations']:
        (output/name).mkdir(exist_ok=True)
    oracle = PrologOracle()
    version = subprocess.run([oracle.executable,'--version'],capture_output=True,text=True,check=True).stdout.strip()
    fingerprint = oracle.fingerprint()
    records, reports, checks, log = [], [], [], []
    def emit(line):
        log.append(line);print(line,flush=True)
    emit('SWI-Prolog daily-use simulation | ' + version)
    emit('Synthetic scenario dates/roles; actual execution timestamps saved separately.')
    emit('Oracle fingerprint: ' + fingerprint)
    for day in plan['days']:
        day_records = []
        for event in day['events']:
            inputs = normalize_inputs(event['inputs'])
            answer = oracle.evaluate(inputs)
            if answer['target']['decision'] != event['expected_decision']:
                raise AssertionError(f'{event["id"]}: expected {event["expected_decision"]}, got {answer["target"]["decision"]}')
            r = {**event,'scenario_date':day['scenario_date'],'inputs':inputs,'answer':answer,
                 'executed_at':datetime.now(timezone.utc).isoformat(),'input_sha256':digest(inputs)}
            records.append(r);day_records.append(r)
            checks.append({'check':event['id']+':independent_expected_decision','passed':True})
            save_json(output/'inputs'/(r['id']+'.json'),inputs)
            save_json(output/'outputs'/(r['id']+'.json'),answer)
            (output/'consultations'/(r['id']+'.html')).write_text(event_html(r))
            emit(f'PASS {day["id"]} {r["time"]} {r["inputs"]["kind"]:<22} {answer["target"]["decision"]}')
        report = build_report(day,day_records,fingerprint)
        reports.append(report)
        save_json(output/('report-'+day['id']+'.json'),report)
        (output/('report-'+day['id']+'.html')).write_text(report_html(report))
        emit('REPORT ' + day['id'] + ' | human_review_required | highest baseline priority=' + str(report['highest_reconstructed_baseline_priority']))
    rejections = []
    for request in plan['invalid_requests']:
        try:
            oracle.evaluate(request['inputs'])
        except ValueError as error:
            r={**request,'rejected':True,'error':str(error)}
        else:
            raise AssertionError('Invalid request accepted: '+request['id'])
        rejections.append(r)
        save_json(output/'outputs'/('rejected-'+r['id']+'.json'),r)
        (output/'consultations'/('rejected-'+r['id']+'.html')).write_text(page('Rejected input: '+r['id'], '<div class="eyebrow">Actual validation failure</div><h1>'+escape(r['id'])+'</h1><p>Expected rejection confirmed; no assessment report finding is produced for this request.</p><pre id="rejection">'+escape(pretty(r))+'</pre>'))
        emit('PASS rejection ' + r['id'])
        checks.append({'check':r['id']+':request_rejected','passed':True})
    verification = verify_reports(reports,records,oracle,rejections,checks)
    save_json(output/'consultations.json',records)
    save_json(output/'rejections.json',rejections)
    save_json(output/'verification.json',verification)
    emit(f'VERIFIED {len(records)} fresh replay matches | {len(reports)} reports | {len(rejections)} rejections | {len(checks)} checks')
    (output/'execution.log').write_text('\n'.join(log)+'\n')
    manifest={'schema_version':1,'executed_at':datetime.now(timezone.utc).isoformat(),
              'plan_sha256':hashlib.sha256(plan_path.read_bytes()).hexdigest(),
              'runner_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
              'prolog_version':version,'oracle_fingerprint':fingerprint,'consultation_count':len(records),
              'report_count':len(reports),'rejection_count':len(rejections),
              'query_kind_counts':dict(Counter(r['inputs']['kind'] for r in records)),
              'decision_counts':dict(Counter(r['answer']['target']['decision'] for r in records)),
              'verification_passed':verification['passed'], 'check_count':len(checks),
              'limitations':plan['scope'], 'human_use':'Scripted role/workflow simulation; no human participants'}
    save_json(output/'manifest.json',manifest)
    rows = [[escape(d['scenario_date']),escape(d['title']),f'<a href="report-{d["id"]}.html">Open complete report</a>'] for d in plan['days']]
    overview='<div class="eyebrow">Executed test run</div><h1>Five-day Prolog operator simulation</h1><div class="note">Scripted daily tasks and synthetic inputs. Decisions are from SWI-Prolog; reports require human review.</div><div class="grid">'+''.join('<div class="card"><div class="big">'+str(value)+'</div><div>'+label+'</div></div>' for value,label in [(len(records),'consultations'),(len(reports),'reports'),(len(checks),'passed checks')])+'</div>'+table(['Synthetic date','Workday','Artifact'],rows)+'<h2>Runtime and verification</h2><pre>'+escape(pretty(manifest))+'</pre>'
    (output/'index.html').write_text(page('Prolog daily-use simulation',overview))
    (output/'execution.html').write_text(page('Actual execution log','<h1>Actual consultation execution log</h1><p>Captured from the simulator while invoking the SWI-Prolog oracle.</p><pre id="log">'+escape('\n'.join(log))+'</pre>'))
    return manifest


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--plan',type=Path,default=ROOT/'examples/daily_use_plan.json')
    parser.add_argument('--output',type=Path,default=ROOT/'docs/runs/daily-use')
    args=parser.parse_args()
    run(args.plan,args.output)


if __name__=='__main__':
    main()
