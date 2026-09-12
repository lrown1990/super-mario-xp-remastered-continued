endingTimeout += delta_time / 1000000;
var secondi = delta_time / 1000000;

// 3s: she turns around and faces the door
if(endingTimeout > 3 && cutsceneEvents == 0) {
	obj_ending_peach.sprite_index = spr_peach_ending_idle;
	cutsceneEvents++;
}

// 4s: she starts walking
if(endingTimeout > 4 && cutsceneEvents == 1) {
	obj_ending_peach.sprite_index = spr_peach_ending_walk;
	cutsceneEvents++;
}

// 6s: he walks in from the right, from the room where Bowser was
if(endingTimeout > 6 && cutsceneEvents == 2) {
	if(global.character == "luigi")
		obj_ending_player.sprite_index = spr_luigi_walking;
	else
		obj_ending_player.sprite_index = spr_mario_walking;

	cutsceneEvents++;
}

// They walk until they are face to face. The original stops them with a
// collision; here it is the distance between the two, so it does not depend
// on the size of the sprites.
if(!met && cutsceneEvents >= 2) {
	if(obj_ending_player.x - obj_ending_peach.x > 20) {
		obj_ending_peach.x += peachSpeed * secondi;

		if(cutsceneEvents >= 3)
			obj_ending_player.x -= playerSpeed * secondi;
	} else {
		met = true;
		obj_ending_peach.sprite_index = spr_peach_ending_idle;

		if(global.character == "luigi")
			obj_ending_player.sprite_index = spr_luigi_idle;
		else
			obj_ending_player.sprite_index = spr_mario_idle;
	}
}

// 7s: "THANK YOU MARIO!"
if(endingTimeout > 7 && cutsceneEvents == 3) {
	message = instance_create_depth(64, 74, -300, obj_ending_text);
	cutsceneEvents++;
}

// 10s: the second line, "YOUR QUEST IS OVER."
if(endingTimeout > 10 && cutsceneEvents == 4) {
	if(instance_exists(message))
		message.image_index = 1;

	cutsceneEvents++;
}

// 13s: the message goes away and the two of them walk off to the right
if(endingTimeout > 13 && cutsceneEvents == 5) {
	if(instance_exists(message))
		instance_destroy(message);

	obj_ending_peach.sprite_index = spr_peach_ending_walk;
	obj_ending_player.image_xscale = 1;

	if(global.character == "luigi")
		obj_ending_player.sprite_index = spr_luigi_walking;
	else
		obj_ending_player.sprite_index = spr_mario_walking;

	cutsceneEvents++;
}

if(cutsceneEvents >= 6) {
	// They keep his walking pace on the way out: the original moves them 2
	// pixels a step at 50 steps a second, but this room is 320 wide and at
	// that speed they are gone in under a second, with the last three of the
	// scene played to an empty room.
	var uscita = playerSpeed * secondi;
	obj_ending_peach.x += uscita;
	obj_ending_player.x += uscita;
}

// 16s: the screen wipes and the music goes down with it
if(endingTimeout > 16 && cutsceneEvents == 6) {
	audio_sound_gain(endingMusic, 0, 3000);
	cutsceneEvents++;
}

if(endingTimeout > 16 && fadeOutPos < 384)
	fadeOutPos += 12;

if(fadeOutPos > 384)
	fadeOutPos = 384;

// The original waits for a key press and then rolls the credits. Here the
// credits are gone, so the wipe runs out into the game over screen, and a key
// after 16s skips the wait.
if(endingTimeout > 19 || (endingTimeout > 16 && (global.start || global.jump))) {
	audio_stop_all();
	room_goto(gameover);
}
