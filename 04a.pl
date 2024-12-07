#!/usr/bin/perl

use v5.40;

my @letters    = split //, 'XMAS';
my $word_count = 0;
my @lines;
push @lines, $_ while (<>);
chomp @lines;
foreach my $line (0..$#lines) {
    foreach my $column (0..(length($lines[0]) - 1)) {
        foreach my $direction ([-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 1],
                               [1, 0], [1, -1], [0, -1]) {
            ++$word_count if has_word($line, $column, $direction);
        }
    }
}
say "$word_count";

sub has_word {
    my ($line, $column, $direction) = @_;
    foreach my $i (0..$#letters) {
        my $letter = get_letter($line + $i * $direction->[0],
                                $column + $i * $direction->[1]);
        return unless (defined $letter and $letter eq $letters[$i]);
    }
    return 1;
}

sub get_letter($line, $column) {
    return ($line >= 0 and $column >= 0
            and $line <= $#lines and $column < length($lines[0]))
    ? substr($lines[$line], $column, 1) : undef;
}

