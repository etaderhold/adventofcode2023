# I don't love this solution. It takes a few hours and a few dozen GB of memory,
# but it does work eventually.

my @lines = <>;
for $line (@lines) {
  $line =~ /(.) (\d+) \((.*)\)/;
  $color = $3;
  $color =~ /#(.....)(.)/;
  $distance = hex($1);
  $direction = $2;
  $direction =~ y/0123/RDLU/;

  if ($direction eq 'R') {
    for (1..$distance) {
      $col++;
      $max_col = $col if $col > $max_col;
    }
  }

  elsif ($direction eq 'L') {
    for (1..$distance) {
      $col--;
      $min_col = $col if $col < $min_col;
    }
  }

  elsif ($direction eq 'U') {
    for (1..$distance) {
      $row--;
      $min_row = $row if $row < $min_row;
    }
  }

  elsif ($direction eq 'D') {
    for (1..$distance) {
      $row++;
      $max_row = $row if $row > $max_row;
    }

  }
}

# Move offset of starting position so that we can use arrays.
$row = -$min_row + 1;
$col = -$min_col + 1;

sub add_a {
  my ($row, $col) = @_;
  push @{$a[$row]}, $col;
}

sub add_b {
  my ($row, $col) = @_;
  push @{$b[$row]}, $col;
}

# Populate coordinates of every point on the line, plus some points 'a' (to the
# left of the pencil as we draw) and points 'b' (to the right of the pencil as
# we draw). Which of 'a' or 'b' is "inside" the loop will be determined later.
for $line (@lines) {
  $line =~ /(.) (\d+) \((.*)\)/;
  $color = $3;
  $color =~ /#(.....)(.)/;
  $distance = hex($1);
  $direction = $2;
  $direction =~ y/0123/RDLU/;

  if ($direction eq 'R') {
    add_a($row - 1, $col);
    add_b($row + 1, $col);
    for (1..$distance) {
      $col++;
      push @{$grid[$row]}, $col;
      add_a($row - 1, $col);
      add_b($row + 1, $col);
    }
  }

  elsif ($direction eq 'L') {
    add_a($row + 1, $col);
    add_b($row - 1, $col);
    for (1..$distance) {
      $col--;
      push @{$grid[$row]}, $col;
      add_a($row + 1, $col);
      add_b($row - 1, $col);
    }
  }

  elsif ($direction eq 'U') {
    add_a($row, $col - 1);
    add_b($row, $col + 1);
    for (1..$distance) {
      $row--;
      push @{$grid[$row]}, $col;
      add_a($row, $col - 1);
      add_b($row, $col + 1);
    }

  }

  elsif ($direction eq 'D') {
    add_a($row, $col + 1);
    add_b($row, $col - 1);
    for (1..$distance) {
      $row++;
      push @{$grid[$row]}, $col;
      add_a($row, $col + 1);
      add_b($row, $col - 1);
    }

  }
}

# Whichever of 'a' or 'b' that we get to first starting from the left of the
# grid is "outside" the loop. The other one is "inside".
@sorted_a = sort {$a <=> $b} @{$a[2]};
@sorted_b = sort {$a <=> $b} @{$b[2]};
if ($sorted_a[0] < $sorted_b[0]) {
  $inside = \@b;
} else {
  $inside = \@a;
}

for $row (1..@grid-1) {
  @border_cols = sort {$a <=> $b} @{$grid[$row]};
  %insides = map {$_ => 1} sort @{$inside->[$row]};

  $row_sum = @border_cols;
  for (my $i = 1; $i < @border_cols; $i++) {
    $diff = $border_cols[$i] - $border_cols[$i-1];
    if ($diff != 1 && $insides{$border_cols[$i] - 1}) {
      $row_sum += $diff - 1;
    }
  }

  # Status update so we don't get too discouraged
  if ($row % 1000 == 0) {
    print "Row $row sum: $row_sum\n";
    print (join ',', @border_cols);
    print "\n";
  }
  $sum += $row_sum;
}

print "Overall sum = $sum\n";
