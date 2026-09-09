if(!global.playerDead) {
	scorrimento += velocita;
	if(scorrimento >= larghezza)
		scorrimento -= larghezza;
}
layer_x("Nuvole", -scorrimento);
