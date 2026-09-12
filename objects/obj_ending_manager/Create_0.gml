// The ending, rebuilt from frame 65 "Ending_1" of the 2001 game: she waits
// with her back to the door, turns around at 3s, walks over to meet him, the
// message shows up, and at 13s the two of them leave to the right together.
// The original then rolls the credits (frame 66 "Ending_2"): those are not in
// this port, it goes to the game over screen instead.
// EVERYTHING ELSE OFF FIRST. obj_stage_manager keeps the arena loop alive
// even while the boss is dying (obj_boss_7 turns its gain back up right
// before leaving), so without this the King Koopa theme keeps looping
// underneath the ending music: measured, two live sources in the room.
// obj_thank_you_for_playing and obj_gameover_manager open the same way.
audio_stop_all();

endingMusic = audio_play_sound(bgm_ending, 1, false);
endingTimeout = 0;
cutsceneEvents = 0;
fadeOutPos = 0;

// He walks in briskly, she is taking her time: with these two speeds they
// meet around x=190, near the middle of the room. Same speed for both would
// put the meeting at x=216, the midpoint between where the original parks
// them, which is too far right with the message centred above.
peachSpeed = 25;
playerSpeed = 50;
met = false;
message = noone;

depth = -400;
