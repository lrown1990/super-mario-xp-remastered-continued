currentOption = 1;
cursorMoved = false;
selected = false;

timeout = 0;

image_speed = 0.2;

menu_cursor = spr_title_cursor;

audio_stop_all();

// Stage reached, from the save. The save can exist with NO stage in it:
// save_run_state writes lives, weapon, hearts and health at the start of
// every level, stage 1 included, while the stage is written only by
// level_finished. With no save at all load_property gives false, which
// compares as 0 and always behaved. With a save but no stage it gives
// undefined, and undefined compared with a number is neither smaller nor
// bigger: "Select Stage" was drawn locked but could be entered all the same.
// That case now counts as stage 1.
stageCount = load_property("currentStage");
if(!is_numeric(stageCount))
	stageCount = 1;

// Is there a game to lose? Only if a stage beyond the first was reached,
// the same rule that unlocks "Select Stage". It used to check whether the
// save was empty, but the run state is saved at the start of every level:
// entering stage 1 and quitting was enough to make "New game" ask to
// overwrite a game with nothing in it.
hasSave = (stageCount >= 2);

// Confirmation box for "New game", drawn in the Draw event and driven in
// the Step. NO starts highlighted: anyone hammering through deletes
// nothing.
confirming = false;
confirmYes = false;
confirmMoved = true;