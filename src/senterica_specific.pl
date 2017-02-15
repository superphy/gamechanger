#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';

my $coreFragmentsFile = $ARGV[0];
my $blastFile = $ARGV[1];

open(my $blastFH, '<', $blastFile) or die "$!";
open(my $coreFH, '<', $coreFragmentsFile) or die "$!";

my %excludedFragments = ();
while(my $line = $blastFH->getline()){

    $line =~ s/\R//g;
    my @la = split(',', $line);

    if(defined $la[5]){
        #cool
    }
    else{
        #not cool
        #print "bu hao\n$line\n";
        next;
    }

    my $sid = $la[0];
    my $pid = $la[4];
    my $tLen = $la[5];

    if($pid >= 80 && $tLen >= 800){
        $excludedFragments{'>' . $sid} = 1;
    }
    #print $pid . ' ' . $tLen . ' ' . $sid . "\n";

}

while(my $line = $coreFH->getline()){
    $line =~ s/\R//g;

    if($line =~ m/^>/){
        if(defined $excludedFragments{$line}){
            $coreFH->getline();
            print STDERR ".";
            next;
        }
        else{
            unless($coreFH->eof()){
                print $line . "\n";
                print $coreFH->getline();
            }

        }
    }

}

#now keep only the _S. enterica genomes that did not have a match_

#foreach my $s(keys %excludedFragments){
#   print "$s\n";
#}
print STDERR "Done\n";
