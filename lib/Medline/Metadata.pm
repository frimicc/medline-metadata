use strict;
use warnings;

package Medline::Metadata;

# ABSTRACT: Encapsulates a Medline Metadata XML file

use Moose;
use XML::LibXML;
use File::Path qw(make_path remove_tree);

has 'filepath' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'dir' => (
    is  => 'rw',
    isa => 'Str',
);

has 'use_subdirs' => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

sub split_and_create_citation_files {
    my $self = shift;

    die $self->filepath() . ' does not exist!' unless -e $self->filepath();

    my $doc       = XML::LibXML->load_xml( location => $self->filepath() );
    my $root      = $doc->documentElement();
    my @citations = $root->getChildrenByTagName('MedlineCitation');
    foreach my $citation (@citations) {
        my $pmid = $citation->findvalue('PMID');

        my $dir = $self->medline_path($pmid);
        make_path( $dir ) unless ( -e $dir );
        my $path = $dir . '/' . $pmid . '.xml';

        open my $fh, '>:encoding(UTF-8)', $path or die "Can't write to $path";
        print $fh $citation->toString();
        close $fh;
    }
    return;
}

sub medline_path {
    my $self = shift;
    my $pmid = shift;
    my ($dir);

    if ( $self->use_subdirs() ) {
        my $subdir = substr( $pmid, -3 );
        $dir = $self->dir() . '/' . $subdir;
    }
    else {
        $dir = $self->dir();
    }

    return $dir;
}

sub delete_citation_files {
    my $self = shift;
    remove_tree( $self->dir() );
    return;
}
1;
