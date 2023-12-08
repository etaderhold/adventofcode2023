use Data::Dumper;

for (<>) {
  chomp;
  unless (@directions) {
    @directions = split //;
  } elsif (/(\w+) = \((\w+), (\w+)/) {
    $left{$1} = $2;
    $right{$1} = $3;
  }
}

$position = 'AAA';
while ($position ne 'ZZZ') {
  $next_direction = $directions[$step++ % @directions];
  if ($next_direction eq 'L') {
    $position = $left{$position};
  } else {
    $position = $right{$position};
  }
}

print $step, "\n";
