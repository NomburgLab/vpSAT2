#!/usr/bin/env python3
"""Download the AlphaFold DB PDB model for a UniProt ID.

Usage:
    python download_afdb.py UNIPROT_ID [OUTPUT.pdb]

If OUTPUT is omitted, the file is written to the current working directory
using the AlphaFold DB name (e.g. AF-O04147-F1-model_v6.pdb).
"""

import json
import sys
import urllib.error
import urllib.request

API = "https://alphafold.ebi.ac.uk/api/prediction/{}"


def main():
    args = sys.argv[1:]
    if not 1 <= len(args) <= 2:
        sys.exit(__doc__.strip())

    uniprot_id = args[0]
    out_path = args[1] if len(args) == 2 else None

    # The API resolves the current model version, so nothing is hardcoded.
    try:
        with urllib.request.urlopen(API.format(uniprot_id)) as r:
            entries = json.load(r)
    except urllib.error.HTTPError as e:
        sys.exit(f"error: API request for {uniprot_id} failed ({e.code} {e.reason})")

    if not entries:
        sys.exit(f"error: no AlphaFold DB model for {uniprot_id}")

    pdb_url = entries[0]["pdbUrl"]
    if out_path is None:
        out_path = pdb_url.rsplit("/", 1)[-1]

    with urllib.request.urlopen(pdb_url) as r:
        pdb = r.read()
    with open(out_path, "wb") as f:
        f.write(pdb)

    print(out_path)


if __name__ == "__main__":
    main()
