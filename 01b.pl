#!/usr/bin/perl

use v5.40;

use List::Util qw(sum);

my @left;
my %frequencies;
while (<>) {
    @_ = split;
    push @left, $_[0];
    ++$frequencies{ $_[1] };
}
say sum(map { $_ * ($frequencies{$_} // 0) } @left);
