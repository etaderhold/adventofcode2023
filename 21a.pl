for (<>) {
  chomp;
  @chars = split //;
  for $i (0..@chars-1) {
    if ($chars[$i] eq 'S') {
      $start_row = $row;
      $start_col = $i;
      $chars[$i] = '.';
    }
  }
  $row++;
  push @grid, [@chars];
}

$max_steps = 64;

for $step (0..$max_steps) {
  for $row (0..@grid-1) {
    for $col (0..@{$grid[0]}-1) {
      $visited[$step]->{"$row,$col"} = $grid[$row]->[$col];
    }
  }
}

$visited[0]->{"$start_row,$start_col"} = 'O';

for $step_count (1..$max_steps) {
  $sum = 0;
  for $row (0..@grid-1) {
    for $col (0..@{$grid[0]}-1) {
      if ($visited[$step_count - 1]->{"$row,$col"} eq 'O') {
        $north = [$row - 1, $col];
        $south = [$row + 1, $col];
        $east = [$row, $col + 1];
        $west = [$row, $col - 1];
        $visited[$step_count]->{coord_string($north)} = 'O' unless $visited[$step_count]->{coord_string($north)} eq '#';
        $visited[$step_count]->{coord_string($south)} = 'O' unless $visited[$step_count]->{coord_string($south)} eq '#';
        $visited[$step_count]->{coord_string($east)} = 'O' unless $visited[$step_count]->{coord_string($east)} eq '#';
        $visited[$step_count]->{coord_string($west)} = 'O' unless $visited[$step_count]->{coord_string($west)} eq '#';
      }
    }
  }
}

sub coord_string {
  my ($row, $col) = @{$_[0]};
  return "$row,$col";
}

for $row (0..@grid-1) {
  for $col (0..@{$grid[0]}-1) {
    $sum++ if $visited[$max_steps]->{"$row,$col"} eq 'O';
  }
}

print "$sum\n";
