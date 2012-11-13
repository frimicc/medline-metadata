use strict;
use warnings;

use Test::More tests => 6;
use Test::Exception;

use_ok('Medline::SAXCitation');

my ($citation);
ok( $citation = Medline::SAXCitation->new( filepath => 't/sample_citationdata.xml' ),
    'Loaded sample file' );
isa_ok( $citation, 'Medline::SAXCitation' );
is($citation->pmid(), '12255379', 'loaded pmid');

my $title = "Association of maternal and fetal factors with development of mental deficiency.  1. Abnormalities in the prenatal and paranatal periods.";
is($citation->title(), $title, 'loaded title');

like($citation->abstract(), qr/Pregnancy, delivery, and neonatal records of mentally defective/, 'loaded abstract');

