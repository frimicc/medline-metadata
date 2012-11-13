use strict;
use warnings;

package Medline::RabbitCitation;

use XML::Rabbit::Root;
has_xpath_value 'pmid'  => '/MedlineCitation/PMID';
has_xpath_value 'title' => '/MedlineCitation/Article/ArticleTitle';
has_xpath_value 'abstract' => '//AbstractText';

finalize_class();
1;
