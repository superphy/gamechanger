#!/usr/bin/env python

import Bio.Blast.NCBIXML
from sys import argv

blast_file = argv[1]
blastFH = open(blast_file)
blast_records = Bio.Blast.NCBIXML.parse(blastFH)

for blast_record in blast_records:

    for alignment in blast_record.alignments:
        print(blast_record.query.strip() + "\t" + alignment.title.strip())
        break

