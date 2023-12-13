for (<>) {
  chomp;
  ($springs, $broken) = split / /;
  $springs = join '?', (($springs) x 5);
  $broken = join ',', (($broken) x 5);
  $sum += count_possibilities($springs, $broken);
}

print "$sum\n";

sub count_possibilities {
  my ($springs, $broken) = @_;

  my $cached = $cache{"$springs:$broken"};
  return $cached eq 'x' ? 0 : $cached if $cached;

  my @sections = split /\.+/, $springs;
  shift @sections unless $sections[0];

  my @correct = split /,/, $broken;

  # If we're not looking for any more broken springs and all that's left is
  # ? and . characters, this is a valid sequence!
  return cache($springs, $broken, 1) if !@correct && !($springs =~ /#/);

  # If one of the input lists runs out before the other, this is invalid.
  return cache($springs, $broken, 0) unless @correct && @sections;

  # For any section that's entirely broken springs, check it against the
  # expected length, and shift it off the list before recursion.
  while ($sections[0] =~ /^#+$/) {
    my $section = shift @sections;
    my $right_length = shift @correct;
    return cache($springs, $broken, 0) if length($section) != $right_length;
  }

  # If we've reached the end of both inputs, this is a valid sequence!
  return cache($springs, $broken, 1) unless @correct || @sections;

  my $springs1 = my $springs2 = join '.', @sections;
  my $test_correct = join ',', @correct;

  # Recursively count the valid possibilities after resolving the first
  # question mark to both possible values.
  $springs1 =~ s/\?/#/;
  $springs2 =~ s/\?/./;

  $value = count_possibilities($springs1, $test_correct)
    + count_possibilities($springs2, $test_correct);
  return cache($springs, $broken, $value);
}

sub cache {
  my ($springs, $broken, $value) = @_;
  $cache{"$springs:$broken"} = $value ? $value : 'x';
  return $value;
}
