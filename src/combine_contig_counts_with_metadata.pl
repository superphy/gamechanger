#!/usr/bin/env perl

use strict;
use warnings;

my $countFile = $ARGV[0];
my $metaFile = $ARGV[1];

open(my $countFH, '<', $countFile) or die "$!";

my %counts = ();
while(my $line = $countFH->getline()){
    $line =~ s/\R//g;
    my @la = split(/\s+/, $line);

    $counts{$la[0]}->{core} = $la[1];
    $counts{$la[0]}->{contigs} = $la[2];
}

open(my $metaFH, '<', $metaFile) or die "$!";

while(my $line = $metaFH->getline()){
    if($. ==1){
        print "name\tsubspecies\tserovar\tcore\tcontigs\n";
        next;
    }

    $line =~ s/\R//g;
    my @la = split(/\s+/,$line);

    if(defined $counts{$la[0]}){
        print join("\t", ($la[0], $la[1], $la[2], $counts{$la[0]}->{core}, $counts{$la[0]}->{contigs})) . "\n";
    }
    else{
        warn ("$la[0] is not defined\n");
    }

}

