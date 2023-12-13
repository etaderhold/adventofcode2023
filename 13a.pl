use List::Util qw(min);

for (<>) {
  chomp;
  unless ($_) {
    $sum += find_symmetry();
    @pattern = ();
  } else {
    push @pattern, [split //];
  }
}
$sum += find_symmetry();

print "$sum\n";

sub find_symmetry {
  # Look for vertical symmetry
  for $pivot (1..@{$pattern[0]}-1) {
    $possible = 1;

    $width = min($pivot, @{$pattern[0]} - $pivot);

    for $row (0..@pattern-1) {
      for $offset (0..$width-1) {
        $possible = 0 unless $pattern[$row]->[$pivot-$offset-1] eq $pattern[$row]->[$pivot+$offset];
      }
    }

    return $pivot if $possible;
  }

  # Look for horizontal symmetry
  for $pivot (1..@pattern-1) {
    $possible = 1;

    $width = min($pivot, @pattern - $pivot);

    for $col (0..@{$pattern[0]}-1) {
      for $offset (0..$width-1) {
        $possible = 0 unless $pattern[$pivot-$offset-1]->[$col] eq $pattern[$pivot + $offset]->[$col];
      }
    }

    return $pivot * 100 if $possible;
  }
}
