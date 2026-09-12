if(global.playerDead) {
	image_speed = 0;
	return;
}
image_speed = 1;

var passo = delta_time / 1000000;

// ---- he is down: the jingle, then the ending ----------------------------
if(stato == "morto") {
	morteTimeout += passo;
	if(morteTimeout > JINGLE_A && !musicaMorte) {
		musicaMorte = true;
		audio_play_sound(global.bgm_boss_defeated, 1, false);   // "crear_2", ev. 7
	}
	if(morteTimeout > FINE_A) {
		// ev. 8. SILENCE FIRST, then the gain. obj_stage_manager keeps the
		// arena loop alive while he dies, muted, and the gain has to go back
		// up or the next run through the arena would be silent. Turning it up
		// here while the loop is still running leaves a scrap of King Koopa
		// playing into the next room, between this step and the Create of the
		// room after it. Stopping everything first costs nothing: the victory
		// jingle is over by now (it ends around 6.3s, this is 9s).
		audio_stop_all();
		audio_sound_gain(global.bgm_boss_final_loop, 1, 0);
		level_finished(global.currentStage, global.playerWeapon, global.hearts, global.pHealth);
		room_goto(ending);   // the princess room, frame 65 of the original
	}
	return;
}

if(PROVA && keyboard_check_pressed(ord("K"))) vita = 0;
if(PROVA && keyboard_check_pressed(ord("J")) && giocatore) {
	// a moving shell sent from the player towards him, to try the dodge
	var g = instance_create_layer(obj_player.x - 24 * sign(obj_player.x - x), PAVIMENTO, "Objects", obj_koopa);
	g.dead = true;
	g.shellMoving = true;
	g.shellDirection = -sign(obj_player.x - x);
	g.sprite_index = spr_shell_green;
}

var giocatore = instance_exists(obj_player);
var px = giocatore ? obj_player.x : x;

// ---- the koopas (ev. 287/288) -------------------------------------------
attesaKoopa += passo;
if(attesaKoopa >= ATTESA_KOOPA) {
	attesaKoopa = 0;
	// a flipped-over koopa is on its way out and does not count, as in the
	// original where the flip is a different object
	var vivi = 0;
	with(obj_koopa) if(!defeated) vivi += 1;
	if(vivi == 0 && giocatore) {
		// The original's koopas are born 16 px outside the room and walk in;
		// here they are born just inside the walls, and a player standing
		// right there would get one on top of him. In that case it comes in
		// from the other side instead.
		var daDestra = koopaDaDestra;
		var kx = daDestra ? KOOPA_X_DESTRA : KOOPA_X_SINISTRA;
		if(abs(px - kx) < KOOPA_MARGINE) {
			daDestra = !daDestra;
			kx = daDestra ? KOOPA_X_DESTRA : KOOPA_X_SINISTRA;
		}
		var k = instance_create_layer(kx, KOOPA_Y, "Objects", obj_koopa);
		k.entityDirection = daDestra ? -1 : 1;
		koopaDaDestra = !daDestra;
	}
}

// ---- the anchor's vertical motion: the engine's, see the Create -----------
if(inAria) {
	y += vy * passo;
	vy += GRAVITA * passo;
	if(y >= PAVIMENTO) {
		y = PAVIMENTO;
		inAria = false;
		vy = 0;
		audio_play_sound(snd_impact_generic, 1, false);   // "inpact_10", ev. 318/319
		if(stato == "guscio") {
			// ev. 319: inside the shell every landing is a new hop
			vy = -RIMBALZO_GUSCIO * UNITA_SALTO;
			inAria = true;
		}
	}
}

// ---- the anchor's horizontal motion, inside the two limits ---------------
x += velocita * direzione * passo;
if(x < X_MIN) x = X_MIN;
if(x > X_MAX) x = X_MAX;

// ---- what he does -------------------------------------------------------
switch(stato) {

case "attesa":
	// ev. 292: he stands for a second, then walks; he already faces the
	// player, the drawing's animation 0 runs from the first frame
	if(giocatore && px != x) verso = sign(px - x);
	tempoInizio += passo;
	if(tempoInizio >= ATTESA_INIZIO) {
		stato = "cammina";
		velocita = VELOCITA_PASSO;
	}
	break;

case "cammina":
	// ev. 296/297: the drawing faces the player, even while he backs away
	if(giocatore && px != x) verso = sign(px - x);

	// ev. 301-304: keep a hundred pixels. Nearer than that he backs off at
	// once; farther, every second he decides to come closer, and in between
	// he keeps going the way he was going.
	attesaAvvicina += passo;
	if(abs(px - x) <= DISTANZA) {
		direzione = -sign(px - x);
		if(direzione == 0) direzione = 1;
	} else if(attesaAvvicina >= ATTESA_AVVICINA) {
		direzione = sign(px - x);
	}
	if(attesaAvvicina >= ATTESA_AVVICINA) attesaAvvicina = 0;

	// ev. 321: a kicked shell coming within 39 px, and he hops over it
	if(!inAria) {
		var vicino = false;
		with(obj_koopa) {
			if(dead && shellMoving && !defeated && sqr(other.x - x) < other.SCHIVA_QUADRATO) vicino = true;
		}
		if(vicino) {
			vy = -SALTO_SCHIVA * UNITA_SALTO;
			inAria = true;
		}
	}

	// ev. 320: every 600 ms one chance in five of a jump, from the ground.
	// He keeps his walking speed in the air: the jump goes forward.
	attesaSalto += passo;
	if(attesaSalto >= ATTESA_SALTO) {
		attesaSalto = 0;
		if(!inAria && irandom(PROBABILITA - 1) == 0) {
			vy = -(SALTO_MIN + irandom(SALTO_CASUALE - 1)) * UNITA_SALTO;
			inAria = true;
		}
	}

	// ev. 323, 329, 333: every 500 ms the three draws. Each one stops the
	// anchor; a jump already under way just goes on falling.
	attesaAttacco += passo;
	if(attesaAttacco >= ATTESA_ATTACCO) {
		attesaAttacco = 0;
		if(irandom(PROBABILITA - 1) == 0) {
			stato = "sputo";
			tempoAttacco = 0;
			velocita = 0;
			sprite_index = spr_boss_7_spit;
			image_index = 0;
			audio_play_sound(snd_boss_4_leap, 1, false);       // "inpact_18"
		} else if(irandom(PROBABILITA - 1) == 0) {
			stato = "martelli";
			tempoAttacco = 0;
			martelliLanciati = 0;
			velocita = 0;
			sprite_index = spr_boss_7_throw;
			image_index = 0;
		} else if(!inAria && irandom(PROBABILITA - 1) == 0) {
			stato = "guscio";
			tempoAttacco = 0;
			scattato = false;
			velocita = 0;
			sprite_index = spr_boss_7_shell;
			image_index = 0;
			vy = -(SALTO_GUSCIO_MIN + irandom(SALTO_CASUALE - 1)) * UNITA_SALTO;
			inAria = true;
			audio_play_sound(snd_boss_3_boo_dead, 1, false);   // "inpact_16"
			audio_play_sound(snd_boss_3_summon, 1, false);     // "boss_03"
		}
	}
	break;

case "sputo":
	tempoAttacco += passo;
	if(tempoAttacco >= DURATA_SPUTO) {
		// ev. 324: the fireball leaves the mouth the way he is facing, and
		// ev. 325 gives it the player's head height, once, right now
		audio_play_sound(snd_boss_4_roar, 1, false);   // "inpact_17"
		var p = instance_create_layer(x + BOCCA_X * verso, y + BOCCA_Y, "Objects", obj_boss_7_fireball);
		p.vx = VELOCITA_PALLA * verso;
		p.image_xscale = verso;
		p.bersaglioY = giocatore ? obj_player.y - 16 : y + BOCCA_Y;
		stato = "cammina";
		velocita = VELOCITA_PASSO;
		sprite_index = spr_boss_7;
		image_index = 0;
	}
	break;

case "martelli":
	tempoAttacco += passo;
	// ev. 330/331: at frame 2 of every loop of the animation, one hammer
	while(martelliLanciati < MARTELLI && tempoAttacco >= martelliLanciati * GIRO_MARTELLI + GIRO_MARTELLI / 2) {
		var a = ANGOLI_MARTELLO[irandom(2)];
		var h = instance_create_layer(x + MANO_X * verso, y + MANO_Y, "Objects", obj_boss_7_hammer);
		h.vx = VELOCITA_MARTELLO * dcos(a) * verso;
		h.vy = -VELOCITA_MARTELLO * dsin(a);
		audio_play_sound(snd_throw, 1, false);   // "tw_01"
		martelliLanciati += 1;
	}
	if(tempoAttacco >= DURATA_MARTELLI) {
		// ev. 300: the throwing is over, he walks again
		stato = "cammina";
		velocita = VELOCITA_PASSO;
		sprite_index = spr_boss_7;
		image_index = 0;
	}
	break;

case "guscio":
	tempoAttacco += passo;
	// ev. 335/336: half a second in, the dash towards the player
	if(!scattato && tempoAttacco >= SCATTO_A) {
		scattato = true;
		direzione = (px < x) ? -1 : 1;
		velocita = VELOCITA_SCATTO;
		audio_play_sound(snd_boss_7_dash, 1, false);   // "inpact_20"
	}
	// ev. 337: at a second and a half he stops and pops out with a jump.
	// Nothing in the original gives the anchor its walking speed back after
	// this: he stands where he landed until a hit or the next attack.
	if(tempoAttacco >= FINE_GUSCIO) {
		stato = "cammina";
		velocita = 0;
		sprite_index = spr_boss_7;
		image_index = 0;
		vy = -SALTO_USCITA * UNITA_SALTO;
		inAria = true;
	}
	break;

case "colpito":
	// the shell's stop: when the flash is over he walks again (ev. 299)
	tempoColpito += passo;
	if(tempoColpito >= DURATA_COLPITO) {
		stato = "cammina";
		velocita = VELOCITA_PASSO;
	}
	break;
}
image_xscale = verso;

// ---- weapons and shells -------------------------------------------------
if(graziaCroce > 0) graziaCroce -= passo;

var martello = instance_place(x, y, obj_hammer_player);
var fuoco = instance_place(x, y, obj_fireball);
var croce = instance_place(x, y, obj_cross);
var danno = 0;

if(stato == "guscio") {
	// ev. 312-316: curled up he cannot be hurt, and the weapons bounce off:
	// the hammer breaks, the fireball goes out, the cross just rings
	if(martello != noone) {
		audio_play_sound(snd_fireball_impact, 1, false);   // "inpact_01"
		instance_destroy(martello);
	}
	if(fuoco != noone) {
		audio_play_sound(snd_shell_hit_2, 1, false);       // "inpact_09"
		var e = instance_create_layer(fuoco.x, fuoco.y, "Objects", obj_fireball_explosion);
		e.emitter = fuoco.emitter;
		instance_destroy(fuoco);
	}
	if(croce != noone && graziaCroce <= 0) {
		audio_play_sound(snd_shell_hit_2, 1, false);       // "inpact_09"
		graziaCroce = GRAZIA_CROCE;
	}
	// ev. 315/316: a koopa or a shell that touches the shell is flipped over
	var travolto = false;
	with(obj_koopa) {
		if(!defeated && place_meeting(x, y, other)) {
			defeated = true;
			sprite_index = spr_koopa_defeated;
			travolto = true;
		}
	}
	if(travolto) audio_play_sound(snd_enemy_defeat, 1, false);   // "inpact_02"
} else {
	if(martello != noone) {                                   // ev. 306
		danno += DANNO_MARTELLO;
		instance_destroy(martello);
	}
	if(fuoco != noone) {                                      // ev. 307
		danno += DANNO_FUOCO;
		var e = instance_create_layer(fuoco.x, fuoco.y, "Objects", obj_fireball_explosion);
		e.emitter = fuoco.emitter;
		instance_destroy(fuoco);
	}
	if(croce != noone && graziaCroce <= 0) {                  // ev. 308
		danno += DANNO_CROCE;
		graziaCroce = GRAZIA_CROCE;
	}
	// ev. 309: a moving shell, the big one, and the shell is flipped over
	var colpitoDalGuscio = false;
	with(obj_koopa) {
		if(dead && shellMoving && !defeated && place_meeting(x, y, other)) {
			defeated = true;
			sprite_index = spr_koopa_defeated;
			colpitoDalGuscio = true;
		}
	}
	if(colpitoDalGuscio) {
		danno += DANNO_GUSCIO;
		audio_play_sound(snd_enemy_defeat, 1, false);        // "inpact_02"
		// and this one stops him: the anchor halts, the attack under way is
		// lost, and only when the flash is over does he walk again
		stato = "colpito";
		tempoColpito = 0;
		velocita = 0;
		sprite_index = spr_boss_7;
		image_index = 0;
	}
}

if(lampeggio > 0) lampeggio -= passo;

if(danno > 0) {
	vita -= danno;
	audio_play_sound(snd_boss_2_weapon, 1, false);   // "inpact_08"
	audio_play_sound(snd_boss_3_hit, 1, false);      // "boss_05"
	// only the flash, restarted at every hit: he neither stops nor drops
	// what he is doing (see the Create)
	lampeggio = LAMPEGGIO;
}

// ev. 310: the death is an event of its own, watched every step
if(vita <= 0 && stato != "morto") {
	stato = "morto";
	morteTimeout = 0;
	velocita = 0;
	visible = false;
	// all the sounds stop, the music too: the gain trick keeps the arena
	// loop silent under the jingle, as with the other bosses
	audio_stop_sound(global.bgm_boss_final_intro);
	audio_stop_sound(global.bgm_boss_final_loop);
	audio_sound_gain(global.bgm_boss_final_loop, 0, 0);
	audio_play_sound(snd_boss_3_defeat, 1, false);   // "boss_04"
	var m = instance_create_layer(x, y, "Objects", obj_boss_7_death);
	m.image_xscale = verso;
	// everything he had in the air goes, and the koopas and shells with him
	with(obj_boss_7_fireball) instance_destroy();
	with(obj_boss_7_hammer) instance_destroy();
	var caduti = false;
	with(obj_koopa) {
		if(!defeated) {
			defeated = true;
			sprite_index = spr_koopa_defeated;
			caduti = true;
		}
	}
	if(caduti) audio_play_sound(snd_enemy_defeat, 1, false);
	return;
}

// ---- he hurts on contact, from any side (ev. 24, qualifier 18) -----------
if(giocatore && place_meeting(x, y, obj_player) &&
   !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(3);
