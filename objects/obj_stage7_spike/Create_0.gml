// Spike, the first of the three guardians of 7-2 (original level 61, event
// group "supaiku", events 291-331). The behaviour comes from the events, the
// numbers from the longplay: see
// port/marioxp-originale/BOSS-MEZZI-7-2-SPECIFICA.md.
//
// He is one ball that splits in two every time he is killed, four sizes deep:
// 1 -> 2 -> 3 -> 4, so fifteen balls in all before the phase is over.

depth = 30;
profonditaPrima = depth;

// Which size this one is. The ball that comes in is 1; whoever creates a child
// sets this straight after, so nothing in here may depend on it.
livello = 1;

// ev. 304: the counter dies at -3, so three points each, whatever the size.
vita = 3;

// MEASURED on the longplay ("Super Mario XP - Full Gameplay", the 7-2 fight at
// 37:50). All three guardians WALK ALONG THE BLOCK ROWS and fall when the row
// under them ends: none of them floats. Tracked frame by frame at 50 fps, the
// small balls cross the floor at 36 px/s, and a fall from one row to the next
// (56 px) takes 0.38 s.
// This is the whole point of the room: standing on a row is what puts them in
// reach of the shock wave of the block hit from below.
VELOCITA = 36;
GRAVITA = 700;
CADUTA_MAX = 250;

// MEASURED on the longplay, a split followed frame by frame at 50 fps from
// 34.18 to 35.14 of the clip: before coming apart the ball STOPS DEAD and
// flashes for about nine tenths of a second, a flash every eight of a second
// (the flash frames of the original alternate with the normal one, which is
// exactly what spr_stage7_spike_N_hit holds), and only then does it split.
DURATA_LAMPEGGIO = 0.9;

GRAZIA_DANNO = 0.3;        // one shockwave must not count twice
// A block bumped from below throws off several shock waves in a row (the block
// re-arms as soon as its own little animation is over), and with the short
// grace above one bump was taking two or three points off. The wave gets a
// grace of its own: ONE hit per bump, whatever the block does.
GRAZIA_ONDA = 1.2;
graziaOnda = 0;
LAMPEGGIO = 0.25;          // how long the hit flash shows

// ev. 297: he is created at (336, 48), which is outside the room on the right;
// the wrap in obj_stage7_three_guardians walks him straight back in. The
// movement data of the original gives Boss_01 the direction "right" only.
verso = 1;
vy = 0;

tubo = 0;                    // > 0 while it is going through a pipe
stato = "vivo";
graziaDanno = 0;
lampeggio = 0;
image_speed = 1;
