// The ghost that crosses the room (original "Enemy_28", level 61, events
// 292-295). Every six seconds an invisible dummy jumps to the side of the room
// the player is NOT on and fires one of these across, so it always comes at
// the player head on. Nothing can kill it: it goes when the fight does.
//
// There are two of them now. The plain one flies straight down the middle of
// one of the four free lanes. The other one, which is ours and not the
// original's, comes in on a slant and bounces between the floor and the blocks
// above like a ball rolling forward, only slow, the way a ghost should be.
VELOCITA = 60;
VELOCITA_RIMBALZO = 45;      // the bouncing one goes slower, it covers more ground
// Slow enough that crossing the room draws about five peaks, not a comb.
VELOCITA_SU_GIU = 35;

rimbalza = false;            // set by whoever fires it
verso = -1;                  // -1 goes left, 1 goes right
vy = 0;
// The lane it was given, as the two heights its own y may take: the bouncing
// one stays INSIDE one corridor and zigzags from its ceiling to its floor and
// back, all the way across, instead of wandering the whole room.
limiteSu = 17;
limiteGiu = 41;
morto = false;

image_speed = 1;
depth = 40;
