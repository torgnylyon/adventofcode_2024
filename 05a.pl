#!/usr/bin/perl

use v5.40;

use List::Util qw(any);

my $result;
my %rules;
LINE:
while (<>) {
    chomp;
    if (/(\d+)\|(\d+)/) {
        push @{ $rules{$1} }, $2
    } elsif (/\d+,/) {
        my @pages = split /,/;
        foreach my $i (1..$#pages) {
            foreach my $j (0..($i - 1)) {
                next unless defined $rules{ $pages[$i] };
                next LINE if any { $pages[$j] == $_ } @{ $rules{ $pages[$i] } };
            }
        }
        $result += $pages[$#pages / 2];
    }
}
say "$result";
