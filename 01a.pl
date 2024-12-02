#!/usr/bin/perl

use v5.40;

use List::Util qw(pairmap sum zip);

my (@left, @right);
while (<>) {
    @_ = split;
    push @left, $_[0];
    push @right, $_[1];
}
say sum(map { abs($_->[0] - $_->[1]) } zip([sort @left], [sort @right]));
