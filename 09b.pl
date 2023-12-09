for (<>) {
  @numbers = split /\s+/;
  @begin_line = ($numbers[0]);
  while(1) {
    @next_numbers = ();
    for ($i = 0; $i < @numbers - 1; $i++) {
      $value = $numbers[$i+1] - $numbers[$i];
      push @next_numbers, $value;
    }
    push @begin_line, ($next_numbers[0]);
    @numbers = @next_numbers;
    last unless @numbers;
  }
  @extrapolated = ();
  for ($i = @begin_line-1; $i >=0; $i--) {
    $extrapolated[$i] = $begin_line[$i] - $extrapolated[$i+1];
  }
  $sum += $extrapolated[0];
}

print "$sum\n";
