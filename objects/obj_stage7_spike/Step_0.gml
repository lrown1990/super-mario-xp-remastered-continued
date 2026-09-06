if(global.playerDead) {
	image_speed = 0;
	return;
}

var passo = delta_time / 1000000;

// While the pipe has it, obj_stage7_three_guardians is driving: it walks into
// the mouth in sight, slides to the middle of the hole, disappears, and comes
// out of the pipe at the top.
if(tubo > 0) return;


var idle = [spr_stage7_spike_1, spr_stage7_spike_2, spr_stage7_spike_3, spr_stage7_spike_4];
var colpo = [spr_stage7_spike_1_hit, spr_stage7_spike_2_hit, spr_stage7_spike_3_hit, spr_stage7_spike_4_hit];

// ---- he is down: he stands there flashing, and then he splits --------------
// Only the three bigger sizes ever get here; the smallest goes straight to
// "battuto" when its counter runs out, without a pause it has nothing to use.
if(stato == "morto") {
	// He does not move a pixel while this runs: it is the pause the original
	// takes, and it is what tells the player another two are coming.
	lampeggio -= passo;
	if(lampeggio <= 0) {
		// ev. 305, 313 and 321: two children of the next size, one on each
		// side, 12 pixels apart (10 for the last split).
		var scarto = (livello < 3) ? 12 : 10;
		for(var i = -1; i <= 1; i += 2) {
			var f = instance_create_layer(x + scarto * i, y, "Objects", obj_stage7_spike);
			f.livello = livello + 1;
			f.verso = i;
			f.vy = -60;             // a small hop as they come apart
		}
		audio_play_sound(snd_boss_2_land, 1, false);          // "inpact_13"
		instance_destroy();
	}
	return;
}

// ---- beaten: it falls out of the room, through everything -----------------
if(stato == "battuto") {
	vy += GRAVITA * passo;
	y += vy * passo;
	if(y > room_height + 64) instance_destroy();
	return;
}

// ---- walking, and falling when the row runs out ---------------------------
// If it has ended up inside a row (a teleport, a split, a shove) it is lifted
// out: stuck inside, the check ahead is true both ways and it would flip its
// direction every step and stand there jittering for ever.
var fuga = 0;
while(place_meeting(x, y, obj_ground_group) && fuga < 48) { y -= 1; fuga++; }

vy = min(vy + GRAVITA * passo, CADUTA_MAX);

var dx = VELOCITA * verso * passo;
if(place_meeting(x + dx, y, obj_ground_group)) verso = -verso;   // wall: turns
else x += dx;

var dy = vy * passo;
if(place_meeting(x, y + dy, obj_ground_group)) {
	// down to touching, and there it stays
	while(!place_meeting(x, y + 1, obj_ground_group)) y += 1;
	vy = 0;
} else {
	y += dy;
}

if(lampeggio > 0) {
	lampeggio -= passo;
	if(lampeggio <= 0) {
		sprite_index = idle[livello - 1];
		image_index = 0;
	}
} else if(sprite_index != idle[livello - 1]) {
	sprite_index = idle[livello - 1];
}

if(graziaDanno > 0) graziaDanno -= passo;
if(graziaOnda > 0) graziaOnda -= passo;

// ---- taking a hit ---------------------------------------------------------
// ev. 299-303. The fireball is the odd one: it pops on him and does NOTHING,
// which is what makes the fire flower the wrong weapon for this fight.
var danno = 0;

var fuoco = instance_place(x, y, obj_fireball);
if(fuoco != noone) {
	instance_destroy(fuoco);
	audio_play_sound(snd_fireball_impact, 1, false);          // "inpact_01"
}

if(graziaDanno <= 0) {
	var martello = instance_place(x, y, obj_hammer_player);
	if(martello != noone) { instance_destroy(martello); danno = 1; }   // ev. 300

	var croce = instance_place(x, y, obj_cross);
	if(danno == 0 && croce != noone) danno = 2;                        // ev. 301

	// ev. 302 and 303: the shock wave of a block hit from below. It is worth
	// one point AND it kicks him away from the player.
	if(danno == 0 && graziaOnda <= 0 && instance_exists(obj_block_hit_detector) &&
	   instance_place(x, y, obj_block_hit_detector) != noone) {
		danno = 1;
		graziaOnda = GRAZIA_ONDA;
		if(instance_exists(obj_player))
			verso = (obj_player.x >= x) ? -1 : 1;
	}
}

if(danno > 0) {
	vita -= danno;
	audio_play_sound(snd_boss_2_weapon, 1, false);            // "inpact_08"
	sprite_index = colpo[livello - 1];
	image_index = 0;
	image_speed = 1;
	lampeggio = LAMPEGGIO;
	graziaDanno = GRAZIA_DANNO;
}

if(vita <= 0 && stato == "vivo") {
	if(livello < 4) {
		// The pause is there to announce the split: it stands still flashing
		// and only then comes apart.
		stato = "morto";
		sprite_index = colpo[livello - 1];
		image_index = 0;
		image_speed = 1;
		lampeggio = DURATA_LAMPEGGIO;
	} else {
		// The smallest one has nothing left to split into, so it has nothing
		// to announce: it goes straight away, the way every other enemy of the
		// game goes when a weapon gets it (see obj_goomba), sound, a hop and
		// then out of the bottom of the room upside down.
		audio_play_sound(snd_enemy_defeat, 1, false);     // "inpact_02"
		stato = "battuto";
		// Back to the plain ball first: whatever killed it left the sprite on
		// the hit animation, and freezing it there dropped a flat red blob out
		// of the room instead of the mine itself.
		sprite_index = idle[livello - 1];
		image_index = 0;
		image_yscale = -1;
		image_speed = 0;
		vy = -270;                    // the -4.5 a frame the port's enemies use
	}
}

// ---- he hurts on contact --------------------------------------------------
if(stato == "vivo" && instance_exists(obj_player) && place_meeting(x, y, obj_player) &&
   !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(3);
