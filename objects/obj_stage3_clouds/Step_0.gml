// With parallax scrolling switched off in the options the clouds stand
// still too: the whole background then behaves as one fixed picture, as it
// does in every other room (obj_stage_manager/Step_2 stops moving its
// layers on the same flag).
if(!global.playerDead && global.parallaxScrolling) {
	scorrimento += velocita;
	if(scorrimento >= larghezza)
		scorrimento -= larghezza;
}
layer_x("Nuvole", -scorrimento);
