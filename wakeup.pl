my $wakeup_time = "7:00 am";

if(state_now $wakeup_alarm eq 'on') {
        speak "Wake up alarm scheduled for " . $wakeup_time;
}

if(state_now $wakeup_alarm eq 'off') {
        speak "Wake up alarm is disabled";
}

if(time_now $wakeup_time and state $wakeup_alarm eq 'on') {
        set $bedroom_light 'on';
        set $bedroom_fan 'off';
        speak "Good morning, Sam.  It is now $Time_Now on $Date_Now_Speakable.";
        speak "The outside temperature is " . round($Weather{TempOutdoor}) . " degrees.";
#TODO: Start boxee playing music
}

