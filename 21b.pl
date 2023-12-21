for (<>) {
  chomp;
  @chars = split //;
  for $i (0..@chars-1) {
    if ($chars[$i] eq 'S') {
      $visited[0]->{"$row,$i"} = 'O';
      $chars[$i] = '.';
    }
  }
  $row++;
  push @grid, [@chars];
}

my $total_steps = 26501365;
$remainder = $total_steps % @grid;
$max_steps = $remainder + 2 * @grid;

for $step_count (1..$max_steps) {
  for $key (keys %{$visited[$step_count-1]}) {
  my ($row, $col) = split /,/, $key;
    $north = [$row - 1, $col];
    $south = [$row + 1, $col];
    $east = [$row, $col + 1];
    $west = [$row, $col - 1];
    unless ($grid[$north->[0] % @grid]->[$north->[1] % @{$grid[0]}] eq '#') { 
      $visited[$step_count]->{coord_string($north)} = 'O' ;
    }
    unless ($grid[$south->[0] % @grid]->[$south->[1] % @{$grid[0]}] eq '#') { 
      $visited[$step_count]->{coord_string($south)} = 'O' ;
    }
    unless ($grid[$east->[0] % @grid]->[$east->[1] % @{$grid[0]}] eq '#') { 
      $visited[$step_count]->{coord_string($east)} = 'O' ;
    }
    unless ($grid[$west->[0] % @grid]->[$west->[1] % @{$grid[0]}] eq '#') { 
      $visited[$step_count]->{coord_string($west)} = 'O' ;
    }
  }
}

my $point1 = keys %{$visited[$remainder]};
my $point2 = keys %{$visited[$remainder + @grid]};
my $point3 = keys %{$visited[$remainder + 2 * @grid]};

# Fit a quadratic equation to the three points
$a = ($point1 - 2 * $point2 + $point3) / 2;
$b = (-3 * $point1 + 4 * $point2 - $point3) / 2;
$x = int($total_steps / @grid);
$result = $a * $x * $x + $b * $x + $point1;

print "$result\n";

sub coord_string {
  my ($row, $col) = @{$_[0]};
  return "$row,$col";
}
