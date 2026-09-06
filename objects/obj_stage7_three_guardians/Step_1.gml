// The walk out at the end of the fight (ev. 281-283). The player is not frozen,
// he is walked: the input is written over, so obj_player keeps moving him and
// obj_player_sprite keeps drawing the walk.
//
// This is a BEGIN STEP on purpose. obj_game_manager reads the keyboard in its
// own begin step, and it is a persistent object born in the first room, so its
// instance is older than anything in here and its begin step runs first: what
// is written below lands on top of the input of this same frame.
if(stato == "uscita") {
	global.horizontal = -1;
	global.vertical = 0;
	global.jump = false;
	global.jumpHold = false;
	global.attack = false;
	global.special = false;

	if(instance_exists(obj_player))
		obj_player.lastHorizontalDirection = -1;
}
