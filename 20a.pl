for (<>) {
  chomp;
  /(.*) -> (.*)/;
  $name = $1;
  @outputs = split /, /, $2;

  if ($name =~ /%(.*)/) {
    $name = $1;
    $modules{$name} -> {'type'} = 'flip';
    $modules{$name} -> {'state'} = 'off';
  } elsif ($name =~ /&(.*)/) {
    $name = $1;
    $modules{$name} -> {'type'} = 'conj';
  } elsif ($name eq 'broadcaster') {
    $modules{$name} -> {'type'} = 'broadcaster';
  } else {
    next;
  }
  $modules{$name} -> {'outputs'} = [@outputs];
  for $output (@outputs) {
    $modules{$output} -> {'inputs'} -> {$name} = 'low';
  }

}

for (1..1000) {
  @pulse_queue = ();
  push @pulse_queue, {'input' => 'button', 'type' => 'low', 'output' => 'broadcaster'};
  while (@pulse_queue) {

    my %pulse = %{shift @pulse_queue};

    $pulse_input = $modules{$pulse{'input'}};
    $pulse_output = $modules{$pulse{'output'}};
    $pulse_type = $pulse{'type'};
    $total_pulses{$pulse_type}++;

    if ($pulse_output -> {'type'} eq 'flip') {
      # High pulses are ignored
      if ($pulse_type eq 'low') {
        if ($pulse_output -> {'state'} eq 'off') {
          $pulse_output -> {'state'} = 'on';
          for $output (@{$pulse_output->{'outputs'}}) {
            push @pulse_queue, {input => $pulse{'output'}, type => 'high', output => $output};
          }
        } else {
          $pulse_output -> {'state'} = 'off';
          for $output (@{$pulse_output->{'outputs'}}) {
            push @pulse_queue, {input => $pulse{'output'}, type => 'low', output => $output};
          }
        }
      }
    } elsif ($pulse_output -> {'type'} eq 'conj') {
      $pulse_output->{'inputs'}->{$pulse{'input'}} = $pulse_type;
      $output_type = 'low';
      for $input_value (values %{$pulse_output->{'inputs'}}) {
        $output_type = 'high' if $input_value eq 'low';
      }
      for $output (@{$pulse_output->{'outputs'}}) {
        push @pulse_queue, {input => $pulse{'output'}, type => $output_type, output => $output};
      }
    } elsif ($pulse_output -> {'type'} eq 'broadcaster') {
      for $output (@{$pulse_output->{'outputs'}}) {
        push @pulse_queue, {input => $pulse{'output'}, type => $pulse_type, output => $output};
      }    
    }
  }
}

print $total_pulses{'low'} * $total_pulses{'high'}, "\n";
