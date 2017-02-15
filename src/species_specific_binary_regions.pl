#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';
use Data::Dumper;


my $speciesSpecificFastFile = $ARGV[0];
my $binaryFile = $ARGV[1];

open(my $ssFH, '<', $speciesSpecificFastFile) or die "$!";
open(my $binaryFH, '<', $binaryFile) or die "$!";

my %ssHeaders=();

my $counter = 0;
while(my $line = $ssFH->getline){

    if($line =~ m/>\S+(lcl\|GCA_.+)/){
        my $gca = $1;
        $counter++;
        $ssHeaders{$gca}=1;
    }
    else{
        #warn("skipping $line \n");
        next;
    }
}

while(my $line = $binaryFH->getline()){
    if($. == 1){
        print $line;
        next;
    }

    my @la = split('\t', $line);

    if(defined $ssHeaders{$la[0]}){
        print $line;
    }
}




