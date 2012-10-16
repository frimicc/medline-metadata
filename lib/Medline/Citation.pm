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
    $self->pmid($xml->PMID());

}
 
no Moose;
__PACKAGE__->meta->make_immutable;

1;
