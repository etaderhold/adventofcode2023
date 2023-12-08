use Math::Utils qw(lcm);

for (<>) {
  chomp;
  unless (@directions) {
    @directions = split //;
  } elsif (/(\w+) = \((\w+), (\w+)/) {
    $left{$1} = $2;
    $right{$1} = $3;
  }
}

for (keys %left) {
  push @positions, $_ if /..A/;
}

for (@positions) {
  $position = $_;
  $step = 0;
  @valid = ();

  while (@valid < 2) {
    $next_direction = $directions[$step++ % @directions];
    if ($next_direction eq 'L') {
      $position = $left{$position};
    } else {
      $position = $right{$position};
    }

    push @valid, $step if $position =~ /..Z/;
  }
  push @cycles, $valid[1] - $valid[0];
}

print lcm(@cycles), "\n";
