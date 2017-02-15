#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';

use Text::CSV;
my $csv = Text::CSV->new({ sep_char => ',' });

my $inFile = $ARGV[0];

open(my $inFH, '<', $inFile) or die "$!";

my %results=();
while(my $line = $inFH->getline()){
    next if $. == 1;
    my @la;
    if($csv->parse($line)){
        @la= $csv->fields();
    }
    else{
        warn ("$line could not be parsed!\n");
    }
    ($results{$la[1]}->{$la[2]}++) // ($results{$la[1]}->{$la[2]}=1);
}

foreach my $k(sort keys %results){
    foreach my $kk(sort keys %{$results{$k}}){
        print $k . "\t" . $kk . "\t" . $results{$k}->{$kk} . "\n";
    }
}