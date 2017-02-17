#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

my $inFile = $ARGV[0];

open(my $inFH, '<', $inFile) or die "$!";

my $count=0;
while(my $line = $inFH->getline()){
    if($. == 1){
        print $line;
    }
    else{
        print 'snp_' . $count . "\t" . $line;
    }
    $count++;
}
