#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

my $inFile = $ARGV[0];
open(my $inFH, '<', $inFile) or die "$!";

while(my $line = $inFH->getline()){
    if($. == 1){
        print $line;
        next;
    }

    $line =~ s/\R//g;
    my @la = split('\t', $line);

    my $convertedConversion = "FAIL";
    if($la[1] =~ m/(^GCA_\d+)/){
        $convertedConversion = $1;
    }
    else{
        warn("Could not convert $line\n");
    }

    print $la[0] . "\t" . $convertedConversion . "\n";

}