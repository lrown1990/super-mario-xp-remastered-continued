// The halo is added to what is already on screen, like obj_lava does with the
// lava, so it lights the wall instead of covering it. Then the flame goes on
// top, drawn normally.
gpu_set_blendmode(bm_add);
draw_sprite_ext(spr_torch_glow, alone_indice, x, y - 9, 1, 1, 0, c_white, 0.5);
gpu_set_blendmode(bm_normal);
draw_self();
