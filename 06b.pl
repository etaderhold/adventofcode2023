@lines = <>;

s/Time:|Distance:|\s//g for @lines;
$time = $lines[0];
$record = $lines[1];

for (0..$time) {
  $winners++ if ($time - $_) * $_ > $record;
}

print "$winners\n";