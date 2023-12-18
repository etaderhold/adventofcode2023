for (<>) {
  chomp;
  push @grid, [split //];
}

$width = @{$grid[0]} - 1;
$height = @grid - 1;

my $MAX_DISTANCE = 99999999999;

# Dijkstra's algorithm: each node in the graph is a combination of a row/column
# coordinate, a direction moved to arrive at that coordinate, and a number of
# steps moved consecutively in that direction. Each node's distance from start
# is initializade to a very high number, and set to a lower number as that node
# is visited during the algorithm.
for $dir ('n','s','e','w') {
  for $row (0..@grid-1) {
    for $col (0..(@{$grid[0]}-1)) {
      for $steps (1..10) {
        $distance{"$row,$col,$dir,$steps"} = $MAX_DISTANCE;
      }
    }
  }
}

# Seed the first two distances in the graph for the two points immediately next
# to the starting position.
$distance{"0,1,e,1"} = $grid[0]->[1];
push @queue, "0,1,e,1";
$distance{"1,0,s,1"} = $grid[1]->[0];
push @queue, "1,0,s,1";

while (@queue) {
  # Find nearest unexplored node
  @queue = sort {$distance{$a} <=> $distance{$b}} @queue;
  $current_node = shift @queue;

  ($row, $col, $direction, $steps) = split /,/, $current_node;

  # Stop if we got to the destination
  if ($row == $height && $col == $width && $steps >= 4) {
    print $distance{$current_node}, "\n";
    exit;
  }

  # go north
  try_move($row - 1, $col, 'n', 's');

  #go south
  try_move($row + 1, $col, 's', 'n');

  #go east
  try_move($row, $col + 1, 'e', 'w');

  #go west
  try_move($row, $col - 1, 'w', 'e');
}

sub try_move {
  my ($new_row, $new_col, $new_dir, $reverse_dir) = @_;
  if ($direction ne $reverse_dir && is_valid($new_row, $new_col)) {
    # If we're maintaining the same direction, only proceed if we've gone fewer
    # than 10 steps in that direction.
    if ($direction eq $new_dir && $steps < 10) {
      my $next_node = build_key($new_row, $new_col, $new_dir, $steps + 1);
      set_distance($next_node, $distance{$current_node} + $grid[$new_row]->[$new_col]);
    }
    # If we're trying a new direction, only proceed if we've already gone at
    # least 4 steps in the current direction.
    elsif ($direction ne $new_dir && $steps >= 4) {
      my $next_node = build_key($new_row, $new_col, $new_dir, 1);
      set_distance($next_node, $distance{$current_node} + $grid[$new_row]->[$new_col]);
    }
  }
}

# Returns true if the given row/column is in the grid, false otherwise
sub is_valid {
  my ($row, $col) == @_;
  return $row >= 0 && $row < @grid && $col >= 0 && $col < @{$grid[0]};
}

# Converts four numbers into a hash key
sub build_key {
  my ($row, $col, $direction, $steps) = @_;
  return "$row,$col,$direction,$steps";
}

# If the given node isn't explored yet, set the distance and add it to the queue.
sub set_distance {
  my $node_key = shift;
  my $new_distance = shift;
  return unless $distance{$node_key} == $MAX_DISTANCE;
  $distance{$node_key} = $new_distance;
  push @queue, $node_key;
}
