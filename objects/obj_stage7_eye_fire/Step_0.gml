// ev. 377: when the eye goes, these go with it. Now that it stays around for a
// second falling out of the room, "gone" means beaten, not destroyed.
if(!instance_exists(obj_stage7_eye) || obj_stage7_eye.stato == "battuto") {
	instance_destroy();
	return;
}

// While the eye is inside a pipe it is out of play: these go with it.
if(obj_stage7_eye.tubo > 0) {
	visible = false;
	return;
}
visible = true;

if(global.playerDead) return;

var passo = delta_time / 1000000;

angolo -= VELOCITA_ANGOLARE * passo;

// The eye's origin is at its feet, so its middle is half a sprite higher.
var o = obj_stage7_eye;
x = o.x + lengthdir_x(RAGGIO, angolo);
y = (o.y - sprite_get_height(spr_stage7_eye_move) / 2) + lengthdir_y(RAGGIO, angolo);

scia += passo;
if(scia > PASSO_SCIA) {
	instance_create_layer(x, y, "Objects", obj_fire_rod_trail);
	scia = 0;
}

if(instance_exists(obj_player) && place_meeting(x, y, obj_player) &&
   !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(2);
