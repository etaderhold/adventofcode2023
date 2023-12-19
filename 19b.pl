my @RATINGS = qw(x m a s);

for (<>) {
  if (/(\w+)\{(.*)\}/) {
    $workflows{$1} = [split /,/, $2];
  }
}

$initial_range = { map { $_ => [1,4000] } @RATINGS };

validate_range($initial_range, 'in');
print "$sum\n";

sub validate_range {
  my ($range, $workflow_id) = @_;
  my $workflow = $workflows{$workflow_id};

  if ($workflow_id eq 'A') {
    $sum += sum_range($range);
    return;
  } elsif ($workflow_id eq 'R') {
    return;
  }

  for $step (@{$workflow}) {
    # Split up the range for steps that require a comparison.
    if ($step =~ /(.)([<>])(\d+):(\w+)/) {
      my $new_ranges = split_ranges($range, $1, $2, $3);

      validate_range($new_ranges->[0], $4);
      $range = $new_ranges->[1];
    }
    # Send entire remaining range to the default step.
    else {
      validate_range($range, $step);
    }
  }
}

sub split_ranges {
  my ($range, $rating, $operator, $pivot) = @_;

  my %match = ();
  my %non_match = ();

  for $r (@RATINGS) {
    # Split the requested rating
    if ($r eq $rating) {
      if ($operator eq '<') {
        $match{$r} = [$range->{$r}->[0], $pivot - 1];
        $non_match{$r} = [$pivot, $range->{$r}->[1]];
      }
      elsif ($operator eq '>') {
        $non_match{$r} = [$range->{$r}->[0], $pivot];
        $match{$r} = [$pivot + 1, $range->{$r}->[1]];
      }
    } 
    # Copy over the non-requested rating
    else {
      $match{$r} = $range->{$r};
      $non_match{$r} = $range->{$r};
    }
  }

  return [\%match, \%non_match];
}

sub sum_range {
  my $range = shift;
  my $product = 1;
  for $r (@RATINGS) {
    $product *= $range->{$r}->[1] - $range->{$r}->[0] + 1;
  }
  return $product;
}
