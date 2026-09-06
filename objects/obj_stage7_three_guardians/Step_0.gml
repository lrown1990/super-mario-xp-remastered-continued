if(global.playerDead) return;

var passo = delta_time / 1000000;

// ---- the loop -------------------------------------------------------------
// ev. 33 and 34 for the player, ev. 276-279 for the guardians. It stays on all
// through the fight; it is only let go for the walk out at the end, which is
// the one time somebody is meant to leave the room.
if(stato != "uscita" && instance_exists(obj_player)) {
	if(obj_player.x < 0) obj_player.x = 320;
	else if(obj_player.x > 320) obj_player.x = 0;
}

with(obj_stage7_guardian) {
	// One that has been beaten is falling out of the room on purpose: the
	// round of the room must not catch it and put it back at the top.
	if(stato == "battuto" || stato == "morto") continue;

	// ---- the pipes -------------------------------------------------------
	// Down on the floor the room is not left sideways: they walk into the pipe
	// at the side, the pipe swallows them, and they come back out of the pipe
	// at the top on the same side (ev. 278 and 279), turned back inwards, and
	// the round starts again.
	if(tubo > 0) {
		tubo -= passo;
		if(tubo > other.DENTRO) {
			// Walking into the mouth. The walking is done here and not by the
			// guardian itself, because it also has to slide to the middle of
			// the hole and its own gravity would pull it straight back down.
			x += VELOCITA * verso * passo;
			var meta = other.CENTRO_TUBO + sprite_height / 2;
			y += clamp(meta - y, -other.VELOCITA_CENTRA * passo, other.VELOCITA_CENTRA * passo);
		} else if(visible) {
			visible = false;                  // deep inside now, out of sight
		}
		if(tubo <= 0) {
			// Out of the pipe at the top, on the same side, walking back in.
			// It comes out in the MIDDLE of that hole, the same way it went
			// into the one below, and from there its own weight drops it onto
			// the first row of blocks. The depth stays behind the pipe until
			// it is clear of the art, just below.
			x = (verso < 0) ? other.USCITA_SX : other.USCITA_DX;
			y = other.CENTRO_TUBO_ALTO + sprite_height / 2;
			vy = 0;
			verso = -verso;
			visible = true;
			audio_play_sound(snd_warp_pipe, 1, false);
		}
		continue;
	}

	// Clear of the pipe art: it can be drawn in front of the room again. The
	// whole body has to be out, not just the middle, or the half still over
	// the pipe would pop into view.
	if(depth != profonditaPrima &&
	   x - sprite_width / 2 > other.FINE_TUBO_SX &&
	   x + sprite_width / 2 < other.FINE_TUBO_DX)
		depth = profonditaPrima;

	if(y > 200) {
		if((verso < 0 && x < other.BOCCA_SX) || (verso > 0 && x > other.BOCCA_DX)) {
			tubo = other.DURATA_TUBO;
			// The pipes are tiles on a layer at depth 300, so anything at the
			// usual depth of 30 walks OVER them. Going behind that layer is
			// what makes the walk into the mouth read as going in.
			depth = 350;
			audio_play_sound(snd_warp_pipe, 1, false);
			continue;
		}
	}

	if(y > 200) {
		// Last resort, if one ever gets past the mouth without going in: the
		// first version teleported here with no change of direction, and they
		// came back out still walking outwards, fell into the strip past the
		// end of the rows (which stop at x=320) and bounced between the two
		// teleports for ever. That is what left the little mines stuck against
		// the side of the room, and, since they were still alive, it is also
		// why killing every one you could see never ended the phase.
		if(x < 0) { x = other.USCITA_SX; y = 48; verso = 1; vy = 0; }
		else if(x > 320) { x = other.USCITA_DX; y = 48; verso = -1; vy = 0; }
	} else {
		// ev. 276 and 277: on the rows above, straight round the side and back
		// in on the other one, still going the same way.
		if(x < 0) x = 320;
		else if(x > 320) x = 0;
	}

	// Last resort: anything that has fallen out of the room altogether comes
	// back in from the top instead of being lost with the phase never ending.
	if(y > 260) { x = clamp(x, 8, 312); y = 48; vy = 0; }
}

// ---- the three, one after the other ---------------------------------------
switch(stato) {
	case "attesa": {
		attesa -= passo;
		if(attesa <= 0) {
			var nato = noone;
			switch(fase) {
				// ev. 297, 335 and 366 have them appear at a fixed spot; here
				// they all come out of a pipe instead (see just below), so the
				// position given at birth does not matter.
				case 0: nato = instance_create_layer(0, 48, "Objects", obj_stage7_spike); break;
				case 1: nato = instance_create_layer(0, 48, "Objects", obj_stage7_degbubble); break;
				case 2: nato = instance_create_layer(0, 48, "Objects", obj_stage7_eye); break;
			}
			// They never simply appear: the first time in, they come out of one
			// of the two pipes at the top, drawn at random, exactly like every
			// round of the room after that. Created already inside the pipe,
			// so the passage above brings them out with its own sound.
			if(nato != noone) {
				nato.verso = choose(-1, 1);
				nato.visible = false;
				nato.profonditaPrima = nato.depth;
				nato.depth = 350;
				nato.tubo = DENTRO * 0.9;
			}

			attesaFantasma = 0;
			stato = "combatte";
		}
		break;
	}

	case "combatte": {
		// ev. 292-295. In the original the ghost belongs to Spike's group
		// alone; here it crosses the room through all three fights, which is
		// how the user wants the room to feel.
		{
			attesaFantasma += passo;
			if(attesaFantasma >= PASSO_FANTASMA) {
				attesaFantasma = 0;
				if(instance_exists(obj_player)) {
					// The dummy that fires it jumps to the far side of the
					// room from the player, so it always comes head on.
					// It flies down the MIDDLE OF A LANE, one of the four
					// corridors between the rows of blocks, drawn fresh every
					// time: so it turns up now in one, now in another, and
					// sometimes twice running in the same one. Before this it
					// was given any height at all and spent most of its
					// crossings inside the blocks.
					var daSinistra = obj_player.x >= 160;
					var f = instance_create_layer(daSinistra ? -16 : 336,
					                              CORSIE[irandom(3)], "Objects", obj_stage7_boo);
					f.verso = daSinistra ? 1 : -1;

					// In the THIRD fight of the room, whichever guardian that
					// turns out to be, a second one comes over with it: the one
					// that crosses on a slant, bouncing between the floor and
					// the blocks. It draws its own lane, so the two of them
					// hardly ever come at the same height. It is the room
					// getting harder as it goes.
					if(rimasti == 1) {
						var c = irandom(3);
						var f2 = instance_create_layer(daSinistra ? -16 : 336,
						                               CORSIE[c], "Objects", obj_stage7_boo);
						f2.verso = daSinistra ? 1 : -1;
						f2.rimbalza = true;
						f2.limiteSu = CORSIE_SU[c];
						f2.limiteGiu = CORSIE_GIU[c];
						f2.vy = choose(-1, 1) * f2.VELOCITA_SU_GIU;
					}
				}
			}
		}

		var vivo = false;
		switch(fase) {
			case 0: vivo = instance_exists(obj_stage7_spike); break;
			// the copies do not count: the phase is over when the real one goes
			case 1: with(obj_stage7_degbubble) if(!finto) vivo = true; break;
			case 2: vivo = instance_exists(obj_stage7_eye); break;
		}

		if(!vivo) {
			rimasti--;
			if(rimasti > 0) {
				// The ghosts keep flying between one fight and the next: they
				// belong to the room, not to the guardian that has just gone.
				attesa = ATTESA_FRA[fase];
				fase = (fase + 1) mod 3;
				stato = "attesa";
			} else {
				// The last of the three is down, and only now do the ghosts go
				// with it, BOTH of them. They are not simply removed: they are
				// beaten, sound, upside down and out of the bottom of the room,
				// the way a stomped enemy goes. (ev. 330 clears them out when
				// the fight is over.)
				with(obj_stage7_boo) {
					if(!morto) {
						morto = true;
						image_yscale = -1;
						image_speed = 0;
						vy = -270;
						audio_play_sound(snd_enemy_defeat, 1, false);
					}
				}

				attesa = ATTESA_USCITA;
				stato = "finito";
			}
		}
		break;
	}

	case "finito": {
		attesa -= passo;
		if(attesa <= 0) stato = "uscita";
		break;
	}

	// ev. 281-283: the controls are taken away and the player walks off to the
	// left by himself. Nothing else is needed to change room: walking out of
	// the room on the left is what the obj_screen_advance bar is there for.
	case "uscita": break;
}
