// The hit flash: the original's animation 15 alternates a bright red, a dark
// red and a darker silhouette with the normal frame, 40 ms each. Here the
// silhouette is a white copy of the current pose tinted with those colours,
// so it follows him whatever he is doing.
var fase = -1;
if(lampeggio > 0)
	fase = floor((LAMPEGGIO - lampeggio) / PASSO_LAMPEGGIO) mod array_length(COLORI_LAMPEGGIO);
var sagoma = noone;
if(fase >= 0 && COLORI_LAMPEGGIO[fase] != -1) {
	if(sprite_index == spr_boss_7) sagoma = spr_boss_7_sil;
	else if(sprite_index == spr_boss_7_spit) sagoma = spr_boss_7_spit_sil;
	else if(sprite_index == spr_boss_7_throw) sagoma = spr_boss_7_throw_sil;
}
if(sagoma != noone)
	draw_sprite_ext(sagoma, image_index, x, y, image_xscale, image_yscale, 0, COLORI_LAMPEGGIO[fase], image_alpha);
else
	draw_self();

if(PROVA) {
	draw_set_font(small_font);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	var k = 0;
	with(obj_koopa) if(!defeated) k += 1;
	draw_text(4, 40, "vita " + string(vita) + " stato " + stato + chr(10)
		+ "x " + string(round(x)) + " y " + string(round(y)) + " vy " + string(round(vy)) + chr(10)
		+ "vel " + string(velocita) + " dir " + string(direzione) + " verso " + string(verso) + chr(10)
		+ "koopa " + string(k) + " martelli " + string(instance_number(obj_boss_7_hammer))
		+ " palle " + string(instance_number(obj_boss_7_fireball)));
}
