#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

my $poorFile = $ARGV[0];
my $dataFile = $ARGV[1];

open (my $poorFH, '<', $poorFile) or die "$!";

my %poor=();
while(my $line = $poorFH->getline()){
    $line =~ s/\R//g;
    $poor{$line}=1;
}
$poorFH->close();

my %columnNumbersToExclude=();
open(my $dataFH, '<', $dataFile) or die "$!";
while(my $line = $dataFH->getline()){
    $line =~ s/\R//g;
    my @la = split(/\s+/, $line);

    if($. == 1){
        #id the columns to remove
        my $counter = 0;
        foreach my $name(@la){
            if(defined $poor{$name}){
                $columnNumbersToExclude{$counter}=1;
            }
            $counter++;
        }
    }

    #print all but the poor quality columns
    my $counter = 0;
    foreach my $l(@la){
        if(defined $columnNumbersToExclude{$counter}){
            #exclude
        }
        else{
            #add tab
            if($counter == 0){
                #leave first column alone
            }
            else{
                print "\t";
            }
            print $l;
        }
        $counter++;
    }
    print "\n";

}