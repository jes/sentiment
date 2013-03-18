#!/usr/bin/perl
# train sentiment analysis (really, train a generic naive bayes classifier)
# James Stanley 2013

use strict;
use warnings;

use lib 'lib';

use SentimentAnalysis::Bayes;
use CGI;
use URI::Escape;

my $bayes = SentimentAnalysis::Bayes->new(filename => 'databayes');

my $cgi = CGI->new;

my $class = $cgi->param('type');
my $line = $cgi->param('words');

my @words = split /\s+/, $line;

foreach my $word (@words) {
    next if $word =~ /^(ht|f)tp/; # hyperlink
    next if $word =~ /["']?@/; # at-someone
    next if $word eq 'RT';

    $word = lc $word;
    $word =~ s/^[^a-z]*//;
    $word =~ s/[^a-z]*$//;
    $bayes->add($word, $class);
}

$bayes->save;

print "Content-Type: text/plain\r\n\r\nOK\n";
