for (<>) {
  @halves = split /\|/;
  $score = 0;
  %winners = map {$_ => 1} $halves[0] =~ /(\d+)\s/g;
  for $guess ($halves[1] =~ /(\d+)\s/g) {
    $score = ($score * 2) || 1 if $winners{$guess};
  }
  $sum += $score;
}

print $sum, "\n";