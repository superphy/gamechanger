#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

my $metadataFile = $ARGV[0];
my $dataFile = $ARGV[1];
my $serovarToMatch = $ARGV[2];

open(my $metaFH, '<', $metadataFile) or die "$!";
my %serovars;

while(my $line = $metaFH->getline()){
    my @la = split(/\t/,$line);
    my $name = $la[0];
    my $serovar = $la[2];

    $serovars{$name}=$serovar;
}


my %columnNumbersToKeep=();
open(my $dataFH, '<', $dataFile) or die "$!";
while(my $line = $dataFH->getline()){
    $line =~ s/\R//g;
    my @la = split(/\s+/, $line);

    if($. == 1){
        #id the columns to remove
        my $counter = 0;
        foreach my $name(@la){
            if((defined $serovars{$name}) && ($serovars{$name} eq $serovarToMatch)){
                $columnNumbersToKeep{$counter}=1;
            }
            $counter++;
        }
    }

    #print only the columns matching the serovar
    my $counter = 0;
    foreach my $l(@la){
        if($counter == 0){
            print $l;
        }

        if(defined $columnNumbersToKeep{$counter}){
            #add tab

            print "\t" . $l;

        }
        $counter++;
    }
    print "\n";
}