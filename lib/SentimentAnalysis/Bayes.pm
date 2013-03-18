package SentimentAnalysis::Bayes;

use strict;
use warnings;

sub new {
    my ($pkg, %opts) = @_;

    my $self = bless {
        %opts,
        nwords => {},
        totalwords => 0,
    }, $pkg;

    $self->load;

    return $self;
}

sub add {
    my ($self, $word, $category) = @_;

    $self->{nwords}{$category}{lc $word}++;
    $self->{nwords}{$category}{TOTAL}++;
    $self->{totalwords}++;
}

sub classify {
    my ($self, $wordcounts) = @_;

    my %score;

    foreach my $word (keys %$wordcounts) {
        foreach my $category (keys %{ $self->{nwords} }) {
            my $count = $self->{nwords}{$category}{$word} || 0.1;
            $score{$category} += log($count / $self->{nwords}{$category}{TOTAL});
        }
    }

    my $bestscore;
    my $bestcat;
    foreach my $category (keys %score) {
        $score{$category} += log($self->{nwords}{$category}{TOTAL} / $self->{totalwords});

        if (!defined $bestscore || $score{$category} < $bestscore) {
            $bestscore = $score{$category};
            $bestcat = $category;
        }
    }

    return $bestcat;
}

sub load {
    my ($self) = @_;

    return if not -r $self->{filename};

    $self->{nwords} = {};

    open( my $fh, '<', $self->{filename} )
        or die "can't read $self->{filename}: $!";
    while (<$fh>) {
        chomp;
        my ($category, $word, $count) = split /\t/;
        $self->{nwords}{$category}{$word} += $count;
        $self->{totalwords} += $count;
    }
    close $fh;
}

sub save {
    my ($self) = @_;

    open( my $fh, '>', $self->{filename} )
        or die "can't write $self->{filename}: $!";
    foreach my $category (keys %{ $self->{nwords} }) {
        foreach my $word (keys %{ $self->{nwords}{$category} }) {
            print $fh "$category\t$word\t$self->{nwords}{$category}{$word}\n";
        }
    }
    close $fh;
}

1;
