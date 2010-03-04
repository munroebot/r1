package RegularEmployee;
sub new {
    my ($name,$age,$starting_position,$monthly_salary,$months_worked) = @_;
    my $r_employee = {
        "name" => $name,
        "age" => $age,
        "position" => $starting_position,
        "monthly_salary" => $monthly_salary,
        "months_worked" => $months_worked,
    };
    bless $r_employee, "RegularEmployee";
    return $r_employee;
}

sub compute_ytd_income {
    my $r_emp = shift;
    return ($r_emp->{'monthly_salary'} * $r_emp->{'months_worked'});
}

package HourlyEmployee;
sub new {
    my ($hourly_rate) = @_;
    my $r_employee = {
        "hourly_rate" => $hourly_rate,
    };
    bless $r_employee, "HourlyEmployee";
    return $r_employee;
}

1;

__END__

=pod

=head1 NAME

Employee - Base Class for an Employee Object

=head1 SYNOPSIS

use Employee;

my $dash = Dashboard("Your Application Name");
$dash->send_cluepacket("context", 1, [{'data' => 'test data'}]);

The arguments to send_cluepacket are, in order:
    * context - the application context of the cluepacket
    * focus   - a boolean, indicating whether the application is
                currently focused
    * clues   - the list of clues

That last argument to send_cluepacket is a listref of hashrefs.  Each
hash has a 'data' key, which is the clue contents, and optionally a
'type' key and a 'relevance' key.

The values of 'type' and 'relevance' are described in doc/cluepacket.txt
in the dashboard distribution.

At the moment, type can be one of:
    * date
    * fullname
    * email
    * imname
    * url
    * keyword
    * textblock

relevance is an integer between 1 and 10, inclusive.  10 is the most
relevant a clue can be, 1 is the least.

=head1 DESCRIPTION

=head1 AUTHORS

Brian Munroe <brian.munroe@ymp.gov>

=cut
