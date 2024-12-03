#!/usr/bin/perl

use v5.40;

my $result;
s/mul\((\d+),(\d+)\)/ $result += $1 * $2 /eg while (<>);
say $result;
