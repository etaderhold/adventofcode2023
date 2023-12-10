use List::MoreUtils 'pairwise';

# Offsets to move turtle in the given direction
$west = [0, -1];
$east = [0, 1];
$north = [-1, 0];
$south = [1, 0];

# Mapping between direction letter and coordinate offsets
%direction_mappings = (
  'N' => $north,
  'S' => $south,
  'E' => $east,
  'W' => $west
);

# Mapping between current direction and which offset to use for coloring A or B
%fill_mappings = (
  'N' => [$west, $east],
  'S' => [$east, $west],
  'E' => [$north, $south],
  'W' => [$south, $north]
);

%turn_mappings = (
  'N' => ['W', 'E'],
  'S' => ['E', 'W'],
  'E' => ['N', 'S'],
  'W' => ['S', 'N']
);

# Mark the cell to the left of the turtle as 'A', and 'B' to the right.
sub color {
  $mask{coord_offset_string($coords, $fill_mappings{$direction}->[0])} = 'A';
  $mask{coord_offset_string($coords, $fill_mappings{$direction}->[1])} = 'B';
}

$move_forward = sub {
  # Mark current position as visited.
  $grid{coord_string($coords)} = 'V';

  # Move turtle by the correct offset for current direction of travel.
  $coords = [pairwise {$a + $b} @{$coords}, @{$direction_mappings{$direction}}];
  color();
};

$turn_left = sub {
  $direction = $turn_mappings{$direction} -> [0];
  color();
  $move_forward->();
};

$turn_right = sub {
  $direction = $turn_mappings{$direction} -> [1];
  color();
  $move_forward->();
};

$mark_complete = sub {
  $complete = 1;
};

# Mapping from current pipe, to movement direction upon entering the pipe, to next action.
%turtle_actions = (
  '|' => {'N' => $move_forward, 'S' => $move_forward},
  '-' => {'E' => $move_forward, 'W' => $move_forward},
  'L' => {'W' => $turn_right, 'S' => $turn_left},
  'J' => {'S' => $turn_right, 'E' => $turn_left},
  '7' => {'E' => $turn_right, 'N' => $turn_left},
  'F' => {'N' => $turn_right, 'W' => $turn_left},
  'V' => {'N' => $mark_complete, 'S' => $mark_complete, 'E' => $mark_complete, 'W' => $mark_complete},
  'S' => {'N' => $move_forward, 'S' => $move_forward, 'E' => $move_forward, 'W' => $move_forward}
);

# Read file into %grid, store starting $coords
for (<>) {
  $line++;
  chomp;
  @chars = split //;
  for ($i = 0; $i < @chars; $i++) {
    $grid{"$line,$i"} = $chars[$i];
    if ($chars[$i] eq 'S') {
      $coords = [$line, $i];
    }
  }
}

# Look around the starting position to determine starting direction.
$left = $grid{coord_offset_string($coords, $direction_mappings{'W'})};
$right = $grid{coord_offset_string($coords, $direction_mappings{'E'})};
$up = $grid{coord_offset_string($coords, $direction_mappings{'N'})};
$down = $grid{coord_offset_string($coords, $direction_mappings{'S'})};
if ($left eq '-' || $left eq 'L' || $left eq 'F') {
  $direction = 'W';
}
elsif ($right eq '-' || $right eq 'J' || $right eq '7') {
  $direction = 'E';
}
elsif ($up eq '|' || $up eq '7' || $up eq 'F') {
  $direction = 'N';
}
elsif ($down eq '|' || $down eq 'L' || $down eq 'J') {
  $direction = 'S';
}

# Move the turtle until we have completely traversed the main loop.
while (!$complete) {
  $turtle_actions{$grid{coord_string($coords)}} -> {$direction} -> ();
}

# Apply mask to squares in the grid that aren't part of the main loop.
for $row (0..$line) {
  for $col (0..$i) {
    $index = coord_string([$row, $col]);
    $masked{$index} = $grid{$index} eq 'V' ? 'V' : $mask{$index};
  }
}

# Iteratively fill in non-colored squares.
$unset = 1;
while ($unset) {
  $unset = 0;
  for $row (-1..$line) {
    for $col (-1..$i) {
      unless ($masked{"$row,$col"}) {
        $unset++;
        $masked{"$row,$col"} = 'A' if $masked{coord_offset_string([$row,$col], $north)} eq 'A';
        $masked{"$row,$col"} = 'A' if $masked{coord_offset_string([$row,$col], $south)} eq 'A';
        $masked{"$row,$col"} = 'A' if $masked{coord_offset_string([$row,$col], $east)} eq 'A';
        $masked{"$row,$col"} = 'A' if $masked{coord_offset_string([$row,$col], $west)} eq 'A';
        $masked{"$row,$col"} = 'B' if $masked{coord_offset_string([$row,$col], $north)} eq 'B';
        $masked{"$row,$col"} = 'B' if $masked{coord_offset_string([$row,$col], $south)} eq 'B';
        $masked{"$row,$col"} = 'B' if $masked{coord_offset_string([$row,$col], $east)} eq 'B';
        $masked{"$row,$col"} = 'B' if $masked{coord_offset_string([$row,$col], $west)} eq 'B';
      }
    }
  }
}

# Count squares of each coloring.
for (0..$line) {
  $row = $_;
  for (0..$i) {
    $col = $_;
    $count_a++ if $masked{"$row,$col"} eq 'A';
    $count_b++ if $masked{"$row,$col"} eq 'B';
  }
}

# Look at the square just off the edge of the grid to see which coloring is "outside" the loop.
print $masked{'-1,-1'} eq 'A' ? "$count_b\n" : "$count_a\n";

sub coord_string {
  my $coords = shift;
  return $coords->[0] . ',' . $coords->[1];
}

sub coord_offset_string {
  my $coords = shift;
  my $offset = shift;
  return coord_string([pairwise {$a + $b} @{$coords}, @{$offset}]);
}
