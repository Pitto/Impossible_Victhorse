'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


'A love letter to Freebasic Game Engine by Pitto
' Compiling instructions: fbc -w all -exx "%f"

#include "fbgfx.bi"

Using FB
randomize timer


#include "inc/definitions.bi"
#include "inc/enums.bi"
#include "inc/types.bi"
#include "file.bi"
#include "inc/functions.bi"


utility_consmessage(APP_NAME + " " + APP_VERSION + " by " + APP_AUTHOR)


#IFDEF	COMPILE_MUSIC_AND_SFX

	#include once "inc/fbsound_oop.bi"

	
	utility_consmessage("initializing audio, please wait...")
	
	
	'initializing sound files #################################

	dim Device as SoundDevice = SoundDevice()
	dim Background_music (0 to 3) as SoundBuffer = _
		{ 	SoundBuffer(SampleBuffer("audio/music/drozerix_-_neon_techno.mod")), _
			SoundBuffer(SampleBuffer("audio/music/once_is_not_enough.mod")), _
			SoundBuffer(SampleBuffer("audio/music/the_nada_one.mod")), _
			SoundBuffer(SampleBuffer("audio/music/sgs-excl.mod"))}
			
	dim Game_sfx(1 to 26) as SoundBuffer = { _
			SoundBuffer(SampleBuffer("audio/sfx_all_level_keyword_found.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_ballistic_floppy_launch.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_bullet_1_launch.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_bullet_2_launch.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_bullet_3_launch.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_coin_bonus.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_directional_floppy_launch.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_door_opened.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_explosion_1.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_explosion_2.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_floppy_block.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_floppy_bonus.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_floppy_empty.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_floppy_explosion.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_game_over.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_keyword_bonus.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_key_bonus.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_medpack_bonus.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_missile_launch.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_player_climb_jump.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_player_death.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_player_hurt.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_player_jump.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_player_powerup.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_sys64738.wav")), _ 
			SoundBuffer(SampleBuffer("audio/sfx/sfx_wood_box_explosion.wav")) _
			}
#ENDIF



#include "inc/sound_handler.bi"
'#include "inc/music_handler.bi"


#include "inc/item.bi"
#include "inc/canvas.bi"
#include "inc/level.bi"
#include "inc/joystick.bi"
#include "inc/keyboard.bi"
#include "inc/user_input.bi"
#include "inc/player.bi"
#include "inc/camera.bi"
#include "inc/debug.bi"

#include "inc/gui.bi"
#include "inc/highscore.bi"
#include "inc/level_data.bi"
#include "inc/game_handler.bi"


#IFDEF CHEAT_MODE

	#include "inc/cheat.bi"

#ENDIF



#IFDEF DEBUG_MODE 
	utility_consmessage("** GAME LAUNCHED ****")
	utility_consmessage("")
	utility_consmessage("initializing video...")
#ENDIF




'graphical initialization
DIM workpage 				AS INTEGER
workpage = 0

screenres (SCR_W, SCR_H, 24, 2, GFX_HIGH_PRIORITY)
screenset workpage, 1 - workpage
WindowTitle APP_NAME + " " + Str(APP_VERSION) + " by " + str(APP_AUTHOR)
'SetMouse SCR_W\2, SCR_H\2, 0

dim as ulong i, j, k, c

#IFDEF DEBUG_MODE 
	utility_consmessage("initializing objects...")
#ENDIF


dim game_handler as game_handler_proto

dim camera 			as camera_proto
dim debug_info 		as debug_info_proto
dim victor as player_proto


dim player_input 	as user_input
dim keyboard 		as keyboard_proto
dim joystick 		as joystick_proto

dim canvas 			as canvas_proto
dim gui 			as gui_proto

dim level as level_proto

#IFDEF DEBUG_MODE
	#IFDEF COMPILE_MUSIC_AND_SFX
		utility_consmessage("initializing audio...")
	#ENDIF
#ENDIF

dim sound_handler as sound_handler_proto



#IFDEF CHEAT_MODE
	dim cheat_handler as cheat_proto
#ENDIF

'In debug mode, passing a level as argument - the level is launched by the main directly to be tested

dim as string level_file_name
level_file_name = ""

#IFDEF DEBUG_MODE

	'check if specified file exists
	if __FB_ARGC__ > 1 then
		level_file_name = str(Command(1))
	   if FileExists(level_file_name)  then
		
			game_handler.set_game_section(_game_section_LEVEL_INTRO)
			utility_consmessage("*** LEVEL TESTING ***")
			utility_consmessage(level_file_name)
	   else
			utility_consmessage("*** LEVEL TESTING ***")
			utility_consmessage(level_file_name)
			utility_consmessage("*** DOESN'T EXISTS ***")
		  end
	   end if
	end if

#ENDIF

#IFDEF COMPILE_MUSIC_AND_SFX
	'stop all background music
	for i = 0 to Ubound(Background_music)
		Background_music(i).pause = true
	next i
	Background_music(3).pause = false
	Background_music(3).play
#ENDIF

type f_t_s_proto
	oldTimer as double
	update_physics as boolean
end type

dim f_t_s as f_t_s_proto
f_t_s.oldTimer = Timer
f_t_s.update_physics = true



'just a workaround to syncronize better the intro
game_handler.set_section_timing (timer)


dim as string x_close_key
do
	
	if game_handler.get_exit_flag then exit do
	
	x_close_key = Inkey
	if x_close_key = Chr(255, 107) then exit do 'x-button on window
	
	
	'update____________________________________________________________
	
	'reset sound into sound queue
	sound_handler.set_queued_sound(0)
	
	'IMPORTANT!
	if Timer > f_t_s.oldTimer + FIXED_TIME_STEP then
		f_t_s.update_physics = true
	end if
	
	select case game_handler.get_game_section()
		case _game_section_INTRO
			game_handler.update_intro (keyboard, joystick)
		
		case _game_section_MAIN_MENU
		
			game_handler.update_main_menu (keyboard, joystick, victor, sound_handler)
			
		case _game_section_ENTER_NAME
			
			game_handler.update_enter_name (keyboard)
			
			
		case _game_section_TOP_SCORERS
		
			game_handler.update_top_scorers (keyboard, joystick)
		
		case _game_section_LEVEL_INTRO
		
			game_handler.update_level_intro (keyboard, joystick)

		
		case _game_section_LEVEL_INITIALIZE


			level.load_level (game_handler.get_current_level(), level_file_name, victor.difficulty_ratio)

			level.time_to_complete = level_data(game_handler.get_current_level()).time_left
			level.set_time_left (level.time_to_complete)
			
			level.load_block_icons(game_handler.get_current_level())
			
			level.set_scenario_slot(level_data(game_handler.get_current_level()).scenario)
			level.set_wallpaper_slot(level_data(game_handler.get_current_level()).wallpaper)

			camera.set_bounds(TILE_W,TILE_H,Ubound(level.tiles, 2)*TILE_W - camera.w*2,TILE_H + Ubound(level.tiles)*TILE_H - camera.h*2)
			camera.set_position(level.get_player_start_position().x, level.get_player_start_position().y)
			
			victor.init_position(level.get_player_start_position().x, level.get_player_start_position().y)
	
			victor.reset_player_values()
			victor.empty_key_basket()
			
			#IFDEF DEBUG_MODE
				utility_consmessage("*** INITIALIZING LEVEL ***")
				utility_consmessage("LEVEL            : " + str(game_handler.get_current_level()))
				utility_consmessage("time left        : " + str(level.get_time_left ()))
				utility_consmessage("keywords to find : " + str(level.keyword_to_find))
				utility_consmessage("victor lives     : " + str(victor.lives))
			#ENDIF
			
			#IFDEF COMPILE_MUSIC_AND_SFX
				'stop all background music
				for i = 0 to Ubound(Background_music)
					Background_music(i).pause = true
				next i
				Background_music(level_data(game_handler.get_current_level()).music_slot).pause = false
				Background_music(level_data(game_handler.get_current_level()).music_slot).volume = 1
				Background_music(level_data(game_handler.get_current_level()).music_slot).play
			
			#ENDIF
			
			game_handler.set_game_section(_game_section_LEVEL)
			
		case _game_section_LEVEL
		
		
			
			#IFDEF DEBUG_MODE
				debug_info.get_time(Timer, False, True)
			#ENDIF
			
			#IFDEF CHEAT_MODE
				cheat_handler.update(keyboard, victor, level)
			#ENDIF
			

			if f_t_s.update_physics then
				level.update_level_blocks()
				level.update_level_items(@victor.points, victor.get_player_position(), sound_handler, victor.difficulty_ratio)
			end if
			
			level.items = level.delete_selected_items(level.items)
			
			player_input.get_input(joystick, keyboard)
			
			if f_t_s.update_physics then
				victor.update_player(player_input, level, sound_handler)
				
				if victor.is_dead = false then
					victor.check_block_collision(level.tiles(), level)
					victor.check_item_collision (level.items, level, sound_handler)
				end if
				
				camera.update(victor.x_sight, victor.y_sight)
			end if
			
			debug_info.update(keyboard)
			
			
			
			if level.is_completed then
				level.mark_all_items_to_be_deleted()
				level.items = level.delete_selected_items(level.items)
				game_handler.go_to_next_level()
			end if
			
			'ESC
			if keyboard.released ( FB.SC_ESCAPE ) then
				level.mark_all_items_to_be_deleted()
				level.items = level.delete_selected_items(level.items)
				game_handler.set_game_section(_game_section_MAIN_MENU)
			end if
			
			if victor.game_over then
				game_handler.set_game_section(_game_section_GAME_OVER)
				game_handler.set_section_timing (timer)
			end if
			

		case _game_section_GAME_OVER
		
			victor.update_player(player_input, level, sound_handler)
		
			if game_handler.get_section_timing() > 4 then
				'cleanup level
				level.mark_all_items_to_be_deleted()
				level.items = level.delete_selected_items(level.items)
				
				'save points to highscore
				game_handler.player_score.set (game_handler.get_player_name(), str(Victor.points), date)
				game_handler.hst.Insert(game_handler.player_score)
				
				'back to main menu
				game_handler.set_game_section(_game_section_TOP_SCORERS)
				

			end if
			
		case _game_section_GAME_COMPLETED
		
			if 	keyboard.released ( FB.SC_ESCAPE ) or keyboard.released ( FB.SC_SPACE )  or keyboard.released ( FB.SC_ENTER ) then
		
				'cleanup level
				level.mark_all_items_to_be_deleted()
				level.items = level.delete_selected_items(level.items)
				
				'save points to highscore
				game_handler.player_score.set (game_handler.get_player_name(), str(Victor.points), date)
				game_handler.hst.Insert(game_handler.player_score)
				
				'back to main menu
				game_handler.set_game_section(_game_section_TOP_SCORERS)

			end if
		
	
		case _game_section_CREDITS
			game_handler.update_credits (keyboard, joystick)
		
	end select
	

	'important!
	if f_t_s.update_physics then
		f_t_s.update_physics = false
		f_t_s.oldTimer = Timer
	end if
	
	'draw________________________________________________________________
	
	
	
	canvas.clear_canvas()
	
	select case game_handler.get_game_section()
	

		case _game_section_INTRO
		
			game_handler.draw_intro (canvas.original_size)
	
		'MAIN MENU______________________________________________________
		case _game_section_MAIN_MENU
		
			game_handler.draw_main_menu(canvas.original_size)
			
		case _game_section_ENTER_NAME
			
			game_handler.draw_enter_name (canvas.original_size)
			
		case _game_section_TOP_SCORERS
		
			game_handler.draw_top_scorers (canvas.original_size)
			
		case _game_section_LEVEL_INTRO
		
			 game_handler.draw_level_intro (	canvas.original_size,_
												level_data(game_handler.get_current_level()).heading, _
												level_data(game_handler.get_current_level()).language_name,  _
												level_data(game_handler.get_current_level()).tip_1, _
												level_data(game_handler.get_current_level()).tip_2, _
												victor.get_remaining_keywords_to_find(), _
												victor.points,_
												victor.lives, _
												level_data(game_handler.get_current_level()).wallpaper,_
												level_data(game_handler.get_current_level()).scenario)

	
		case _game_section_LEVEL
			
			level.draw_level (camera.x_offset, camera.y_offset, victor.difficulty_ratio, canvas.original_size)
			victor.draw_player(camera.x_offset, camera.y_offset, canvas.original_size)
			
			gui.draw_gui_header (0, SCR_H - 20, victor.lives, victor.ammo_floppies, victor.ammo_sys_64738, _
								victor.energy , victor.coins, victor.points, _
								victor.has_yellow_key , victor.has_red_key , victor.has_blue_key , _
								level.keyword_to_find, level.get_time_left(), canvas.original_size)
								
			#IFDEF CHEAT_MODE
				if cheat_handler.enabled then
					'draw a red box around the whole screen
					line canvas.original_size, (0,0)-step(SCR_W,10), C_RED, BF
					line canvas.original_size, (0,SCR_H-10)-step(SCR_W,10), C_RED, BF
					line canvas.original_size, (0,0)-step(10, SCR_H), C_RED, BF
					line canvas.original_size, (SCR_W-10,0)-step(10, SCR_H), C_RED, BF
					draw string canvas.original_size, (10, 10), "CHEAT MODE"
				end if
			#ENDIF
								
		case _game_section_GAME_OVER
		
			level.draw_level (camera.x_offset, camera.y_offset, victor.difficulty_ratio, canvas.original_size)
			victor.draw_player(camera.x_offset, camera.y_offset, canvas.original_size)
			
		
			for i = 0 to SCR_H step 2
			
				line canvas.original_size, (0,i)-step(SCR_W,0), C_C64_Black
			
			next i
		
			game_handler.print_font 	(SCR_W\2 - len("GAME OVER")*8, SCR_H\2, _
										"GAME OVER",_
										canvas.original_size)
										
		case _game_section_GAME_COMPLETED
		
			game_handler.draw_game_completed (canvas.original_size)
		
		case _game_section_CREDITS
		
			game_handler.draw_credits (canvas.original_size)
		
	end select

	#IFDEF DEBUG_MODE
		debug_info.get_time(Timer, True, True)
	#ENDIF
	
	
	#IFDEF __FB_LINUX__
		'check this
		ScreenSync
	#ELSE
		'check this
		ScreenSync
	#ENDIF 
	
	screenlock ' Lock the screen
	
	screenset Workpage, 1 - Workpage
	
	cls
	
	if canvas.original_size <> 0 then
		put (0, 0), canvas.original_size, pset
	end if
	
	#IFDEF DEBUG_MODE
		debug_info.get_time(Timer, True, True)
	#ENDIF
	
	#IFDEF DEBUG_MODE
	
		debug_info.draw_debug (victor, camera, level, player_input, joystick)
		
		draw string (SCR_W\2,SCR_H - 8), str (APP_NAME + " "+  APP_VERSION), C_BLACK
		draw string (SCR_W\2 - 1,SCR_H - 9), str (APP_NAME +" " +APP_VERSION), C_WHITE
		'draw string (20,SCR_H - 8), "FPS: " +  str (debug_info.fps), C_WHITE
		
		draw_button (20,SCR_H - 30, 80,_
							10, "FPS: " +  str (debug_info.fps),_
							true)
		joystick.update()
		
		
		
			
			draw_button (20,SCR_H - 20, 150,_
							10, "joy y: " +  str (joystick.get_y()),_
							true)
		
		
		
	#ENDIF
	


	workpage = 1 - Workpage ' Swap work pages.  
	
	screenunlock
	
	#IFDEF DEBUG_MODE
		debug_info.get_time(Timer, True, False)
	#ENDIF
	
	#IFDEF COMPILE_MUSIC_AND_SFX
		'play the queued sound, if present
		if 	sound_handler.get_queued_sound() andalso _
			sound_handler.get_queued_sound() <= Ubound (Game_sfx)then
				Game_sfx(sound_handler.get_queued_sound()).play
		end if

		'loop the background music
		if Background_music(level_data(game_handler.get_current_level()).music_slot).Playposition >= 1 then
			Background_music(level_data(game_handler.get_current_level()).music_slot).play
		end if
	#ENDIF
	
	
	'check this
	
	
	#IFDEF __FB_LINUX__
		sleep 5,1
	#ELSE
		sleep 5,1
	#ENDIF 
	
	
LOOP

utility_consmessage("Bye Bye :) - Thank you for having played my game")
utility_consmessage("")
utility_consmessage("psst! Be careful, while you were playing, Darkistra")
utility_consmessage("stole your credit card number ;)")


