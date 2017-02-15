#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

my $inFile = $ARGV[0];

open(my $inFH, '<', $inFile) or die "$!";

#print headers
print "name,subspecies,serovar\n";

while(my $line = $inFH->getline()){
    my $name = "NA";
    my $subspecies = "NA";
    my $serovar = "NA";

    if($line =~ m/(GCA_\d+)_/){
        $name = $1;
    }
    else{
        warn "No name for $line! \n";
    }

    if($line =~ m/subsp\.\s+(\w+)/){
        $subspecies = $1;
    }
    else{
        #warn "No subspecies for $line! \n";
    }

    if($line =~ m/serovar\s+([\S]+)/){
        $serovar = $1;
    }
    else{
        #warn "No serovar for $line! \n";
    }

    print "$name,$subspecies,$serovar\n";
}
