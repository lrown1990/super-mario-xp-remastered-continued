if(!pressed && global.vertical != 0) {
	pressed = true;
	audio_play_sound(snd_cursor_move, 1, false);
	if(arrCurrent == array_length(arrProps) - 1 && global.vertical == 1) {
		audio_stop_sound(snd_cursor_move);
	} else if(arrCurrent == 0 && global.vertical == -1) {
		audio_stop_sound(snd_cursor_move);
	}
	arrCurrent = clamp(arrCurrent + global.vertical, 0, array_length(arrProps) - 1);
}

if(!pressedOption && global.horizontal != 0) {
	pressedOption = true;
	audio_play_sound(snd_cursor_move, 1, false);
	cambiato = true;
	switch(arrCurrent) {
		case 0: {
			if(arrCharacterCurrent == array_length(characterList) - 1 && global.horizontal == 1) {
				audio_stop_sound(snd_cursor_move);
			} else if(arrCharacterCurrent == 0 && global.horizontal == -1) {
				audio_stop_sound(snd_cursor_move);
			}
			arrCharacterCurrent = clamp(arrCharacterCurrent + global.horizontal, 0, array_length(characterList) - 1);
			break;
		}
		
		
		case 1: {
			if(arrParallaxCurrent == array_length(parallaxActivated) - 1 && global.horizontal == 1) {
				audio_stop_sound(snd_cursor_move);
			} else if(arrParallaxCurrent == 0 && global.horizontal == -1) {
				audio_stop_sound(snd_cursor_move);
			}
			arrParallaxCurrent = clamp(arrParallaxCurrent + global.horizontal, 0, array_length(parallaxActivated) - 1);
			break;
		}
		
		case 2: {
			if(arrTransitionCurrent == array_length(smoothTransitionsActivated) - 1 && global.horizontal == 1) {
				audio_stop_sound(snd_cursor_move);
			} else if(arrTransitionCurrent == 0 && global.horizontal == -1) {
				audio_stop_sound(snd_cursor_move);
			}
			arrTransitionCurrent = clamp(arrTransitionCurrent + global.horizontal, 0, array_length(smoothTransitionsActivated) - 1);
			break;
		}
	}
}

// ENTER (or Z, the game's other confirm key) on an entry steps its value on
// to the next one, wrapping round at the end, the same as the arrows do.
// Until 12 September 2026 it left the options screen from any entry, which
// is what it still does, and only does, on "exit" (the last entry). Reported
// from play.
if((global.start || global.jump) && arrCurrent != array_length(arrProps) - 1) {
	audio_play_sound(snd_cursor_move, 1, false);
	cambiato = true;
	switch(arrCurrent) {
		case 0: {
			arrCharacterCurrent = (arrCharacterCurrent + 1) mod array_length(characterList);
			break;
		}

		case 1: {
			arrParallaxCurrent = (arrParallaxCurrent + 1) mod array_length(parallaxActivated);
			break;
		}

		case 2: {
			arrTransitionCurrent = (arrTransitionCurrent + 1) mod array_length(smoothTransitionsActivated);
			break;
		}
	}
}

switch(arrCurrent) {
	case 0: {
		global.character = characterList[arrCharacterCurrent];
		break;
	}
	
	case 1: {
		global.parallaxScrolling = parallaxActivated[arrParallaxCurrent];
		break;
	}
	
	case 2: {
		global.smoothTransitions = smoothTransitionsActivated[arrTransitionCurrent];
		break;
	}
}

// It writes to disk as soon as an entry changes, not on the way out: the
// game lives in a browser window and that can be closed at any moment.
// The block goes HERE, after the switch that updates the globals from the
// highlighted entry: put before it, it would save the old value.
if(cambiato) {
	cambiato = false;

	ini_open("save_data.xp");
	ini_write_string("options", "character", global.character);
	ini_write_real("options", "parallax", global.parallaxScrolling);
	ini_write_real("options", "transitions", global.smoothTransitions);
	ini_close();
}

if(pressed && global.vertical == 0) {
	pressed = false;
}

if(pressedOption && global.horizontal == 0) {
	pressedOption = false;
}

// "exit": ENTER confirms, as in every menu of the game
if((global.start || global.jump) && arrCurrent == array_length(arrProps) - 1)
	room_goto(title_screen);