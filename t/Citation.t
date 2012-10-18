use strict;
use warnings;

use Test::More tests => 8;                      # last test to print
use Test::Exception;

use_ok('Medline::Citation');

throws_ok { Medline::Citation->new() }
qr/Attribute \(filepath\) is required /,
    'missing filepath caught okay';

my ($citation);
ok( $citation = Medline::Citation->new( filepath => 't/sample_citationdata.xml' ),
    'Loaded sample file' );
isa_ok( $citation, 'Medline::Citation' );
is($citation->pmid(), '12255379', 'loaded pmid');
is($citation->created()->ymd(), '1980-01-03', 'loaded created');
is($citation->completed()->ymd(), '1980-01-03', 'loaded completed');
is($citation->revised()->ymd(), '2011-11-17', 'loaded revised');