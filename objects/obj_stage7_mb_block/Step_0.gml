// The bump was off by ONE PIXEL and had never worked. Measured: this block's
// sprite has its origin at the BOTTOM, so an instance placed at y=176 covers
// 160-175, while the player's mask stops with its top at 177 (the ground he
// bumps into covers the same 160-175). Shifted down by one the block reaches
// 176: it misses the player's head by a pixel, every time, so in the one room
// built around the bump neither the sound nor the block's own animation ever
// fired. obj_brick gets away with the same line because ITS origin is in the
// middle of the tile, which gives it eight pixels of reach downwards: the same
// eight are written here.
if(!activated && place_meeting(x, y + 8, obj_player)) {
	activated = true;
	audio_play_sound(snd_impact, 1, false);

	// The bump is a weapon in this room. In the original every block of the
	// arena is a plain brick, and a brick hit from below fires "Weapon_04",
	// the shock wave that hurts all three guardians (ev. 302, 310, 318, 326,
	// 343, 376). The port's bricks already do this; these blocks did not, so
	// the only room in the game built around the bump was the one room where
	// the bump did nothing. Same detector and same size as obj_brick, sitting
	// on top of the block, where a guardian floating over the row is.
	var onda = instance_create_layer(x + sprite_width / 2, y - sprite_height, "Objects", obj_block_hit_detector);
	onda.image_xscale = 0.75;
	onda.image_yscale = 0.75;
}

if(!activated)
	sprite_index = spr_mb_block;
else
	sprite_index = spr_mb_block_collision;
	
	
// It re-arms only once the player is out from under it. Before, it re-armed as
// soon as its own animation was over (about a sixth of a second), so a single
// bump threw off several shock waves in a row and a guardian standing on the
// row took two or three points from one headbutt.
if(activated && image_index >= 7 && !place_meeting(x, y + 8, obj_player))
	activated = false;
