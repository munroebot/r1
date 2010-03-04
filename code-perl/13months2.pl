# 13 month roll.

%months = ( 
   1 => "Jan", 2 => "Feb",
   3 => "Mar", 4 => "Apr",
   5 => "May", 6 => "Jun",
   7 => "Jul", 8 => "Aug",
   9 => "Sep", 10 => "Oct",
   11 => "Nov", 12 => "Dec",
   13 => "Jan", 14 => "Feb",
   15 => "Mar", 16 => "Apr",
   17 => "May", 18 => "Jun",
   19 => "Jul", 20 => "Aug",
   21 => "Sep", 22 => "Oct",
   23 => "Nov", 24 => "Dec",
);

$month = 1;
$year = 2005;

$lastMonth = $month + 12;
for ($i = $month; $i <= $lastMonth; $i++) {
    ($i >= 13 ? print "$months{$i} ".($year + 1)."\n" : print "$months{$i} $year\n"); 
}
