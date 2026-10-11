"""Run direct SWI-Prolog commands and the regression suite; save actual transcripts."""
import argparse
from datetime import datetime, timezone
from html import escape
import json
from pathlib import Path
import shlex
import subprocess
import sys
import os

from oracles import ROOT, PrologOracle, canonical
from simulate_daily_use import page, pretty, save_json


def verify(output):
    oracle = PrologOracle()
    manifest = json.loads((output/'manifest.json').read_text())
    if manifest['oracle_fingerprint'] != oracle.fingerprint():
        raise ValueError('Simulation is stale; rerun before verification')
    executable = oracle.executable
    commands = [
        ('runtime-version',[executable,'--version'],None),
        ('direct-prolog-demo',[executable,'-q','-f','none','-s','knowledge_base/esc1.pl','-g','esc1:demo','-t','halt'],None),
        ('direct-bridge',[executable,'-q','-f','none','-s','knowledge_base/oracle_bridge.pl','-g','oracle_bridge:main','--','knowledge_base/esc1.pl'],
         canonical({'action':'evaluate','inputs':[json.loads((output/'inputs/day-03-ambient.json').read_text())]})),
        ('prolog-tests',[executable,'-q','-f','none','-s','tests/test_prototype.pl','-g','run_tests','-t','halt'],None),
        ('python-tests',[sys.executable,'-m','unittest','discover','-s','tests','-v'],None)]
    records=[]
    environment={**os.environ,'SWIPL':executable}
    for name,args,stdin in commands:
        result=subprocess.run(args,cwd=ROOT,input=stdin,text=True,capture_output=True,
                              env=environment,timeout=180)
        record={'id':name,'executed_at':datetime.now(timezone.utc).isoformat(),'argv':args,
                'cwd':str(ROOT),'stdin':stdin,'exit_code':result.returncode,
                'stdout':result.stdout,'stderr':result.stderr}
        records.append(record)
        save_json(output/(name+'.json'),record)
        transcript='$ '+shlex.join(args)+'\n'
        if stdin is not None:
            transcript+='STDIN:\n'+stdin+'\n'
        transcript+='STDOUT:\n'+result.stdout+'\nSTDERR:\n'+result.stderr+'\nEXIT CODE: '+str(result.returncode)+'\n'
        (output/(name+'.log')).write_text(transcript)
        body='<div class="eyebrow">Actual subprocess transcript</div><h1>'+escape(name)+'</h1><p>Command ran in '+escape(str(ROOT))+'. This browser view renders the saved stdout/stderr; it is not a mock terminal.</p><pre id="transcript">'+escape(transcript)+'</pre>'
        (output/(name+'.html')).write_text(page(name,body))
        if result.returncode:
            raise RuntimeError('Command failed: '+name+'; inspect saved transcript')
        if name=='direct-prolog-demo':
            decision=json.loads(result.stdout)['target']['decision']
            if decision!='urgent_review':raise AssertionError('Direct loaded Prolog demo changed')
        if name=='direct-bridge':
            expected=json.loads((output/'outputs/day-03-ambient.json').read_text())
            if canonical(json.loads(result.stdout)[0])!=canonical(expected):
                raise AssertionError('Direct bridge execution differs from recorded consultation')
        print(f'PASS {name}: actual command exit={result.returncode}',flush=True)
    save_json(output/'runtime-verification.json',{'passed':True,'commands':records,
              'direct_demo_decision':'urgent_review','direct_bridge_matches_consultation':True})
    return records


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,default=ROOT/'docs/runs/daily-use')
    verify(parser.parse_args().output)


if __name__=='__main__':
    main()
