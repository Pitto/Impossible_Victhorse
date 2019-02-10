'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


type game_handler_proto

	declare sub set_game_section(section as game_section_proto)
	declare function get_game_section() as game_section_proto
	declare function get_current_level() as Ulong
	declare function get_section_timing() as double
	declare sub set_section_timing(timing as double)
	declare function get_exit_flag () as boolean
	
	declare sub go_to_next_level()
	declare sub print_font (x as Ulong, y as Ulong, txt as string, image_buffer as FB.Image ptr)
	declare sub load_txt (filename as string, txt() as string)
	
	declare sub update_main_menu (keyboard as keyboard_proto, joystick as joystick_proto, player as player_proto, sound_handler as sound_handler_proto)
	declare sub draw_main_menu (image_buffer as FB.Image ptr)
	
	declare sub update_enter_name (keyboard as keyboard_proto)
	declare sub draw_enter_name (image_buffer as FB.Image ptr)
	
	declare sub update_credits (keyboard as keyboard_proto, joystick as joystick_proto)
	declare sub draw_credits (image_buffer as FB.Image ptr)
	
	declare sub draw_game_completed (image_buffer as FB.Image ptr)
	
	declare sub update_intro (keyboard as keyboard_proto, joystick as joystick_proto)
	declare sub draw_intro (image_buffer as FB.Image ptr)
	
	declare sub update_level_intro (keyboard as keyboard_proto, joystick as joystick_proto)
	declare sub draw_level_intro (	image_buffer as FB.Image ptr, _
									heading as string, _
									language_name as string, _
									tip_1 as string, _
									tip_2 as string,_
									keywords_to_find as Ulong,_
									points as Ulong,_
									lives as Ulong, _
									wallpaper_slot as Ulong, _
									scenario_slot as Ulong)
	
	declare sub update_top_scorers (keyboard as keyboard_proto, joystick as joystick_proto)
	declare sub draw_top_scorers (image_buffer as FB.Image ptr)
	
	declare sub set_exit_flag (flag as boolean)
	
	declare sub init_keywords_list(freebasic_keywords_list() as string)
	
	declare function get_a_keyword () as ULong
	
	declare function get_player_name () as string
	
	declare constructor()
	declare destructor()
	
	'bitmaps
	splashscreens 		(0 to 3) as FB.Image ptr
	splashscreens_2x	(0 to 3) as FB.Image ptr
	
	end_screen(0 to 0)	as FB.Image ptr
	end_screen_2x(0 to 0)	as FB.Image ptr
	
	
	redim game_intro_txt (0 to 0) as string
	
	redim credits_txt (0 to 0) as string
	
	credits_txt_y_start as Long
	intro_txt_y_start as Long
	
	redim keywords_list(0 to 0) as keyword_proto
	
	game_difficulty_value (0 to 2) as single = {1.0, 1.5, 2.0}
	game_difficulty_label (0 to 2) as string*6 = {" EASY ", "MEDIUM", " HARD "}
	game_difficulty_slot as Ulong
	
	c64_colors(0 to 15) as Ulong = { _
	C_C64_Black, C_C64_WHITE, C_C64_RED, C_C64_CYAN, _
	C_C64_VIOLET_PURPLE,  C_C64_GREEN,  C_C64_BLUE, _
	C_C64_YELLOW, C_C64_ORANGE, C_C64_BROWN, C_C64_LIGHT_RED,_
	C_C64_DARK_GREY_GREY_1, C_C64_GREY_2, C_C64_LIGHT_GREEN, C_C64_LIGHT_BLUE, _
	C_C64_LIGHT_GREY_GREY_3	}
	
	main_menu_buttons as main_menu_buttons_proto
	
	hst as HighScoreTable
	player_score as HighScore
	
	game_paused as boolean
	game_paused_time_left as Long
	
	private:
	
	section as game_section_proto
	level_number as Ulong
	timing as double
	exit_flag as boolean
	player_name as string
	
		
	
	ascii_font_big 		(0 to 127) as FB.Image ptr
	wallpaper (0 to 7) as FB.Image ptr
	wallpaper_2x (0 to 7) as FB.Image ptr
	

end type

constructor game_handler_proto()

	this.set_game_section(_game_section_INTRO)
	this.level_number = 0
	this.timing = timer
	this.game_paused = false
	
	this.set_exit_flag (false)
	
	load_sprite_sheet 	(this.splashscreens(), 	640, 480, 2, 2,	"img/splashscreens.bmp")
	load_sprite_sheet 	(this.wallpaper(), 		640, 240, 4, 2,		"img/wallp_640x240.bmp")
	load_sprite_sheet 	(this.end_screen(), 		320, 240, 1, 1,		"img/end_screen.bmp")
	load_sprite_sheet 	(this.ascii_font_big(), 	320, 192, 16, 8,	"img/font_ascii_big.bmp")
	
	
	dim i as Ulong
	
	for i = 0  to Ubound(this.splashscreens)
		this.splashscreens_2x	(i) = imagescale(this.splashscreens(i), this.splashscreens(i)->width * 2, this.splashscreens(i)->height * 2)
	next i
	
	for i = 0  to Ubound(this.wallpaper_2x)
		this.wallpaper_2x	(i) = imagescale(this.wallpaper(i), this.wallpaper(i)->width * 2, this.wallpaper(i)->height * 2)
	next i
	
	
	for i = 0  to Ubound(this.end_screen)
		this.end_screen_2x	(i) = imagescale(this.end_screen(i), this.end_screen(i)->width * 2, this.end_screen(i)->height * 2)
	next i
	
	
	load_txt ("txt/game_intro_txts", game_intro_txt())
	load_txt ("txt/credits_intro_txts", credits_txt())
	
	this.credits_txt_y_start = SCR_H
	this.intro_txt_y_start = SCR_H
	
	main_menu_buttons = _main_menu_button_new_game
	
	#include "inc/keywords_list.bi"
	
	this.init_keywords_list(keywords_list())
	
	this.hst.Load ("txt/highscores")
	
	this.game_difficulty_slot = 0
	

	
end constructor

destructor game_handler_proto()

	Dim i as Ulong

	for i = 0 to Ubound (this.ascii_font_big)
		ImageDestroy this.ascii_font_big(i)
	next i
	
	for i = 0  to Ubound(this.splashscreens)
		ImageDestroy this.splashscreens(i)
		ImageDestroy this.splashscreens_2x(i)
	next i
			
	for i = 0 to Ubound(this.wallpaper)
		ImageDestroy this.wallpaper(i)
		ImageDestroy this.wallpaper_2x(i)
	next i
	
	for i = 0 to Ubound(this.end_screen)
		Imagedestroy this.end_screen(i)
		Imagedestroy this.end_screen_2x(i)
	next i
	
	
	#IFDEF DEBUG_MODE
		utility_consmessage("saving highscore table")
	#endif
	this.hst.Save()

end destructor

sub game_handler_proto.set_exit_flag (flag as boolean)

	this.exit_flag = flag

end sub

function game_handler_proto.get_exit_flag () as boolean

	return this.exit_flag

end function

sub game_handler_proto.update_main_menu (keyboard as keyboard_proto, joystick as joystick_proto, player as player_proto, sound_handler as sound_handler_proto)

	Dim i as Ulong
	
	dim is_enter as boolean = false

	'update keywords movements
	for i = 0 to Ubound(this.keywords_list)
		this.keywords_list(i).x += this.keywords_list(i).speed
		
		if this.keywords_list(i).x > SCR_W then
			this.keywords_list(i).x =  - rnd*100 - 100
		end if
	next i
	
	
	if keyboard.released( FB.SC_DOWN) then
		main_menu_buttons += 1
		sound_handler.set_queued_sound(SFX_COIN_BONUS)
	end if
	
	if keyboard.released( FB.SC_UP) then
		main_menu_buttons -= 1
		sound_handler.set_queued_sound(SFX_COIN_BONUS)
	end if
	

	
	
	if keyboard.released ( FB.SC_ESCAPE ) then
		this.set_exit_flag (true)
	end if
	
	
	if joystick.is_present then 
		joystick.update()

		if joystick.lever_up_pressed then
			main_menu_buttons += 1
			sound_handler.set_queued_sound(SFX_COIN_BONUS)
		end if
		
		if joystick.lever_down_pressed then
			main_menu_buttons -= 1
			sound_handler.set_queued_sound(SFX_COIN_BONUS)
		end if
	

		if joystick.released(0)  then
			is_enter = true
		end if

	end if
	
	
	
	if main_menu_buttons > 3 then main_menu_buttons = 0
	if main_menu_buttons < 0 then main_menu_buttons = 3
	
	
	if keyboard.released( FB.SC_SPACE) or keyboard.released( FB.SC_ENTER) then is_enter = true
	
	if (is_enter) then
	
	
		select case main_menu_buttons
			
			case _main_menu_button_new_game
			
				this.set_game_section(_game_section_ENTER_NAME)
				this.level_number = 0
				
				'init player's default values
				select case this.game_difficulty_slot
					case 1
						player.lives = 3
					case 2
						player.lives = 3
					case else
						player.lives = 3
				end select
				
				player.points = 0
				player.game_over = false
				player.ammo_floppies = _PL_FLOPPIES_DEFAULT
				player.ammo_sys_64738 = 0
				player.coins = 0
				player.empty_key_basket()
				
				player.reset_player_values()
				
				player.difficulty_ratio = this.game_difficulty_value(game_difficulty_slot)
				player.set_all_keywords_as_non_found()
				
				
			case _main_menu_button_credits
			
				this.set_game_section(_game_section_CREDITS)
				
			case _main_menu_button_difficulty
			
				this.game_difficulty_slot += 1
				if this.game_difficulty_slot > Ubound(this.game_difficulty_value) then
				
					this.game_difficulty_slot  = 0
				
				end if
				
				
			case _main_menu_button_top_scorers
			
				this.set_game_section(_game_section_TOP_SCORERS)
				
		end select
		
		sound_handler.set_queued_sound(SFX_COIN_BONUS)
		
	end if

end sub

sub game_handler_proto.draw_main_menu (image_buffer as FB.Image ptr)

	Dim i as Ulong
	for i = 0 to Ubound(this.keywords_list)
		
		draw string image_buffer, (	keywords_list(i).x, _
									keywords_list(i).y), _
									this.keywords_list(i).label,_
									this.keywords_list(i)._color
		
	next i


	line image_buffer, (0, 20)-step(SCR_W, 20),C_C64_BLUE, BF
	line image_buffer, (0, 50)-step(SCR_W, 20),C_C64_BLUE, BF
	line image_buffer, (0, 80)-step(SCR_W, 20),C_C64_BLUE, BF
	line image_buffer, (0, 110)-step(SCR_W, 20),C_C64_BLUE, BF
	
	draw string image_buffer, (360 - len("NEW GAME")*4, 28), "NEW GAME",	 	C_C64_LIGHT_BLUE
	draw string image_buffer, (360 - len("Level: " + this.game_difficulty_label(this.game_difficulty_slot))*4, 58), "Level: " +  this.game_difficulty_label(game_difficulty_slot),	 	C_C64_LIGHT_BLUE
	draw string image_buffer, (360 - len("TOP SCORERS")*4, 88), "TOP SCORERS", 	C_C64_LIGHT_BLUE
	draw string image_buffer, (360 - len("CREDITS")*4, 118), "CREDITS",			C_C64_LIGHT_BLUE
	

	select case this.main_menu_buttons
		case _main_menu_button_new_game
		
			line image_buffer, (0, 20)-step(SCR_W, 20),C_C64_LIGHT_BLUE, BF
		
			print_font (360 - len("NEW GAME")*8,23, "NEW GAME",	image_buffer)
						
		case _main_menu_button_difficulty
		
			line image_buffer, (0, 50)-step(SCR_W, 20),C_C64_LIGHT_BLUE, BF
		
			print_font (360 - len("Level: " + this.game_difficulty_label(game_difficulty_slot))*8,53, _
						"Level: " + this.game_difficulty_label(game_difficulty_slot),_
						image_buffer)
							
		case _main_menu_button_top_scorers
		
			line image_buffer, (0, 80)-step(SCR_W, 20),C_C64_LIGHT_BLUE, BF

			print_font (360 - len("TOP SCORERS")*8,83, _
						"TOP SCORERS",_
						image_buffer)
							
		case _main_menu_button_credits
		
			line image_buffer, (0, 110)-step(SCR_W, 20),C_C64_LIGHT_BLUE, BF

			print_font (360 - len("CREDITS")*8,113, _
						"CREDITS",_
						image_buffer)
	end select
	
	put image_buffer, (0,0), splashscreens_2x(0), trans

end sub

sub game_handler_proto.update_top_scorers (keyboard as keyboard_proto, joystick as joystick_proto)

	if keyboard.released ( FB.SC_SPACE )  or keyboard.released ( FB.SC_ENTER ) or keyboard.released ( FB.SC_ESCAPE ) then
		this.set_game_section(_game_section_MAIN_MENU)
	end if
	
	if joystick.is_present then 
		joystick.update()

		if joystick.released(0)  then
			this.set_game_section(_game_section_MAIN_MENU)
		end if

	end if
	

end sub

sub game_handler_proto.draw_top_scorers (image_buffer as FB.Image ptr)

	put image_buffer, (0,0), splashscreens_2x(3), pset

	'this.hst.Display(image_buffer)
	
	dim as Ulong col1, col2, col3
	
	col1 = 100	
	col2 = ((SCR_W  )\4) + 120
	col3 = ((SCR_W  )\4)*2 + 100
	
	
	print_font (SCR_W\2 - len("HIGHSCORE TABLE")*8, 20, _
				"HIGHSCORE TABLE", image_buffer)
	
	
	print_font (col1, 70, "Player",	image_buffer)
	print_font (col2, 70, "Score",	image_buffer)
	print_font (col3, 70, "Date",	image_buffer)
	
	for i as Ulong = 1 to HIGHSCORE_ENTRIES
	
		 if i = hst.score_position then
			line image_buffer, (0, 90 + (i*25) - 4)- step(SCR_W, 22), C_C64_BLUE, BF
		end if
	
		print_font (col1, 90 + (i*25), hst.Record(i).Playername,	image_buffer)
		print_font (col2, 90 + (i*25), hst.Record(i).Score,	image_buffer)
		print_font (col3, 90 + (i*25), hst.Record(i).Dateof,	image_buffer)
	
	next
	
	print_font (20, SCR_H - 30, "Press Esc to back to main menu", image_buffer)

end sub

sub game_handler_proto.update_credits (keyboard as keyboard_proto, joystick as joystick_proto)


	'go to main menu
	if keyboard.released ( FB.SC_SPACE )  or keyboard.released ( FB.SC_ENTER ) or keyboard.released ( FB.SC_ESCAPE ) then
		this.set_game_section(_game_section_MAIN_MENU)
		this.credits_txt_y_start = SCR_H
	end if
	
	if joystick.is_present then 
		joystick.update()
	
		if joystick.released(0)  then
			this.set_game_section(_game_section_MAIN_MENU)
			this.credits_txt_y_start = SCR_H
		end if

	end if
	
	
	
	
	'scroll the credits from bottom to top
	if this.credits_txt_y_start >  - Ubound( credits_txt) * 8 then
		this.credits_txt_y_start -=1
	end if

end sub

sub game_handler_proto.draw_credits (image_buffer as FB.Image ptr)

	dim heading as String
				
	dim i as Ulong
	dim y as Long
	
	y = credits_txt_y_start
	

					
	for i = 0 to Ubound(credits_txt)
	
		
		if (left(credits_txt(i),1)="*") then

			heading = Mid(credits_txt(i), 2)
		
			print_font (SCR_W\2 - len(heading)*8,i * 10 - 8 + y, _
					heading,_
					image_buffer)
		
			continue for
		end if
	
		draw string image_buffer, _
					(SCR_W\2 - len(credits_txt(i))*4, i * 10 + y), _
					credits_txt(i), C_C64_LIGHT_GREY_GREY_3	
	next i
	

	

end sub

function game_handler_proto.get_section_timing() as double

	return Timer - this.timing

end function

sub game_handler_proto.go_to_next_level()

	if this.level_number < MAX_NO_OF_LEVELS then

		this.level_number += 1
		this.set_game_section(_game_section_LEVEL_INTRO)
		this.timing = timer
		
	else
		'GAME COMPLETED
		this.set_game_section(_game_section_GAME_COMPLETED)
	end if
	
end sub

sub game_handler_proto.set_game_section(section as game_section_proto)
	
	this.timing = timer
	this.section = section

end sub

function game_handler_proto.get_game_section() as game_section_proto

	return this.section

end function

function game_handler_proto.get_current_level() as Ulong

	return this.level_number

end function

sub game_handler_proto.print_font (x as Ulong, y as Ulong, txt as string, image_buffer as FB.Image ptr)
	dim as ulong i, _x
	
	_x = x
	for i = 1 to len(txt)
		if i <= 127 then
			put image_buffer, (_x, y), ascii_font_big(asc(txt, i)), trans
			_x+=16
		end if
	next i
		

end sub

sub game_handler_proto.set_section_timing(timing as double)

	this.timing = timing

end sub

sub game_handler_proto.load_txt (filename as string, txt() as string)

	dim as string textline
	dim as Ulong i, j, filenum, res

	filenum = Freefile
	res 	= Open (filename, For Input, As #filenum)
	
	i = 0
	if res = 0 then 
		While (Not Eof(filenum))
			
			Line Input #filenum, textline ' Get one whole text line
			
			redim preserve txt(0 to i)
			
			txt(i) = textline
			
			i +=1
			
		Wend

		Close #filenum
	end if
	
	#IFDEF DEBUG_MODE
		utility_consmessage("game handler --- loaded txt")
		
		for i = 0 to Ubound(txt)
			utility_consmessage(txt(i))
		next i
	#ENDIF



end sub


sub game_handler_proto.update_intro (keyboard as keyboard_proto, joystick as joystick_proto)

	
	dim i as Long
	dim j as Long
	
	'update keywords movements
	for i = 0 to Ubound(this.keywords_list)
		
		if not this.keywords_list(i).is_found then
			this.keywords_list(i).x += this.keywords_list(i).speed
			
			if this.keywords_list(i).x > SCR_W then
				this.keywords_list(i).x =  - rnd*100 - 100
			end if
		end if
				
	next i

	'toggle keywords
	if Timer - this.timing > 3 then
		for j = 0 to 3
			i = this.get_a_keyword()
			'important check!
			if i >= 0 then
				this.keywords_list(i).is_found = true
			end if
		next j
	end if
	
	
	'go to main menu
	if keyboard.released ( FB.SC_SPACE ) then
		this.set_game_section(_game_section_MAIN_MENU)
	end if
	
	if joystick.is_present then 
		joystick.update()
	
		if joystick.released(0)  then
			this.set_game_section(_game_section_MAIN_MENU)
		end if

	end if
	
	
	
end sub

sub game_handler_proto.draw_intro (image_buffer as FB.Image ptr)

'	line image_buffer, (0,0)-step(SCR_W, SCR_H), C_C64_DARK_GREY_GREY_1, BF
	
	dim as Ulong i, j
	static y as single = SCR_H \ 2
	

	
	dim t as double
	t = int(Timer - this.timing)
	
	
	'for i = -1 to 4
		'for j = -1 to 4
			''wallpaper
			'put image_buffer,  (	320*i,  240*j), this.wallpaper_2x(3), pset
			
		'next j
	'next i
	
	
	for i = 0 to Ubound(this.keywords_list)
		if not this.keywords_list(i).is_found then
			draw string image_buffer, (	keywords_list(i).x, _
										keywords_list(i).y), _
										this.keywords_list(i).label,_
										this.keywords_list(i)._color
		end if
		
	next i
	
	put image_buffer, (0,0), splashscreens_2x(1), trans
	
	
	select case t
		case 0 to 1
			'do not type nothing on screen
		case 2 to 8
			for i = 0 to 7
				print_font (SCR_W\2 - len(game_intro_txt(i))*8,i * 20 - 8 + y, _
						game_intro_txt(i),_
						image_buffer)
			next i
		case 9 to 11
			for i = 0 to 48
				line image_buffer, _
					(0, i *  (SCR_H\48))-step(SCR_W,  (SCR_H\48)),_
					this.c64_colors(Clng(rnd*15)), BF
			next i
		case 12 to 15
	
				draw string image_buffer, ( SCR_W\2 - 150, SCR_H\2), "A long time ago in a compiler far,", C_C64_BLUE 
				draw string image_buffer, ( SCR_W\2 - 150, SCR_H\2 + 20), "far away", C_C64_BLUE 
		case else
			for i = 8 to Ubound(game_intro_txt)
				print_font (SCR_W\2 - len(game_intro_txt(i))*8, (i-8)*20 + this.intro_txt_y_start, _
						game_intro_txt(i),_
						image_buffer)
			next i
			
			this.intro_txt_y_start -=1
			
			if t > 30 andalso frac(Timer) mod 100 = 0 then
				line image_buffer, (0, SCR_H - 40) - step(SCR_W, 40), C_C64_BLUE, BF
				this.print_font (	SCR_W\2 - len("Press Fire" +  this.player_name + "!")*8, _
									SCR_H - 28,"Press Fire",	image_buffer)
			end if
			
			if t > 32 then
				draw string image_buffer, (SCR_W\2 - len("If you can read this, you don't need glasses") * 4, SCR_H\2), _
											"If you can read this, you don't need glasses", &h333333
			end if
			
	end select

	



end sub

sub game_handler_proto.init_keywords_list(freebasic_keywords_list() as string)
	Dim i as Ulong
	
	dim c as Ulong
	for i = 0 to Ubound(freebasic_keywords_list)
		redim preserve this.keywords_list(0 to i)
		this.keywords_list(i).id = i
		this.keywords_list(i).label = freebasic_keywords_list(i)
		this.keywords_list(i).is_found = false
		this.keywords_list(i).x =  rnd * SCR_W 
		this.keywords_list(i).y = int(rnd * 60) * 8
		this.keywords_list(i).speed = rnd*3+1
		c = rnd*3
		
		select case c
			case 0
				this.keywords_list(i)._color = C_C64_DARK_GREY_GREY_1
			case 1
				this.keywords_list(i)._color = C_C64_GREY_2
			case 2
				this.keywords_list(i)._color = C_C64_LIGHT_GREY_GREY_3
			case else
				this.keywords_list(i)._color = C_C64_WHITE
		end select
		
			
		
	next i
	
end sub


function game_handler_proto.get_a_keyword () as ULong

	dim i as Ulong
	
	redim free_slots(0 to 0) as Ulong
	
	for i = 0 to Ubound (this.keywords_list)
		if this.keywords_list(i).is_found = false then
			free_slots(Ubound(free_slots)) = i
			redim preserve free_slots(0 to Ubound(free_slots) + 1)
		end if
	next i
	
	'it will return -1 if there are not free slots available
	if Ubound(free_slots) >= 0 then
		return free_slots(rnd * (Ubound (free_slots)))
	else
		return -1
	end if
	
end function

sub game_handler_proto.update_enter_name (keyboard as keyboard_proto)

	if len(this.player_name) < 8 then

		if keyboard.pressed(FB.SC_A) then this.player_name = this.player_name +  "A"
		if keyboard.pressed(FB.SC_B) then this.player_name = this.player_name +  "B"
		if keyboard.pressed(FB.SC_C) then this.player_name = this.player_name +  "C"
		if keyboard.pressed(FB.SC_D) then this.player_name = this.player_name +  "D"
		if keyboard.pressed(FB.SC_E) then this.player_name = this.player_name +  "E"
		if keyboard.pressed(FB.SC_F) then this.player_name = this.player_name +  "F"
		if keyboard.pressed(FB.SC_G) then this.player_name = this.player_name +  "G"
		if keyboard.pressed(FB.SC_H) then this.player_name = this.player_name +  "H"
		if keyboard.pressed(FB.SC_I) then this.player_name = this.player_name +  "I"
		if keyboard.pressed(FB.SC_J) then this.player_name = this.player_name +  "J"
		if keyboard.pressed(FB.SC_K) then this.player_name = this.player_name +  "K"
		if keyboard.pressed(FB.SC_L) then this.player_name = this.player_name +  "L"
		if keyboard.pressed(FB.SC_M) then this.player_name = this.player_name +  "M"
		if keyboard.pressed(FB.SC_N) then this.player_name = this.player_name +  "N"
		if keyboard.pressed(FB.SC_O) then this.player_name = this.player_name +  "O"
		if keyboard.pressed(FB.SC_P) then this.player_name = this.player_name +  "P"
		if keyboard.pressed(FB.SC_Q) then this.player_name = this.player_name +  "Q"
		if keyboard.pressed(FB.SC_R) then this.player_name = this.player_name +  "R"
		if keyboard.pressed(FB.SC_S) then this.player_name = this.player_name +  "S"
		if keyboard.pressed(FB.SC_T) then this.player_name = this.player_name +  "T"
		if keyboard.pressed(FB.SC_U) then this.player_name = this.player_name +  "U"
		if keyboard.pressed(FB.SC_V) then this.player_name = this.player_name +  "V"
		if keyboard.pressed(FB.SC_W) then this.player_name = this.player_name +  "W"
		if keyboard.pressed(FB.SC_X) then this.player_name = this.player_name +  "X"
		if keyboard.pressed(FB.SC_Y) then this.player_name = this.player_name +  "Y"
		if keyboard.pressed(FB.SC_Z) then this.player_name = this.player_name +  "Z"
		if keyboard.pressed(FB.SC_SPACE) then this.player_name = this.player_name +  " "

	end if

	if keyboard.released ( FB.SC_BACKSPACE ) then
		this.player_name = ""
	end if
	
	if keyboard.released ( FB.SC_ESCAPE ) then
		this.set_game_section(_game_section_MAIN_MENU)
		this.player_name = ""
	end if
	
	if keyboard.released( FB.SC_ENTER) then
	
		this.set_game_section(_game_section_LEVEL_INTRO)
	
	end if

end sub

sub game_handler_proto.draw_enter_name (image_buffer as FB.Image ptr)

	put image_buffer, (0,0), splashscreens_2x(2), pset
	
	line image_buffer, (0, 0) - step(SCR_W, 100), C_C64_BLUE, BF

	print_font (SCR_W\2 - len("ENTER YOUR NAME")*8, 20, _
				"ENTER YOUR NAME", image_buffer)
				
	print_font (SCR_W\2 - len(this.player_name)*8, 46, _
			this.player_name, image_buffer)

end sub

function game_handler_proto.get_player_name () as string
	return this.player_name
end function


sub game_handler_proto.update_level_intro (keyboard as keyboard_proto, joystick as joystick_proto)

	if 	Cbool(this.get_section_timing() > LEVEL_INTRO_GET_READY_TIME) then
	
		if keyboard.released ( FB.SC_SPACE )  then
			this.set_game_section(_game_section_LEVEL_INITIALIZE)
		end if
		
		if joystick.is_present then 
			joystick.update()
	
			if joystick.released(0)  then
				this.set_game_section(_game_section_LEVEL_INITIALIZE)
			end if

		end if
		
		
	end if

end sub

sub game_handler_proto.draw_level_intro (image_buffer as FB.Image ptr, _
										heading as string, _
										language_name as string, _
										tip_1 as string, _
										tip_2 as string, _
										keywords_to_find as Ulong,_
										points as Ulong,_
										lives as Ulong, _
										wallpaper_slot as Ulong, _
										scenario_slot as Ulong)
										
	dim as Long i, j

	if this.get_section_timing() < LEVEL_INTRO_GET_READY_TIME then
		for i = 0 to 48
			line image_buffer, _
				(0, i *  (SCR_H\48))-step(SCR_W,  (SCR_H\48)),_
				this.c64_colors(Clng(rnd*15)), BF
		next i
	else
		for i = -1 to 4
			for j = -1 to 4
				'wallpaper
				put image_buffer,  (	320*i, 240*j), this.wallpaper_2x(wallpaper_slot), pset
			next j
		next i
		
		for i = -1 to 4
			'scenario
			put image_buffer,  (	320*i, SCR_H - 240), this.wallpaper_2x(scenario_slot), trans
	
		next i
		
	end if
	
	
		
	line image_buffer, _
		(50, 50)-(SCR_W-50, SCR_H-50), C_C64_BLUE, BF
		
	draw string image_buffer, (SCR_W\2 - len(this.game_difficulty_label(this.game_difficulty_slot))*4, 54), _
								this.game_difficulty_label(this.game_difficulty_slot)
				
	this.print_font (SCR_W\2 - len (heading)*8, 80, _
					heading, _
					image_buffer)
	this.print_font (SCR_W\2 - len (language_name)*8, 120, _
					language_name, _
					image_buffer)
	this.print_font (SCR_W\2 - len (tip_1)*8, SCR_H - 120, _
					tip_1, _
					image_buffer)
	this.print_font (SCR_W\2 - len (tip_1)*8, SCR_H - 100, _
					tip_2, _
					image_buffer)
					
					
	this.print_font (SCR_W\2 - len (str(keywords_to_find) + " keywords to find")*8, SCR_H - 200, _
					str(keywords_to_find) + " keywords to find", _
					image_buffer)
	
	this.print_font (SCR_W\2 - len ("points: " + str(points))*8, SCR_H - 180, _
					"points: " + str(points), _
					image_buffer)
	this.print_font (SCR_W\2 - len ("lives: " + str(lives))*8, SCR_H - 160, _
					"lives: " + str(lives), _
					image_buffer)
					
					

					
	if 	this.get_section_timing() > LEVEL_INTRO_GET_READY_TIME then

		
		if frac(Timer) mod 100 = 0 then
		
		line image_buffer, (0, SCR_H\2 - 20) - step(SCR_W, 40), C_C64_RED, BF
		
		this.print_font (SCR_W\2 - len("GET READY " +  this.player_name + "!")*8, _
						SCR_H\2 - 8,_
						"GET READY " +  this.player_name + "!"	,_
						image_buffer)
		end if
	end if
	
end sub



sub game_handler_proto.draw_game_completed (image_buffer as FB.Image ptr)

	Dim i as Ulong
	
	'update keywords movements
	for i = 0 to Ubound(this.keywords_list)
		this.keywords_list(i).x -= this.keywords_list(i).speed
		this.keywords_list(i).y -= this.keywords_list(i).speed
		
		if this.keywords_list(i).x > SCR_W then
			this.keywords_list(i).x =  0
		end if
		
		if this.keywords_list(i).x < 0 then
			this.keywords_list(i).x =  SCR_W
		end if
		
		if this.keywords_list(i).y < 0 then
			this.keywords_list(i).y =  SCR_H
		end if
		
		if this.keywords_list(i).y > SCR_H then
			this.keywords_list(i).y =  0
		end if
		
	next i

	
	for i = 0 to Ubound(this.keywords_list)
		
		draw string image_buffer, (	keywords_list(i).x, _
									keywords_list(i).y), _
									this.keywords_list(i).label,_
									this.keywords_list(i)._color
		
	next i

	put image_buffer, (0,0), this.end_screen_2x(0), trans

	print_font (50, 80, 			"GAME COMPLETED!", 				image_buffer)
	print_font (50, SCR_H - 150, 	"Also the remaining keywords", 	image_buffer)
	print_font (50, SCR_H - 120, 	"are now free again!", 			image_buffer)
	
	print_font (50, SCR_H - 80, 	"...but Darkistra is escaped!", image_buffer)
	print_font (50, SCR_H - 60, 	"See you in Impossible Victhorse II", image_buffer)
				
	
end sub
