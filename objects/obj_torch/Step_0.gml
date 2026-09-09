if(global.playerDead) {
	image_speed = 0;
} else {
	image_speed = ritmo;
	alone_indice += alone_passo;
	if(alone_indice >= alone_numero)
		alone_indice -= alone_numero;
}
