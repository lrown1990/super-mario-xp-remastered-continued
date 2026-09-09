// The gate of a boss arena. It is an invisible wall at the edge of the room,
// solid like any obj_ground, and it stands there for as long as the fight
// lasts: outside the arena there is no floor, so walking out was not an exit,
// it was a fall and a death.
// When the boss goes down it opens, and only then can the stage be left on
// that side. global.bossBattuto is put back to false by obj_stage_manager at
// the start of every room, so it never opens on its own.
if(global.bossBattuto) {
	instance_destroy();
}
