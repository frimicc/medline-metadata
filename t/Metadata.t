use strict;
use warnings;

use Test::More tests => 15;
use Test::Exception;

use_ok('Medline::Metadata');
throws_ok { Medline::Metadata->new() }
qr/Attribute \(filepath\) is required /,
    'missing filepath caught okay';

my ($meta);
ok( $meta = Medline::Metadata->new( filepath => 't/sample_metadata.xml' ),
    'Loaded sample file' );
isa_ok( $meta, 'Medline::Metadata' );

# Test without subdirs
ok( $meta->dir('t/citations'), 'added citations dir' );
is( $meta->split_and_create_citation_files(), undef,
    'split_and_create_citation_files'
);
ok( -e $meta->dir(), 'split_and_create_citation_files created dir' );
is( $meta->delete_citation_files(), undef, 'delete_citation_files' );
is( -e $meta->dir(), undef, 'delete_citation_files removed dir' );

# Test with subdirs
ok($meta->use_subdirs(1), 'use_subdirs');
is( $meta->split_and_create_citation_files(), undef,
    'split_and_create_citation_files with subdirs'
);
ok( -e $meta->dir(), 'split_and_create_citation_files created dir' );
ok( -e $meta->dir(). '/395', 'split_and_create_citation_files created subdir' );
is( $meta->delete_citation_files(), undef, 'delete_citation_files' );
is( -e $meta->dir(), undef, 'delete_citation_files removed dir' );


