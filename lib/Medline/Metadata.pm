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

sub split_and_create_citation_files {
    my $self = shift;

    die $self->filepath() . ' does not exist!' unless -e $self->filepath();
    unless ( -e $self->dir() ) {
        make_path( $self->dir() );
    }

    my $doc = XML::LibXML->load_xml( location => $self->filepath() );
    my $root = $doc->documentElement();
    my @citations = $root->getChildrenByTagName('MedlineCitation');
    foreach my $citation (@citations) {
        my $pmid = $citation->findvalue('PMID' );
        my $path = $self->dir() . '/' . $pmid . '.xml';
        open my $fh, '>:encoding(UTF-8)', $path or die "Can't write to $path";
        print $fh $citation->toString();
        close $fh;
    }
    return;
}

sub delete_citation_files {
    my $self = shift;
    remove_tree( $self->dir() );
    return;
}
1;
