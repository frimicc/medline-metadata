use strict;
use warnings;
 
package Medline::Citation;
# ABSTRACT: Encapsulates a Medline Citation XML file

use XML::Simple;
use DateTime;
use Moose;
 
has 'filepath' => (
    is  => 'rw',
    isa => 'Str',
    required => 1,
);
 
has 'pmid' => (
    is  => 'rw',
    isa => 'Str',
);
 
has 'created' => (
    is      => 'rw',
    isa     => 'DateTime',
);
 
has 'completed' => (
    is      => 'rw',
    isa     => 'DateTime',
);

has 'revised' => (
    is      => 'rw',
    isa     => 'DateTime',
);

sub BUILD {
    my $self = shift;
 
    die unless -e $self->filepath();

    my $xml = XMLin($self->filepath());
    $self->pmid($xml->{PMID}{content});

    $self->created($self->make_date('DateCreated', $xml));
    $self->completed($self->make_date('DateCompleted', $xml));
    $self->revised($self->make_date('DateRevised', $xml));
    
}
 
sub make_date {
    my ($self, $type, $xml) = @_;
    my $dt = DateTime->new(
        year       => $xml->{$type}{Year},
        month      => $xml->{$type}{Month},
        day        => $xml->{$type}{Day},
    );
    return $dt;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
