Impossible Victhorse
by Pitto (c) 2019

SOFTWARE LICENSING

Software released under the terms of LGPL License
see COPYNG.txt in root folder for further details.

---

GRAPHICS LICENSING

All the graphic elements (sprites and bitmaps)
contained in this videogame are instead released
under the "Pittographic" license, which means that
they can only be used in the context of this videogame,
no part can be reused in other works unless the author
does not authorize it.

________________________________________________________________________

MAIN FEATURES

* Old school platformer game inspired to the games of late 80's and early 90's
* C64 palette - except for the skin color of Victor
* Resolution 320 x 240 upscaled 2x
* Game engine and level editor designed from scratch
* Uses only the fbgfx standard library and FBSound Dynamic by D.J. Peters.
* All the graphics (sprites, tiles, wallpaper, splashscreen) have been
  made by the author exclusively for this project, the green robot is
  heavy inspired to the robots of Impossible Mission C64 game.
* The player may jump, launch floppies, collect bonuses, inspect computers,
  climb walls and collect keys in order to open doors.
* 9 levels
* 3 difficulty mode: easy / medium / hard
* Multiple bonuses and power-up
* 8 kind of enemies with different AI
* Highscore table
* Analogue joystick input supported and recommended
* Parallax effect
* Works on both Win & Linux (even Raspberry is supported)

________________________________________________________________________

INSTRUCTIONS

The target of the game is collect all keywords along the levels in order 
to go on.

To collect keywords, simply stay firm toward the PC's while the search
bar is in progression.

Bonuses:
* 100 coins will give an extra life
* SYS64738 will speed-up the search of the keyword
* heart bonus will give 1 life
* Medpack will restore a bit of health
* "V" makes the carachter a SuperVictor, allowing to launch floppies 
  directionaly

-----

Use arrow keys to navigate trough the menu, press enter or spacebar
to enter into any section such "New game". Press Esc to back to main menu.

Controlling the carachter (analogue joystick recommended)

Keyboard - use arrow keys to move left, right, watch down or jump,
           spacebar to fire
           
Joystick - use analogue lever to move & watch up & down
           & while, in superVictor mode, direct precisely the launch of
           floppies; button 1 to jump, button 2 to fire
           
Hints:

You may launch floppies even while searching keywords or jumping.

If you press jump button while sliding on a wall the player will jump
on the opposite side.

Sometimes it's useful to watch up or down in order to discover enemies
or dangers.

           
HOW TO START A GAME

1. Use arrow keys or joystick lever to move to difficulty: easy
2. Select the difficulty level pressing space or joystick button 1
3. Use arrow keys to go to "NEW GAME"
4. Press Enter or spacebar or joystick button 1 to start
5. Type your name and press Enter
6. At the Level intro screen get ready by pressing SPACEBAR or joystick button 1

________________________________________________________________________

SUCCESSFUL TESTED ON FOLLOWING MACHINES
Compiled using FBC 32 bit 1.0.5

with sound: 
	* Win Xp SP2 Intel Celeron @ 2.00 Ghz 256 Mb Ram 
	* Linux Ubuntu 18.04.1 LTS 64 bit - AMD E1-6015 apu with radeon(tm) 
	  r2 graphics x 2; Gnome 3.28.2 AMD Kabini; 4 Gb ram
	* Linux Ubuntu 18.04.1 LTS
	  AMD® Athlon(tm) ii x4 631 quad-core processor × 4 - AMD® Cedar
	  Gnome 3.28.2
	* WIN 10 Pro 64 bit
	  Intel i5-7400 CPU @ 3.00 Ghz 16 Gb ram
	* WIN 10 64 bit
	  Intel Pentium(R) CPU 3825U @ 1.90 Ghz 4.00 Gb Ram
			
without sound:
	* Linux Ubuntu 18.04.1 LTS
	  AMD® Athlon(tm) ii x4 631 quad-core processor × 4 - AMD® Cedar
      Gnome 3.28.2
    * Raspberry PI 3 (Raspian 2.3)
	* WIN 10 64 bit
	  Intel Pentium(R) CPU 3825U @ 1.90 Ghz 4.00 Gb Ram
			  
			
SUCCESSFUL TESTED WITH THESE CONTROLLERS

	* Thrustmaster Dual Analogic 4 v.1
	* Logitech DUAL ACTION 


KNOWN ISSUES

* If a Wacom tablet is connected, the game may not recognize the joystick.
  Exit from the game, disconnect the tablet and restart.
  
* (	Linux Ubuntu 18.04.1 LTS 64 bit - AMD E1-6015 apu with radeon(tm) 
	r2 graphics x 2; Gnome 3.28.2 AMD Kabini) In some cases, while playing
	the levels the screen seems to freeze for a couple of seconds
	but the game goes on.
	
* WIN10 - entering in fullscreen mode (ALT +  ENTER) and then exiting 
 (ALT + ENTER again) without closing application with ESC key may cause a crash.
  
	

***TODO***

IMPROVE: glitch of the player while jumping on the vertex of blocks
CLEANUP directories
CHECK Java the Hutt level respawn

**** CHECK ALL " check this " COMMENTS in the code!!!! ****

2019.02.06 - 0.5.5

* Improved a bit the smoothness on Windows
* Now the physics are update at given time (1/55 sec ATM)

---

2019.02.03 - 0.5.4

* FIRST PUBLIC REPOSITORY RELEASE
* close application via X button on the window
* checked refresh tearing on linux
* while dying the player now doesn't bufferize the jump
* name of alìpplication & Version & Author on window bar

------

2019.02.02 - 0.5.03

Tuned down a little the enemy damage power

-------

2019.02.01 - 0.5.2

* fixed wrong coins while restarting game
* menu navigation via joystick

-------
2019.01.30 - 0.5.1

* fixed wrong key basket while restarting game
* in difficulty medium and hard mode the enemies will release also bonuses
* tuned up the enemies values

-------
2019.01.29 - 0.5

* If player dies with less than the floppies default value, this value is restored
* level design & cleanup
* exit on type your name


-------
2019.01.28 - 0.1.6

* level cleanup
* conditional compilation for Win & Linux
* Hud fix
* Queued only sounds close to the player
* 3 difficulty mode

-------
2019.01.26 - 0.1.5

* SFX!
* Music!
* get ready by joystick
* fixed Floppy ammo overflow
* save on highscore while finishing game!
* fix game over
* fixed wrong time left


2019.01.25 - 0.1.4

* Re-spawn location, when the player dies, resume from last block_top hitted.
* intro

2019.01.23 - 0.1.3

* collision of enemies with horse
* every enemy erased release a coin
* fixed level time left
* position on high-score table

2019.01.21 - 0.1.2

* horse animation
* Parrallax fix
* intro txt for each level
* graphics of the blocksof each level
* get ready on loading level
* reset time left while player dies
* reset player keyword on game over

2019.01.20 - 0.1.1

* enter player name on start
* fps count on debug mode

2019.01.19 - 0.0.4.9

* CREDITS section
* Horizontal cannons


2019.01.14 - 0.0.4.7

* COMPILE_MUSIC_AND_SFX option while compiling

2019.01.12 - 0.0.4.6

* levels block and wallpaper with different background color
* cheat mode enhanced

2019.01.11 - 0.0.4.6

* cheat mode


2019.01.08 - 0.0.4.5

* Victor has also powerup mode
* in powerup mode it's possible to fire floppies at 360 degree (analogue joystick supported)


2019.01.06 - 0.0.4

* collectiong 100 coins +1 up
* some level logic fix
* added 1 up powerup
* camera set initial position
* more sprites for Victor, while searching and climbing walls

2019.01.05 - 0.0.3.8

* MAin menu
* level intro section
* game handler object

2019.01.03 - 0.0.3.6

* editor may open and save custom file path -> usage: main level.lev

2019.01.02 - 0.0.3.5

* UPDOWN PLATFORM size fix
* Position of enemy on level grid fix

2019.01.01 - 0.0.3.4

* optimized items bounds
* collision AABB with enemy bullets & bodies

2018.12.31 - 0.0.3.3

* each enemy has his energy and his damage power
* behaviour of the green enemy
* behaviour of the flying robot enemy
* behaviour of the black ball enemy

2018.12.30 - 0.0.3.2

* updated the editor
* now all include file are into "inc" folder
* parallax fix
* 8 kind of enemies

2018.12.26 - 0.0.3.1

* fixed some problems in the linked list
* added elevator object
* added floppy dispenser tile


2018.12.24 - 0.0.3

* cannon
* cannon with missile launcher
* SYS 64738 powerup now speeds-up the keyword search into the computers

2018.12.22 - 0.0.2.8

* player can climb the walls
* meta enter
* meta exit
* meta flag

2018.12.22 - 0.0.2.7

* only one spritesheet for all 16x16 px items
* enemy may fire against the player

2018.12.21 - 0.0.2.6

* added roll belts, evancescence floors
* added Victor start position

2018.12.19 - 0.0.2.5

* added medpack (+30% energy)
* added yellow, red & blue keys & doors

2018.12.16 - 0.0.2

* print font routine added to Hud Gui

2018.12.15 - 0.0.2

* the block_null now is useful to track the perimeter of the enemies
* draw searching bar while searching on computer
* an id for each type of enemy
* player is hurt while touching an enemy


2018.12.15 - 0.0.1

* First beta
* Coins initialization
* Level initialization
* Victor may search keyword into computer
* Victor may be controlled via keyboard or joystick
* collision detection
* Debug functions - press "D" to enable debug
* some sheets fly away while victor is searching keywords
