for (<>) {
  s/[^\d]//g;
  @chars = split //;
  $sum += $chars[0] . $chars[@chars - 1];
}

print $sum, "\n";