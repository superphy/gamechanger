#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use Parallel::ForkManager;

my $inputDirectory = $ARGV[0];
my $outputDirectory = $ARGV[1];
my $fileNames = _getFileNamesFromDirectory($inputDirectory);

my $forker = Parallel::ForkManager->new(3);

foreach my $file(@{$fileNames}){
    $forker-> start and next;
        my $name = $file;
        $name =~ s/\W//g;
        my $sistrLine = 'sistr -f csv -T /tmp/ -o ' . $outputDirectory . '/' . $name . '.csv ' . $inputDirectory . $file;
        system($sistrLine);
    $forker->finish;
}
$forker->wait_all_children;


=head3 _getFileNamesFromDirectory

Opens the specified directory, excludes all filenames beginning with '.' and
returns the rest as an array ref.

=cut

sub _getFileNamesFromDirectory{
    my $directory = shift;

    opendir( DIRECTORY, $directory ) or die "cannot open directory $directory $!\n";
    my @dir = readdir DIRECTORY;
    closedir DIRECTORY;

    my @fileNames;
    foreach my $fileName(@dir){
        next if substr( $fileName, 0, 1 ) eq '.';
        next if -d $fileName;
        push @fileNames, ($fileName);
    }

    return \@fileNames;
}
