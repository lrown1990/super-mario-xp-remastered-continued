if(appearing && y > initialY - sprite_height && !global.playerDead){
	y -= 0.35;
} else {
	appearing = false;
}

onGround = place_meeting(x, y + 1, obj_ground_group);

if(place_meeting(x, y, obj_player) && !appearing) {
	switch(mushroomType) {
		case "normal": {
			audio_play_sound(snd_mushroom_collect, 1, false);
			global.pHealth += 4;
			instance_destroy();
			break;
		}
		
		case "poisoned": {
			switch(global.character) {
				case "mario": {
					audio_play_sound(snd_poison_mushroom, 1, false);
					break;
				}
				
				case "luigi": {
					audio_play_sound(snd_luigi_poison_mushroom, 1, false);
					break;
				}
			}
			global.pHealth -= 4;
			obj_player.hitState = true;
			instance_destroy();
			break;
		}
		
		case "life": {
			audio_play_sound(snd_life_up, 1, false);
			global.playerLives++;
			if(chiaveUnUp != "")
				array_push(global.unUpPresi, chiaveUnUp);
			instance_create_layer(x, y, "Objects", obj_1up_indicator);
			instance_destroy();
			break;
		}
	}
}

if(!appearing && !global.playerDead) {
	x += round(entitySpeed * entityDirection);
}

if(!appearing && place_meeting(x, y + 1, obj_ground_group)){
	var brick = instance_place(x, y + 1, obj_block_hit_detector);
	var block = instance_place(x, y + 1, obj_block_hit_detector);
	
	if(instance_exists(obj_player)) {
		if(brick != noone && entityCurrentY == 0 && onGround) {
			entityCurrentY = -3;
		
			if(x < brick.x && entityDirection == 1) {
				entityDirection = -1;
			} else if (x >= brick.x && entityDirection == -1) {
				entityDirection = 1;
			}
		} else if(block != noone && entityCurrentY == 0 && onGround) {
			entityCurrentY = -3;
		
			if(x < block.x && entityDirection == 1) {
				entityDirection = -1;
			} else if (x >= block.x && entityDirection == -1) {
				entityDirection = 1;
			}
		}
	}
}

switch(mushroomType) {
	case "normal": {
		sprite_index = spr_mushroom;
		break;
	}
	
	case "poisoned": {
		sprite_index = spr_poison_mushroom;
		break;
	}
	
	case "life": {
		sprite_index = spr_life_mushroom;
		break;
	}
}

entityCurrentY += 0.2;

// What holds it up is the ground under its CENTRE, one pixel at a time, not
// under its whole mask. With the whole mask (18 px wide) a corner always
// rested on a neighbouring block and it never dropped into a gap one block
// wide, which it does in the original (reported from play, 12 September 2026):
// the original's collision is on the sprite's own pixels, and a mushroom is
// narrow at the bottom. Going up, after a headbutt from below, the whole mask
// still counts, as before.
var scendi = round(entityCurrentY);
if(scendi >= 0) {
	if(!appearing && !global.playerDead) {
		var fatti = 0;
		while(fatti < scendi && !position_meeting(x, y + 1, obj_ground_group)) {
			y += 1;
			fatti += 1;
		}
		if(fatti < scendi)
			entityCurrentY = 0;   // it touched down
	}
} else if(!place_meeting(x, y + scendi, obj_ground_group) && !appearing && !global.playerDead) {
	y += scendi;
} else {
	while(!place_meeting(x, y - 1, obj_ground_group) && !global.playerDead) {
		y -= 1;
	}
	entityCurrentY = 0;
}

// It turns when its LEADING edge meets a wall: a line down the front of the
// sprite, not the whole mask. With the whole mask, the block it had just
// walked off still counted as a wall the moment it dropped a pixel, so it
// flipped back and forth and slid down glued to that edge, "like water"
// (reported from play, 12 September 2026). Now it keeps walking while it
// falls and comes away from the edge; in a hole one block wide it bounces
// between the two sides and goes down the middle.
if(collision_line(x + entityDirection * 9, y - 15, x + entityDirection * 9, y - 1, obj_ground_group, false, true) != noone) {
	entityDirection = -entityDirection;
}

// It turns around at the edges of the screen too, not just at walls. In the
// room before the boss (3-6) the right hand side is open, because that is
// where Mario goes through into the arena: the mushroom slipped in there,
// walked past the end of the floor and dropped out of sight.
if(x < 4 && entityDirection == -1)
	entityDirection = 1;
else if(x > room_width - 4 && entityDirection == 1)
	entityDirection = -1;

if(y > room_height + 32) {
	instance_destroy();
}