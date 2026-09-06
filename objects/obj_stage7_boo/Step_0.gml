if(global.playerDead) return;

var passo = delta_time / 1000000;

// ---- beaten: it goes out the way the enemies of the game go ---------------
// Nothing in the fight can kill it; this is the end of the round, when the
// guardian it came with is down. It used to blink out, which looked like a bug.
if(morto) {
	vy += 700 * passo;
	y += vy * passo;
	if(y > room_height + 64) instance_destroy();
	return;
}

x += (rimbalza ? VELOCITA_RIMBALZO : VELOCITA) * verso * passo;
image_xscale = verso;       // the frames imported are the "facing right" set

if(rimbalza) {
	// Green, so it is told apart from the other one at a glance.
	if(sprite_index != spr_stage7_boo_verde) sprite_index = spr_stage7_boo_verde;

	// Up and down between the ceiling and the floor OF ITS OWN LANE, drawing
	// the zigzag all the way across. Before this it bounced off whatever it
	// met in the whole room and ended up wandering along the middle rail.
	y += vy * passo;
	if(y <= limiteSu)  { y = limiteSu;  vy =  abs(vy); }
	if(y >= limiteGiu) { y = limiteGiu; vy = -abs(vy); }
}

// It is not part of the room's round: it crosses once and goes.
if(x < -32 || x > 352) {
	instance_destroy();
	return;
}

if(instance_exists(obj_player) && place_meeting(x, y, obj_player) &&
   !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(2);
