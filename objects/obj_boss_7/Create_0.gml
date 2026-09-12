// Bowser, the final boss (original level 64, "7-5", event group "kuppa").
// Every number below is read out of the 2001 original's events and carries
// the number of the event it comes from; the full reading, and the video
// measurements, are in port/marioxp-originale/BOSS-BOWSER-SPECIFICA.md.
// Like Kamek he is two objects in the original: an invisible anchor (Boss_01)
// that walks, jumps and lands, and a drawing (Boss_02) put back on top of it
// every step. Here they are one: x/y is the anchor's foot point, and every
// sprite's origin sits on the original frame's hotspot.

depth = 30;

// ev. 310: the counter goes from 0 down to -80. Damage: hammer 1 (ev. 306),
// fireball 1 (307), cross 2 (308), a moving koopa shell 8 (309). There is no
// stomp event at all: landing on him only hurts.
VITA = 80;
DANNO_MARTELLO = 1;
DANNO_FUOCO = 1;
DANNO_CROCE = 2;
DANNO_GUSCIO = 8;
// The cross is not destroyed by the hit and keeps overlapping him as it goes
// through: the original has no grace, but a Klik collision fires again on
// every frame of overlap, and how many that came to is not known. A quarter
// of a second per contact, to be tuned.
GRAZIA_CROCE = 0.25;

// The anchor's world: the flat floor at y=192 (ev. 318 puts him back there on
// every landing) and the two limits 52 and 268 (ev. 294/295).
PAVIMENTO = 192;
X_MIN = 52;
X_MAX = 268;

// Speeds. One unit of the original is 6 px/s, MEASURED on the video: walking
// speed 4 = 24 px/s (three clean stretches: 24, 20, 26), the shell dash at
// speed 50 = 300 px/s, a kicked koopa shell at speed 30 = 180 px/s.
VELOCITA_PASSO = 24;        // ev. 292, 299, 300, 324
VELOCITA_SCATTO = 300;      // ev. 335/336

// The 2001 engine moves "bouncing ball" objects vertically with the alterable
// value C as their speed: Y += C/4 and C += 1 every frame, at 50 frames a
// second, with no event doing it. MEASURED on five jumps of the video (C=-20
// rises 52 px in 0.41 s, C=-15 30 px, C=-28 98 px): gravity 625 px/s^2, and
// an initial speed of C x 12.5 px/s.
GRAVITA = 625;
UNITA_SALTO = 12.5;
SALTO_MIN = 20;             // ev. 320: -(20 + Random 10), so 20..29
SALTO_CASUALE = 10;
SALTO_GUSCIO_MIN = 15;      // ev. 333: -(15 + Random 10), so 15..24
SALTO_SCHIVA = 20;          // ev. 321
RIMBALZO_GUSCIO = 10;       // ev. 319: every landing inside the shell
SALTO_USCITA = 15;          // ev. 337: he pops out of the shell with a jump

// ev. 301-304: the hundred-pixel rule. Farther than that, once a second he
// decides to come closer; nearer, he backs off at once.
DISTANZA = 100;
ATTESA_AVVICINA = 1.0;

// ev. 320: every 600 ms one chance in five of a jump, from the ground.
// ev. 321: he hops over a moving shell when (his x - its x)^2 < 1500, which
// is within 39 px.
ATTESA_SALTO = 0.6;
SCHIVA_QUADRATO = 1500;

// ev. 323, 329, 333: every 500 ms three separate one-in-five draws, in this
// order: the big fireball, the hammers, the shell attack (from the
// ground only).
ATTESA_ATTACCO = 0.5;
PROBABILITA = 5;

// Big fireball (ev. 323-327): animation 12 is three frames at 67 ms looped
// five times, a second of open mouth, then Boss_03 leaves at speed 20 =
// 120 px/s (MEASURED: 120 and 119 px/s on two shots), aiming at the height
// of the player's head as it was at that moment.
DURATA_SPUTO = 1.0;
VELOCITA_PALLA = 120;

// Hammers (ev. 329-331): animation 13, the raised arm, is four frames at
// 40 ms looped six times, and at frame 2 of every loop one hammer (Enemy_14,
// the hammer bros' own) leaves at speed 40 = 240 px/s in one of the
// original's directions 5, 6 or 7 (56.25, 67.5 and 78.75 degrees upwards;
// 9, 10, 11 facing left). Never seen on the videos.
DURATA_MARTELLI = 0.96;
GIRO_MARTELLI = 0.16;
MARTELLI = 6;
VELOCITA_MARTELLO = 240;
ANGOLI_MARTELLO = [56.25, 67.5, 78.75];

// Shell attack (ev. 333-337): he curls up and jumps; half a second later the
// anchor darts at the player at speed 50; at a second and a half he stops
// and pops out. Curled up he cannot be hurt (ev. 312-316).
SCATTO_A = 0.5;
FINE_GUSCIO = 1.5;

// ev. 306-309: in the original every hit stops him and plays animation 15,
// six frames at 40 ms looped five times, 1.2 s of red and dark silhouettes
// alternating with the normal frame, with NO invulnerability (every hammer
// that lands meanwhile counts and restarts it). CHANGED ON REQUEST (12
// September 2026): here the hit does not stop him and does not break what he
// is doing, it only takes its points and flashes. The flash is drawn in the
// Draw event over whatever pose he is in, with the original's three colours
// (frames 1323, 1335 and 1336: bright red, dark red, darker).
LAMPEGGIO = 1.2;
PASSO_LAMPEGGIO = 0.04;
// The koopa shell is the exception, again on request: that one stops him
// for the length of the flash and drops what he was doing, as every hit did
// in the original (ev. 309 with its 2/6, "stop the anchor").
DURATA_COLPITO = 1.2;
COLORI_LAMPEGGIO = [make_colour_rgb(255, 11, 15), -1, make_colour_rgb(123, 0, 0), -1, make_colour_rgb(39, 0, 0), -1];

// ev. 287/288: a green koopa every 3 s when no koopa and no shell is around,
// alternating sides, the first from the right. On both videos the first one
// walks in about five seconds after the start (the original has two parked
// outside the room, and the spawner waits for them), so the first wait is
// longer here.
ATTESA_KOOPA = 3.0;
PRIMO_KOOPA = 5.0;
KOOPA_X_DESTRA = 312;       // 336 and -16 in the original, but the port's
KOOPA_X_SINISTRA = 8;       // invisible walls stand at 320 and 0: just inside
KOOPA_Y = 176;              // on the side steps, as in the original
KOOPA_MARGINE = 48;         // a player closer than this to the birth point sends it to the other side

// The mouth: action point (26,11) of a 32x32 frame whose hotspot is (10,32),
// so 16 to the right and 21 above the feet, mirrored when he faces left. The
// hammers leave from the raised hand, the action point (25,13) of frame 1350.
BOCCA_X = 16;
BOCCA_Y = -21;
MANO_X = 16;
MANO_Y = -21;

// ev. 292: a second after the room starts he begins to walk.
ATTESA_INIZIO = 1.0;

// ev. 7/8: two seconds after the death the victory jingle, nine seconds
// after it the ending. The original goes to level 65, "Ending_1", which the
// port does not have yet: for now the thank-you screen stands in for it.
JINGLE_A = 2.0;
FINE_A = 9.0;

// Test scaffolding: with PROVA on he has little life, K kills him and a
// readout is drawn. Off in the real build.
PROVA = false;

vita = VITA;
stato = "attesa";           // attesa | cammina | sputo | martelli | guscio | colpito | morto
velocita = 0;               // the anchor's own speed, px/s
direzione = 1;              // where the anchor walks
verso = -1;                 // where the drawing faces (ev. 296/297)
inAria = false;
vy = 0;
tempoInizio = 0;
attesaAvvicina = 0;
attesaSalto = 0;
attesaAttacco = 0;
tempoAttacco = 0;
martelliLanciati = 0;
scattato = false;
lampeggio = 0;
tempoColpito = 0;
attesaKoopa = ATTESA_KOOPA - PRIMO_KOOPA;   // starts below zero: the first one waits longer
koopaDaDestra = true;
graziaCroce = 0;
morteTimeout = 0;
musicaMorte = false;

if(PROVA) vita = 12;

sprite_index = spr_boss_7;
image_speed = 1;
image_index = 0;
image_xscale = verso;
