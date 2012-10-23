use strict;
use warnings;

package Medline::Journal;

# ABSTRACT: Encapsulates a Medline Journal XML file

use XML::XPath;
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
        my $xp = XML::XPath->new( filename => $self->filepath() );

        $self->issn(
            $xp->findvalue('/Journal/ISSN[@IssnType="Print"]')->value() );
        $self->title( $xp->findvalue('/Journal/Title')->value() );
        $self->abbreviation(
            $xp->findvalue('/Journal/ISOAbbreviation')->value() );
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
