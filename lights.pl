#Set up the occupancy monitor
$om->set_edges($livingroom_motion, 1);
$om->set_edges($bedroom_motion, 2);

$livingroom_presence->occupancy_expire(3600);  # Expire after 1 hour
$bedroom_presence->occupancy_expire(300);  # Expire after 5 minutes

#Configure the livingroom and bedroom lights to turn on when a room is occupied
$livingroom_light->add($livingroom_presence);
$bedroom_light->add($bedroom_presence);

#Forward some button commands to their physical objects
#We use the X10 lighting addresses here to support dimming
$bedroom_light_switch->tie_event('set $x10_bedroom_light state $bedroom_light_switch');
$bedroom_fan_switch->tie_event('set $bedroom_fan state $bedroom_fan_switch');
$livingroom_light_switch->tie_event('set $x10_livingroom_light state $livingroom_light_switch');

