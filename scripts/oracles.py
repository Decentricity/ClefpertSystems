"""Backend-independent oracle contract and SWI-Prolog implementation."""
from __future__ import annotations
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
from typing import Protocol

ROOT = Path(__file__).resolve().parents[1]
# Input contracts are engineering glue, not historical input menus.
FIELDS = {
    'impact': ('pollutant', 'environment'),
    'standard': ('pollutant',),
    'impact_se': ('activity', 'factor'),
    'indirect_impact': ('from', 'to'),
    'soc_ec': ('activity',),
    'mitigation': ('activity',),
    'method': ('pollutant', 'technique'),
    'unit': ('pollutant',),
    'criterion': ('criterion',),
    'score_pair': ('answer_1', 'answer_2'),
}


def canonical(value):
    return json.dumps(value, sort_keys=True, ensure_ascii=False, separators=(',', ':'), allow_nan=False)


def digest(value):
    return hashlib.sha256(canonical(value).encode()).hexdigest()


def load_provenance():
    # provenance.yaml intentionally uses the JSON subset of YAML 1.2.
    return json.loads((ROOT / 'knowledge_base/provenance.yaml').read_text())


def validate_inputs(inputs):
    if not isinstance(inputs, dict) or not isinstance(inputs.get('kind'), str):
        raise ValueError('Inputs must be an object with a string kind')
    kind = inputs['kind']
    if kind not in FIELDS or set(inputs) != {'kind', *FIELDS[kind]}:
        raise ValueError(f'Unsupported query or fields: {kind}')
    if any(not isinstance(inputs[key], str) or not inputs[key] for key in FIELDS[kind]):
        raise ValueError('All query values must be nonempty strings')
    if kind == 'score_pair' and any(inputs[k] not in ('yes', 'no') for k in FIELDS[kind]):
        raise ValueError('Scoring answers must be yes or no')
    if kind == 'criterion' and inputs['criterion'] not in {c['id'] for c in load_provenance()['criteria']}:
        raise ValueError('Unknown criterion')


class Oracle(Protocol):
    def evaluate(self, inputs: dict) -> dict: ...
    def evaluate_many(self, inputs: list[dict]) -> list[dict]: ...
    def fingerprint(self) -> str: ...
    def domain(self) -> list[dict]: ...


class PrologOracle:
    def __init__(self):
        self.executable = os.environ.get('SWIPL') or shutil.which('swipl')
        if not self.executable:
            raise RuntimeError('SWI-Prolog required; install swipl or set SWIPL. No fallback oracle is used.')
        self.bridge = ROOT / 'knowledge_base/oracle_bridge.pl'

    def _request(self, request):
        process = subprocess.run(
            [self.executable, '-q', '-f', 'none', '-s', str(self.bridge), '-g', 'oracle_bridge:main'],
            input=canonical(request), text=True, capture_output=True, timeout=30)
        if process.returncode:
            raise RuntimeError(f'Prolog failed: {process.stderr.strip()}')
        return json.loads(process.stdout)

    def evaluate_many(self, inputs):
        for item in inputs:
            validate_inputs(item)
        return self._request({'action': 'evaluate', 'inputs': inputs})

    def evaluate(self, inputs):
        return self.evaluate_many([inputs])[0]

    def domain(self):
        result = self._request({'action': 'domain'})
        for item in result:
            validate_inputs(item)
        return result

    def fingerprint(self):
        # Include execution glue and schema/provenance, not just domain clauses.
        files = [ROOT / 'knowledge_base' / name for name in
                 ('esc1.pl', 'oracle_bridge.pl', 'provenance.yaml')]
        files.append(Path(__file__))
        return digest({p.relative_to(ROOT).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest()
                       for p in files})


def read_jsonl(path):
    with Path(path).open() as stream:
        return [json.loads(line) for line in stream if line.strip()]


def write_jsonl(path, records):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(''.join(canonical(row) + '\n' for row in records))


def query_text(inputs):
    return ('Return only the JSON decision for the documented thesis subset. '
            'Use undocumented when this subset cannot support an answer. Inputs: ' + canonical(inputs))
