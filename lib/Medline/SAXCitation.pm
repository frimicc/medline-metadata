use strict;
use warnings;

package Medline::SAXCitation;

# ABSTRACT: Encapsulates a Medline Citation XML file

use XML::SAX::ParserFactory;
use Moose;

has 'filepath' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'pmid' => (
    is  => 'rw',
    isa => 'Str',
);

has 'title' => (
    is  => 'rw',
    isa => 'Str',
);

has 'abstract' => (
    is  => 'rw',
    isa => 'Str',
);

has 'current_element' => (
    is  => 'rw',
    isa => 'Str',
    clearer => 'clear_current',
);

sub BUILD {
    my $self = shift;

    die unless -e $self->filepath();

    my $factory = XML::SAX::ParserFactory->new();
    my $handler = $factory->parser( Handler => $self );
    $handler->parse_uri( $self->filepath() );
}

my %elem_attr_map = (
    PMID         => 'pmid',
    ArticleTitle => 'title',
    AbstractText => 'abstract',
);

sub start_element {
    my ( $self, $data ) = @_;

    $self->current_element( $elem_attr_map{ $data->{Name} } )
        if exists $elem_attr_map{ $data->{Name} };
}

sub end_element {
    my ( $self, $data ) = @_;
    $self->clear_current();
}

sub characters {
    my ( $self, $data ) = @_;
    if ( defined $self->current_element() ) {
        $self->pmid( $data->{Data} )
            if $self->current_element() eq 'pmid';
        $self->title( $data->{Data} )
            if $self->current_element() eq 'title';
        $self->abstract( $data->{Data} )
            if $self->current_element() eq 'abstract';
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
