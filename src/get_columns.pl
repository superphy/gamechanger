#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

my $inFile = $ARGV[0];
my $term = $ARGV[1];

open(my $inFH, '<', $inFile) or die "$!";
while(my $line = $inFH->getline){
    if($. == 1){
        my @la = split(/\s+/, $line);

        #start at 1, so the number matches the field used in linux cut command
        my $count = 1;
        foreach my $l(@la){
            if($l eq $term){
                print $count . "\n";
            }
            $count++;
        }
    }
    else{
        last;
    }
}