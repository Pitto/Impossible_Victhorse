'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


Type player_proto
	speed 					as single
	max_speed 				as single
	z_speed 				as single
	max_z_speed 			as single
	y_speed 				as single
	direction 				as single
	input_direction 		as single
	acceleration 			as single
	distance_covered 		as single
	sprite_frame_current 	as Ubyte
	sprite_frame_offset		as single
	next_frame_flag as boolean
	
	is_hurt as boolean
	is_hurt_begin_time as double
	
	is_input_enabled as boolean
	input_disabled_time as double
	
	is_searching as boolean
	is_powerup as boolean
	
	x as single		'x position
	y as single		'y position
	z as single		'z position
	w as Ubyte		'width
	h as Ubyte		'height
	x_sight as single
	y_sight as single
	old_x as single 'store x pos
	old_y as single  'store y pos
	old_action as proto_action
	action as proto_action
	collision as boolean
	energy as Long
	lives as Byte
	coins as Ulong
	
	points as Ulong
	
	has_yellow_key as boolean
	has_red_key as boolean
	has_blue_key as boolean
	
	has_reached_exit as boolean
	is_dead as boolean
	is_dead_begin_time as double
	
	game_over as boolean
	
	is_on_ice as boolean
		
	ammo_floppies as Long
	ammo_sys_64738 as Long
	
	redim keywords_list(0 to 0) as keyword_proto
	
	x_sprite as Long
	y_sprite as Long
	
	'bounding tiles: 0: TOP, 1: RIGHT; 2: BOTTOM, 3: LEFT
	bounding_tile (0 to 3) as Ubyte
	
	sprites_player (0 to 41) as FB.Image ptr
	sprites_player_2x (0 to 41) as FB.Image ptr
	
	sprites_player_powerup (0 to 41) as FB.Image ptr
	sprites_player_powerup_2x (0 to 41) as FB.Image ptr
	
	hit_top as boolean
	hit_right as boolean
	hit_bottom as boolean
	hit_left as boolean
	
	respawn_x as Long
	respawn_y as Long

	difficulty_ratio as single
	
	Declare Sub init_position(x as Ulong, y as Ulong)
	Declare Sub init_keywords_list(freebasic_keywords_list() as string)
	Declare Sub draw_player(x as single, y as single, image_buffer as FB.Image ptr)
	Declare Sub draw_bounding_tiles(w as Ulong, h as Ulong, x as single, y as single)
	Declare Sub get_bounding_tiles (w as Ulong, h as Ulong, lr as Ulong, lc as Ulong)
	Declare Sub check_block_collision(level_tiles() as tile_proto, level as level_proto)
	Declare Sub update_player(player_input as user_input, level as level_proto, sound_handler as sound_handler_proto)
	declare sub check_item_collision(item as item_proto ptr, level as level_proto, sound_handler as sound_handler_proto)
	declare sub calc_sprite_frame()
	declare sub death_sequence()
	declare sub reset_player_values()
	declare sub set_all_keywords_as_non_found()
	declare sub set_all_keywords_as_found()
	declare sub empty_key_basket()
	
	declare function get_remaining_keywords_to_find() as Ulong
	
	declare function get_action(is_giving_input as boolean,  is_fire as boolean) as proto_action
	declare function get_player_position() as position_proto
	
	declare function get_a_keyword() as Ulong
	

	Declare Constructor()
	
	Declare Destructor()
End Type



constructor player_proto()
	this.speed = 0 '_PL_MAX_SPEED
	this.max_speed = _PL_MAX_SPEED
	this.z_speed = 0
	this.max_z_speed = 10
	this.direction = 0
	this.input_direction = 0
	this.w = 24
	this.h = 24
	this.x_sprite = this.w\2
	this.y_sprite = this.h\2
	this.acceleration = _PL_ACCELERATION
	this.energy = 100
	this.lives = 3
	this.collision = false
	this.y_speed = 0
	this.coins = 0
	this.is_dead = false
	this.is_hurt = true
	this.is_hurt_begin_time = Timer
	this.game_over = false
	
	this.difficulty_ratio = 1.0
	
	this.ammo_floppies = _PL_FLOPPIES_DEFAULT
	this.ammo_sys_64738 = 0
	
	'useful while climbing walls
	this.is_input_enabled = true
	
	
	load_sprite_sheet 	(this.sprites_player(), 		144, 168, 6, 7,		"img/victor.bmp")
	load_sprite_sheet 	(this.sprites_player_powerup(), 		144, 168, 6, 7,		"img/victor_powerup.bmp")
	
	
	this.next_frame_flag = 0
	this.sprite_frame_current 	= 0
	this.sprite_frame_offset 	= 0
	
	dim i as Ulong
	
	for i = 0 to Ubound(this.sprites_player)
		this.sprites_player_2x(i) = ImageScale (	this.sprites_player(i), _
													this.sprites_player(i)-> width  * 2, _
													this.sprites_player(i)-> height * 2 )
													
		this.sprites_player_powerup_2x(i) = ImageScale (	this.sprites_player_powerup(i), _
													this.sprites_player_powerup(i)-> width  * 2, _
													this.sprites_player_powerup(i)-> height * 2 )
	next i
	
	#include "inc/keywords_list.bi"
	
	this.init_keywords_list(keywords_list())

	

end constructor

destructor player_proto()
	dim i as Ulong
	
	for i = 0 to Ubound (this.sprites_player)
		ImageDestroy this.sprites_player(i)
		ImageDestroy this.sprites_player_2x(i)
		
		ImageDestroy this.sprites_player_powerup(i)
		ImageDestroy this.sprites_player_powerup_2x(i)
	next i
	
end destructor

function player_proto.get_player_position() as position_proto
	dim position as position_proto
	
	position.x = this.x
	position.y = this.y
	
	return position

end function


Sub player_proto.init_keywords_list(freebasic_keywords_list() as string)
	Dim i as Ulong
	
	for i = 0 to Ubound(freebasic_keywords_list)
		redim preserve this.keywords_list(0 to i)
		this.keywords_list(i).id = i
		this.keywords_list(i).label = freebasic_keywords_list(i)
		this.keywords_list(i).is_found = false
	next i
	
end sub

sub player_proto.set_all_keywords_as_non_found()

	for i as ulong = 0 to Ubound(this.keywords_list)
		this.keywords_list(i).is_found = false
	next i
	
end sub

sub player_proto.set_all_keywords_as_found()

	for i as ulong = 0 to Ubound(this.keywords_list)
		this.keywords_list(i).is_found = true
	next i
	
end sub

Sub player_proto.draw_player(x as single, y as single, image_buffer as FB.Image ptr)
	dim as single _x, _y
	_x = this.x - x - this.w + 8
	_y = this.y - y - this.h
	
	if this.is_hurt andalso this.is_dead = false then
		if CUlng(Timer * 10) mod 2 = 0 then
			if this.is_powerup then
				put image_buffer, (_x, _y), this.sprites_player_powerup_2x(this.sprite_frame_current), trans
			else
				put image_buffer, (_x, _y), this.sprites_player_2x(this.sprite_frame_current), trans
			
			end if
		end if
	else
		if this.is_powerup then
			put image_buffer, (_x, _y), this.sprites_player_powerup_2x(this.sprite_frame_current), trans
		else
			put image_buffer, (_x, _y), this.sprites_player_2x(this.sprite_frame_current), trans
		end if
		
	end if
	
End Sub

Sub player_proto.get_bounding_tiles (w as Ulong, h as Ulong, lr as Ulong, lc as Ulong)
	
	this.bounding_tile(0) = this.y \ h 
	this.bounding_tile(1) = (this.x+this.w) \ w 
	this.bounding_tile(3) = this.x \ w 
	this.bounding_tile(2) = (this.y+this.h) \ h 
	
	'bounding check
	if (this.bounding_tile(3) < 0) 		then this.bounding_tile(3)	= 0
	if (this.bounding_tile(3) > lc) 	then this.bounding_tile(3)	= lc
	if (this.bounding_tile(1) < 0) 		then this.bounding_tile(1) 	= 0
	if (this.bounding_tile(1) > lc) 	then this.bounding_tile(1) 	= lc
	if (this.bounding_tile(0) < 0) 		then this.bounding_tile(0) 	= 0
	if (this.bounding_tile(0) > lr) 	then this.bounding_tile(0) 	= lr
	if (this.bounding_tile(2) < 0) 		then this.bounding_tile(2) 	= 0
	if (this.bounding_tile(2) > lr) 	then this.bounding_tile(2)	= lr

end sub

Sub player_proto.check_item_collision (item as item_proto ptr, level as level_proto, sound_handler as sound_handler_proto)
	
	dim i as Long
	
	dim as single xmid, ymid
	
	xmid = this.x + this.w/2
	
	this.is_searching = false
	
	while (item <> NULL)
	
		
	
		select case item-> id
		
			case ITEM_ID_UPDOWN_PLATFORM
			
				if manhattan_distance (this.x, this.y, item->x, item->y) < MIN_DISTANCE_FROM_ITEM_UPDOWN_PLATFORM  then
					'BOTTOM
					'here the height of the item is doubled in order to guaranteee that the player may land safety on it
					if is_point_into_area(	this.x + 4, this.y + this.h, _
											item->x , item->y, _
											item->x + item->w, item->y + item->h) or _
						is_point_into_area(	this.x + this.w - 4, this.y + this.h, _
											item->x , item->y, _
											item->x + item->w, item->y + item->h) then
					
						this.y = item->y - this.h
						'this.y_speed = 0
						this.hit_bottom = true
					end if
				end if
			
			'a SYS 64738 allows the player to check a computer on the fly
			case ITEM_ID_SYS64738
				if not item->delete_me andalso _
					is_collision (	this.x, this.y, this.x + this.w, this.y + this.h, _
									item->x, item->y, item->x + item->w, item->y + item->h)  then
					item->delete_me = true
					
					level.create_floating_label (item->x, item->y, "SYS 64738")
					level.items = level.add_item(@level.items, item->x, item->y, _
												ITEM_COIN_W, ITEM_COIN_H, 0, 0, _
												ITEM_ID_BLINK, "", 0, this.difficulty_ratio)
												
					this.ammo_sys_64738 += 1
					
					sound_handler.set_queued_sound(SFX_SYS64738)

				end if
			
			'if the player catches all the keywords and also reaches the
			'exit location the level is completed
			case ITEM_ID_EXIT_LOCATION
			
				if 	item->is_active andalso _
					is_collision (	this.x, this.y, this.x + this.w, this.y + this.h, _
										item->x, item->y, item->x + item->w, item->y + item->h)  then
					level.is_completed = true
				end if
			
			'player reaches a computer in order to get a keyword
			'the player has to stand without moving in front of the computer
			case ITEM_ID_KEYWORD
			
			if item->is_active then
					if is_collision (	this.x, this.y, this.x + this.w, this.y + this.h, _
										item->x, item->y, item->x + item->w, item->y + item->h)  then
					
					'if the player has a SYSY64738 powerup the search whole pc in a while
					if this.ammo_sys_64738 then
						this.ammo_sys_64738 -=1
						item->energy = 0
					end if
					
					
					if item->energy > 0 and this.speed = 0 then
						item->energy -=1
						item->is_reached_by_player = true
						
						this.is_searching = true
						
						'generate some flying sheet while searching
						if rnd*10 > 9 then level.items = level.add_item(@level.items, item->x, item->y, _
												ITEM_COIN_W, ITEM_COIN_H, _PI/4 + rnd*(_PI_HALF), GRAVITY*3, _
												ITEM_ID_SHEET, "", 0, difficulty_ratio)
						
					end if
					if item->energy <= 0 then
						'finds a keyword
						
						i = this.get_a_keyword()
						if i >= 0 then
							this.keywords_list(i).is_found = true
							level.keyword_to_find -= 1
							level.create_floating_label (item->x - len("found")*4, item->y-16, "found")
							level.create_floating_label (item->x - len(keywords_list(i).label)*4, item->y, this.keywords_list(i).label)
					
						end if
						item->is_active = false
						
						
						
						sound_handler.set_queued_sound(SFX_KEYWORD_BONUS)
						
					end if
				else
					item->is_reached_by_player = false
				end if
			end if
			
			
			'player reaches a key (yellow, red or blue)
			'
			case ITEM_ID_KEY_YELLOW to ITEM_ID_KEY_BLUE
				if not item->delete_me andalso _
					is_collision (	this.x, this.y, this.x + this.w, this.y + this.h, _
									item->x, item->y, item->x + item->w, item->y + item->h)  then
					
					level.create_floating_label (item->x, item->y, "KEY REACHED")
					level.items = level.add_item(@level.items, item->x, item->y, _
												ITEM_COIN_W, ITEM_COIN_H, 0, 0, _
												ITEM_ID_BLINK, "", 0, this.difficulty_ratio)
												
					sound_handler.set_queued_sound(SFX_KEY_BONUS)
				
					
					item->is_reached_by_player = true
					item->delete_me = true
					
					'collect the keys only if there aren't yet in the inventory
					select case item->id
						case ITEM_ID_KEY_YELLOW
							this.has_yellow_key = true					
						case ITEM_ID_KEY_RED
							this.has_red_key = true
						case ITEM_ID_KEY_BLUE
							this.has_blue_key = true
					end select
				else
					item->is_reached_by_player = false
				end if
			
			'player reaches a medpack
			case ITEM_ID_MEDPACK
			if not item->delete_me andalso _
				is_collision (	this.x, this.y, this.x + this.w, this.y + this.h, _
								item->x, item->y, item->x + item->w, item->y + item->h)  then
				
				level.create_floating_label (item->x, item->y, "MEDPACK")
				level.items = level.add_item(@level.items, item->x, item->y, _
											ITEM_COIN_W, ITEM_COIN_H, 0, 0, _
											ITEM_ID_BLINK, "", 0, this.difficulty_ratio)
												
				item->is_reached_by_player = true
				item->delete_me = true
	
				this.energy += ITEM_MEDPACK_ENERGY_POWERUP
				sound_handler.set_queued_sound(SFX_MEDPACK_BONUS)
				
			end if
		
			case ITEM_ID_POWER_UP
			'doesnt catches the powerup if is alreay powerup
			if 	not this.is_powerup andalso not item->delete_me andalso _
				is_collision (	this.x, this.y, this.x + this.w, this.y + this.h, _
								item->x, item->y, item->x + item->w, item->y + item->h) then
				
				
				
				level.create_floating_label (item->x, item->y, "POWERUP")
				
				'create a mega blink
				level.items = level.add_item(@level.items, item->x-16, item->y-16, _
												64, 64, 0, 0, _
												ITEM_ID_MEGA_BLINK, "", 0, this.difficulty_ratio)

				item->delete_me = true
				this.is_powerup = true
				this.energy = PLAYER_MAX_ENERGY
				
				sound_handler.set_queued_sound(SFX_PLAYER_POWERUP)	
						
			end if
			
			case ITEM_ID_1UP
			if 	not item->delete_me andalso _
				is_collision (	this.x, this.y, this.x + this.w, this.y + this.h, _
								item->x, item->y, item->x + item->w, item->y + item->h) then
				
				
				
				level.create_floating_label (item->x, item->y, "+ " + "1 UP")
				level.items = level.add_item(@level.items, item->x, item->y, _
												ITEM_COIN_W, ITEM_COIN_H, 0, 0, _
												ITEM_ID_BLINK, "", 0, this.difficulty_ratio)

				item->delete_me = true
				this.lives += 1
						
			end if
			
			'player reaches a coin
			case ITEM_ID_COIN
			if not item->delete_me andalso _
				is_collision (	this.x, this.y, this.x + this.w, this.y + this.h, _
								item->x, item->y, item->x + item->w, item->y + item->h)  then
				
				
				'some blinking
				level.items = level.add_item(@level.items, item->x, item->y, _
											ITEM_COIN_W, ITEM_COIN_H, 0, 0, _
											ITEM_ID_BLINK, "", 0, this.difficulty_ratio)
												

				
				item->is_reached_by_player = true
				item->delete_me = true

				this.coins += 1
				this.points += PLAYER_POINTS_COIN * this.difficulty_ratio 
				
				'check if the player collect 100 coins, in that cas he gets 1 UP
				if this.coins > 99 then
				
					this.coins =  0
					this.lives += 1
					
					level.create_floating_label (this.x, this.y, "+ " + "1 UP")
					
				else
				
					sound_handler.set_queued_sound(SFX_COIN_BONUS)
				
				end if
				
			end if
			'player reaches a floppy power up
			case ITEM_ID_AMMO_FLOPPY
			if not item->delete_me andalso _
				is_collision (	this.x, this.y, this.x + this.w, this.y + this.h, _
								item->x, item->y, item->x + item->w, item->y + item->h)  then
			
				level.create_floating_label (item->x, item->y, "+ " + str(AMMO_FLOPPY_POWER_UP *  this.difficulty_ratio) + " FLOPPIES")
				
				item->is_reached_by_player = true
				item->delete_me = true
				this.ammo_floppies += AMMO_FLOPPY_POWER_UP *  this.difficulty_ratio
				
				sound_handler.set_queued_sound(SFX_FLOPPY_BONUS)
				
			end if
			
			case ITEM_ID_CANNON_BULLET
				if not item->delete_me andalso _
					is_collision (	this.x, this.y, this.x + this.w, this.y + this.h, _
									item->x, item->y, item->x + item->w, item->y + item->h) and _
					this.is_hurt = false then
						this.is_hurt = true
						this.is_hurt_begin_time = Timer
						this.energy -= ITEM_ID_CANNON_BULLET_DAMAGE * this.difficulty_ratio 
						this.is_powerup = false
						
						item->delete_me = true
						
						sound_handler.set_queued_sound(SFX_PLAYER_HURT)
					
				end if
			
			
			case ITEM_ID_ENEMY_BULLET_0
				if not item->delete_me andalso _
					is_collision (	this.x, this.y, this.x + this.w, this.y + this.h, _
									item->x, item->y, item->x + item->w, item->y + item->h) and _
					this.is_hurt = false then
						this.is_hurt = true
						this.is_hurt_begin_time = Timer
						this.energy -= ITEM_ID_ENEMY_BULLET_0_DAMAGE *  this.difficulty_ratio
						this.is_powerup = false
						
						item->delete_me = true
						
						sound_handler.set_queued_sound(SFX_PLAYER_HURT)
					
				end if
			
			case ITEM_ID_BALLISTIC_ENEMY_BULLET
				if not item->delete_me andalso _
					is_collision (	this.x, this.y, this.x + this.w, this.y + this.h, _
									item->x, item->y, item->x + item->w, item->y + item->h) and _
					this.is_hurt = false then
						this.is_hurt = true
						this.is_hurt_begin_time = Timer
						this.energy -= ITEM_ID_BALLISTIC_ENEMY_BULLET_DAMAGE * this.difficulty_ratio
						this.is_powerup = false
						
						item->delete_me = true
						
						sound_handler.set_queued_sound(SFX_PLAYER_HURT)
				end if
				
			case ITEM_ID_FLYING_BOMB
				if not item->delete_me andalso _
					is_collision (	this.x, this.y, this.x + this.w, this.y + this.h, _
									item->x, item->y, item->x + item->w, item->y + item->h) and _
					this.is_hurt = false then
						this.is_hurt = true
						this.is_hurt_begin_time = Timer
						this.energy -= ITEM_ID_FLYING_BOMB_DAMAGE * this.difficulty_ratio 
						item->delete_me = true
						this.is_powerup = false
						
						sound_handler.set_queued_sound(SFX_PLAYER_HURT)
					
				end if
				
			case ITEM_ID_MISSILE
				if not item->delete_me andalso _
					is_collision (	this.x, this.y, this.x + this.w, this.y + this.h, _
									item->x, item->y, item->x + item->w, item->y + item->h) then
					if 	this.is_hurt = false then
						this.is_hurt = true
						this.is_hurt_begin_time = Timer
						this.energy -= ITEM_ID_MISSILE_DAMAGE * this.difficulty_ratio
						this.is_powerup = false
						
						item->delete_me = true
						
						sound_handler.set_queued_sound(SFX_PLAYER_HURT)
						
					else
						item->delete_me = true
					end if
					
				end if
			
			'collision with an enemy
			case ITEM_ID_ENEMY
				if is_collision (	this.x, this.y, this.x + this.w, this.y + this.h, _
									item->x, item->y, item->x + item->w, item->y + item->h) and _
				this.is_hurt = false then
					this.is_hurt = true
					this.is_hurt_begin_time = Timer
					this.is_powerup = false
					
					select case item->enemy_type
						case ENEMY_TYPE_GREEN_ROBOT
							this.energy -= ENEMY_TYPE_GREEN_ROBOT_DAMAGE *  this.difficulty_ratio 
						case ENEMY_TYPE_BLACK_BALL
							this.energy -= ENEMY_TYPE_BLACK_BALL_DAMAGE * this.difficulty_ratio 
						case ENEMY_TYPE_GREEN_GUY
							this.energy -= ENEMY_TYPE_GREEN_GUY_DAMAGE * this.difficulty_ratio 
						case ENEMY_TYPE_EYEGLASS_GUY
							this.energy -= ENEMY_TYPE_EYEGLASS_GUY_DAMAGE * this.difficulty_ratio 
						case ENEMY_TYPE_FLYING_ROBOT
							this.energy -= ENEMY_TYPE_FLYING_ROBOT_DAMAGE * this.difficulty_ratio 
						case ENEMY_TYPE_FLOOR_SPIDER
							this.energy -= ENEMY_TYPE_FLOOR_SPIDER_DAMAGE * this.difficulty_ratio 
						case ENEMY_TYPE_PROGRAMMER
							this.energy -= ENEMY_TYPE_PROGRAMMER_DAMAGE * this.difficulty_ratio 
						case ENEMY_TYPE_CHARLES_BRONSON
							this.energy -= ENEMY_TYPE_CHARLES_BRONSON_DAMAGE * this.difficulty_ratio 
						case ENEMY_TYPE_JASC
							this.energy -= ENEMY_TYPE_JASC_DAMAGE
						case else
							this.energy -= 10
						
					end select
					
					sound_handler.set_queued_sound(SFX_PLAYER_HURT)
					
					
				end if
			
			
		
		end select
		item = item->next_p
	wend
	
end sub

Sub player_proto.check_block_collision (level_tiles() as tile_proto, level as level_proto)
	
	dim as Ulong i, j, row, col
	this.hit_top = false
	this.hit_right = false
	this.hit_bottom = false
	this.hit_left = false
	
	dim as single xmid, ymid
	
	xmid = this.x + this.w/2
	ymid = this.y + this.h/2
	
	
	this.collision = false
	
	this.get_bounding_tiles(TILE_W, TILE_H, Ubound(level_tiles), Ubound(level_tiles, 2))

	'reset the status of collide_flag
	for i = 0 to Ubound(level_tiles)
		for j = 0 to (Ubound(level_tiles,2))
			level_tiles(i, j).collide_flag = false
		next j
	next i


	for j = this.bounding_tile(3) to this.bounding_tile(1)
		for i = this.bounding_tile(0)  to this.bounding_tile(2)
			
			'SOLID BLOCKS
			if level_tiles(i, j).attributes.tile_type = 1 and level_tiles(i, j).attributes.id <> block_null then
			
			
				select case level_tiles(i, j).attributes.id
				
					'ice block
					case block_ice
						'BOTTOM
						if is_point_into_area(xmid, this.y + this.h, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
							this.hit_bottom = true
							this.y = i * TILE_H - this.h
							level_tiles(i, j).collide_flag = true
							this.is_on_ice = true
						else
							this.is_on_ice = false
						end if
				
					'DOOR YELLOW KEY____________________________________
					case block_door_yellow_key
						'right
						if is_point_into_area(this.x + this.w, ymid, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
							select case this.has_yellow_key
								'remove the door
								case true
									this.has_yellow_key =false
									level_tiles(i, j).collide_flag = true
									level_tiles(i, j).attributes.tile_type = 0
									level_tiles(i, j).attributes.id = 0
								case false
									this.x = j * TILE_W - this.w - 1
									level_tiles(i, j).collide_flag = true
							end select
						end if
						'left
						if is_point_into_area(this.x, ymid, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
							select case this.has_yellow_key
								'remove the door
								case true
									this.has_yellow_key =false
									level_tiles(i, j).collide_flag = true
									level_tiles(i, j).attributes.tile_type = 0
									level_tiles(i, j).attributes.id = 0
								case false
									this.x = (j+1) * TILE_W
									level_tiles(i, j).collide_flag = true
							end select
						end if
					'DOOR RED KEY____________________________________
					case block_door_red_key
						'right
						if is_point_into_area(this.x + this.w, ymid, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
							select case this.has_red_key
								'remove the door
								case true
									this.has_red_key =false
									level_tiles(i, j).collide_flag = true
									level_tiles(i, j).attributes.tile_type = 0
									level_tiles(i, j).attributes.id = 0
								case false
									this.x = j * TILE_W - this.w - 1
									level_tiles(i, j).collide_flag = true
							end select
						end if
						'left
						if is_point_into_area(this.x, ymid, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
							select case this.has_red_key
								'remove the door
								case true
									this.has_red_key =false
									level_tiles(i, j).collide_flag = true
									level_tiles(i, j).attributes.tile_type = 0
									level_tiles(i, j).attributes.id = 0
								case false
									this.x = (j+1) * TILE_W
									level_tiles(i, j).collide_flag = true
							end select
						end if
					'DOOR BLUE KEY____________________________________
					case block_door_blue_key
						'right
						if is_point_into_area(this.x + this.w, ymid, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
							select case this.has_blue_key
								'remove the door
								case true
									this.has_blue_key =false
									level_tiles(i, j).collide_flag = true
									level_tiles(i, j).attributes.tile_type = 0
									level_tiles(i, j).attributes.id = 0
								case false
									this.x = j * TILE_W - this.w - 1
									level_tiles(i, j).collide_flag = true
							end select
						end if
						'left
						if is_point_into_area(this.x, ymid, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
							select case this.has_blue_key
								'remove the door
								case true
									this.has_blue_key =false
									level_tiles(i, j).collide_flag = true
									level_tiles(i, j).attributes.tile_type = 0
									level_tiles(i, j).attributes.id = 0
								case false
									this.x = (j+1) * TILE_W
									level_tiles(i, j).collide_flag = true
							end select
						end if
						
				
					case block_horizontal_moving
						'some stuff :)
					
					case block_roll_chemical_poison
						'BOTTOM
						if is_point_into_area(xmid, this.y + this.h, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
							this.hit_bottom = true
							this.y = i * TILE_H - this.h
							this.y_speed = _PL_Y_SPEED_REJECTION
							level_tiles(i, j).collide_flag = true
							if this.is_hurt = false then
								this.is_hurt = true
								this.is_hurt_begin_time = Timer
								this.energy -= CHEMICAL_POISON_DAMAGE
							end if
							
						end if
					case block_spikes_bottom
						'BOTTOM
						if is_point_into_area(xmid, this.y + this.h, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
							this.hit_bottom = true
							this.y = i * TILE_H - this.h
							this.y_speed = _PL_Y_SPEED_REJECTION
							level_tiles(i, j).collide_flag = true
							if this.is_hurt = false then
								this.is_hurt = true
								this.is_hurt_begin_time = Timer
								this.is_powerup = false
								this.energy -= _PL_SPIKES_DAMAGE * this.difficulty_ratio
							end if
							
						end if
					
					
					case block_semi_block
						'BOTTOM
						if is_point_into_area	(xmid, this.y + this.h, j * TILE_W, _
												i*TILE_H, j * TILE_W+TILE_W, _
												i*TILE_H + _BLOCK_SEMI_BLOCK_HEIGHT) then
							'andalso Cbool(this.action <> action_jump_facing_right) _
							'andalso Cbool(this.action <> action_jump_facing_left) then				
								this.hit_bottom = true
								this.y = i * TILE_H - this.h
								this.y_speed = 0
								level_tiles(i, j).collide_flag = true
						end if
						
					case block_evanescence
						'BOTTOM
						if is_point_into_area(xmid, this.y + this.h, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H + _BLOCK_SEMI_BLOCK_HEIGHT) then
							this.hit_bottom = true
							this.y = i * TILE_H - this.h
							this.y_speed = 0
							level_tiles(i, j).collide_flag = true
							if level_tiles(i,j).attributes.power - BLOCK_EVANESCENCE_RATIO > 0 then
								level_tiles(i,j).attributes.power -= BLOCK_EVANESCENCE_RATIO
							else
								level_tiles(i, j).attributes.id = 0
								level_tiles(i, j).attributes.power = 0
							end if
							
						end if
						
					case block_roll_clockwise
						'bottom
						if is_point_into_area(xmid, this.y + this.h, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
						this.hit_bottom = true
						this.y = i * TILE_H - this.h
						this.x += BLOCK_ROLL_SPEED
						level_tiles(i, j).collide_flag = true
						end if
						
					case block_roll_counterclockwise
						'bottom
						if is_point_into_area(xmid, this.y + this.h, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
						this.hit_bottom = true
						this.y = i * TILE_H - this.h
						this.x -= BLOCK_ROLL_SPEED
						level_tiles(i, j).collide_flag = true
						end if
					
					
					
					case else
					'check wich side collide with the tile
					'top
					if is_point_into_area(xmid, this.y, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
						this.hit_top = true
						this.y_speed = 0
						this.y = i * TILE_H + TILE_H + 1
						'important! or the playe will move along the x axis if hit the top with too energy
						ymid = this.y + this.h/2
						level_tiles(i, j).collide_flag = true
						
						'if hits the block floppy dispenser the player has one more floppy
						if level_tiles(i, j).attributes.id = block_floppy_dispenser then
							this.ammo_floppies +=1
							level.items = level.add_item(@level.items, j * TILE_W + TILE_W\2, i*TILE_H + TILE_H\2, _
												ITEM_COIN_W, ITEM_COIN_H, 0, 0, _
												ITEM_ID_BLINK, "", 0, this.difficulty_ratio)
							level.items = level.add_item(@level.items, j * TILE_W + TILE_W\2, i*TILE_H + TILE_H\2, _
												ITEM_COIN_W, ITEM_COIN_H, _PI_HALF, GRAVITY*2, _
												ITEM_ID_AMMO_FLOPPY_FROM_DISPENSER, "", 0, this.difficulty_ratio)
						end if
						
					end if
					'BOTTOM
					'before the order was top/right/bottom/left
					if is_point_into_area(xmid, this.y + this.h, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
						this.hit_bottom = true
						this.y = i * TILE_H - this.h
						level_tiles(i, j).collide_flag = true
						
						'store the respawn location
						if level_tiles(i, j).attributes.id = block_top then
							this.respawn_x = this.x
							this.respawn_y = this.y
						
						end if
						
					end if
					
					'RIGHT
					if is_point_into_area(this.x + this.w, ymid, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
						this.hit_right = true
						this.x = j * TILE_W - this.w - 1
						level_tiles(i, j).collide_flag = true
					end if
					
					'LEFT
					if is_point_into_area(this.x, ymid, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
						this.hit_left = true
						this.x = (j+1) * TILE_W 
						level_tiles(i, j).collide_flag = true
					end if
					
				
					
					
				
				end select
				
				if this.hit_top or this.hit_right or this.hit_bottom or this.hit_left then
						this.collision = true
					else
						this.collision = false
				end if

			end if
			
		next i
	next j
	

	
end sub

Sub player_proto.draw_bounding_tiles(w as Ulong, h as Ulong, x as single, y as single)
	
	
	line (this.bounding_tile(3)* w -x , this.bounding_tile(0)*h - y)-_
	step(w+(this.bounding_tile(1)-this.bounding_tile(3))*w,_
	h+(this.bounding_tile(2)-this.bounding_tile(0))*h), C_CYAN, B

	draw string (20,20), str(this.bounding_tile(3)) + ";" + str(this.bounding_tile(0)) + ";" + str(this.bounding_tile(1)) + ";" + str(this.bounding_tile(2))

end sub

Sub player_proto.init_position(x as Ulong, y as Ulong)
	this.x = x
	this.y = y
	this.respawn_x = x
	this.respawn_y = y
	this.has_reached_exit = false
End Sub

sub player_proto.death_sequence()
	this.is_dead = true
	this.is_dead_begin_time = Timer
	this.lives -= 1
	if this.lives <= 0 then
		this.lives = 0
		this.game_over = true
	end if
	this.reset_player_values()
end sub

sub player_proto.reset_player_values()

	this.speed = 0 
	this.z_speed = 0
	this.max_z_speed = 10
	this.direction = 0
	this.input_direction = 0
	this.energy = 100
	this.collision = false
	this.y_speed = 0
	this.is_hurt = true
	this.is_hurt_begin_time = Timer
	if this.ammo_floppies < _PL_FLOPPIES_DEFAULT then this.ammo_floppies = _PL_FLOPPIES_DEFAULT
	this.is_powerup = false

end sub

Sub player_proto.update_player(player_input as user_input, level as level_proto, sound_handler as sound_handler_proto)
	
	'if the timer is over the player losses a life 
	if level.get_time_left() <= 0 then
		level.create_floating_label (this.x - len("OUT OF TIME!")*8, this.y-16, "OUT OF TIME!")
		this.death_sequence()
		
		'reset the time
		level.set_time_left (level.time_to_complete)
	end if
	
	'if the energy is <= 0 then the player losses a life
	if this.energy <= 0 then
		level.create_floating_label (this.x - len("OUCH!")*8, this.y-16, "OUCH!")
		
		this.death_sequence()
		
		'reset the time
		level.set_time_left (level.time_to_complete)
	end if
	
	'if the player dies, restore to level init position	
	if 	this.is_dead andalso this.game_over = false andalso _
		CBool(Timer - this.is_dead_begin_time > PLAYER_HURT_DEATH_DURATION) then
		
		this.is_dead = false
		this.is_hurt = true
		this.is_hurt_begin_time = Timer
		this.init_position(this.respawn_x, this.respawn_y)
		player_input.is_jump = false
		
		
	
	end if
	
	if this.is_dead = false then
	
		if timer - this.input_disabled_time > 0.5 then
			this.is_input_enabled = true
		end if
		
		if this.is_hurt and CBool(Timer - this.is_hurt_begin_time > PLAYER_HURT_STATE_DURATION) then
			this.is_hurt = false
		end if
		
		if player_input.is_giving_input and this.is_input_enabled then
			this.speed = abs(player_input.x_trigger) * _PL_MAX_SPEED
			this.direction = _abtp(0,0, player_input.x_trigger, 0) ' player_input.direction
		end if
	
	
		'while climbing, jump on the other side
		if CBool(this.action = action_climb_facing_left) and player_input.is_jump then
			player_input.is_jump = false
			this.action = action_jump_facing_right
			
			this.direction = 0
			this.speed = _PL_MAX_SPEED
			this.y_speed = _PL_Y_SPEED_MAX
			this.is_input_enabled = false
			this.input_disabled_time = Timer
			
			level.items = level.add_item(@level.items, this.x, this.y, ITEM_LITTLE_W, ITEM_LITTLE_H, 0, 0, ITEM_ID_CLOUD, "", 0, this.difficulty_ratio)
			
			sound_handler.set_queued_sound(SFX_PLAYER_CLIMB_JUMP)
			
		end if
	
		if CBool(this.action = action_climb_facing_right) and player_input.is_jump then
			player_input.is_jump = false
			this.action = action_jump_facing_left
			
			this.direction = _PI
			this.speed = _PL_MAX_SPEED
			this.y_speed = _PL_Y_SPEED_MAX
			this.is_input_enabled = false
			this.input_disabled_time = Timer
			
			level.items = level.add_item(@level.items, this.x, this.y, ITEM_LITTLE_W, ITEM_LITTLE_H, 0, 0, ITEM_ID_CLOUD, "", 0, this.difficulty_ratio)
		
			sound_handler.set_queued_sound(SFX_PLAYER_CLIMB_JUMP)
		
		end if
		
		if not this.hit_bottom and player_input.is_jump then
			player_input.is_jump = false
		end if
		
		if this.hit_bottom and player_input.is_jump then
			player_input.is_jump = false
			this.y_speed = cos (1-player_input.jump_power) * _PL_Y_SPEED_MAX
			
			sound_handler.set_queued_sound(SFX_PLAYER_JUMP)
		end if
		
		if player_input.is_fire then
			'player_input.is_fire = false
			
			
			
			if this.ammo_floppies > 0 then
			
			
			
				if this.is_powerup then
					
					
					
					if player_input.is_giving_input then
						'precise direction launch - only with joystick
						level.items = level.add_item	(@level.items, this.x, this.y - 20, _
														ITEM_LITTLE_W, ITEM_LITTLE_H, _
														_abtp (0,0,player_input.get_x(), player_input.get_y()),_
														10 + this.speed, ITEM_ID_PLAYER_BULLET_DIRECTIONAL, "", 0, _
														this.difficulty_ratio)

					else
						'simply directional launch
						level.items = level.add_item(	@level.items, this.x, this.y - 20, ITEM_LITTLE_W, ITEM_LITTLE_H, _
														this.direction, 10 + this.speed, ITEM_ID_PLAYER_BULLET_DIRECTIONAL, "", 0, _
														this.difficulty_ratio)
					end if
					
					sound_handler.set_queued_sound(SFX_BALLISTIC_FLOPPY_LAUNCH)
					
				else
					'ballistic launch
					level.items = level.add_item(	@level.items, this.x, this.y - 20, ITEM_LITTLE_W, ITEM_LITTLE_H, _
													_abtp (-_PI_HALF, 0,this.direction,-_PI_HALF), 20 + this.speed, _
													ITEM_ID_PLAYER_BULLET, "", 0, this.difficulty_ratio)
				
					sound_handler.set_queued_sound(SFX_DIRECTIONAL_FLOPPY_LAUNCH)
				
				end if
				this.ammo_floppies-=1
				
			else
			
			sound_handler.set_queued_sound(SFX_FLOPPY_EMPTY)
			
			end if
			
			
			
		end if
	
		'max speed value check
		if this.speed > this.max_speed then this.speed  = this.max_speed

		this.x += cos(this.direction) * this.speed

		this.y -= this.y_speed
		
		this.speed *= 0.85

		this.y_speed *= 0.85
		
		'minimum values
		if this.speed < 0.1 then this.speed = 0
		if this.y_speed < 0.1 then this.y_speed = 0
		
		this.y += GRAVITY

		
		this.action = this.get_action(player_input.is_giving_input, player_input.is_fire)
		this.calc_sprite_frame()
		
		'store old values___________________________________________________
		this.old_x = this.x
		this.old_y = this.y
		
		
		this.old_action = this.action
		
		this.x_sight = this.x + PLAYER_SIGHT_DISTANCE * cos(this.direction)
		if this.action = action_fall_facing_right or this.action = action_fall_facing_right then
			this.y_sight = this.y + PLAYER_SIGHT_DISTANCE * (player_input.get_y()) + PLAYER_SIGHT_Y_OFFSET
		else
			this.y_sight = this.y + PLAYER_SIGHT_DISTANCE * (player_input.get_y()) - PLAYER_SIGHT_Y_OFFSET
		end if
		
		'DEBUG
		
		if this.energy < 0 then this.energy = 0
		
		
		if this.energy > PLAYER_MAX_ENERGY then this.energy = PLAYER_MAX_ENERGY
		
		if (this.ammo_floppies + 1) > 256 then this.ammo_floppies = 255
	
		'important
		if player_input.is_fire then player_input.is_fire = false
		
	else
	
		this.action = action_death
		this.calc_sprite_frame()
		
	end if
	
	
End Sub

function player_proto.get_a_keyword () as Ulong

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

function player_proto.get_remaining_keywords_to_find() as Ulong
	
	dim c as Ulong = 0
	
	for i as ulong = 0 to Ubound(this.keywords_list)
		if not this.keywords_list(i).is_found then
			c +=1
		end if
	next i
	
	return c

end function


function player_proto.get_action (is_giving_input as boolean, is_fire as boolean) as proto_action

	'recognize if the player is firing
	if 	is_fire andalso _
		CBool(abs(this.direction) > 0)  then
		return action_launch_facing_left
	end if
	
	'recognize if the player is firing
	if 	is_fire andalso _
		CBool(abs(this.direction) = 0)  then
		return action_launch_facing_right
	end if
	
	if this.is_searching andalso CBool(this.speed = 0) then
		return action_searching
	end if
	

	'recognize if the player is climbing a wall
	if 	this.hit_left and not this.hit_bottom and _
		CBool(abs(this.direction) > 0) and is_giving_input and _
		Cbool(this.y_speed < _PL_Y_SPEED_CLIMB) then
		return action_climb_facing_left
	end if
	
	if this.hit_right and not this.hit_bottom and _
		CBool(abs(this.direction) = 0) and is_giving_input and _
		CBool(this.y_speed < _PL_Y_SPEED_CLIMB) then
		return action_climb_facing_right
	end if	
		
	'recognize if the player is jumping
	if not this.hit_bottom and Cbool(this.y_speed > GRAVITY) then
		if abs(this.direction) = 0 then
			return action_jump_facing_right
		else
			return action_jump_facing_left
		end if
	end if
	
	'recognize if the player is falling
	if not this.hit_bottom and Cbool(this.y_speed < 0.5) then
		if abs(this.direction) = 0 then
			return action_fall_facing_right
		else
			return action_fall_facing_left
		end if
	end if
	
	'recognize if the player is running
	if this.hit_bottom and Cbool(this.speed > 0 ) then
		if abs(this.direction) = 0 then
			return action_run_facing_right
		else
			return action_run_facing_left
		end if
	end if
	
	'recognize if the player is standing
	if this.hit_bottom and Cbool(this.speed = 0 ) then
		if abs(this.direction) = 0 then
			return action_stand_facing_right
		else
			return action_stand_facing_left
		end if
	end if
	
	'case else
	return this.old_action


end function


sub player_proto.empty_key_basket()
	
	this.has_blue_key = false
	this.has_red_key = false
	this.has_yellow_key = false

end sub

sub player_proto.calc_sprite_frame()
	this.distance_covered += distance (this.x, this.y, this.old_x, this.old_y)
	
	if this.distance_covered > PLAYER_DISTANCE_FOR_FRAME_STEP then
		this.next_frame_flag 	= true
		this.distance_covered 	= 0
	end if
	
	if this.old_action <> this.action then this.sprite_frame_offset = 0
	
	if this.action = action_death then
		this.sprite_frame_current = this.action + Culng(Timer*10) mod 4
	elseif this.action = action_stand_facing_right then
		this.sprite_frame_current = this.action
	elseif this.action = action_stand_facing_left then
		this.sprite_frame_current = this.action
	elseif this.action = action_climb_facing_left then
		this.sprite_frame_current = this.action
	elseif this.action = action_climb_facing_left then
		this.sprite_frame_current = this.action
	elseif this.action = action_launch_facing_right then
		this.sprite_frame_current = this.action
	elseif this.action = action_launch_facing_left then
		this.sprite_frame_current = this.action
	elseif this.action = action_searching then
		this.sprite_frame_current = this.action
	else
	
	
	
		if this.next_frame_flag then
			this.sprite_frame_current = this.action
			this.next_frame_flag = false
			select case this.action
			
				case action_run_facing_right
					this.sprite_frame_offset +=1
					if this.sprite_frame_offset > 4 then this.sprite_frame_offset = 0
						
				case action_run_facing_left
					this.sprite_frame_offset +=1
					if this.sprite_frame_offset > 4 then this.sprite_frame_offset = 0
					
				case action_jump_facing_left
					this.sprite_frame_offset +=0.25
					if this.sprite_frame_offset > 4 then this.sprite_frame_offset = 4
				
				case action_jump_facing_right
					this.sprite_frame_offset +=0.25
					if this.sprite_frame_offset > 4 then this.sprite_frame_offset = 4
					
				case action_fall_facing_left
					this.sprite_frame_offset +=0.25
					if this.sprite_frame_offset > 4 then this.sprite_frame_offset = 4
				
				case action_fall_facing_right
					this.sprite_frame_offset +=0.25
					if this.sprite_frame_offset > 4 then this.sprite_frame_offset = 4
					

				
			end select
			this.sprite_frame_current += int(this.sprite_frame_offset)
		end if
	end if
	
end sub


