use List::Util qw(min);

for (<>) {
  chomp;
  unless ($_) {
    $sum += find_smudge() if @pattern;
    @pattern = ();
  } else {
    push @pattern, [split //];
  }
}
$sum += find_smudge() if @pattern;

print "$sum\n";

sub find_smudge {
  my $original_value = find_symmetry();
  for $row (0..@pattern - 1) {
    for $col (0..@{$pattern[0]} - 1) {
      print "Testing $row $col\n";
      flip_value($row, $col);
      $new_value = find_symmetry($original_value);
      if ($new_value && $new_value != $original_value) {
        print "$row $col $original_value $new_value\n";
        return $new_value;
      }
      flip_value($row, $col);
    }
  }
}

sub flip_value {
  my $row = shift;
  my $col = shift;

  print "$row $col\n";

  if ($pattern[$row]->[$col] eq '.') {
    $pattern[$row]->[$col] = '#';
  } else {
    $pattern[$row]->[$col] = '.';
  }

  if ($row == 1 && $col == 4) {
    for $line(@pattern) {
      for $char(@{$line}) {
        print $char;
      }
      print "\n";
    }
  }
}


sub find_symmetry {
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
    }

    return $pivot if $possible;
  }

  for $pivot (1..@pattern-1) {
    next if $pivot * 100 == $skip_value;
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