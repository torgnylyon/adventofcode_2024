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
                if (any { $pages[$j] == $_ } @{ $rules{ $pages[$i] } }) {
                    my @correct = order_pages(@pages);
                    $result += $correct[$#correct / 2];
                    next LINE;
                }
            }
        }
    }
}
say "$result";

sub order_pages {
    return sort { (any { $b == $_ } @{ $rules{$a} }) ? 1 : -1 } @_;
}
