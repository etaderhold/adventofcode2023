$row = 0;
$col = 0;
$grid{"$row,$col"} = 1;

for (<>) {
  /(.) (\d+) \((.*)\)/;
  $direction = $1;
  $distance = $2;
  $color = $3;

  if ($direction eq 'R') {
    $mask{($row -1) . ",$col"} = 'A';
    $mask{($row +1) . ",$col"} = 'B';
    for (1..$distance) {
      $col++;
      $max_col = $col if $col > $max_col;
      $grid{"$row,$col"} = 1;
      $mask{($row -1) . ",$col"} = 'A';
      $mask{($row +1) . ",$col"} = 'B';
    }
  }

  elsif ($direction eq 'L') {
    $mask{($row +1) . ",$col"} = 'A';
    $mask{($row -1) . ",$col"} = 'B';
    for (1..$distance) {
      $col--;
      $min_col = $col if $col < $min_col;
      $grid{"$row,$col"} = 1;
      $mask{($row +1) . ",$col"} = 'A';
      $mask{($row -1) . ",$col"} = 'B';
    }
  }

  elsif ($direction eq 'U') {
    $mask{"$row," . ($col - 1)} = 'A';
    $mask{"$row," . ($col + 1)} = 'B';
    for (1..$distance) {
      $row--;
      $min_row = $row if $row < $min_row;
      $grid{"$row,$col"} = 1;
      $mask{"$row," . ($col - 1)} = 'A';
      $mask{"$row," . ($col + 1)} = 'B';
    }

  }

  elsif ($direction eq 'D') {
    $mask{"$row," . ($col + 1)} = 'A';
    $mask{"$row," . ($col - 1)} = 'B';
    for (1..$distance) {
      $row++;
      $max_row = $row if $row > $max_row;
      $grid{"$row,$col"} = 1;
      $mask{"$row," . ($col + 1)} = 'A';
      $mask{"$row," . ($col - 1)} = 'B';
    }

  }

}

# Apply mask to squares in the grid that aren't part of the main loop.
for $row ($min_row -1..$max_row + 1) {
  for $col ($min_col - 1..$max_col +1) {
    $index = "$row,$col";
    $masked{$index} = $grid{$index} ? '#' : $mask{$index};
  }
}

# Iteratively fill in non-colored squares.
$unset = 1;
while ($unset) {
  $unset = 0;
  for $row ($min_row -1..$max_row + 1) {
    for $col ($min_col - 1..$max_col +1) {
      unless ($masked{"$row,$col"}) {
        $unset++;
        $masked{"$row,$col"} = 'A' if $masked{coord_string($row+1, $col)} eq 'A';
        $masked{"$row,$col"} = 'A' if $masked{coord_string($row-1, $col)} eq 'A';
        $masked{"$row,$col"} = 'A' if $masked{coord_string($row, $col+1)} eq 'A';
        $masked{"$row,$col"} = 'A' if $masked{coord_string($row, $col-1)} eq 'A';
        $masked{"$row,$col"} = 'B' if $masked{coord_string($row+1, $col)} eq 'B';
        $masked{"$row,$col"} = 'B' if $masked{coord_string($row-1, $col)} eq 'B';
        $masked{"$row,$col"} = 'B' if $masked{coord_string($row, $col+1)} eq 'B';
        $masked{"$row,$col"} = 'B' if $masked{coord_string($row, $col-1)} eq 'B';
      }
    }
  }
}

$in = $masked{coord_string($min_row - 1, $min_col - 1)} eq 'A' ? 'B' : 'A';

for $row ($min_row -1..$max_row + 1) {
  for $col ($min_col - 1..$max_col +1) {
    $sum++ if $masked{"$row,$col"} eq $in || $masked{"$row,$col"} eq '#';
    print $masked{"$row,$col"};
  }
  print "\n";
}

print "$sum\n";

sub coord_string {
  my ($a, $b) = @_;
  return "$a,$b";
}
