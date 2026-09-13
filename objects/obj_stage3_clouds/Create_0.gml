// Moves the cloud layer of the Nightmare arena (stage 3-7). The layer is
// tiled horizontally, so the offset is wrapped at the width of the sprite and
// the clouds never end. Same mechanism as obj_stage7_clouds in Bowser's arena.
scorrimento = 0;
larghezza = sprite_get_width(spr_stage3_clouds);
velocita = 1 / 60;                 // pixels per frame, that is 1 a second
