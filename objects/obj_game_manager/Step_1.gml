// Read the first connected gamepad instead of a fixed slot 0: the slot
// depends on the browser or driver (a DualSense in Chrome showed up in
// slot 1, DirectInput pads on Windows start at slot 4).
var pad = 0;
for (var i = 0; i < gamepad_get_device_count(); i++) {
	if (gamepad_is_connected(i)) {
		pad = i;
		break;
	}
}

global.horizontal = (keyboard_check(vk_right) || gamepad_button_check(pad, gp_padr) || gamepad_axis_value(pad, gp_axislh) > 0.9) - 
					(keyboard_check(vk_left) || gamepad_button_check(pad, gp_padl) || gamepad_axis_value(pad, gp_axislh) < -0.9);

global.vertical = (keyboard_check(vk_down) || gamepad_button_check(pad, gp_padd) || gamepad_axis_value(pad, gp_axislv) > 0.9) -
				  (keyboard_check(vk_up) || gamepad_button_check(pad, gp_padu) || gamepad_axis_value(pad, gp_axislv) < -0.9);

global.jump = (keyboard_check_pressed(ord("Z")) || gamepad_button_check_pressed(pad, gp_face1));

global.jumpHold = (keyboard_check(ord("Z")) || gamepad_button_check(pad, gp_face1));

global.start = (keyboard_check_pressed(vk_enter) || gamepad_button_check_pressed(pad, gp_start));

global.attack = (keyboard_check_pressed(ord("X")) || gamepad_button_check_pressed(pad, gp_face3)); 

global.special = (keyboard_check_pressed(ord("C")) || gamepad_button_check_pressed(pad, gp_face4));

if(global.debug) {
	if(keyboard_check_pressed(vk_f2))
		game_restart();
}