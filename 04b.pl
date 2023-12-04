use List::Util qw(sum);

for (<>) {
  $copies[++$card]++;
  $next = $card + 1;
  @halves = split /\|/;
  %winners = map {$_ => 1} $halves[0] =~ /(\d+)\s/g;
  for $guess ($halves[1] =~ /(\d+)\s/g) {
    $copies[$next++] += $copies[$card] if $winners{$guess};
  }
}

print sum(@copies), "\n";
