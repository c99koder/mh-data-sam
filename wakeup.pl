my $wakeup_time = "7:00 am"; # noloop
my $said_goodnight = 0; # noloop

$bedroom_light_switch->tie_event('bedroom_light_toggle()');
$wakeup_alarm->tie_event('wakeup_alarm_toggle()');

sub bedroom_light_toggle {
	if(state $bedroom_light_switch eq 'off' and $bedroom_light_switch->get_set_by() eq 'rf' and time_greater_than('9 pm')) {
		if($said_goodnight == 0) {
			if(state $wakeup_alarm eq 'on') {
				speak "Good night, Sam.  I will wake you tomorrow at " . $wakeup_time;
			} else {
				speak "Good night, Sam.";
			}
			$said_goodnight = 1;
		}
		#Clear the livingroom presence and turn off the light
		$livingroom_presence->set_count(0);
		set $livingroom_light 'off';
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
        speak "Good morning, Sam.  It is now $Time_Now on $Date_Now_Speakable.";
        speak "The outside temperature is " . round($Weather{TempOutdoor}) . " degrees.";
#TODO: Start boxee playing music
  }
  $said_goodnight = 0;
}

