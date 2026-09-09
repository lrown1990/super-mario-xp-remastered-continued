// Same handover as obj_screen_advance: touch it and the stage fades out, the
// room changes when the fade has covered the screen. What this one adds is the
// arrival point, handed to the next room the way obj_warp_pipe_trigger does it,
// so Mario can come out of a pipe on the other side.
if(place_meeting(x, y, obj_player) && !touched && canEnter) {
	obj_player.canMove = false;
	obj_stage_manager.stage_fadeout = true;
	touched = true;
	array_push(global.warpsEntered, entrance_id);
}

if(touched && (!global.smoothTransitions
   || (obj_stage_manager.stage_fadeout_offset >= camera_get_view_width(view_camera[0]) + 64
       && obj_stage_manager.stage_fadeout && obj_stage_manager.stage_fadeout_timer > 1))) {
	global.startX = start_x;
	global.startY = start_y;
	global.initialWarping = true;
	global.initialWarpDirection = start_direction;
	room_goto(screen_to_advance);
}
