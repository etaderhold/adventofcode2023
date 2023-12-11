for (<>) {
  @chars = split //;
  for ($i = 0; $i < @chars; $i++) {
    if ($chars[$i] eq '#') {
      $found_col[$i]++;
      $found_row[$line]++;
    }
  }
  $grid[$line++] = [@chars];
}

for ($row = 0; $row < $line; $row++) {
  @output_row = ();
  for ($col = 0; $col < @chars; $col++) {
    push @output_row, $grid[$row]->[$col];
    push @output_row, '.' unless $found_col[$col];
  }    
  push @expanded_grid, [@output_row];
  push @expanded_grid, [@output_row] unless $found_row[$row];
}

for ($row = 0; $row < @expanded_grid; $row++) {
  for ($col = 0; $col < @{$expanded_grid[0]}; $col++) {
    push @galaxies, [$row, $col] if $expanded_grid[$row]->[$col] eq '#';
  }
}

for ($i = 0; $i < @galaxies; $i++) {
  for ($j = $i + 1; $j < @galaxies; $j++) {
    $sum += abs($galaxies[$i]->[0] - $galaxies[$j]->[0]) 
          + abs($galaxies[$i]->[1] - $galaxies[$j]->[1]);
  }
}

print "$sum\n";
