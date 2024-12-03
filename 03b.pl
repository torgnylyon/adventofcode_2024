#!/usr/bin/perl

use v5.40;

my $is_enabled = 1;
my $result;
s/mul\((\d+),(\d+)\)|(do\(\))|don't\(\)/
    if (defined $1 and defined $2 and $is_enabled) {
        $result += $1 * $2;
    } elsif (defined $3) {
        $is_enabled = 1;
    } else {
        $is_enabled = 0;
    }
/eg while (<>);
say $result;
