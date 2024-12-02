#!/usr/bin/perl

use v5.40;

use List::Util qw(all);

my $safe_count;
while (<>) {
    my @levels = split;
    my @pairs = map { [ $levels[$_], $levels[ $_ + 1 ] ] } 0..($#levels - 1);
    ++$safe_count if ((all { $_->[0] > $_->[1] } @pairs
            or all { $_->[0] < $_->[1] } @pairs)
            and all { $_ >= 1 and $_ <= 3 }
            map { abs($_->[0] - $_->[1]) } @pairs);
}
say $safe_count;
