'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


type debug_info_proto
	
	dim show 					as boolean
	dim show_level_grid			as boolean
	dim show_joystick_info		as boolean
	dim show_player_info 		as boolean
	dim show_player_boundings 	as boolean
	dim show_player_collisions 	as boolean
	dim show_help 				as boolean
	dim show_camera_info		as boolean
	dim show_player_input_info	as boolean
	dim show_compute_timing_info		as boolean
	dim show_level_info			as boolean
	dim show_item_info			as boolean
	dim show_keyword_info			as boolean
	dim show_tile_power			as boolean
	dim show_item_bounds			as boolean
	redim on_screen_help(0 to 0) as string
	
	
	dim draw_time_begin as double
	dim draw_time_end as double
	dim draw_time_elapsed as double
	
	dim compute_time_begin as double
	dim compute_time_end as double
	dim compute_time_elapsed as double
	
	dim fps as Ulong
	
	declare sub update (keyboard as keyboard_proto)
	declare sub load_on_screen_help_txt (Byref fn As String)
	
	declare sub get_time(timing as double, draw_mode as boolean, begin as boolean)
	
	declare sub draw_debug (	victor as player_proto, _
								camera as camera_proto, _
								level as level_proto,_
								player_input as user_input,_
								joystick as joystick_proto)
	
	declare constructor()

end type

Constructor debug_info_proto
	this.show						= false
	this.show_joystick_info			= false
	this.show_player_info			= false
	this.show_player_boundings		= false
	this.show_player_collisions 	= false
	this.show_help 					= false
	this.show_level_grid 			= false
	this.show_camera_info 			= false
	this.show_player_input_info		= false
	this.show_compute_timing_info	= false
	this.show_level_info			= false
	this.show_item_info				= false
	this.show_keyword_info				= false
	this.show_tile_power				= false
	this.show_item_bounds				= false
	this.load_on_screen_help_txt ("data/instructions.txt")
	
end constructor

sub debug_info_proto.get_time(timing as double, draw_mode as boolean, begin as boolean)
	if draw_mode then
		if begin then
			this.draw_time_begin = Timer
		else
			this.draw_time_end = Timer
		end if
	else
		if begin then
			this.compute_time_begin = Timer
		else
			this.compute_time_end = Timer
		end if
	end if
	
	this.compute_time_elapsed 	= this.compute_time_end - this.compute_time_begin
	this.draw_time_elapsed 		= this.draw_time_end - this.draw_time_begin
	this.fps = abs(int(1.0f/(draw_time_begin-draw_time_end)))
	
	
	
end sub

sub debug_info_proto.load_on_screen_help_txt (Byref fn As String)
	'Thanks to bulrush for this very useful sub
    'this is a snippet based on his source
    'http://www.freebasic.net/forum/viewtopic.php?f=7&t=24284
    'this sub read a whole text file and put it into an array
    Dim As Integer filenum,res,outpos,i,ub
    Dim As String ln

    outpos 	= 0
    filenum = Freefile
    res 	= Open (fn, For Input, As #filenum)

	While (Not Eof(filenum))
		Line Input #filenum, ln ' Get one whole text line
		Redim Preserve this.on_screen_help(outpos)
		on_screen_help(outpos)	= ln
		outpos += 1
	Wend

    Close #filenum

    
end sub

sub debug_info_proto.update  (keyboard as keyboard_proto)

	'enable / disable on-screen infos
	if keyboard.released( FB.SC_D ) then
		this.show = not this.show
		this.show_help = false
	end if
	
	if keyboard.released( FB.SC_F1 ) then this.show_help 				= not this.show_help
	if keyboard.released( FB.SC_B ) then this.show_player_boundings 	= not this.show_player_boundings
	if keyboard.released( FB.SC_C ) then this.show_player_collisions 	= not this.show_player_collisions
	if keyboard.released( FB.SC_E ) then this.show_tile_power 			= not this.show_tile_power
	if keyboard.released( FB.SC_G ) then this.show_level_grid		 	= not this.show_level_grid
	if keyboard.released( FB.SC_I ) then this.show_player_input_info	= not this.show_player_input_info
	if keyboard.released( FB.SC_J ) then this.show_joystick_info		= not this.show_joystick_info
	if keyboard.released( FB.SC_K ) then this.show_keyword_info 			= not this.show_keyword_info
	if keyboard.released( FB.SC_L ) then this.show_level_info 			= not this.show_level_info
	if keyboard.released( FB.SC_M ) then this.show_camera_info		 	= not this.show_camera_info
	if keyboard.released( FB.SC_N ) then this.show_player_info 			= not this.show_player_info
	if keyboard.released( FB.SC_Q ) then this.show_item_info 			= not this.show_item_info
	if keyboard.released( FB.SC_T ) then this.show_compute_timing_info 	= not this.show_compute_timing_info
	if keyboard.released( FB.SC_X ) then this.show_item_bounds 			= not this.show_item_bounds

end sub

sub debug_info_proto.draw_debug  (	victor as player_proto, _
									camera as camera_proto, _
									level as level_proto,_
									player_input as user_input, _
									joystick as joystick_proto)

	dim as Ulong i, j, x, y
	dim as single _x, _y
	
	
	if this.show then
	
		if this.show_keyword_info then
			
			
		
		
			for i = 0 to SCR_H step 2
				line(0, i)-(SCR_W, i), C_GRAY
			next i
			
			draw string (SCR_W - 80, SCR_H - 30), _
			"remaining :"
			draw string (SCR_W - 80, SCR_H - 20), _
			 str(victor.get_remaining_keywords_to_find())
		
			for i = 0 to Ubound (victor.keywords_list)
				if i>0 and i mod 12 = 0 then
					y+= 10
					x = 0 
				end if
				if victor.keywords_list(i).is_found then
					draw string (x + 1, y + 1), Mid(victor.keywords_list(i).label, 1, 5), C_BLACK
					draw string (x, y), Mid(victor.keywords_list(i).label, 1, 5), C_GREEN
				else
					draw string (x, y), Mid(victor.keywords_list(i).label, 1, 5), C_WHITE
				end if
				x+= 48
			next i
			
			draw string ( 20, SCR_H - 20), "keyword_to_find    : " 	+ str(level.keyword_to_find)
			
		end if
		
		if this.show_compute_timing_info then
			draw string (50,50), "DRAW TIME    : " 	+ str(this.draw_time_elapsed)
			draw string (50,60), "COMPUTE TIME : " 	+ str(this.compute_time_elapsed)
		end if
	
		if this.show_help then

			for i = 0 to SCR_H step 2
				line(0, i)-(SCR_W, i), C_DARK_GRAY
			next i
			for i = 0 to Ubound(this.on_screen_help)-1
				draw string (21, 21 + i * 12), this.on_screen_help(i), C_BLACK
				draw string (20, 20 + i * 12), this.on_screen_help(i), C_WHITE
			next i

		end if

		if this.show_player_info then
			_x = victor.x - camera.x_offset
			_y = victor.y - camera.y_offset
			dim action_label as string * 32
			draw string (20, 20), "ENERGY   : " + str(victor.energy)
			draw string (20, 30), "COINS    : " + str(victor.coins)
			
			
			draw string (_x, _y + 20), "   DIR: " + str (victor.direction)
			draw string (_x, _y + 30), " SPEED: " + str (victor.speed)
			draw string (_x, _y + 40), "     X: " + str (victor.x)
			draw string (_x, _y + 50), "     Y: " + str (victor.y)
			draw string (_x, _y + 60), "YSPEED: " + str (victor.y_speed)
			
			
			select case victor.action
				case action_climb_facing_left
					action_label = "action_climb_facing_left"
				case action_climb_facing_right
					action_label = "action_climb_facing_right"
				case action_stand_facing_right
					action_label = "action_stand_facing_right"
				case action_stand_facing_left
					action_label = "action_stand_facing_left"
				case action_run_facing_right
					action_label = "action_run_facing_right"
				case action_run_facing_left
					action_label = "action_run_facing_left"
				case action_jump_facing_right
					action_label = "action_jump_facing_right"
				case action_jump_facing_left
					action_label = "action_jump_facing_left"
				case action_fall_facing_right
					action_label = "action_fall_facing_right"
				case action_fall_facing_left
					action_label = "action_fall_facing_left"
			end select
			draw string (_x, _y + 80), "action: " + action_label
			draw string (_x, _y + 90), "dist c: " + str(victor.distance_covered)
			draw string (_x, _y + 100), "frame offset: " + str(victor.sprite_frame_offset)
			draw string (_x, _y + 110), "frame current: " + str(victor.sprite_frame_current)
			draw string (_x, _y + 120), "is_hurt: " + str(victor.is_hurt)
			
			
			'center
			line (_x-2, _y)-step(4,0)
			line (_x, _y-2)-step(0,4)
			
			
	'draw string  (20,20), "UPPER_LEFT " + str (level.visible_bounding_tile(3) ) + " ; " + str (this.visible_bounding_tile(0) )
	'draw string  (20,30), "BOTT RIGHT " + str (level.visible_bounding_tile(2) ) + " ; " + str (this.visible_bounding_tile(1) )
	
			
			
		end if
		
		if this.show_player_collisions then
			_x = victor.x - camera.x_offset
			_y = victor.y - camera.y_offset
			
		
			if victor.collision then
				line (_x -2, _y -2)-step(victor.w+4, victor.h+4), C_RED, BF
			end if
		
			line (_x, _y)-step(victor.w, victor.h), C_ORANGE, BF
			
			for i = 0 to Ubound(level.tiles)
				for j = 0 to (Ubound(level.tiles,2))
						if level.tiles(i,j).collide_flag then
							line (	level.tiles(i,j).x +4 - camera.x_offset, level.tiles(i,j).y +4 - camera.y_offset)-step(TILE_W-8, TILE_H-8), C_YELLOW, BF
						end if
				next j
			next i
			
			if victor.hit_top 		then line (_x, _y)-step(victor.w, -5), C_LILIAC, BF
			if victor.hit_right 	then line (_x +victor.w, _y)-step(5, victor.h), C_LILIAC, BF
			if victor.hit_bottom 	then line (_x +victor.w, _y+victor.h)-step(-victor.w, 5), C_LILIAC, BF
			if victor.hit_left 		then line (_x, _y +victor.h)-step(-5, -victor.h), C_LILIAC, BF

			
			
			
		end if
		
		if this.show_tile_power then
			for i = 0 to Ubound(level.tiles)
				for j = 0 to (Ubound(level.tiles,2))
					_x = level.tiles(i,j).x - camera.x_offset
					_y = level.tiles(i,j).y - camera.y_offset
					draw string (	_x, _y + 20), str(level.tiles(i,j).attributes.power), C_WHITE
					'cross
					line (_x -4, _y   )-step	(8, 0), C_GRAY
					line (_x   , _y -4)-step	(0, 8), C_GRAY
				next j
			next i
		
		end if
		
		if this.show_player_boundings then
			victor.draw_bounding_tiles(TILE_W, TILE_H, camera.x_offset, camera.y_offset)
		end if
		
		if this.show_level_grid then
					
			for i = 0 to Ubound(level.tiles)
				for j = 0 to (Ubound(level.tiles,2))
					_x = level.tiles(i,j).x - camera.x_offset
					_y = level.tiles(i,j).y - camera.y_offset
					'grid
					line (	_x, _y)- step	(TILE_W, TILE_H), C_DARK_GRAY, B, &b111100001111000011110000
					
					draw string (	_x, _y), str(i), C_DARK_GRAY
					draw string (	_x, _y + 10), str(j), C_DARK_GRAY
					'cross
					line (_x -1, _y   )-step	(2, 0), C_GRAY
					line (_x   , _y -1)-step	(0, 2), C_GRAY
				next j
			next i

		end if
		
		if this.show_camera_info then
			draw string (20,170), "camera x        : " + str (camera.x)
			draw string (20,180), "camera y        : " + str (camera.y)
			draw string (20,190), "camera speed    : " + str (camera.speed)
			draw string (20,200), "camera dir      : " + str (camera.direction)
			draw string (20,210), "camera x_offset : " + str (camera.x_offset)
			draw string (20,220), "camera y_offset : " + str (camera.y_offset)
			draw string (20,230), "camera x2_bound : " + str (camera.bound_x2)
			draw string (20,240), "camera y2_bound : " + str (camera.bound_y2)
		end if
		
		if this.show_player_input_info then
			draw string (20, SCR_H - 50), "is_giving_input  : " + str(player_input.is_giving_input)
			draw string (20, SCR_H - 40), "button_a_begin_timer  : " + str(player_input.button_a_begin_timer)
			draw string (20, SCR_H - 30), "jump_power            : " + str(player_input.jump_power)
			draw string (20, SCR_H - 20), "is_button_a_pressed   : " + str(player_input.is_button_a_pressed)
			
			player_input.draw_input(victor.x + victor.w\2 - camera.x_offset, victor.y + victor.h\2 - camera.y_offset)
		end if
		
		if this.show_joystick_info then
			draw string (SCR_W - 200, SCR_H\2 + 20), "JOY ID  : " + str(joystick.get_id())
			draw string (SCR_W - 200, SCR_H\2 + 30), "JOY x   : " + str(joystick.get_x())
			draw string (SCR_W - 200, SCR_H\2 + 40), "JOY y   : " + str(joystick.get_y())
			draw string (SCR_W - 200, SCR_H\2 + 50), "JOY BTN A PRESS: " + str(joystick.pressed(0))
			draw string (SCR_W - 200, SCR_H\2 + 60), "JOY BTN A HOLD : " + str(joystick.hold(0))
			draw string (SCR_W - 200, SCR_H\2 + 70), "JOY BTN A RLSD : " + str(joystick.released(0))
			draw string (SCR_W - 200, SCR_H\2 + 80), "JOY BTN A PRESS: " + str(joystick.pressed(1))
			draw string (SCR_W - 200, SCR_H\2 + 90), "JOY BTN A HOLD : " + str(joystick.hold(1))
			draw string (SCR_W - 200, SCR_H\2 + 100), "JOY BTN A RLSD : " + str(joystick.released(1))
			
			
			
		end if
		
		if this.show_level_info then
			i = 0
			dim temp as item_proto ptr
			dim head as item_proto ptr
			head = level.items
			if head <> NULL then
				while (head <> NULL)
					temp = Head
					head = temp->next_p

					i +=1
				wend

				draw string (20, SCR_H - 20), "ID : " + str(level.items->id)
				
				draw string (SCR_W - 200, SCR_H - 20), "No ITEMS : " + str(i)
				draw string (SCR_W - 200, SCR_H - 30), "Head ITEMS : " + str(hex(level.items))
				draw string (SCR_W - 200, SCR_H - 40), "Tail ITEMS : " + str(hex(temp))
			end if
		end if
		
		if this.show_item_bounds then
			dim temp as item_proto ptr
			dim head as item_proto ptr
			head = level.items
			if head <> NULL then
				while (head <> NULL)
					temp = head
					head = head->next_p
					
					_x = temp->x - camera.x_offset 
					_y = temp->y - camera.y_offset

					'center
					line (_x-2, _y)-step(4,0),C_RED
					line (_x, _y-2)-step(0,4),C_RED
					
					line (_x, _y)-step(temp->w, temp->h), C_WHITE, B
					
				wend
			end if
		
		end if
		
		if this.show_item_info then
			
			
			dim temp as item_proto ptr
			dim head as item_proto ptr
			head = level.items
			if head <> NULL then
				while (head <> NULL)
					temp = head
					head = head->next_p
					
					_x = temp->x - camera.x_offset 
					_y = temp->y - camera.y_offset
					
					draw string (_x , _y + temp->h + 10), "x, y      :" + str(temp->x) + ", "+ str(temp->y)
					draw string (_x , _y + temp->h + 20), "speed     :" + str(temp->speed) 
					draw string (_x , _y + temp->h + 30), "direction :" + str(temp->direction) 
					draw string (_x , _y + temp->h + 40), "sprt_offst:" + str(temp->sprite_offset) 
					draw string (_x , _y + temp->h + 50), "energy:" 	+ str(temp->energy) 
					draw string (_x , _y + temp->h + 60), "is_active:" 	+ str(temp->is_active) 
					draw string (_x , _y + temp->h + 70), "is_reached:" 	+ str(temp->is_reached_by_player) 
					draw string (_x , _y + temp->h + 80), "enemy_type:" 	+ str(temp->enemy_type) 

				

				wend
			end if
			
		end if
		
		
		
		draw_button (SCR_W\2, 20, 150,10, "DEBUG MODE ACTIVE", true)
	
		
	end if
	
	
end sub

