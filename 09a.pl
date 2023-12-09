use List::Util qw(sum);

for (<>) {
  @numbers = split /\s+/;
  @end_line = ($numbers[-1]);
  while(1) {
    @next_numbers = ();
    for ($i = 0; $i < @numbers - 1 ; $i++) {
      $value = $numbers[$i+1] - $numbers[$i];
      push @next_numbers, $value;
    }
    push @end_line, ($next_numbers[-1]);
    @numbers = @next_numbers;
    last unless @numbers;
  }
  $sum += sum(@end_line);
}

print "$sum\n";
