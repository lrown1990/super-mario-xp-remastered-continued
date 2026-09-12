// Bowser's death: the object ev. 310 of level 64 creates in his place,
// Kouka_04 with its animation 14, his silhouette flashing red and dark. The
// frame loop (ev. 14) lifts every Kouka_04 by 4 px a frame, 200 px/s, while
// the engine's gravity pulls it down from a standing start: it hops some
// thirty pixels and drops off the bottom of the screen.
depth = 20;
image_speed = 1;
vy = -200;
GRAVITA = 625;
