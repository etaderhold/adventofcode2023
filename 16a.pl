for (<>) {
  chomp;
  push @grid, [split //];
}

beam_right(0,0);

for $row (0..@grid) {
  for $col (0..@{$grid[0]}) {
    $sum++ if $energized_left{"$row,$col"} || $energized_right{"$row,$col"} 
           || $energized_down{"$row,$col"} || $energized_up{"$row,$col"};
  }
}

print "$sum\n";

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
