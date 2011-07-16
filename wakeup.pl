#noloop=start
my $wakeup_time = "7:00 am";
my $said_goodnight = 0;
my $said_goodmorning = 1;

$bedroom_light_switch->tie_event('bedroom_light_toggle()');
$wakeup_alarm->tie_event('wakeup_alarm_toggle()');

$v_goodmorning = new Voice_Cmd('Good morning');
$v_goodnight = new Voice_Cmd('Good night');
#noloop=stop

if(said $v_goodmorning) {
	goodmorning();
}

if(said $v_goodnight) {
	goodnight();
}

if(state_changed $livingroom_motion eq 'motion' and $said_goodmorning eq 0 and time_greater_than('6 am') and time_less_than('12 pm')) {
	goodmorning();
}

sub goodmorning {
	my $line;
	my $forecast_today;
	my $forecast_tonight;
	my $msg;

	open(my $forecast, "$config_parms{data_dir}/web/weather_forecast.txt");
	while(<$forecast>) {
		$line = $_;
		chomp($line);

		if($line =~ m/^Today: (.*)/) {
			$forecast_today = $1;
		} elsif($line =~ m/^Tonight: (.*)/) {
			$forecast_tonight = $1;
		} elsif($line =~ m/^(\S+):(.*)/) {
			last;
		} else {
			$line =~ m/^\s+(.*)/;
			if(length $forecast_tonight > 0) {
				$forecast_tonight .= " " . $1;
			} elsif(length $forecast_today > 0) {
				$forecast_today .= " " . $1;
			}
		}
	}
	close($forecast);
	run_voice_cmd 'stop this song';
	$msg = "Good morning. ";
	$msg .= "\nToday is $Holiday. " if $Holiday;
	$msg .= "\nToday's weather forecast: $forecast_today. " if $forecast_today;
	$msg .= "\nTonight: $forecast_tonight. " if $forecast_tonight;
	$msg .= "\nIt is currently " . round($Weather{TempOutdoor}) . " degrees outside.";
	speak $msg;
	$said_goodmorning = 1;
	$said_goodnight = 0;
}

sub goodnight {
	speak "Good night.";
	if(state $wakeup_alarm eq 'on') {
		speak "I will wake you tomorrow at " . $wakeup_time;
	}
	$said_goodnight = 1;
	$said_goodmorning = 0;
}

sub bedroom_light_toggle {
	if(state $bedroom_light_switch eq 'off' and $bedroom_light_switch->get_set_by() eq 'rf' and (time_greater_than('9 pm') or time_less_than('4 am'))) {
		#Clear the livingroom presence and turn off the light
		$livingroom_presence->set_count(0);
		set $livingroom_light 'off';
		$om->reset();
		if($said_goodnight == 0) {
			goodnight();
		}
	}
}

sub wakeup_alarm_toggle {
	if(state $wakeup_alarm eq 'on') {
        	speak "Wake up alarm scheduled for " . $wakeup_time;
	}

	if(state $wakeup_alarm eq 'off') {
        	speak "Wake up alarm is disabled";
	}
}

if(time_now $wakeup_time) {
  if(state $wakeup_alarm eq 'on') {
        set $bedroom_light 'on';
        set $bedroom_fan 'off';
	speak "It is $Time_Now on $Date_Now_Speakable. Time to wake up!";
	run_voice_cmd 'Play my mix';
  }
  $said_goodnight = 0;
}

