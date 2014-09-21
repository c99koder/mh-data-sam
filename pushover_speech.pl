if ($Reload) {
	&State_change_add_hook( \&UpdatePushover );
	&Speak_parms_add_hook( \&PushoverSpeech );
}

sub PushoverSpeech {
	my($ref) = @_;
	$push->notify($$ref{text});
}

sub UpdatePushover {
	my($object, $state) = @_;
	my $o_update = new Process_Item;
	my $url;

	if($object->isa('Motion_Item') && $state eq 'motion') {
		if(state $mode_security eq 'armed') {
			$push->notify( "Motion detected by sensor: " . $object->get_object_name(), { title => 'Security Alert', priority => 2 });
		}
	}
}

