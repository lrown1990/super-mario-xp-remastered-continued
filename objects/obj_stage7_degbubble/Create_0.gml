// Degbubble, the second of the three guardians of 7-2 (original level 61,
// event group "degubaburu", events 334-362). Read from the 2001 original; the
// full reading is in port/marioxp-originale/BOSS-MEZZI-7-2-SPECIFICA.md.
//
// The trick of this one is that he sends in copies of himself. The copies look
// exactly the same and pop at the first touch of any weapon, but while they
// are on screen he spits far less: leaving them alone is the quiet way through
// the fight, popping them all is the fast and dangerous one.

depth = 30;
profonditaPrima = depth;

// false for the real one, true for a copy. Set by whoever creates it, so
// nothing in here may depend on it.
finto = false;

// ev. 345: the counter dies at -8.
vita = 8;

// MEASURED on the longplay, the fight at 37:50: he walks the block rows like
// the other two, at 36 px/s, and falls when the row under him ends (his
// copies were tracked resting at every one of the four row heights, 36, 93,
// 149 and 213). Nothing in this room floats.
VELOCITA = 36;
GRAVITA = 700;
CADUTA_MAX = 250;

// ev. 358 and 359: a copy every 2060 ms, from the side he is facing.
PASSO_COPIA = 2.06;
MAX_COPIE = 5;
// ev. 360: with no copy about, he turns round every 8000 ms.
PASSO_VERSO = 8;
// ev. 352-356: how often a bubble leaves, by how many copies are on screen.
// With none he is the only one spitting; from one copy on they all spit, so
// the count on screen goes DOWN as the copies pile up.
CADENZA = [0.3, 0.6, 1.0, 1.3, 2.0];

GRAZIA_DANNO = 0.3;
// A block bumped from below throws off several shock waves in a row (the block
// re-arms as soon as its own little animation is over), and with the short
// grace above one bump was taking two or three points off. The wave gets a
// grace of its own: ONE hit per bump, whatever the block does.
GRAZIA_ONDA = 1.2;
graziaOnda = 0;
LAMPEGGIO = 0.25;

verso = choose(-1, 1);
vy = 0;
verso = choose(-1, 1);          // which side the next copy comes in from

attesaBolla = 0;
attesaCopia = 0;
attesaVerso = 0;

tubo = 0;                    // > 0 while it is going through a pipe
stato = "vivo";
graziaDanno = 0;
lampeggio = 0;
image_speed = 1;
