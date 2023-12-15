for (<>) {
  chomp;
  for $step (split /,/) {
    $sum += hash($step);
  }
}

print "$sum\n";

sub hash {
  my $val = 0;
  for $ch (split //, $_[0]) {
    $val += ord($ch);
    $val *= 17;
    $val %= 256;
  }
  return $val;
}
