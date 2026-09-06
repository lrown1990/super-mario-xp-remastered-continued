// The eye of Cookie, the third of the three guardians of 7-2 (original level
// 61, event group "kukki no me", events 366-385). Behaviour from the events,
// numbers from the longplay: see
// port/marioxp-originale/BOSS-MEZZI-7-2-SPECIFICA.md.
//
// A green ball that WALKS THE BLOCK ROWS after the player with its eye shut,
// and every four seconds stops and opens it. Shut it is armour: weapons ring
// off it (ev. 379-383). Open it is the only moment it can be hurt (ev.
// 373-376). Two fireballs turn around it the whole time.

depth = 30;
profonditaPrima = depth;

// ev. 377: the counter dies at -4.
vita = 4;

// MEASURED on the longplay, tracked frame by frame at 50 fps (the same frame
// rate as the original), the fight at 37:50 of the video:
// - it walks at 36 px/s and never floats: its centre sits at y=36 over the row
//   at 48, at y=92 over the row at 104, and so on;
// - a fall from one row to the next, 56 px, takes 0.38 s;
// - it walks TOWARDS the player and turns round when it has gone past him
//   (three reversals in a row followed the player's own turns);
// - it stands still for 1.6 s at a time, about every 4 s of walking.
VELOCITA = 36;
GRAVITA = 700;
CADUTA_MAX = 250;
PASSO_SOSTA = 4;
DURATA_SOSTA = 1.6;

// ev. 369: it only stops well inside the room, so it never opens half off screen.
BORDO_SINISTRO = 32;
BORDO_DESTRO = 288;

GRAZIA_DANNO = 0.3;
// A block bumped from below throws off several shock waves in a row (the block
// re-arms as soon as its own little animation is over), and with the short
// grace above one bump was taking two or three points off. The wave gets a
// grace of its own: ONE hit per bump, whatever the block does.
GRAZIA_ONDA = 1.2;
graziaOnda = 0;

verso = -1;
vy = 0;
attesaSosta = 0;
sosta = 0;
tubo = 0;                    // > 0 while it is going through a pipe
stato = "muove";             // "muove", "aperto", "morto"
graziaDanno = 0;
sprite_index = spr_stage7_eye_move;
image_speed = 1;

// ev. 366: the two Enemy_24/Enemy_25 born with it and stuck to it. On the
// video they are two fireballs turning around it, half a turn apart.
var f = instance_create_layer(x, y, "Objects", obj_stage7_eye_fire);
f.angolo = 0;
f = instance_create_layer(x, y, "Objects", obj_stage7_eye_fire);
f.angolo = 180;
