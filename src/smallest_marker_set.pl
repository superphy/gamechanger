#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';

my $inFile = $ARGV[0];

open(my $inFH, '<', $inFile) or die "$!";

#get all columns, initialize to 0
my %columns = ();
my %rows = ();
my @finalMarkers;

while(my $line = $inFH->getline()){
    $line =~ s/\R//g;
    my @la = split(/\t/, $line);

    #need data line, otherwise skip
    unless(scalar(@la) > 1){
        next;
    }

    my $count=0;
    my $rowLabel;
    foreach my $l(@la){
        if($. == 1){
            unless($count == 0){
                $columns{$count} = 0;
            }
        }
        else{
            if($count ==0){
                $rowLabel=$l;
            }
            else{
                $rows{$rowLabel}->{$count}=$l;
            }
        }
        $count++;
    }
}

#run loop until all columns are minimized
while(1){
    #get columns that are at zero
    my $columnsAtZero = _getColumnsAtZero(\%columns);
    print STDERR "Number to minimize: " .  @{$columnsAtZero} . "\n";

    if(defined $columnsAtZero->[0]){
        #iterate through all rows, find top minimizer
        push @finalMarkers, _getBestMinimizer($columnsAtZero);
    }
    else{
        last;
    }
}

foreach my $marker(@finalMarkers){
    print "$marker\n";
}



#functions
sub _getBestMinimizer{
    my $cols = shift;

    my %newRows = ();

    foreach my $row(keys %rows){

        my $count=0;
        foreach my $c(@{$cols}){
           #only looking at columns that had 0, so counting values is okay
           $count += $rows{$row}->{$c};
        }
        $newRows{$row}=$count;
    }
    #return the row with the highest number, which is also the fewest zeroes
    my @sortedKeys = reverse sort {$newRows{$a} <=> $newRows{$b}} keys %newRows;

    #need to update the %columns, with all new values that had 1
    #for the selected locus
    foreach my $value(keys %{$rows{$sortedKeys[0]}}){
        $columns{$value} += $rows{$sortedKeys[0]}->{$value};
    }
    return $sortedKeys[0];
}

sub _getColumnsAtZero{
    my $columns = shift;

    my @colAtZero;
    foreach my $k(keys %{$columns}){
        if($columns->{$k} == 0){
             push @colAtZero, $k;
        }
    }
    return \@colAtZero;
}