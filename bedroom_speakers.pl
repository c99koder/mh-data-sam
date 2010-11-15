#!/usr/bin/perl
use Net::DBus;

#noloop=start

my $dbus = Net::DBus->find;
my $bluez = $dbus->get_service("org.bluez");
my $bluez_manager = $bluez->get_object("/", "org.bluez.Manager");

$v_connect_bedroom_speakers = new Voice_Cmd('[Connect,Disconnect] bedroom speakers', 0);
$v_connect_bedroom_speakers->tie_event("&connect_bedroom_speakers(\$state)");

#noloop=stop

# Get the ID of the default bluetooth adapter
my @bt_adapter = split('/',$bluez_manager->DefaultAdapter);
my $bt_adapter_id = $bt_adapter[3];
my $bedroom_speakers = $bluez->get_object("/org/bluez/" . $bt_adapter_id . "/hci0/dev_00_02_72_EA_D9_A2", "org.bluez.AudioSink");

sub connect_bedroom_speakers {
	my $state = shift;

	if($state eq 'Disconnect') {
		$bedroom_speakers->Disconnect;
		$v_connect_bedroom_speakers->respond("bedroom speakers are now disconnected");
		unload_combine_module();
	} else {
		unload_combine_module();
		while($bedroom_speakers->IsConnected == 0) {
			$bedroom_speakers->Connect;
		}
		$v_connect_bedroom_speakers->respond("bedroom speakers are now connected");
		load_combine_module();
	}
}

sub unload_combine_module {
	my $combine_module_id=`pactl list | grep module-combine -A 1 | grep "Owner Module" -m 1 | awk -F': ' '{print \$2}'`; 
	chomp($combine_module_id);

	if($combine_module_id > 0) {
        	print "Unloading module\n";
        	system("/usr/bin/pactl unload-module " . $combine_module_id);
	}
}

sub load_combine_module {
	system("/usr/bin/pactl load-module module-combine");
}
