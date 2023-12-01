%names = (
  0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9,
  'one' => 1, 'two' => 2, 'three' => 3, 'four' => 4, 'five' => 5,
  'six' => 6, 'seven' => 7, 'eight' => 8, 'nine' => 9
);

for (<>) {
  $_ = substr($_, 1) while !/^(0|1|2|3|4|5|6|7|8|9|one|two|three|four|five|six|seven|eight|nine)/;
  chop while !/(0|1|2|3|4|5|6|7|8|9|one|two|three|four|five|six|seven|eight|nine)$/;

  /^(0|1|2|3|4|5|6|7|8|9|one|two|three|four|five|six|seven|eight|nine)/;
  $first = $names{$1};

  /(0|1|2|3|4|5|6|7|8|9|one|two|three|four|five|six|seven|eight|nine)$/;
  $last = $names{$1};

  $sum += $first . $last;
}

print $sum, "\n";
