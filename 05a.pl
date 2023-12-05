use List::Util qw(min);

$index = -1;
for (<>) {
  chomp;
  if (/seeds/) {
    @seeds = split / /;
    shift @seeds;
  }
  elsif (/map/) {
    $maps[++$index] = [];
  }
  elsif (/\d/) {
    push @{$maps[$index]}, [split / /];
  }
}

for $step (@maps) {
  for ($i = 0; $i < @seeds; $i++) {
    $original_value = $seeds[$i];
    $new_value = $original_value;

    for $mapping (@{$step}) {
      ($begin_out, $begin_in, $range) = @{$mapping};
      if ($original_value >= $begin_in && $original_value - $begin_in < $range) {
        $new_value = $begin_out + $original_value - $begin_in;
      }
    }

    $seeds[$i] = $new_value;
  }
}

print min(@seeds), "\n";