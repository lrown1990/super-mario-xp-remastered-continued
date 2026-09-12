// Whoever was being played stays on screen for the ending.
if(global.character == "luigi")
	sprite_index = spr_luigi_idle;

// The original has him looking left, towards her: the port's sprites
// all face right, so he is mirrored instead.
image_xscale = -1;
depth = -100;
