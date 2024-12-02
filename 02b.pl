#!/usr/bin/perl

use v5.40;

use List::Util qw(all);

my $safe_count;
while (<>) {
    my @levels = split;
    if (is_safe(map { [ $levels[$_], $levels[ $_ + 1 ] ] } 0..($#levels - 1))) {
        ++$safe_count;
        next;
    }
    foreach (0..$#levels) {
        my @damp = @levels;
        splice @damp, $_, 1;
        if (is_safe(map { [ $damp[$_], $damp[ $_ + 1 ] ] } 0..($#damp - 1))) {
            ++$safe_count;
            last;
        }
    }
}
say $safe_count;

sub is_safe {
    return ((all { $_->[0] > $_->[1] } @_ or all { $_->[0] < $_->[1] } @_)
            and all { $_ >= 1 and $_ <= 3 } map { abs($_->[0] - $_->[1]) } @_);
}
