"""Fetch EPA's live reference table for review; never silently modify the frozen KB."""
import argparse
from datetime import datetime, timezone
import hashlib
from html.parser import HTMLParser
import json
from pathlib import Path
import urllib.request

URL = 'https://www.epa.gov/criteria-air-pollutants/naaqs-table'


class TableParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.depth = 0
        self.cell = None
        self.rows = []
        self.row = []
        self.attributes = {}
        self.text = []

    def handle_starttag(self, tag, attrs):
        if tag == 'table':
            self.depth += 1
        if self.depth and tag == 'tr':
            self.row = []
        if self.depth and tag in ('td', 'th'):
            self.cell = []
            self.attributes = dict(attrs)

    def handle_data(self, data):
        self.text.append(data)
        if self.cell is not None:
            self.cell.append(data)

    def handle_endtag(self, tag):
        if self.depth and tag in ('td', 'th') and self.cell is not None:
            self.row.append({'text': ' '.join(''.join(self.cell).split()),
                             **{k: v for k, v in self.attributes.items() if k in ('rowspan', 'colspan')}})
            self.cell = None
        if self.depth and tag == 'tr' and self.row:
            self.rows.append(self.row)
        if tag == 'table':
            self.depth -= 1


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=Path('.source-cache/current-standards-review.json'))
    args = parser.parse_args()
    response = urllib.request.urlopen(URL, timeout=45)
    raw = response.read()
    document = TableParser()
    document.feed(raw.decode('utf-8'))
    if not document.rows or 'Averaging Time' not in json.dumps(document.rows[0]):
        raise ValueError('Unexpected EPA table structure; review manually')
    text = ' '.join(' '.join(document.text).split())
    marker = 'Last updated on '
    last_updated = text.split(marker, 1)[1].split(' Assistance', 1)[0] if marker in text else None
    evidence = {'url': URL, 'publisher': 'US Environmental Protection Agency', 'title': 'NAAQS Table',
                'retrieved_on': datetime.now(timezone.utc).date().isoformat(),
                'page_last_updated_text': last_updated,
                'response_sha256': hashlib.sha256(raw).hexdigest(), 'table_rows': document.rows,
                'review_required': 'Compare levels, statistical forms and footnotes before changing the frozen profile.'}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(evidence, indent=2, ensure_ascii=False) + '\n')
    print(f'Fetched {len(document.rows) - 1} table rows for review: {args.output}')


if __name__ == '__main__':
    main()
