#!/usr/bin/env perl

use strict;
use warnings;

my $metaFile = $ARGV[0];
my $poorFile = $ARGV[1];

open(my $metaFH, '<', $metaFile) or die "$!";


my @poorQuality = ();
while(my $line = $metaFH->getline()){
    if($. ==1){
        print "name\tsubspecies\tserovar\tcore\tcontigs\tquality\n";
        next;
    }

    $line =~ s/\R//g;
    my @la = split(/\s+/, $line);

    my $name = $la[0];
    my $core = $la[3];
    my $contigs = $la[4];
    my $subspecies = $la[1];

    my $quality;
    if(($core > 250 && $contigs < 1000) || ($subspecies ne 'enterica')){
        $quality = 1;
    }
    else{
        $quality = 0;
        push @poorQuality, $name;
    }

    print $line . "\t" . $quality . "\n";
}

open(my $poorFH, '>', $poorFile) or die "$!";

$poorFH->print(join("\n", @poorQuality));


