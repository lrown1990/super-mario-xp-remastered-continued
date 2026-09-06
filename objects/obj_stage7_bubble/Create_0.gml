// One of the drops Degbubble spits (original "Boss_06" plus the "Kouka_02" it
// drips, level 61, ev. 336 and 352-356).
//
// MEASURED on the longplay, one drop followed at 50 fps from 83.93 to 84.43 of
// the clip: it falls STRAIGHT DOWN and it accelerates, from about 200 px/s to
// about 400, which is a gravity of some 450 px/s^2; it holds the same x to the
// pixel; and it goes THROUGH the rows of blocks (tracked from y=147 to y=178
// straight across a solid row) down to the bottom of the room.
//
// The first port read them out of the events alone, where they are shot at
// speed zero, and left them hanging in the air: that is what looked wrong in
// play, and the video says the events were read too literally.
GRAVITA = 450;

vy = 0;
image_speed = 1;
depth = 40;
