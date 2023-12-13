# This is my initial naive solution, runs noticeably slower than the optimized
# solution in part 2 does with the 5x input logic removed.
# The code is much shorter though!

for (<>) {
  chomp;
  ($springs, $broken) = split / /;
  $sum += count_possibilities($springs, $broken);
}

print "$sum\n";

sub count_possibilities {
  my $springs = shift;
  my $broken = shift;

  if ($springs =~ /\?/) {
    my $springs1 = $springs;
    my $springs2 = $springs;
    $springs1 =~ s/\?/#/;
    $springs2 =~ s/\?/./;
    return count_possibilities($springs1, $broken) + count_possibilities($springs2, $broken);
  } else {
    @sections = map {length} split /\.+/, $springs;
    $broken_string = join ',', @sections;
    $broken_string =~ s/^0,//;
    return $broken_string eq $broken ? 1 : 0;
  }
}
