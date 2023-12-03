# Read input file into %grid
for (<>) {
  chomp;
  $line++;
  @chars = split //;
  for ($i = 0; $i < @chars; $i++) {
    $grid{"$line,$i"} = $chars[$i];
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
        # Check adjacent squares for a symbol.
        for ($x = -1; $x <= 1; $x++) {
          for ($y = -1; $y <= 1; $y++) {
            $adjacent = 1 if $grid{($i + $x) . ',' . ($j + $y)} =~ /[^\d.]/;
          }
        }
      }
      # Past the end of the number, add it to the sum and reset.
      else {
        $sum += $current if $adjacent;
        $in_number = 0;
        $current = 0;
        $adjacent = 0;
      }
    }
  }
}

print $sum, "\n";