// The invisible stair up to the secret room exists only while that room can
// still be entered. Once the door has been walked through it is taken away:
// coming back from the pipe Mario drops straight down to the floor of the
// chamber, and with the steps gone there is no way left to climb over the top
// of the room, which is not an exit and used to let you reach the boss arena
// from up there.
// The ledger is the pipes' one, global.warpsEntered, the same obj_secret_entrance
// writes into: so this follows the door, including after a death.
for(var i = 0; i < array_length(global.warpsEntered); i++) {
	if(global.warpsEntered[i] == entrance_id) {
		instance_destroy();
	}
}
