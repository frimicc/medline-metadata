use strict;
use warnings;

package Medline::Journal;

# ABSTRACT: Encapsulates a Medline Journal XML file

use XML::Simple;
use Moose;

has 'filepath' => (
    is  => 'rw',
    isa => 'Str',
);

has 'issn' => (
    is  => 'rw',
    isa => 'Str',
);

has 'title' => (
    is  => 'rw',
    isa => 'Str',
);

has 'abbreviation' => (
    is  => 'rw',
    isa => 'Str',
);

sub BUILD {
    my $self = shift;

    # read from file if there is one
    if ( defined $self->filepath() && -e $self->filepath() ) {
        my $xml = XMLin( $self->filepath() );
        $self->issn( $xml->{ISSN}{content} );
        $self->title( $xml->{Title} );
        $self->abbreviation( $xml->{ISOAbbreviation} );
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
