# Category=Last.fm

# Commands for interacting with Shell.fm

#noloop=start
my $rc = new IO::File("$ENV{HOME}/.shell-fm/shell-fm.rc");
my $lastfmuser; # = "c99koder"; #Play my stations, but scrobble to another account
my $shellfmsocketpath;

for($rc->getlines) {
	$shellfmsocketpath = $1 if /^\s*unix\s*=\s*([^#\s]+)/;
# Comment out the line below to override the username
	$lastfmuser = $1 if /^\s*username\s*=\s*([^#\s]+)/;
}
$rc->close;

$v_whatsong = new Voice_Cmd('What song is playing');
$v_ratesong = new Voice_Cmd('[love,ban,skip,pause,stop] this song');
$v_tunestation = new Voice_Cmd('Play my [mix,library,recommendations]');
$v_smoothjazz = new Voice_Cmd('Play smooth jazz');
#noloop=stop

use Weather_Common;

if($state = said $v_whatsong) {
	open(my $npfile,"$config_parms{data_dir}/shell-fm");
	speak <$npfile>;
	close($npfile);
}

if($state = said $v_ratesong) {
	my $shellfmsocket = new IO::Socket::UNIX($shellfmsocketpath);
	$shellfmsocket->print("$state\n") or speak "Failed to send command.";
	$shellfmsocket->close;
}

if($state = said $v_tunestation) {
	tune_lastfm_station("lastfm://user/$lastfmuser/$state");
}

if($state = said $v_smoothjazz) {
	speak 'Commencing smooth jazz in 3, 2, 1.';
	tune_lastfm_station("lastfm://globaltags/smooth+jazz");
}

sub tune_lastfm_station {
	my ($station) = @_;
	my $shellfmsocket = new IO::Socket::UNIX($shellfmsocketpath);
	if($shellfmsocket) {
		$shellfmsocket->print("play $station\n") or speak "Failed to send command.";
		$shellfmsocket->print("volume %70\n") or speak "Failed to send command.";
		$shellfmsocket->close;
	} else {
		speak 'Unable to connect to Shell F M';
	}
}
