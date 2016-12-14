use strict;
use warnings;

my $w;
my $total = 0;
while (<>) {
  ($w) = ($_ =~ /"\s*w(\d+)\s*/);
  $total +=  $w if $w;
}
print $total;

