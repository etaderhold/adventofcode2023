push @boxes, [] for 1..256;

for (<>) {
  chomp;
  for $step (split /,/) {
    $step =~ /(\w+)([-=])(.?)/;
    $box_id = hash($1);
    $box = $boxes[$box_id];

    if ($2 eq '-') {
      my @removed = ();
      for $lens (@{$box}) {
        push @removed, $lens unless $lens->[0] eq $1; 
      }
      $boxes[$box_id] = [@removed];
    } else {
      $found = 0;
      for $lens (@{$box}) {
        if ($lens->[0] eq $1) {
          $lens->[1] = $3;
          $found = 1;
        }
      }
      push @{$box}, [$1, $3] unless $found;
    }
  }
}

for $box_id (0..255) {
  for $lens_id (0..@{$boxes[$box_id]}-1) {
    $sum += ($box_id + 1) * ($lens_id + 1) * $boxes[$box_id]->[$lens_id]->[1];
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
