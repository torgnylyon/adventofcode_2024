#!/usr/bin/perl

use v5.40;

use List::Util qw(reduce);

my @DIMENSIONS = (101, 103);
my @robots;
while (<>) {
    /p=(?<x>\d+),(?<y>\d+) v=(?<vx>-?\d+),(?<vy>-?\d+)/ and push @robots, {%+};
}
foreach (1..100) {
    move_robot($_, @DIMENSIONS) foreach @robots;
}
say reduce { $a * $b } map {
    my $quadrant = $_;
    scalar grep { is_robot_in_quadrant($_, $quadrant) } @robots
} make_quadrants(@DIMENSIONS);

sub move_robot {
    my ($robot, $width, $height) = @_;
    $robot->{x} = (($robot->{x} + $robot->{vx}) % $width); 
    $robot->{y} = (($robot->{y} + $robot->{vy}) % $height); 
}

sub is_robot_in_quadrant {
    my ($robot, $quadrant) = @_;
    return ($robot->{x} >= $quadrant->[0]
            and $robot->{y} >= $quadrant->[1]
            and $robot->{x} <= $quadrant->[2]
            and $robot->{y} <= $quadrant->[3]);
}

sub make_quadrants {
    return (
        [ 0, 0, int($_[0] / 2) - 1, int($_[1] / 2) - 1 ],
        [ int($_[0] / 2) + 1, 0, $_[0] - 1, int($_[1] / 2) - 1 ],
        [ 0, int($_[1] / 2) + 1, int($_[0] / 2) - 1, $_[1] - 1 ],
        [ int($_[0] / 2) + 1, int($_[1] / 2) + 1, $_[0] - 1, $_[1] - 1 ]
    );
}
