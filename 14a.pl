for (<>) {
  chomp;
  push @grid, [split //];
}

$moved = 1;
while ($moved) {
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
}

for $row (0..@grid-1) {
  for $col (0..@{$grid[0]}-1) {
    $sum += (@grid - $row) if $grid[$row]->[$col] eq 'O';
  }
}

print "$sum\n";
