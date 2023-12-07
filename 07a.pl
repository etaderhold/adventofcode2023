%card_values = ('A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T' => 10);

for (<>) {
  chomp;
  push @hands, [split / /];
}

@sorted_hands = sort {hand_value($b->[0]) <=> hand_value($a->[0])} @hands;

for (@sorted_hands) {
  $sum += $_->[1] * (@hands - $i++);
}

print "$sum\n";

sub hand_value {
  my @cards = map {$card_values{$_} || $_} (split //, shift);
  my %frequencies;
  $frequencies{$card_values{$_} || $_}++ for @cards;

  my @sorted_frequencies = sort {$b <=> $a} values %frequencies;

  if ($sorted_frequencies[0] == 5) {
    $value = 0x700000;
  } elsif ($sorted_frequencies[0] == 4) {
    $value = 0x600000;
  } elsif ($sorted_frequencies[0] == 3) {
    $value = $sorted_frequencies[1] == 2 ? 0x500000 : 0x400000;
  } elsif ($sorted_frequencies[0] == 2) {
    $value = $sorted_frequencies[1] == 2 ? 0x300000 : 0x200000;
  } else {
    $value = 0x100000;
  }

  # Add hex value of hand as a tiebreaker.
  return $value + $cards[0] * 0x10000 + $cards[1] * 0x1000 + 
    $cards[2] * 0x100 + $cards[3] * 0x10 + $cards[4] * 0x1;
}
