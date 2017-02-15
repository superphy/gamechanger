#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my $inFile = $ARGV[0];
my $bestOrFull = $ARGV[1] // 'best';

open(my $inFH, '<', $inFile) or die "$!";

my %functionalCounts = ();
while(my $line = $inFH->getline()){
    my @la = split(/\t/, $line);

    my $annos = $la[1];
    my @tempFuncs = split('>', $annos);

    my @funcs;
    if($bestOrFull eq 'best'){
        @funcs = (lc($tempFuncs[0]));
    }
    else{
        @funcs = @tempFuncs;
    }

    foreach my $f (@funcs) {
        if($f =~ m/^.+\|\s?(.+)\sprotein/){
            $functionalCounts{$1}++ // ($functionalCounts{$1}=1);
        }
        elsif($f =~ m/^.+\|\s?(.+)(\s\[)/){
            $functionalCounts{$1}++ // ($functionalCounts{$1}=1);
        }
        elsif($f =~ m/^.+\|\s?(.+),/){
            $functionalCounts{$1}++ // ($functionalCounts{$1}=1);
        }
        elsif($f =~ m/Full=([\w\-\s]+)/){
             $functionalCounts{$1}++ // ($functionalCounts{$1}=1);
        }
        elsif($f =~ m/^.+\|\s?(.+)/){
            warn("Using last");
            $functionalCounts{$1}++ // ($functionalCounts{$1}=1);
        }
        else{
            warn "Cannot find function for $f\n";
        }
    }
}

my @values = values %functionalCounts;
my $sumOfValues;
map {$sumOfValues += $_} @values;

foreach my $k(reverse sort {$functionalCounts{$a} <=> $functionalCounts{$b}} keys %functionalCounts){
    my $outputValue;
    if($bestOrFull eq 'full'){
        $outputValue =  sprintf("%.1f", $functionalCounts{$k} / $sumOfValues * 100);
    }
    else{
        $outputValue = $functionalCounts{$k};
    }
    print $k . "\t" . $outputValue . "\n";
}