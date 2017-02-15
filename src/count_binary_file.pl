#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';

my $inFile = $ARGV[0];
my $cutoff = $ARGV[1] // 100;

open(my $inFH, '<', $inFile) or die "$!";

my %results=();
while(my $line = $inFH->getline()){
    next if $. == 1;
    $line =~ s/\R//g;
    my @la = split('\t', $line);
    my $name = shift @la;

    my $sum = 0;
    map {$sum += $_} @la;

    if($sum >= $cutoff){
        $results{$name}=$sum;
    }

}

foreach my $k(sort keys %results){
    print $k . '\t' . $results{$k} . "\n";
}


