if(time_now '6:59 am' and $bedroom_fan->state eq 'on') {
	set $bedroom_fan 'off';
}
if(time_now '7:00 am') {
	set $bedroom_light 'on';
	speak "Good morning, Sam.  It is now $Time_Now on $Date_Now_Speakable.";
	speak "The outside temperature is " . round($Weather{TempOutdoor}) . " degrees.";
#TODO: Start boxee playing music
}
