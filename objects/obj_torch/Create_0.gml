// Behind everything that moves in the room. The player sits at depth 100 and
// goes to 150 while entering a pipe, enemies and bosses set themselves between
// 20 and 40, so 170 keeps the torch on the wall and lets anyone pass in front
// of it. The room drawing is further back still, on the layer at depth 300.
depth = 170;

// One of the six torches of Bowser's arena. Every torch picks its own starting
// frame and its own pace, otherwise the six flames beat together and the wall
// looks like one animation copied six times.
image_index = irandom(image_number - 1);
ritmo = 0.75 + random(0.55);
image_speed = ritmo;

// The halo pulses on its own, slower than the flame and out of step with it.
alone_numero = sprite_get_number(spr_torch_glow);
alone_indice = random(alone_numero);
alone_passo = 0.02 + random(0.03);
