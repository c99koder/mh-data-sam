my $livingroom_alert_time;
my $bedroom_alert_time;

if(state $mode_occupied eq 'vacation') {
	if(state_changed $livingroom_motion eq 'motion') {
		&net_mail_send(subject => "Motion Alert: Livingroom", text => "Motion detected in the living room") if get_tickcount - $livingroom_alert_time > 300000;
		$livingroom_alert_time = get_tickcount;
	}
	if(state_changed $bedroom_motion eq 'motion') {
		&net_mail_send(subject => "Motion Alert: Bedroom", text => "Motion detected in the bedroom") if get_tickcount - $bedroom_alert_time > 300000;
		$bedroom_alert_time = get_tickcount;
	}
}
