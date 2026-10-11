"""Executable-oracle contract; no paper content is converted into model records."""
from __future__ import annotations
import copy
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
from typing import Protocol

ROOT = Path(__file__).resolve().parents[1]


def canonical(value):
    return json.dumps(value, sort_keys=True, ensure_ascii=False, separators=(',', ':'), allow_nan=False)


def digest(value):
    return hashlib.sha256(canonical(value).encode()).hexdigest()


def load_provenance():
    return json.loads((ROOT / 'knowledge_base/provenance.yaml').read_text())


def normalize_inputs(inputs):
    if not isinstance(inputs, dict) or not isinstance(inputs.get('kind'), str):
        raise ValueError('Inputs require an object with string kind')
    inputs = copy.deepcopy(inputs)
    for key in ('processes', 'receptors'):
        if key in inputs:
            if not isinstance(inputs[key], list) or not inputs[key] or any(
                    not isinstance(item, str) for item in inputs[key]):
                raise ValueError(f'{key} must contain nonempty string lists')
            if len(set(inputs[key])) != len(inputs[key]):
                raise ValueError(f'Duplicate {key}')
            inputs[key].sort()
    for key in ('magnitude', 'concentration', 'observed_value'):
        if key in inputs:
            if type(inputs[key]) not in (int, float):
                raise ValueError(f'{key} must be numeric')
            inputs[key] = float(inputs[key])
    canonical(inputs)  # Reject NaN/infinity before passing anything to Prolog.
    return inputs


class Oracle(Protocol):
    def evaluate(self, inputs: dict) -> dict: ...
    def evaluate_many(self, inputs: list[dict]) -> list[dict]: ...
    def fingerprint(self) -> str: ...
    def domain(self) -> dict: ...


class PrologOracle:
    """Execute any Prolog module exporting evaluate/3, domain/1, rule_id/1.

    Optional dependencies are explicit, so custom KB fingerprints include every
    imported domain file. No static extraction or Python fallback produces labels.
    """
    def __init__(self, kb=None, dependencies=None):
        self.executable = os.environ.get('SWIPL') or shutil.which('swipl')
        if not self.executable:
            raise RuntimeError('SWI-Prolog required; install swipl or set SWIPL. No fallback oracle is used.')
        self.kb = Path(kb or ROOT / 'knowledge_base/esc1.pl').resolve()
        if not self.kb.is_file():
            raise ValueError('Knowledge base file does not exist')
        self.bridge = ROOT / 'knowledge_base/oracle_bridge.pl'
        default = self.kb == ROOT / 'knowledge_base/esc1.pl'
        self.dependencies = [Path(p).resolve() for p in (dependencies or [])]
        if default:
            self.dependencies += [ROOT / 'knowledge_base/documented_facts.pl']
        if any(not p.is_file() for p in self.dependencies):
            raise ValueError('An oracle dependency is missing')

    def _request(self, request):
        process = subprocess.run(
            [self.executable, '-q', '-f', 'none', '-s', str(self.bridge),
             '-g', 'oracle_bridge:main', '--', str(self.kb)],
            input=canonical(request), text=True, capture_output=True, timeout=120)
        if process.returncode:
            raise ValueError(f'Prolog rejected request: {process.stderr.strip()}')
        return json.loads(process.stdout)

    def evaluate_many(self, inputs):
        inputs = [normalize_inputs(item) for item in inputs]
        # Bound requests: no single process has to handle an unbounded corpus.
        results = []
        for offset in range(0, len(inputs), 100):
            chunk = self._request({'action': 'evaluate', 'inputs': inputs[offset:offset + 100]})
            if len(chunk) != len(inputs[offset:offset + 100]):
                raise RuntimeError('Oracle did not return one answer per input')
            results.extend(chunk)
        return results

    def evaluate(self, inputs):
        return self.evaluate_many([inputs])[0]

    def domain(self):
        return self._request({'action': 'domain'})

    def rule_ids(self):
        return self._request({'action': 'rules'})

    def fingerprint(self):
        # Fingerprint executable semantics, not narrative/provenance documents.
        files = [self.kb, *self.dependencies, self.bridge, Path(__file__)]
        return digest([{ 'name': p.name, 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()}
                       for p in files])


def read_jsonl(path):
    with Path(path).open() as stream:
        return [json.loads(line) for line in stream if line.strip()]


def write_jsonl(path, records):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(''.join(canonical(row) + '\n' for row in records))


def query_text(inputs):
    return ('Evaluate this expert-system case. Return only the JSON decision, '
            'inferred impacts and recommendations. Inputs: ' + canonical(inputs))
