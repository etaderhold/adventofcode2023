for (<>) {
  chomp;
  push @grid, [split //];
}

# Wait for a repeated grid configuration, figure out the length of the cycle,
# then get the beam load once the cycle count shares the same modulus value
# as 1 billion.
while (1) {
  $grid_val = cycle();
  if (!$period) {
    if ($last_cycle{$grid_val}) {
      $period = $cycles - $last_cycle{$grid_val};
    } else {
      $last_cycle{$grid_val} = $cycles;
    }
  } else {
    if ($cycles % $period == 1000000000 % $period) {
      print load_factor(), "\n";
      last;
    }
  }
}

sub cycle {
  $cycles++;

  # Tilt north
  do {
    $moved = 0;
    for $row (1..@grid-1) {
      for $col (0..@{$grid[0]}-1) {
        if ($grid[$row]->[$col] eq 'O' and $grid[$row-1]->[$col] eq '.') {
          $moved++;
          $grid[$row]->[$col] = '.';
          $grid[$row-1]->[$col] = 'O';
        }
      }
    }
  } while ($moved);

  # Tilt west
  do {
    $moved = 0;
    for $col (1..@{$grid[0]}-1) {
      for $row (0..@grid-1) {
        if ($grid[$row]->[$col] eq 'O' and $grid[$row]->[$col-1] eq '.') {
          $moved++;
          $grid[$row]->[$col] = '.';
          $grid[$row]->[$col-1] = 'O';
        }
      }
    }
  } while ($moved);

  # Tilt south
  do {
    $moved = 0;
    for $r (1..@grid-1) {
      $row = @grid - $r;
      for $col (0..@{$grid[0]}-1) {
        if ($grid[$row]->[$col] eq '.' and $grid[$row-1]->[$col] eq 'O') {
          $moved++;
          $grid[$row]->[$col] = 'O';
          $grid[$row-1]->[$col] = '.';
        }
      }
    }
  } while ($moved);

  # Tilt east
  do {
    $moved = 0;
    for $c (1..@{$grid[0]}-1) {
      $col = @{$grid[0]} - $c;
      for $row (0..@grid-1) {
        if ($grid[$row]->[$col] eq '.' and $grid[$row]->[$col-1] eq 'O') {
          $moved++;
          $grid[$row]->[$col] = 'O';
          $grid[$row]->[$col-1] = '.';
        }
      }
    }
  } while ($moved);

  # String representation of the current grid value to use as a hash key
  return join '', (map {join '', @{$_}} @grid);
}

sub load_factor {
  $sum = 0;
  for $row (0..@grid-1) {
    for $col (0..@{$grid[0]}-1) {
      $sum += (@grid - $row) if $grid[$row]->[$col] eq 'O';
    }
  }
  return $sum;
}
