deathTimeout = 0;

// A room can ask for SILENCE by leaving stage_bgm at noone. The secret room
// above the 7-3 has no music in the original and has to stay that way, and
// without this the manager would try to play the track "noone".
if(stage_bgm == noone) {
	audio_stop_all();
} else if(!audio_is_playing(stage_bgm) && !audio_is_playing(stage_bgm_loop) || !global.continuousMusic) {
	audio_stop_all();
	
	if(stage_bgm_loop == noone)
		audio_play_sound(stage_bgm, 1, true);
	else
		audio_play_sound(stage_bgm, 1, false);
}

global.lastRoom = redirect_after_death == noone ? room : redirect_after_death;

// Every room starts with the boss still alive: otherwise, coming back after
// beating it once, the gate of the arena would already be open.
global.bossBattuto = false;

stage_fadeout = false;

stage_fadein_offset = -64;
stage_fadeout_offset = -1;

stage_fadeout_timer = 0;

cheep_cheep_timer = 0;

// The run is written to the save at the start of every level, not only at the
// end of a stage: see the note inside save_run_state.
save_run_state();
