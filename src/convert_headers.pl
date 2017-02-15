#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';

my $inFile = $ARGV[0];

open(my $inFH, '<', $inFile) or die "$!";

while(my $line = $inFH->getline()){

    $line =~ s/\R//g;
    my @la = split('\s+', $line);

    if($. == 1){
        foreach my $header(@la){
            my $name;
            if($header =~ m/(GCA_\d+)_/){
                $name = $1;
            }
            else{
                warn "$header has no name\n";
                next;
            }
            print "\t" . $name;
        }
        print "\n";
    }
    else{
        print join("\t", @la) . "\n";
    }
}

