#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

my $inFile = $ARGV[0];

open(my $inFH, '<', $inFile) or die "Cannot open $inFile \n";
while(my $line = $inFH->getline()){
    if($line =~ m/^GroupOne/){
        print $line;
    }
    elsif($line =~ m/^GroupTwo/){
        print $line;
    }
    elsif($line =~ m/^Name\s+/){
        print $line;
    }
    else{
        my @la = split(/\t+/,$line);

        unless(scalar(@la) == 6){
            next;
        }

        if(($la[1] == 0 && $la[4] == 0) || ($la[2] == 0 && $la[3] == 0)){
            print $line;
        }
    }
}
