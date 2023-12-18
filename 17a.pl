for (<>) {
  chomp;
  push @grid, [split //];
}

$width = @{$grid[0]} - 1;
$height = @grid - 1;

my $MAX_DISTANCE = 99999999999;

for $dir ('n','s','e','w') {
  for $row (0..@grid-1) {
    for $col (0..(@{$grid[0]}-1)) {
      for $steps (1..3) {
        $distance{"$row,$col,$dir,$steps"} = $MAX_DISTANCE;
      }
    }
  }
}

$distance{"0,1,e,1"} = $grid[0]->[1];
push @queue, "0,1,e,1";
$distance{"1,0,s,1"} = $grid[1]->[0];
push @queue, "1,0,s,1";


while (@queue) {
  @queue = sort {$distance{$a} <=> $distance{$b}} @queue;
  $current_node = shift @queue;

  my ($row, $col, $direction, $steps) = split /,/, $current_node;

  if ($row == $height && $col == $width) {
    print $distance{$current_node}, "\n";
    exit;
  }

  # go north
  if ($direction ne 's') {
    my $new_row = $row - 1;
    my $new_col = $col;
    my $new_dir = 'n';
    if (is_valid($new_row, $new_col)) {
      if ($direction eq $new_dir && $steps < 3) {
        my $next_node = build_key($new_row, $new_col, $new_dir, $steps + 1);
        set_distance($next_node, $distance{$current_node} + $grid[$new_row]->[$new_col]);
      } elsif ($direction ne $new_dir) {
        my $next_node = build_key($new_row, $new_col, $new_dir, 1);
        set_distance($next_node, $distance{$current_node} + $grid[$new_row]->[$new_col]);
      }
    }
  }

  #go south
  if ($direction ne 'n') {
    my $new_row = $row + 1;
    my $new_col = $col;
    my $new_dir = 's';
    if (is_valid($new_row, $new_col)) {
      if ($direction eq $new_dir && $steps < 3) {
        my $next_node = build_key($new_row, $new_col, $new_dir, $steps + 1);
        set_distance($next_node, $distance{$current_node} + $grid[$new_row]->[$new_col]);
      } elsif ($direction ne $new_dir) {
        my $next_node = build_key($new_row, $new_col, $new_dir, 1);
        set_distance($next_node, $distance{$current_node} + $grid[$new_row]->[$new_col]);
      }
    }
  }

  #go east
  if ($direction ne 'w') {
    my $new_row = $row;
    my $new_col = $col + 1;
    my $new_dir = 'e';
    if (is_valid($new_row, $new_col)) {
      if ($direction eq $new_dir && $steps < 3) {
        my $next_node = build_key($new_row, $new_col, $new_dir, $steps + 1);
        set_distance($next_node, $distance{$current_node} + $grid[$new_row]->[$new_col]);
      } elsif ($direction ne $new_dir) {
        my $next_node = build_key($new_row, $new_col, $new_dir, 1);
        set_distance($next_node, $distance{$current_node} + $grid[$new_row]->[$new_col]);
      }
    }
  }

  #go west
  if ($direction ne 'e') {
    my $new_row = $row;
    my $new_col = $col - 1;
    my $new_dir = 'w';
    if (is_valid($new_row, $new_col)) {
      if ($direction eq $new_dir && $steps < 3) {
        my $next_node = build_key($new_row, $new_col, $new_dir, $steps + 1);
        set_distance($next_node, $distance{$current_node} + $grid[$new_row]->[$new_col]);
      } elsif ($direction ne $new_dir) {
        my $next_node = build_key($new_row, $new_col, $new_dir, 1);
        set_distance($next_node, $distance{$current_node} + $grid[$new_row]->[$new_col]);
      }
    }
  }

}

sub is_valid {
  my ($row, $col) == @_;
  return $row >= 0 && $row < @grid && $col >= 0 && $col < @{$grid[0]};
}

sub build_key {
  my ($row, $col, $direction, $steps) = @_;
  return "$row,$col,$direction,$steps";
}

sub set_distance {
  my $node_key = shift;
  my $new_distance = shift;
  return unless $distance{$node_key} == $MAX_DISTANCE;
  $distance{$node_key} = $new_distance;
  push @queue, $node_key;
}
