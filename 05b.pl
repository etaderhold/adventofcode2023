$index = -1;
for (<>) {
  chomp;
  if (/seeds/) {
    @seeds = split / /;
    shift @seeds;
    for ($i = 0; $i < @seeds; $i += 2) {
      push @seed_pairs, [$seeds[$i], $seeds[$i + 1]];
    }
  }
  elsif (/map/) {
    $maps[++$index] = [];
  }
  elsif (/\d/) {
    push @{$maps[$index]}, [split / /];
  }
}

# Sort mapping arrays
for ($i = 0; $i < @maps; $i++) {
  my @complete = ();
  $next_start = 0;

  for $mapping (sort { $a->[1] <=> $b->[1] } @{$maps[$i]}) {
    # Insert a no-op mapping if there's a gap in the mappings.
    if ($mapping->[1] != $next_start) {
      $start = $mapping->[1];
      push @complete, [$next_start, $next_start, $mapping->[1] - $next_start];
    }
    push @complete, $mapping;
    $next_start = $mapping->[1] + $mapping->[2];
  }
  # Hacky: add a very large no-op mapping to the end of the list.
  push @complete, [$next_start, $next_start, 9999999999999];
  $maps[$i] = [@complete];
}

# Go through each step of the process from seed to location, transforming each
# range of input values into one or more ranges of output values.
for $step (@maps) {
  @new_seed_pairs = ();
  for $seed_pair (@seed_pairs) {
    ($start_seed, $seed_range) = @{$seed_pair};

    foreach $mapping (@{$step}) {
      ($begin_out, $begin_in, $range) = @{$mapping};
      if ($start_seed >= $begin_in && $start_seed - $begin_in < $range) {
        if ($seed_range <= $range) {
          push @new_seed_pairs, [$begin_out - $begin_in + $start_seed, $seed_range];
          $seed_range = 0;
        } else {
          push @new_seed_pairs, [$begin_out - $begin_in + $start_seed, $range];
          $seed_range -= $range - ($start_seed - $begin_in);
          $start_seed += $range - ($start_seed - $begin_in);
        }
      }
    }
  }
  @seed_pairs = @new_seed_pairs;
}

@sorted_pairs = sort { $a->[0] <=> $b->[0] } @seed_pairs;
print $sorted_pairs[0]->[0], "\n";
