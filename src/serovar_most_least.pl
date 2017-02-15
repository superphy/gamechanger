#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my $inFile = $ARGV[0];
my $minimumGenomeNumber = $ARGV[1] // 10;

open(my $inFH, '<', $inFile) or die "$!";

my %results;
while(my $line = $inFH->getline()){
    next if $.==1;
    $line =~ s/\R//g;
    my @la = split(/\s+/, $line);

    if($la[5] == 1){
        if(defined $results{$la[2]} && defined $results{$la[2]}->{core}){
            $results{$la[2]}->{core} = $results{$la[2]}->{core} + $la[3];
            $results{$la[2]}->{genomes} = $results{$la[2]}->{genomes} + 1;
        }
        else{
            $results{$la[2]}->{core}=$la[3];
            $results{$la[2]}->{genomes}=1;
        }
    }
    else{
        #skip
        next;
    }
}
#print Dumper(%results);

my %finalResult;
foreach my $k(keys %results){
    if($results{$k}->{genomes} >= $minimumGenomeNumber){
        $finalResult{$k} = $results{$k}->{core} / $results{$k}->{genomes};
    }
}

foreach my $k(reverse sort {$finalResult{$a} <=> $finalResult{$b}} keys %finalResult){
    print $k . "\t" . sprintf("%.1f", $finalResult{$k}) . "\n";
}
