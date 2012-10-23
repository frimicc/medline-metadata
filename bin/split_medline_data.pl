#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: split_medline_data.pl
#
#        USAGE: ./split_medline_data.pl
#
#  DESCRIPTION: This is a driving script that will let you set up a directory
#  full of Medline Citation XML files, given a single large
#  NLMMedlineCitationSet file.
#
#      VERSION: 1.0
#      CREATED: 10/22/2012 21:59:57
#     REVISION: ---
#===============================================================================

# PODNAME: split_medline_data
# ABSTRACT: This is a driving script that will let you set up a directory full of Medline Citation XML files, given a single large NLMMedlineCitationSet file.

use strict;
use warnings;

use Medline::Metadata;
use Getopt::Long;

my $USAGE = <<END_USAGE;
This script reads in an NLMMedlineCitationSet XML file and creates individual
Citation XML files for each included Citation.

Usage: 
$0.pl [-use_subdirs] -dir <output directory> file1.xml [file2.xml...]

END_USAGE

my ( $output_dir, $use_subdirs );
GetOptions(
    'h|help' => sub { print $USAGE; exit; },
    'd|dir=s'       => \$output_dir,
    's|use_subdirs' => \$use_subdirs,
);
my @files = @ARGV;

unless ( defined $output_dir && $output_dir && scalar(@files) > 0 ) {
    print $USAGE;
    exit;
}

foreach my $filename (@files) {
    unless ( -e $filename ) {
        die "File $filename not found.\n";
    }

    print "Processing $filename .\n";
    my $meta = Medline::Metadata->new( filepath => $filename );
    $meta->dir($output_dir);
    $meta->use_subdirs(1) if ( defined $use_subdirs && $use_subdirs );

    my $count = $meta->split_and_create_citation_files();
    print "Created $count Citation files in $output_dir .\n";
}

