use List::Util qw(min max);

for (<>) {
  @chars = split //;
  for ($col = 0; $col < @chars; $col++) {
    if ($chars[$col] eq '#') {
      $found_col[$col]++;
      $found_row[$row]++;
      push @galaxies, [$row, $col];
    }
  }
  $row++;
}

$dilation_factor = 1000000;

for ($i = 0; $i < @galaxies; $i++) {
  for ($j = $i + 1; $j < @galaxies; $j++) {
    ($row1, $col1) = @{$galaxies[$i]};
    ($row2, $col2) = @{$galaxies[$j]};
    for $row (min(($row1, $row2)) .. max(($row1, $row2)) - 1) {
      $sum += $found_row[$row] ? 1 : $dilation_factor;
    }
    for $col (min(($col1, $col2)) .. max(($col1, $col2)) - 1) {
      $sum += $found_col[$col] ? 1 : $dilation_factor;
    }
  }
}

print "$sum\n";
