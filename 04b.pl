#!/usr/bin/perl

use v5.40;

use List::Util qw(any);

my $xmas_count = 0;
my @lines;
push @lines, $_ while (<>);
chomp @lines;
foreach my $line (1..($#lines - 1)) {
    foreach my $column (1..(length($lines[0]) - 2)) {
        if (get_letter($line, $column) eq 'A') {
            my $s;
            foreach ([-1, -1], [-1, 1], [1, -1], [1, 1]) {
                $s .= get_letter($line + $_->[0], $column + $_->[1]);
            }
            ++$xmas_count if any { $s eq $_ } qw(MMSS SSMM MSMS SMSM);
        }
    }
}
say "$xmas_count";

sub get_letter($line, $column) {
    return substr $lines[$line], $column, 1;
}
