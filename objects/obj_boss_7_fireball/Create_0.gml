// Bowser's big fireball (Boss_03 of level 64, ev. 324-327). It flies straight
// at 120 px/s and drifts up or down, one pixel a frame, to the height of the
// player's head as it was when it left the mouth: ev. 325 works the distance
// out once, at birth, and ev. 326/327 eat it a pixel at a time. MEASURED on
// the video: 120 px/s across, 1 px a frame up, then dead straight.
depth = 20;
image_speed = 1;
vx = 0;
bersaglioY = y;
VELOCITA_VERTICALE = 50;   // one pixel a frame at the original's 50 fps
