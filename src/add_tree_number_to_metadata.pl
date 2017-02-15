#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

my $inFile = $ARGV[0];
open(my $inFH, '<', $inFile) or die "$!";

my $count = 0;
while(my $line = $inFH->getline()){
    print $count . "\t" . $line;
    $count++
}