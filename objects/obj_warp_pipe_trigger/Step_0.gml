// Set by either branch below the moment the player goes in; the warp zone
// bookkeeping at the bottom runs on it.
var entrato = false;

if(place_meeting(x, y, obj_player) && !obj_player.warpState && initial_direction == "down" && global.vertical > 0 && canEnter) {
	obj_player.canMove = false;
	obj_player.warpState = true;
	obj_player.warpChangeScreen = true;
	obj_player.warpDirection = "down";
	global.initialWarpDirection = endpoint_direction;
	switch(global.character) {
		case "mario": {
			obj_player_sprite.sprite_index = spr_mario_crouch;
			break;
		}
		
		case "luigi": {
			obj_player_sprite.sprite_index = spr_luigi_crouch;
			break;
		}
	}
	obj_player.x = x;
	obj_player.y = y;
	obj_player.warpYLimit = obj_player.y + 32;
	global.screenToWarp = screen_warp;
	global.initialWarping = true;
	global.startX = endpoint_initial_x;
	global.startY = endpoint_initial_y;
	audio_play_sound(snd_warp_pipe, 1, false);
	if(enterOnce)
		array_push(global.warpsEntered, warp_id);
	entrato = true;
}

if(place_meeting(x, y, obj_player) && !obj_player.warpState && initial_direction == "up" && global.vertical < 0 && canEnter) {
	obj_player.canMove = false;
	obj_player.currentY = 0;
	obj_player.warpState = true;
	obj_player.warpChangeScreen = true;
	obj_player.warpDirection = "up";
	global.initialWarpDirection = endpoint_direction;
	obj_player.x = x;
	obj_player.y = y + 16;
	obj_player.warpYLimit = obj_player.y - 32;
	global.screenToWarp = screen_warp;
	global.initialWarping = true;
	global.startX = endpoint_initial_x;
	global.startY = endpoint_initial_y;
	audio_play_sound(snd_warp_pipe, 1, false);
	if(enterOnce)
		array_push(global.warpsEntered, warp_id);
	entrato = true;
}

// Warp zone: the far side of this pipe is the START of a later stage, not
// another room of this one. The "6" pipe at the end of the roof level above
// 5-3 leads to 6-1 this way (the "3" pipe of 2-2 goes into stage 3 too, but
// lands mid-stage, so it never needed this). Going in counts as reaching that
// stage: the stage number moves on and the save unlocks it in Select Stage,
// exactly as beating the boss of the stage before would. stage_reached is 0
// on every other pipe, and then nothing here runs.
if(entrato && stage_reached > 0 && global.currentStage < stage_reached) {
	global.currentStage = stage_reached;
	level_finished(global.currentStage, global.playerWeapon, global.hearts, global.pHealth);
}
