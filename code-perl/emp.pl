#!/usr/bin/perl -w

use Employee;

my $emp = RegularEmployee::new("Larry Flint",32,"Software Developer",5000,2);

my $emp2 = HourlyEmployee::new(16);

print $emp->{'name'}."\n";
print $emp2->{'hourly_rate'}."\n";

eval {
    my $a = 10;
    my $b = 1;
    my $c = $a / $b;
    print $c."\n";
};

print $@;
