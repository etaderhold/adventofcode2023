use Math::Utils qw(lcm);

# Read input file, parse module structure
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
  }
  $modules{$name} -> {'outputs'} = [@outputs];
  for $output (@outputs) {
    if ($output eq 'rx') {
      $final_module = $name;
    }
    $modules{$output} -> {'inputs'} -> {$name} = 'low';
  }
}

# Repeatedly press the button until we gather enough data about the inputs to
# the final module
while (1) {
  $button_presses++;
  @pulse_queue = ();
  push @pulse_queue, {'input' => 'button', 'type' => 'low', 'output' => 'broadcaster'};
  while (@pulse_queue) {

    my %pulse = %{shift @pulse_queue};

    $pulse_output = $modules{$pulse{'output'}};
    $pulse_type = $pulse{'type'};

    # Track when high pulses are sent to the final output module, find lcm
    # of periods for all inputs.
    if ($pulse{'output'} eq $final_module && $pulse_type eq 'high') {
      push @{$final_inputs{$pulse{'input'}}}, $button_presses;
      @periods = ();
      @inputs = keys %{$pulse_output->{'inputs'}};
      $finished = 1;
      for $input (@inputs) {
        if (@{$final_inputs{$input}} >= 2) {
          push @periods, $final_inputs{$input}->[1] - $final_inputs{$input}->[0];
        } else {
          $finished = 0;
        }
      }
      if ($finished) {
        print lcm(@periods), "\n";
        exit;
      }
    }

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
