#Set up the occupancy monitor
$om->set_edges($livingroom_motion, 1);
$om->set_edges($bedroom_motion, 2);

$livingroom_presence->occupancy_expire(3600);  # Expire after 1 hour
$bedroom_presence->occupancy_expire(300);  # Expire after 5 minutes

#Configure the livingroom and bedroom lights to turn on when a room is occupied
$livingroom_light->add($livingroom_presence);
$bedroom_light->add($bedroom_presence);
