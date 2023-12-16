for (<>) {
  chomp;
  push @grid, [split //];
}

for my $row (0..@grid - 1) {
  beam_right($row, 0);
  $new_sum = compute_sum();
  $max_sum = $new_sum if $new_sum > $max_sum;
  reset_energy();

  beam_left($row, @{$grid[0]} - 1);
  $new_sum = compute_sum();
  $max_sum = $new_sum if $new_sum > $max_sum;
  reset_energy();
}

for my $col (0..@{$grid[0]} - 1) {
  beam_down(0, $col);
  $new_sum = compute_sum();
  $max_sum = $new_sum if $new_sum > $max_sum;
  reset_energy();

  beam_up(0, @grid - 1);
  $new_sum = compute_sum();
  $max_sum = $new_sum if $new_sum > $max_sum;
  reset_energy();
}

print "$max_sum\n";

sub compute_sum {
  my $sum = 0;
  for my $row (0..@grid-1) {
    for my $col (0..@{$grid[0]}-1) {
      $sum++ if $energized_left{"$row,$col"} || $energized_right{"$row,$col"}
             || $energized_down{"$row,$col"} || $energized_up{"$row,$col"};
    }
  }
  return $sum;
}

sub reset_energy {
  %energized_up = ();
  %energized_down = ();
  %energized_left = ();
  %energized_right = ();
}

sub beam_right{
  my ($row, $col) = @_;
  return if $row >= @grid || $col >= @{$grid[0]} || $row < 0 || $col < 0 || $energized_right{"$row,$col"}; 

  $energized_right{"$row,$col"} = 1;

  my $square = $grid[$row]->[$col];
  if ($square eq '.' || $square eq '-') {
    beam_right($row, $col+1);
  }
  if ($square eq '|' || $square eq '\\') {
    beam_down($row+1, $col);
  }
  if ($square eq '|' || $square eq '/') {
    beam_up($row-1, $col);
  }
}

sub beam_left{
  my ($row, $col) = @_;

  return if $row >= @grid || $col >= @{$grid[0]} || $row < 0 || $col < 0 || $energized_left{"$row,$col"}; 

  $energized_left{"$row,$col"} = 1;

  my $square = $grid[$row]->[$col];
  if ($square eq '.' || $square eq '-') {
    beam_left($row, $col-1);
  }
  if ($square eq '|' || $square eq '/') {
    beam_down($row+1, $col);
  }
  if ($square eq '|' || $square eq '\\') {
    beam_up($row-1, $col);
  }
}

sub beam_up{
  my ($row, $col) = @_;

  return if $row >= @grid || $col >= @{$grid[0]} || $row < 0 || $col < 0 ||  $energized_up{"$row,$col"}; 

  $energized_up{"$row,$col"} = 1;

  my $square = $grid[$row]->[$col];
  if ($square eq '.' || $square eq '|') {
    beam_up($row-1, $col);
  }
  if ($square eq '-' || $square eq '/') {
    beam_right($row, $col + 1);
  }
  if ($square eq '-' || $square eq '\\') {
    beam_left($row, $col - 1);
  }
}

sub beam_down{
  my ($row, $col) = @_;

  return if $row >= @grid || $col >= @{$grid[0]} || $row < 0 || $col < 0 || $energized_down{"$row,$col"}; 

  $energized_down{"$row,$col"} = 1;

  my $square = $grid[$row]->[$col];
  if ($square eq '.' || $square eq '|') {
    beam_down($row+1, $col);
  }
  if ($square eq '-' || $square eq '\\') {
    beam_right($row, $col + 1);
  }
  if ($square eq '-' || $square eq '/') {
    beam_left($row, $col - 1);
  }
}
