$workflows{'A'} = ['A'];
$workflows{'R'} = ['R'];

for (<>) {
  if (/(\w+)\{(.*)\}/) {
    $workflows{$1} = [split /,/, $2];
  } elsif (/x=(\d+),m=(\d+),a=(\d+),s=(\d+)/) {
    $ratings{'x'} = $1;
    $ratings{'m'} = $2;
    $ratings{'a'} = $3;
    $ratings{'s'} = $4;
    $current_workflow = $workflows{'in'};
    $done = 0;
    while (!$done) {
      for $step (@{$current_workflow}) {
        if ($step =~ /(.)([<>])(\d+):(\w+)/) {
          if ($2 eq '>' && $ratings{$1} > $3) {
            $current_workflow = $workflows{$4};
            last;
          } elsif ($2 eq '<' && $ratings{$1} < $3) {
            $current_workflow = $workflows{$4};
            last;
          }
        } else {
          if ($step eq 'A') {
            $sum += $ratings{'x'} + $ratings{'m'} + $ratings{'a'} + $ratings{'s'};
            $done = 1;
          } elsif ($step eq 'R') {
            $done = 1;
          } else {
            $current_workflow = $workflows{$step};
          }
        }
      }
    }
  }
}

print "$sum\n";
