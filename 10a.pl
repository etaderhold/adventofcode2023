$west = [0, -1];
$east = [0, 1];
$north = [-1, 0];
$south = [1, 0];

%mappings = (
  '|' => [$north, $south],
  '-' => [$east, $west],
  'L' => [$north, $east],
  'J' => [$north, $west],
  'X' => [$south, $west],
  'F' => [$south, $east]
);

for (<>) {
  $line++;
  chomp;
  # We're going to assign numbers to the grid later, change 7 to something else.
  s/7/X/g;
  @chars = split //;
  for ($i = 0; $i < @chars; $i++) {
    $grid{"$line,$i"} = $chars[$i];
    if ($chars[$i] eq 'S') {
      $start_row = $line;
      $start_col = $i;
    }
  }
}

$left = $grid{$start_row . ',' . ($start_col - 1)};
$right = $grid{$start_row . ',' . ($start_col + 1)};
$up = $grid{($start_row - 1) . ',' . $start_col};
$down = $grid{($start_row + 1) . ',' . $start_col};
if ($left eq '-' || $left eq 'L' || $left eq 'F') {
  push @coords, [$start_row, $start_col - 1];
}
if ($right eq '-' || $right eq 'J' || $right eq 'X') {
  push @coords, [$start_row, $start_col + 1];
}
if ($up eq '|' || $up eq 'X' || $up eq 'F') {
  push @coords, [$start_row - 1, $start_col];
}
if ($down eq '|' || $down eq 'L' || $down eq 'J') {
  push @coords, [$start_row + 1, $start_col];
}

$grid{"$start_row,$start_col"} = 0;
@prev_coords = ([$start_row, $start_col], [$start_row, $start_col]);

while ($grid{$coords[0]->[0] . ',' . $coords[0]->[1]} =~ /[^\d]/) {
  @new_coords = ();
  $distance++;
  for (0..1) {
    $next_coords = get_next($coords[$_], $prev_coords[$_]);
    push @new_coords, get_next($coords[$_], $prev_coords[$_]);
    $grid{"$row,$col"} = $distance;
  }

  @prev_coords = @coords;
  @coords = @new_coords;
}

print "$distance\n";

sub get_next {
  my $current = shift;
  my $prev = shift;

  ($row, $col) = @{$current};
  ($prev_row, $prev_col) = @{$prev};

  my $current_cell = $grid{"$row,$col"};

  $cell_mappings = $mappings{$current_cell};

  if ($prev_row == $row + $cell_mappings->[0]->[0] && $prev_col == $col + $cell_mappings->[0]->[1]) {
    return [$row + $cell_mappings->[1]->[0], $col + $cell_mappings->[1]->[1]];
  } else {
    return [$row + $cell_mappings->[0]->[0], $col + $cell_mappings->[0]->[1]];    
  }
}
