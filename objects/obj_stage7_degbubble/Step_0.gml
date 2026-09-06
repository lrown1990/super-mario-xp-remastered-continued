if(global.playerDead) {
	image_speed = 0;
	return;
}

var passo = delta_time / 1000000;

// While the pipe has it, obj_stage7_three_guardians is driving: it walks into
// the mouth in sight, slides to the middle of the hole, disappears, and comes
// out of the pipe at the top.
if(tubo > 0) return;


// ---- he is down: the shrinking animation, then the room is clear -----------
if(stato == "morto") {
	if(image_index >= image_number - 1) {
		instance_destroy();
	}
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
if(place_meeting(x + dx, y, obj_ground_group)) verso = -verso;
else x += dx;

var dy = vy * passo;
if(place_meeting(x, y + dy, obj_ground_group)) {
	while(!place_meeting(x, y + 1, obj_ground_group)) y += 1;
	vy = 0;
} else {
	y += dy;
}

if(lampeggio > 0) {
	lampeggio -= passo;
	if(lampeggio <= 0) {
		sprite_index = spr_stage7_degbubble;
		image_index = 0;
	}
}

if(graziaDanno > 0) graziaDanno -= passo;
if(graziaOnda > 0) graziaOnda -= passo;

// ---- the bubbles ----------------------------------------------------------
// ev. 352-356. The count of copies decides the rate for everybody, so it is
// read once here and used by the real one and by the copies alike.
var copie = 0;
with(obj_stage7_degbubble) if(finto) copie++;

// With no copy about only the real one spits (ev. 352), and from one copy on
// they all do, slower the more of them there are.
// The events test the number of copies for EQUALITY, one event each for 0, 1,
// 2, 3 and 4, so read to the letter nobody spits at all once there are five:
// with the cap at five copies that meant the fight went quiet for good after
// ten seconds, which is no fight. From four copies on the rate simply stays at
// its slowest.
if(!finto || copie > 0) {
	attesaBolla += passo;
	if(attesaBolla >= CADENZA[min(copie, 4)]) {
		attesaBolla = 0;
		instance_create_layer(x, y - sprite_height / 2, "Objects", obj_stage7_bubble);
		audio_play_sound(snd_boss_2_land, 1, false);          // "inpact_13"
	}
}

// ---- the copies -----------------------------------------------------------
// Only the real one calls them in, and only while he is alive (ev. 358, 359).
if(!finto) {
	if(copie == 0) {
		attesaVerso += passo;
		if(attesaVerso >= PASSO_VERSO) {                      // ev. 360
			attesaVerso = 0;
			verso = -verso;
		}
	} else {
		attesaVerso = 0;
	}

	// A cap the original does not write down anywhere, and that a long fight
	// showed is needed: left alone for seventy seconds he had called in more
	// than thirty copies and the room was impassable. Five is the number the
	// events themselves point at, because their table of firing rates stops at
	// four copies and from the fifth on nobody spits at all: with the cap here
	// that quiet state is reachable and stays put.
	attesaCopia += passo;
	if(copie < MAX_COPIE && attesaCopia >= PASSO_COPIA) {
		attesaCopia = 0;
		// The copies come out of a pipe as well, like everything else that
		// arrives in this room: born already inside the one at the top on the
		// side he is facing, and the passage in obj_stage7_three_guardians
		// brings them out. (The original creates them at the room's edge and
		// lets them slide in, which here looked like they came from nowhere.)
		var c = instance_create_layer(0, 48, "Objects", obj_stage7_degbubble);
		c.finto = true;
		c.verso = verso;
		if(instance_exists(obj_stage7_three_guardians)) {
			c.visible = false;
			c.depth = 350;
			c.tubo = obj_stage7_three_guardians.DENTRO * 0.9;
		}
	}
}

// ---- taking a hit ---------------------------------------------------------
// The copies (ev. 347-350) go down at the first touch of anything, the real
// one (ev. 340-344) counts the points. The fireball does nothing to either
// except pop, exactly as with Spike.
var danno = 0;
var toccato = false;

var fuoco = instance_place(x, y, obj_fireball);
if(fuoco != noone) {
	instance_destroy(fuoco);
	audio_play_sound(finto ? snd_boss_3_boo_dead : snd_fireball_impact, 1, false);
	toccato = true;
}

if(graziaDanno <= 0) {
	var martello = instance_place(x, y, obj_hammer_player);
	if(martello != noone) { instance_destroy(martello); danno = 1; toccato = true; }

	var croce = instance_place(x, y, obj_cross);
	if(danno == 0 && croce != noone) { danno = 2; toccato = true; }

	if(danno == 0 && graziaOnda <= 0 && instance_exists(obj_block_hit_detector) &&
	   instance_place(x, y, obj_block_hit_detector) != noone) {
		danno = 1;
		graziaOnda = GRAZIA_ONDA;
		toccato = true;
		if(instance_exists(obj_player))
			verso = (obj_player.x >= x) ? -1 : 1;
	}
}

if(finto) {
	// ev. 347-350: any hit at all and the copy is gone, with its own sound.
	if(toccato) {
		audio_play_sound(snd_boss_3_boo_dead, 1, false);      // "inpact_16"
		instance_destroy();
		return;
	}
} else if(danno > 0) {
	vita -= danno;
	audio_play_sound(snd_boss_2_weapon, 1, false);            // "inpact_08"
	audio_play_sound(snd_flying_goomba_hit, 1, false);        // "boss_01"
	sprite_index = spr_stage7_degbubble_hit;
	image_index = 0;
	image_speed = 1;
	lampeggio = LAMPEGGIO;
	graziaDanno = GRAZIA_DANNO;
}

// ev. 345: when he goes, the copies and every bubble in the air go with him.
if(!finto && vita <= 0 && stato == "vivo") {
	stato = "morto";
	sprite_index = spr_stage7_degbubble_death;
	image_index = 0;
	image_speed = 1;
	audio_play_sound(snd_enemy_defeat, 1, false);             // "inpact_02"
	with(obj_stage7_bubble) instance_destroy();
	with(obj_stage7_degbubble) if(finto) instance_destroy();
}

// ---- he hurts on contact --------------------------------------------------
if(stato == "vivo" && instance_exists(obj_player) && place_meeting(x, y, obj_player) &&
   !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(2);
