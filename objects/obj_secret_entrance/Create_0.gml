// The door into the secret room can be walked through only ONCE per run, like
// the pipes and the 1UP blocks. The ledger is the same one the pipes use,
// global.warpsEntered, so it is emptied in the same three places (the start of
// a stage, a new game, and the reset in obj_game_manager) and a death does not
// reopen the door.
canEnter = true;
touched = false;

for(var i = 0; i < array_length(global.warpsEntered); i++) {
	if(global.warpsEntered[i] == entrance_id) {
		canEnter = false;
	}
}
