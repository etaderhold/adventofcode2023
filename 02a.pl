for (<>) {
  $possible = ++$game_id;
  for (/(\d+) blue/g) {
    $possible = 0 if $_ > 14;
  }
  for (/(\d+) red/g) {
    $possible = 0 if $_ > 12;
  }
  for (/(\d+) green/g) {
    $possible = 0 if $_ > 13;
  }
  $sum+= $game_id if $possible;
}

print "$sum\n";