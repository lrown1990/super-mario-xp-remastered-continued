// One of the two fireballs that turn around the eye of Cookie (original
// "Enemy_24" and "Enemy_25", level 61, events 366-368). In the original they
// are created with the eye and then held at its position every step, and the
// port already had the object for this kind of thing: obj_fire_rod, with its
// own trail.
//
// MEASURED on the longplay, the fight at 37:50: the two of them turn around
// the eye at a radius of 56 pixels, half a turn apart, at about 110 degrees a
// second, which is one turn every 3.3 s. (The port's obj_fire_rod turns at
// 120 degrees a second, so the original and Matth33w's rod are nearly the
// same speed; the radius is what differs, 56 against 64.)
RAGGIO = 56;
VELOCITA_ANGOLARE = 110;
PASSO_SCIA = 0.05;          // same as obj_fire_rod

angolo = 0;                 // set by whoever creates it
scia = 0;
depth = 20;
