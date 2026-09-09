// Moves the cloud layer of Bowser's arena. The layer is tiled horizontally, so
// the offset is wrapped at the width of the sprite and the clouds never end.
scorrimento = 0;
larghezza = sprite_get_width(spr_stage7_clouds);
velocita = 0.025;                  // pixels per frame, that is 1.5 a second
