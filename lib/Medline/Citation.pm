use strict;
use warnings;

package Medline::Citation;

# ABSTRACT: Encapsulates a Medline Citation XML file

use XML::Simple;
use DateTime;
use Moose;
use Medline::Journal;

has 'filepath' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'pmid' => (
    is  => 'rw',
    isa => 'Str',
);

has 'created' => (
    is  => 'rw',
    isa => 'DateTime',
);

has 'completed' => (
    is  => 'rw',
    isa => 'DateTime',
);

has 'revised' => (
    is  => 'rw',
    isa => 'DateTime',
);

has 'title' => (
    is  => 'rw',
    isa => 'Str',
);

has 'abstract' => (
    is  => 'rw',
    isa => 'Str',
);

has 'journal' => ( 
    is => 'rw',
    isa => 'Medline::Journal',
);

sub BUILD {
    my $self = shift;

    die unless -e $self->filepath();

    my $xml = XMLin( $self->filepath() );
    $self->pmid( $xml->{PMID}{content} );

    $self->created( $self->make_date( 'DateCreated', $xml ) );
    $self->completed( $self->make_date( 'DateCompleted', $xml ) );
    $self->revised( $self->make_date( 'DateRevised', $xml ) );

    $self->title( $xml->{Article}{ArticleTitle} );

    my $abstract = $xml->{Abstract}{AbstractText};
    $abstract = $xml->{OtherAbstract}{AbstractText}
        unless defined $abstract;
    $self->abstract($abstract);

    my $journal = Medline::Journal->new(
        issn => $xml->{Article}{Journal}{ISSN}{content}, 
        title => $xml->{Article}{Journal}{Title}, 
        abbreviation => $xml->{Article}{Journal}{ISOAbbreviation}, 
    );
    $self->journal($journal); 

}

sub make_date {
    my ( $self, $type, $xml ) = @_;
    my $dt = DateTime->new(
        year  => $xml->{$type}{Year},
        month => $xml->{$type}{Month},
        day   => $xml->{$type}{Day},
    );
    return $dt;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
