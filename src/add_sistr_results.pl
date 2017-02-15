#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';
use Text::CSV;

my $csv = Text::CSV->new({ sep_char => ',' });


my $sistr_results = $ARGV[0];
my $metadata_file = $ARGV[1];
my $sistr_cmd_flag = $ARGV[2] // 0;

open(my $sistrFH, '<', $sistr_results) or die "$!";
open(my $metaFH, '<', $metadata_file) or die "$!";

#store all sistr results as hash, use to overwrite metadata file
my %sistrHash=();
while(my $line = $sistrFH->getline()){
    my @la;
    if($csv->parse($line)){
        @la= $csv->fields();
    }
    else{
        warn ("$line could not be parsed!\n");
    }

    #sistr gives quoted names
    #also, the command line version gives results in a different order, are not identical
    #commandline results = cgmlst_distance,cgmlst_genome_match,cgmlst_matching_alleles,genome,h1,h2,serogroup,serovar,serovar_antigen,serovar_cgmlst
    #if the "cmd" flag is set, use the correct location for the command line program, otherwise use the webserver values
    my $fileName;
    if($sistr_cmd_flag == 1){
       $fileName = $la[3];
    }
    else{
       $fileName = $la[0];
    }
    $fileName =~ s/"//g;

    my $serovar;
    if($sistr_cmd_flag == 1){
       $serovar = $la[7];
    }
    else{
        $serovar = $la[1]
    }
    $serovar =~ s/"//g;

    if($fileName =~ m/^(GCA_\d+)/){
        $sistrHash{$1}=$serovar;
    }
    else{
        warn "$fileName did not match\n";
    }
}


#update the metadata
my $counter =0;
while(my $line = $metaFH->getline()){
    my @la = split(',', $line);

    if($la[1] eq "NA"){
        $la[1] = "enterica";
    }

    if(defined $sistrHash{$la[0]}){
        print $la[0] . ',' . $la[1] . ',' . $sistrHash{$la[0]} . "\n";
        $counter++;
    }
    else{
        print $line;
    }
}

print STDERR "$counter serovars updated\n";
