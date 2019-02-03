'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


Type item_proto

	id as Ulong
	
	enemy_type as Ulong
	
	is_active as boolean
	is_reached_by_player as boolean
	delete_me as boolean
	
	dist as Ulong
	
	sprite_offset as Ubyte
	
	w as Ubyte
	h as Ubyte
	
	x as single
	y as single
	
	x_sprite as Long
	y_sprite as Long
	
	speed as single
	speed_default as single
	direction as single
	energy as Long
	
	initialization_time as double
	
	is_hurt_begin_time as double
	is_hurt as boolean
	
	tick_count as Ulong
	
	label as string*32
	
	'bounding tiles: 0: TOP, 1: RIGHT; 2: BOTTOM, 3: LEFT
	bounding_tile (0 to 3) as Ubyte
	
	next_p as item_proto ptr
	
	declare sub draw_item(x as single, y as single, image as FB.Image ptr, image_buffer as FB.Image ptr)
	declare sub initialize_item	(x as Ulong, y as Ulong, w as Ulong, h as Ulong, d as single, _
									s as single, id as Ulong, label as string, other as Ubyte, _
									difficulty_ratio as single)
	declare Sub get_bounding_tiles (w as Ulong, h as Ulong, lr as Ulong, lc as Ulong)
	
	declare function angle_to_sprite_frame() as Ulong
	declare function get_diff_angle(alfa as single, beta as single) as single
	
	
	
	Declare Constructor()
	'Declare Destructor()
End Type

Constructor item_proto()
	'some stuff

	
end constructor

function item_proto.get_diff_angle(alfa as single, beta as single) as single
    if alfa <> beta  then
        return _abtp(0,0,cos(alfa-beta),-sin(alfa-beta))
	else
		return 0
	end if
end function


function item_proto.angle_to_sprite_frame() as Ulong
    dim degree as Short
    
    'convert radiants to 360° degree
    degree = (180-int(this.direction*180/_PI))
    if degree > 360 or degree < 0 then degree = 0 + degree mod 360
    select case degree
		case 0 to 22
			return 4
		case 23 to 67
			return 3'tr
		case 68 to 112
			return 2
		case 113 to 157
			return 1
		case 158 to 202
			return 0
		case 203 to 247
			return 7'bL
		case 248 to 292
			return 6
		case 292 to 337
			return 5
		case 337 to 359
			return 4
		case else
			return 0
    end select
end function




sub item_proto.draw_item(x as single, y as single, image as FB.Image ptr, image_buffer as FB.Image ptr)
	put image_buffer, (	this.x - x , this.y - y ), image, trans
	#IFDEF DEBUG_MODE
		
	#ENDIF

end sub

sub item_proto.initialize_item	(x as Ulong, y as Ulong, w as Ulong, h as Ulong, _
								d as single, s as single, id as Ulong, label as string, _
								other as Ubyte, difficulty_ratio as single)
	this.id = id
	this.direction = d
	this.speed = s

	
	this.x = x
	this.y = y
	this.w = w
	this.h = h
	
	this.label = label
	
	this.initialization_time = Timer
	this.tick_count = 0 
	
	this.x_sprite = this.w\2
	this.y_sprite = this.h\2
	
	this.is_active = true
	this.is_reached_by_player = false
	this.delete_me = false
	
	select case id
	
		case ITEM_ID_CANNON_BOTTOM_TOP
		
			this.initialization_time += (rnd*1.5)
	
		case ITEM_ID_ENEMY_BULLET_0
			this.sprite_offset = int(rnd * 3)
			
		case ITEM_ID_SYS64738
			this.sprite_offset = int(rnd * 7)

	
		case ITEM_ID_KEYWORD
			this.sprite_offset = int(rnd * 7)
			this.energy = ITEM_KEYWORD_ENERGY
			
		case ITEM_ID_COIN
			this.sprite_offset = int(rnd * 7)
			
		case ITEM_ID_BOX_DESTRUCTION_PARTICLE
			this.sprite_offset = int(rnd * 7)
		case ITEM_ID_ENEMY
		
			this.enemy_type = other
		
			if abs(this.direction) = 0  then
				this.sprite_offset = 0
			else
				this.sprite_offset = 5
			end if
			
			select case this.enemy_type
				case ENEMY_TYPE_GREEN_ROBOT
					this.energy = ENEMY_TYPE_GREEN_ROBOT_ENERGY * difficulty_ratio
					this.speed *= difficulty_ratio
				case ENEMY_TYPE_BLACK_BALL
					this.energy = ENEMY_TYPE_BLACK_BALL_ENERGY * difficulty_ratio
					this.speed *= difficulty_ratio
				case ENEMY_TYPE_GREEN_GUY
					this.energy = ENEMY_TYPE_GREEN_GUY_ENERGY * difficulty_ratio
					this.speed *= difficulty_ratio
				case ENEMY_TYPE_EYEGLASS_GUY
					this.energy = ENEMY_TYPE_EYEGLASS_GUY_ENERGY * difficulty_ratio
					this.speed *= difficulty_ratio
				case ENEMY_TYPE_FLYING_ROBOT
					this.energy = ENEMY_TYPE_FLYING_ROBOT_ENERGY * difficulty_ratio
					this.speed *= difficulty_ratio
				case ENEMY_TYPE_FLOOR_SPIDER
					this.energy = ENEMY_TYPE_FLOOR_SPIDER_ENERGY * difficulty_ratio
					this.speed *= difficulty_ratio
				case ENEMY_TYPE_PROGRAMMER
					this.energy = ENEMY_TYPE_PROGRAMMER_ENERGY * difficulty_ratio
					this.speed *= difficulty_ratio
				case ENEMY_TYPE_CHARLES_BRONSON
					this.energy = ENEMY_TYPE_CHARLES_BRONSON_ENERGY * difficulty_ratio
					this.speed *= difficulty_ratio
				case ENEMY_TYPE_JASC
					this.energy = ENEMY_TYPE_JASC_ENERGY * difficulty_ratio
				case else
					this.energy = 10

			end select
			
		case ITEM_ID_PLAYER_BULLET
			this.sprite_offset = int(rnd * 7)
		case else
			this.sprite_offset = 0
	end select
	
	this.speed_default = this.speed
	
	
end sub


Sub item_proto.get_bounding_tiles (w as Ulong, h as Ulong, lr as Ulong, lc as Ulong)
	
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


