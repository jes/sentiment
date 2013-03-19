#!/usr/bin/perl
# store training data for sentiment analysis
# James Stanley 2013

use strict;
use warnings;

use lib 'lib';

use CGI;

my $cgi = CGI->new;

my $class = $cgi->param('type');
my $line = $cgi->param('words');

$line =~ s/\n/ /g;

open (my $fh, '>>', 'training.list')
  or die "can't append training.list: $!";
print $fh "$class\t$line\n";
close $fh;

print "Content-Type: text/plain\r\n\r\nOK\n";
