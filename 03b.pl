# Read input file into %grid
for (<>) {
  chomp;
  $line++;
  @chars = split //;
  for ($i = 0; $i < @chars; $i++) {
    $grid{"$line,$i"} = $chars[$i];
    $gears{"$line,$i"} = [];
  }
}

# Read part numbers
for ($i = 1; $i <= $line; $i++) {
  for ($j = 0; $j <= @chars; $j++) {
    $in_number = 1 if $grid{"$i,$j"} =~ /\d/;
    if ($in_number) {
      # Process next digit
      if ($grid{"$i,$j"} =~ /\d/) {
        $current = $current * 10 + $grid{"$i,$j"};
        # Check adjacent squares for a gear.
        for ($x = -1; $x <= 1; $x++) {
          for ($y = -1; $y <= 1; $y++) {
            $test = ($i + $x) . ',' . ($j + $y);
            $gear_coordinates = $test if $grid{$test} eq '*';
          }
        }
      }
      # Past the end of the number, add it to the gears and reset.
      else {
        push @{$gears{$gear_coordinates}}, $current if $gear_coordinates;
        $in_number = 0;
        $current = 0;
        $gear_coordinates = 0;
      }
    }
  }
}

# Calculate and sum gear ratios
for (my $i = 1; $i <= $line; $i++) {
  for ($j = 0; $j <= @chars; $j++) {
    @parts = @{$gears{"$i,$j"}};
    if (@parts == 2) {
      $sum += $parts[0] * $parts[1];
    }
  }
}

print $sum, "\n";