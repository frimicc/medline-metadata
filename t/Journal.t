use strict;
use warnings;

use Test::More tests => 7;
use Test::Exception;

use_ok('Medline::Journal');

isa_ok( Medline::Journal->new(), 'Medline::Journal' );

my ($journal);
ok( $journal = Medline::Journal->new( filepath => 't/sample_journaldata.xml' ),
    'Loaded sample file' );
isa_ok( $journal, 'Medline::Journal' );
is($journal->issn(), '0002-9955', 'loaded issn');
is($journal->title(), 'Journal of the American Medical Association',
    'loaded title');
is($journal->abbreviation(), 'J Am Med Assoc', 'loaded abbreviation');

