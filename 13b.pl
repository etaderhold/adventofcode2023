use List::Util qw(min);

for (<>) {
  chomp;
  unless ($_) {
    $sum += find_smudge();
    @pattern = ();
  } else {
    push @pattern, [split //];
  }
}
$sum += find_smudge();

print "$sum\n";

sub find_smudge {
  my $original_value = find_symmetry();
  for $row (0..@pattern - 1) {
    for $col (0..@{$pattern[0]} - 1) {
      flip_value($row, $col);
      $new_value = find_symmetry($original_value);
      return $new_value if $new_value;
      flip_value($row, $col);
    }
  }
}

sub find_symmetry {
  # Skip checking the original axis of symmetry when we're looking for a new one.
  my $skip_value = shift;

  # Look for vertical symmetry
  for $pivot (1..@{$pattern[0]}-1) {
    next if $pivot == $skip_value;
    $possible = 1;

    $width = min($pivot, @{$pattern[0]} - $pivot);

    for $row (0..@pattern-1) {
      for $offset (0..$width-1) {
        $possible = 0 unless $pattern[$row]->[$pivot-$offset-1] eq $pattern[$row]->[$pivot+$offset];
      }
      last unless $possible;
    }

    return $pivot if $possible;
  }

  # Look for horizontal symmetry
  for $pivot (1..@pattern-1) {
    next if $pivot * 100 == $skip_value;
    $possible = 1;

    $width = min($pivot, @pattern - $pivot);

    for $col (0..@{$pattern[0]}-1) {
      for $offset (0..$width-1) {
        $possible = 0 unless $pattern[$pivot-$offset-1]->[$col] eq $pattern[$pivot + $offset]->[$col];
      }
      last unless $possible;
    }

    return $pivot * 100 if $possible;
  }
}

sub flip_value {
  ($row, $col) = @_;
  $pattern[$row]->[$col] = $pattern[$row]->[$col] eq '.' ? '#' : '.';
}
