@lines = <>;

@times = split /\s+/, $lines[0];
shift @times;
@distances = split /\s+/, $lines[1];
shift @distances;

for ($i = 0; $i < @times; $i++) {
  for (0..$times[$i]) {
    $winners[$i]++ if ($times[$i] - $_) * $_ > $distances[$i];
  }
}

$product = 1;
$product *= $_ for @winners;

print "$product\n";