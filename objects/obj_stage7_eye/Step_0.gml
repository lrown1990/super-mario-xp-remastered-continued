if(global.playerDead) {
	image_speed = 0;
	return;
}

var passo = delta_time / 1000000;

// While the pipe has it, obj_stage7_three_guardians is driving: it walks into
// the mouth in sight, slides to the middle of the hole, disappears, and comes
// out of the pipe at the top.
if(tubo > 0) return;


// Beaten: it goes the way every other enemy of the game goes, sound, a hop and
// then upside down out of the bottom of the room (see obj_goomba), instead of
// blinking out where it stood.
if(stato == "battuto") {
	vy += GRAVITA * passo;
	y += vy * passo;
	if(y > room_height + 64) instance_destroy();
	return;
}

if(graziaDanno > 0) graziaDanno -= passo;
if(graziaOnda > 0) graziaOnda -= passo;

// ---- gravity, always ------------------------------------------------------
// If it has ended up inside a row (a teleport, a split, a shove) it is lifted
// out: stuck inside, the check ahead is true both ways and it would flip its
// direction every step and stand there jittering for ever.
var fuga = 0;
while(place_meeting(x, y, obj_ground_group) && fuga < 48) { y -= 1; fuga++; }

vy = min(vy + GRAVITA * passo, CADUTA_MAX);
var dy = vy * passo;
if(place_meeting(x, y + dy, obj_ground_group)) {
	while(!place_meeting(x, y + 1, obj_ground_group)) y += 1;
	vy = 0;
} else {
	y += dy;
}

// ---- walking after the player, eye shut -----------------------------------
if(stato == "muove") {
	// MEASURED on the longplay: it does NOT walk towards the player, it walks
	// straight ahead and TURNS ROUND WHEN IT BUMPS INTO HIM. Both reversals in
	// the clip happened as it reached him (15 pixels apart the first, 2 the
	// second), and reading them as a chase was my mistake: written as a chase
	// it settles down next to the player on the floor and never leaves the
	// room again, which is exactly what happened in play.
	if(instance_exists(obj_player) && place_meeting(x, y, obj_player))
		verso = (obj_player.x >= x) ? -1 : 1;

	var dx = VELOCITA * verso * passo;
	if(place_meeting(x + dx, y, obj_ground_group)) verso = -verso;
	else x += dx;

	// ev. 369: the stop, and only in the open middle of the room.
	attesaSosta += passo;
	if(attesaSosta >= PASSO_SOSTA && x > BORDO_SINISTRO && x < BORDO_DESTRO) {
		attesaSosta = 0;
		sosta = DURATA_SOSTA;
		stato = "aperto";
		sprite_index = spr_stage7_eye_open;
		image_index = 0;
		image_speed = 1;
		audio_play_sound(snd_boss_2_land, 1, false);          // "inpact_13"
	}
} else if(stato == "aperto") {
	// It stays open for as long as the video shows it standing still, not for
	// as long as the animation happens to run.
	sosta -= passo;
	if(sosta <= 0) {
		stato = "muove";
		sprite_index = spr_stage7_eye_move;
		image_index = 0;
	}
}

// ---- taking a hit ---------------------------------------------------------
var danno = 0;
var respinto = false;

var fuoco = instance_place(x, y, obj_fireball);
if(fuoco != noone) {
	instance_destroy(fuoco);
	// ev. 373 against ev. 379: with the eye open the fireball is worth a
	// point, and it is the only guardian of the three the fire flower works on.
	if(stato == "aperto" && graziaDanno <= 0) danno = 1;
	else audio_play_sound(snd_fireball_impact, 1, false);     // "inpact_01"
}

if(graziaDanno <= 0 && danno == 0) {
	var martello = instance_place(x, y, obj_hammer_player);
	if(martello != noone) {
		instance_destroy(martello);
		if(stato == "aperto") danno = 1; else respinto = true;
	}

	var croce = instance_place(x, y, obj_cross);
	if(danno == 0 && !respinto && croce != noone) {
		if(stato == "aperto") danno = 2; else respinto = true;
	}

	// The shock wave of a block hit from below always shoves it, open or shut
	// (ev. 376 and 382-383), and is worth a point only with the eye open.
	if(danno == 0 && !respinto && graziaOnda <= 0 && instance_exists(obj_block_hit_detector) &&
	   instance_place(x, y, obj_block_hit_detector) != noone) {
		graziaOnda = GRAZIA_ONDA;
		if(stato == "aperto") danno = 1;
		if(instance_exists(obj_player))
			verso = (obj_player.x >= x) ? -1 : 1;
	}
}

if(respinto)
	audio_play_sound(snd_shell_hit_2, 1, false);              // "inpact_09"

if(danno > 0) {
	vita -= danno;
	audio_play_sound(snd_boss_2_weapon, 1, false);            // "inpact_08"
	audio_play_sound(snd_boss_3_hit, 1, false);               // "boss_05"
	sprite_index = spr_stage7_eye_hit;
	image_index = 0;
	image_speed = 1;
	// ev. 371: the hit animation holds the eye open for its own length.
	stato = "aperto";
	sosta = max(sosta, 0.4);
	graziaDanno = GRAZIA_DANNO;
}

if(vita <= 0 && stato != "battuto") {
	stato = "battuto";
	audio_play_sound(snd_enemy_defeat, 1, false);             // "inpact_02"
	// The plain ball again, eye shut: the blow that killed it left the sprite
	// on the hit animation, and it would fall as a flat red blob.
	sprite_index = spr_stage7_eye_move;
	image_index = 0;
	image_yscale = -1;
	image_speed = 0;
	vy = -270;                    // the -4.5 a frame the port's enemies use
}

// ---- it hurts on contact --------------------------------------------------
if(stato != "battuto" && instance_exists(obj_player) && place_meeting(x, y, obj_player) &&
   !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(2);
