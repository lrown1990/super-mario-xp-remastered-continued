// The room of the three guardians, 7-2 (original level 61). This object is the
// referee: it holds the room shut, calls the three mini bosses in one at a
// time and, when the third is down, hands the player back to the level exit.
// The reading of the original is in
// port/marioxp-originale/BOSS-MEZZI-7-2-SPECIFICA.md.
//
// THE ROOM IS A LOOP. Walking off one side brings you back in on the other
// (ev. 33 and 34, and ev. 276-279 for everything else that moves). That is
// what keeps the player away from the obj_screen_advance bar parked at
// x = -32: it is 328 pixels tall, so without the loop a walk to the left at
// any height would open stage_7_3 and skip the whole fight.

// ev. 285: which of the three comes first is drawn at random when the room
// starts. 0 Spike, 1 Degbubble, 2 the eye of Cookie; from there they follow
// one another in that order (ev. 331, 362, 385).
fase = irandom(2);
rimasti = 3;

// ev. 286-288: the first one does not come in at once.
ATTESA_PRIMA = 1;
// ev. 331, 362 and 385: the wait between one and the next.
ATTESA_FRA = [3, 2, 2];
// After the third, the room is quiet for a moment before the player is walked
// out of it.
ATTESA_USCITA = 2;

// ev. 294 and 295: while Spike is up, a ghost crosses the room every 6000 ms,
// always from the side the player is NOT on.
PASSO_FANTASMA = 6;

// The pipes, measured on the room itself: the art at the sides covers x 0-29
// and x 290-319, the two at the top sit on the first row of blocks and the two
// at the bottom on the floor. So the mouth of the bottom pipe is at x=30 on the
// left and x=290 on the right, and whoever comes out at the top comes out just
// inside the mouth up there.
BOCCA_SX = 30;
BOCCA_DX = 290;
USCITA_SX = 20;
USCITA_DX = 300;
// How long the whole passage lasts, and how much of that is walking into the
// mouth in plain sight before the pipe swallows them. The pipes are painted on
// a background layer, behind everything, so being "inside" has to be done by
// hiding them: on the way in they walk 25 pixels into the mouth, which is far
// enough to read as going in, and then they are gone.
DURATA_TUBO = 1.4;
DENTRO = 0.7;
// The pipe tiles cover 192-223, but the green they draw only fills 195-215:
// above and below that the tile is see-through, which is where the bits that
// stuck out were showing. So on the way in they are slid to the MIDDLE of the
// opening, the way the original centres whatever goes down a pipe. Anything up
// to 21 pixels tall disappears completely; the two biggest sizes of Spike are
// wider than the hole and cannot.
// Measured on the room: the green of the bottom pipes fills y 195-216 and the
// green of the top ones y 19-40, so the middle of the two holes is 205 and 29.
CENTRO_TUBO = 205;
CENTRO_TUBO_ALTO = 29;
VELOCITA_CENTRA = 70;
// How far in from the side the pipe art reaches (the tiles cover x 0-31 and
// 288-319): until the whole body is past it they stay behind it, so coming out
// reads as coming OUT of the pipe.
FINE_TUBO_SX = 31;
FINE_TUBO_DX = 288;

// The four corridors of the arena, and the height that puts the ghost in the
// middle of each: the rows of blocks sit at 48-64, 104-120, 160-176 and
// 224-240, so the free lanes are 0-48, 64-104, 120-160 and 176-224. The five
// pixels are the ghost's own origin, which is not at its middle.
CORSIE = [29, 89, 145, 205];
// And the two ends of the same lane, already worked out from the ghost's own
// size (25 pixels tall with its origin at 17): between these two numbers the
// whole of it fits, so the bouncing one never leaves its corridor.
CORSIE_SU  = [17, 81, 137, 193];
CORSIE_GIU = [41, 97, 153, 217];

stato = "attesa";
attesa = ATTESA_PRIMA;
attesaFantasma = 0;
