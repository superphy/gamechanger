#!/usr/bin/env perl

use strict;
use warnings;

my $countFile = $ARGV[0];
my $coreFile = $ARGV[1];

open(my $countFH, '<', $countFile) or die "$!";

my %counts = ();

while(my $line = $countFH->getline()){
    $line =~ s/\R//g;
    my @la = split(':', $line);

    if($la[0] =~ m/(GCA_\d+)/){
        $counts{$1} = $la[1];
    }
    else{
        warn "Could not match $line\n";
    }
}

open(my $coreFH, '<', $coreFile) or die "$!";

while(my $line = $coreFH->getline()){
    if($. ==1){
        print "name\tNo. Core Regions\tNo. Contigs\n";
        next;
    }

    $line =~ s/\R//g;
    my @la = split(/\s+/,$line);

    if($la[0] =~ m/(GCA_\d+)/){
        print $1 . "\t" . $la[2] . "\t" . $counts{$1} . "\n";
    }
    else{
        warn "Cannot match $line\n";
    }
}

