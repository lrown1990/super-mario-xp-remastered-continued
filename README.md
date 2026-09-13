# Super Mario XP Remastered, continued

Fork of [Matth33w's Super Mario XP Remastered](https://github.com/Matth33w/super-mario-xp-remastered),
the GameMaker remake of **Super Mario XP**, the game CnC Darkside released in 2001.
He stopped partway through. This fork carries it on, and runs it in a browser.

The project opens in **GameMaker LTS 2026** and is exported as HTML5.

Everything added here is checked against the 2001 original. Its level and event
files were read back out, so enemy placements, block contents and boss behaviour
come from the game itself rather than from memory or from videos.

## What this fork adds

### The bosses that were missing

Five of the seven stages had no boss at all, and the room where the last three
guardians wait was empty as well. Stage 2 ended in an empty room,
walking into the stage 3 arena dropped you straight on the game over screen, and
stages 4, 5 and 6 simply stopped: the pipe at the end led nowhere and the last
rooms did not exist in the project. Stage 6 was missing two of them, the store
room where you stock up on hammers and hearts before the fight as well as the
arena itself.

All of those fights are now in, along with the rooms they happen in, rebuilt
from the original's own maps:

- **Stage 2, the Mammoth Flower.** It chases you along the floor, sinks and comes
  back up somewhere else, sends tentacles through the ground and drops spores.
  The angrier it gets, the faster the tentacles come.
- **Stage 3, the Nightmare.** It floats above a ring of ghosts and has two moods:
  it either dives to the floor and flings the ghosts out of the room, or stays
  high and sends them spinning. After a while it calls two skeletons in through
  the side doors.
- **Stage 4, the sea serpent.** It swims under the surface, leaps out where you
  are, and then bites, or hangs in the air and spits fire, or bounces off the
  bridge before dropping back in. Hurt it enough and the body falls away, leaving
  the head alone still fighting.
- **Stage 5, the dinosaurs.** Four of them hop between rising and falling
  platforms over a lava pit. Stomping does nothing: the only way to hurt them is
  a headbutt from below. They spit fire more often when you get close, and they
  come at you harder once wounded.
- **Stage 6, Kamek.** Bowser's right hand, and the one who carried the princess
  off. He keeps to the floor and crosses the room in a dash, trailing ghosts of
  himself, then stops somewhere else to cast: a bolt of magic, a rain of stone
  blocks that burst when they land, or a Thwomp dropped straight down on your
  head. He can only be hurt while he is standing still, and the more he takes the
  harder he works: two bolts instead of one, and the blocks come thicker. Beaten,
  he is squashed flat, lies there a moment and crumbles away.
- **Stage 7, the three guardians.** Their room was in the project but stood
  empty. Three of them take it in turns, in an order drawn afresh every time:
  a spiked mine that splits in two every time it is killed, smaller each time,
  until the room is crawling with them; a grinning ball of ice that calls in
  copies of itself, all alike, only one of which can be hurt, and that spits
  drops raining down through the floors; and an eye that walks the brick rows
  with two fireballs turning around it, armoured while it moves, open and
  vulnerable only when it stops. The room is a loop: walk off one side and you
  come back in on the other, and the way out only opens once all three are
  down. They arrive and leave through the pipes in the corners, and a ghost
  crosses the room while you fight, joined by a second one for the last of the
  three.
- **Stage 7, the road to Bowser.** Past the guardians the stage used to end on
  the game over screen. It goes where it should now: a hidden chamber above the
  last room, reached by a stair of invisible blocks and left through a pipe, and
  from there the throne room at the top of the castle. The chamber can be
  visited once per run, and once the door has been used the stair is taken away,
  so there is no climbing over the top of the room and dropping into the arena
  from above. The hall before the arena has been redrawn as well: its
  arcades fill the room wall to wall, and the stone Bowser is back on his ledge
  watching the doorway, the way the 2001 game had him.

### The Nightmare's arena

The room where the stage 3 boss waits used to be a plain tiled wall that had
nothing to do with the fight. It has been redrawn as an open loggia: three
arches with a balustrade, stone pedestals at the sides, and beyond them a
graveyard under a full moon, with bare trees, a chapel, iron railings and a
castle on the skyline. Clouds drift slowly across the sky behind the arches;
they hold still when parallax scrolling is switched off in the options, like
everything else that moves in the backgrounds. The corridor before the arena,
where the question blocks are, now looks out through the same arcades and night
sky as the hall before Bowser, instead of the old blue wall.

### The throne room

The last room of the game was a bare hall in the 2001 original. It has been
redrawn: the banners and the statue over the throne, a stone bridge with lava
running underneath, six torches burning along the walls, and a night sky behind
the windows, with clouds drifting past and the moon showing through the arch.
It has music of its own, an opening that plays once and a theme that loops
behind the fight.

The ways out at the sides stay shut while the fight is on. Outside the arena
there is no floor, so walking out was never an exit, it was a fall. They open
when the boss goes down.

**And Bowser is in it now.** He throws hammers, breathes fire and charges the
length of the bridge, and what he does was read out of the 2001 game's own event
files rather than copied from videos. The ways out open when he goes down.

### The ending

Beating him used to leave you on a placeholder screen. The game ends properly
now, the way the 2001 original ended it.

She is waiting in the hall beyond the arena, with her back to the door. At some
point she turns, walks over to meet you, and a message thanks you and tells you
the quest is over. Then the two of you walk off together and the screen wipes.

The original rolled its credits after that. This fork stops at the game over
screen instead.

### The stages as the 2001 game had them

Whole groups of enemies and item blocks had never been carried over. Reading the
original's level files put them back, stage by stage: enemies that were simply
absent, question blocks that handed out the wrong item, pipes that were missing
one of the two plants growing out of them, and one stage that had lost its
cannon fire entirely.

**Dry Bones** deserve a line of their own. The sprites had always been in the
project but no enemy ever used them, so the walking skeletons were missing from
the whole game. They are now everywhere the original puts them. They behave as
they should: fire does nothing to them, a stomp or a hammer knocks them apart and
they pull themselves back together a few seconds later, and only the cross
finishes them for good.

### Smaller things

- The character now walks across the world map on every stage, not just the first
  three, and a marker shows where you are heading on the stage select screen.
- Fish jumping out of water make a splash, on the way up and on the way down,
  but only where there is actually water below them.
- The green mushroom is worth one extra life per run. Take it, die, come back and
  hit the same block, and you get a heart instead.

### Menus and saving

- **The game saves as you go.** It used to write only when a boss went down, so
  the save stood still at your last victory: reach a boss in good shape and you
  could replay the rest of the stage on that same state, reloading from the menu
  every time it went badly. It now records where you stand each time a level
  starts, and your lives are part of what it keeps, which they never were.
- **New game asks first** when a save already exists, instead of quietly wiping it.
- **Options are remembered between sessions**, and starting a new game no longer
  clears them.
- The options screen says what each character is good at.
- The credits screen was redone and can now be skipped.
- New title screen, using a background Matth33w had drawn but never used.

## Fixes

- **Progress was never saved on a first playthrough**, so stage select stayed
  locked forever no matter how far you got. Later it could also overwrite a
  higher stage with a lower one.
- **New game did not start a new game.** It resumed from wherever you had got to,
  with the hearts and the weapon of the previous run.
- **Leaving for the menu while you were dying left the game believing you still
  were.** Whatever stage you started next played for a few seconds, then took a
  life off you and restarted itself, and the lives of the run you had walked out
  of came back with it.
- **Opening the options screen forced the character back to Mario.**
- **Luigi was broken in two ways**: his fireballs flew straight instead of
  bouncing, and he threw two crosses where Mario throws one.
- **Mushrooms could walk out of the world** in the room that opens onto the stage
  3 arena, and were lost.
- **A mushroom would not fall into a gap one block wide.** What held one up was
  the ground under the whole of it, and it is wider underneath than it looks: a
  corner always found the block next door, so it sat over the hole instead of
  dropping through it the way it does in the 2001 game. What carries it now is
  the ground under its middle.
- **And a mushroom walking off an edge slid down the side of it.** It turned
  round whenever anything at all touched it, so the block it had just stepped
  off counted as a wall the moment it dropped a pixel: it flipped back and forth
  and came down glued to that edge. It turns on what is in front of it now, so
  it keeps walking as it falls and comes away; in a hole one block wide it
  bounces between the two sides and goes down the middle.
- **The stage 3 boss could push you up through the ceiling** if you kept stomping
  it as it rose.
- **The hammer throwing turtle walked through walls.** Two of its rules cancelled
  each other out, so where a wall stood at the edge of its patrol it drifted into
  the stone and ended up stuck in mid air on the far side. It also used to pass
  through anything on its way up, the only enemy in the game that did.
- **The hammer throwing turtle also froze at the end of a level.** Where its patrol
  reached the edge of the map it walked into the way out, stood still and stopped
  throwing anything. The edge of the map is a wall to it now.
- **The cloud that drops spiny shells flew through walls too**, and the shells it
  dropped inside them stayed stuck there for good.
- **The stage select screen could crash the game to a black screen** if it was
  reached without a single finished stage.
- **Everything the game left to chance came out the same every session.** The
  random generator was never seeded, so every run drew the same sequence: the
  three guardians turned up in the same order every time, and the rest of what
  should have been chance was just as predictable.
- **A game over left you with a single life** if you chose to quit to the menu
  instead of carrying on. Carrying on gave you a full set, but the save still
  held the one life you had died with, so starting a stage from the menu handed
  you that.
- **Hitting a block from below did nothing in the guardians' room**, which is
  the one room in the game built around doing exactly that: the blocks are how
  you reach something standing on the row above you, and they had never once
  answered. They were out by a single pixel.
- **The music had gone mono** and is stereo again.
- **Three stage tracks did not loop.** They were cut so that the end joins the
  beginning without a gap or a click.
- **The clouds in the throne room drifted with parallax switched off.** Turn the
  option off and every other background in the game stands still; those kept
  moving on their own.
- **Enter left the options screen whichever entry you were on**, so the key you
  confirm with everywhere else could not be used to change a setting: only the
  arrows could. It steps an entry on to its next value now, and still leaves the
  screen from "exit".

## About the web version

Worth knowing before merging anything back:

- Only the remastered soundtrack is kept. The other three and the music style
  option were removed, along with the unused music, to keep the download small.
- The game listens for messages from the page that hosts it, which is how the
  browser pause screen offers a way out to the menu.
- The title screen no longer shows a fake copyright notice, and the stage select
  screen no longer advertises a demo build made for an event this fork has
  nothing to do with.
- If you export to HTML5 yourself, be aware that browsers can get stuck at the
  point where a looping track starts over, turning the music into a continuous
  tone. Shortening the loop by a single sample avoids it. The web build in this
  fork's sister project does that from the hosting page.
- Also be aware that if you put the game in a frame, some browsers will keep it
  silent unless the hosting page explicitly allows that frame to play sound.
  Nothing is reported when they do: the game loads its sounds, decodes them and
  plays them, and you hear nothing.
- Converting the project to GameMaker LTS 2026 rewrote every project file, so the
  diff is large. The real work is in the scripts, the rooms and the new resources
  listed above.

## Credits

- Original game, 2001: **CnC Darkside**
- GameMaker remaster: **Matth33w**
- This fork: **Carlo Sinatra**
