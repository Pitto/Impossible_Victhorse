'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


Type level_proto
	number as UShort 'N° of level
	style as UShort 'graphic style of the level
	
	keyword_to_find as Ulong
	is_completed as boolean
	time_to_complete as double
	
	'bidimensional array containing tiles values
	redim tiles (0 to 0, 0 to 0) 	as tile_proto
	'bitmaps
	bitmap_block 		(0 to 31) as FB.Image ptr
	bitmap_block_2x		(0 to 31) as FB.Image ptr
	
	bitmap_object		(0 to 255) as FB.Image ptr
	bitmap_object_2x	(0 to 255) as FB.Image ptr
	bitmap_wallpaper 	(0 to 255) as FB.Image ptr
	bitmap_wallpaper_2x	(0 to 255) as FB.Image ptr
	
	sprites_items_16x16 (0 to 119) as FB.Image ptr
	sprites_items_16x16_2x (0 to 119) as FB.Image ptr
	
	sprites_items_32x24 (0 to 2) as FB.Image ptr
	sprites_items_32x24_2x (0 to 2) as FB.Image ptr
	
	sprites_block_moving (0 to 15) as FB.Image ptr
	sprites_block_moving_2x (0 to 15) as FB.Image ptr

	sprites_computer_keyword (0 to 8) as FB.Image ptr
	sprites_computer_keyword_2x (0 to 8) as FB.Image ptr
	
	sprites_horse (0 to 29) as FB.Image ptr
	sprites_horse_2x (0 to 29) as FB.Image ptr
	
	sprites_mega_blink (0 to 7) as FB.Image ptr

	sprites_baloon (0 to 11) as FB.Image ptr
	
	sprites_enemy (0 to 99) as FB.Image ptr
	sprites_enemy_2x (0 to 99) as FB.Image ptr
	
	wallpaper (0 to 7) as FB.Image ptr
	wallpaper_2x (0 to 7) as FB.Image ptr
	
	ascii_font_big 		(0 to 127) as FB.Image ptr
		
	
	'visible bounding tiles: 0: TOP, 1: RIGHT; 2: BOTTOM, 3: LEFT
	visible_bounding_tile (0 to 3) as Ubyte
	
	'text of the jeff's tips
	redim jeff_tips (0 to 0) as string
	
	'items: things that can be catched or destroyed
	dim items as item_proto ptr
	
	dim limit_upper_left as position_proto
	dim limit_lower_right as position_proto
	
	Declare sub draw_level (x as single, y as single, difficulty_ratio as single, image_buffer as FB.Image ptr)
	declare sub draw_items(head as item_proto ptr, x as single, y as single, difficulty_ratio as single, image_buffer as FB.Image ptr)
	declare sub draw_searching_bar(x as single, y as single, value as Ubyte, image_buffer as FB.Image ptr)
	declare sub draw_energy(x as single, y as single, value as Ubyte, enemy_type as Ubyte, difficulty_ratio as single, image_buffer as FB.Image ptr)
	
	declare sub get_visible_tiles (x as single, y as single, w as Ulong, h as Ulong, lr as Ulong, lc as Ulong)
	
	declare sub initialize_level_items (difficulty_ratio as single)
	declare sub update_level_items (points as Ulong ptr,  player_position as position_proto, sound_handler as sound_handler_proto, difficulty_ratio as single)
	declare sub delete_all_items(head as item_proto ptr)
	
	declare sub delete_visible_items (x1 as Long, y1 as Long, x2 as Long, y2 as Long, item_id as Ulong)
	
	declare function add_item	(head as item_proto ptr ptr, x as Ulong, y as Ulong, w as Ulong, h as Ulong, d as single, _
								s as single, id as Ulong, label as string, other as Ubyte, difficulty_ratio as single)  as item_proto ptr
	declare function delete_selected_item (item as item_proto ptr) as item_proto ptr
	
	declare function delete_selected_items (item as item_proto ptr) as item_proto ptr
	
	declare sub update_level_blocks ()
	declare sub create_floating_label (x as single, y as single, label as string)
	
	declare sub load_custom_block_icons(slot as Ulong)
	
	declare sub set_player_start_position(x as Ulong, y as Ulong)
	declare function get_player_start_position() as position_proto
	declare sub set_time_left(timing as Ulong)
	declare function get_time_left() as Long
	
	declare sub load_level (level_number as Ulong, level_file_name as string, difficulty_ratio as single)
	
	declare sub mark_all_items_to_be_deleted ()
	
	declare sub print_font (x as Ulong, y as Ulong, txt as string, image_buffer as FB.Image ptr)
	
	declare sub set_scenario_slot(byval slot as Ulong)
	declare sub set_wallpaper_slot(byval slot as Ulong)
	
	declare sub load_block_icons(slot as Ulong)
	
	declare sub load_txt (filename as string, txt() as string)
	
	declare sub draw_baloon (x as Long, y as Long, txt as string, image_buffer as FB.Image ptr)
	
	Declare Constructor()
	Declare Destructor()
	
	
	
	private:
	
		player_start_position as position_proto
		time_left as double
		wallpaper_slot as Ulong
		scenario_slot as Ulong 
	
End Type

'Constructor level_proto()
'end constructor

Constructor level_proto()
	
	this.keyword_to_find = 0
		
	'by default load block_icons_0.bmp
	this.load_block_icons(0)
	
	load_sprite_sheet 	(this.bitmap_object(), 		512, 384, 16, 16,	"img/object_icons.bmp")
	load_sprite_sheet 	(this.bitmap_wallpaper(), 	512, 384, 16, 16,	"img/wallp_icons.bmp")
	load_sprite_sheet 	(this.sprites_items_16x16(), 	128, 240, 8, 15,	"img/items_16x16.bmp")
	load_sprite_sheet 	(this.sprites_items_32x24(), 	96, 24, 3, 1,	"img/items_32x24.bmp")
	
	load_sprite_sheet	(this.sprites_baloon(), 48, 64, 3, 4, "img/baloon.bmp")
	
	load_sprite_sheet 	(this.sprites_block_moving(), 	128, 96, 4, 4,	"img/block_moving.bmp")
	
	load_sprite_sheet 	(this.sprites_horse(), 	288, 384, 4, 8,	"img/horse.bmp")
		
	load_sprite_sheet 	(this.sprites_computer_keyword(), 		288, 24, 9, 1,		"img/sprites_computer_keyword.bmp")
	
	
	load_sprite_sheet 	(this.sprites_enemy(), 		240, 240, 10, 10,		"img/sprites_enemies.bmp")
	
	load_sprite_sheet 	(this.wallpaper(), 		640, 240, 4, 2,		"img/wallp_640x240.bmp")
	
	load_sprite_sheet 	(this.ascii_font_big(), 	320, 192, 16, 8,	"img/font_ascii_big.bmp")
	
	dim i as Ulong
	
	
	for i = 0 to Ubound(this.sprites_items_32x24)
		this.sprites_items_32x24_2x		(i) = imagescale(this.sprites_items_32x24(i), _
														this.sprites_items_32x24(i)->width * 2,_
														this.sprites_items_32x24(i)->height * 2)
	next i
	

	
	for i = 0 to Ubound(this.bitmap_wallpaper)
		this.bitmap_wallpaper_2x	(i) = imagescale(this.bitmap_wallpaper(i), TILE_W, TILE_H)
	next i 
	
	for i = 0 to Ubound(this.sprites_horse)
		this.sprites_horse_2x	(i) = imagescale(this.sprites_horse(i), 144, 96)
	next i 
	
	for i = 0  to Ubound(this.bitmap_object_2x)
		this.bitmap_object_2x	(i) = imagescale(this.bitmap_object(i), TILE_W, TILE_H)
	next i
	
	
	for i = 0  to Ubound(this.sprites_block_moving_2x)
		this.sprites_block_moving_2x	(i) = imagescale(this.sprites_block_moving(i), this.sprites_block_moving(i)->width * 2, this.sprites_block_moving(i)->height * 2)
	next i
	

	
	for i = 0  to Ubound(this.sprites_computer_keyword_2x)
		this.sprites_computer_keyword_2x	(i) = imagescale(this.sprites_computer_keyword(i), this.sprites_computer_keyword(i)->width * 2, this.sprites_computer_keyword(i)->height * 2)
	next i
	
	
	
	for i = 0  to Ubound(this.sprites_items_16x16)
		this.sprites_items_16x16_2x	(i) = imagescale(this.sprites_items_16x16(i), this.sprites_items_16x16(i)->width * 2, this.sprites_items_16x16(i)->height * 2)
	next i
	
		
	for i = 0  to Ubound(this.sprites_enemy_2x)
		this.sprites_enemy_2x	(i) = imagescale(this.sprites_enemy(i), this.sprites_enemy(i)->width * 2, this.sprites_enemy(i)->height * 2)
	next i
	
	
	for i = 0  to Ubound(this.wallpaper_2x)
		this.wallpaper_2x	(i) = imagescale(this.wallpaper(i), this.wallpaper(i)->width * 2, this.wallpaper(i)->height * 2)
	next i
	
	for i = 0 to Ubound(sprites_mega_blink)
	
		this.sprites_mega_blink(i) = imagescale	(this.sprites_items_16x16(16 + i),64, 64)
	
	next i
	
	this.load_txt ("txt/jeff_tips_txt", jeff_tips())
	
End Constructor

Destructor level_proto()
	dim i as Ulong
	'delete all items
	this.delete_all_items(items)
	
	'destroy bitmaps from memory____________________________________________
	for i = 0 to Ubound(this.sprites_mega_blink)
		imagedestroy this.sprites_mega_blink(i)
	next i
	
	for i = 0 to Ubound(this.sprites_items_32x24)
		imagedestroy this.sprites_items_32x24_2x(i)
		imagedestroy this.sprites_items_32x24(i)
	next i
	
	for i = 0 to Ubound(this.sprites_horse)
		ImageDestroy this.sprites_horse(i)
		ImageDestroy this.sprites_horse_2x(i)
	
	next i
	
	for i = 0 to Ubound ( this.sprites_baloon)
		ImageDestroy this.sprites_baloon(i)
	next i
	
	for i = 0 to Ubound (this.bitmap_block)
		ImageDestroy this.bitmap_block(i)
		ImageDestroy this.bitmap_object(i)
		ImageDestroy this.bitmap_wallpaper(i)
		
		ImageDestroy this.bitmap_block_2x(i)
		ImageDestroy this.bitmap_object_2x(i)
		ImageDestroy this.bitmap_wallpaper_2x(i)
	next i
	
	for i = 0 to Ubound(this.sprites_computer_keyword)
		ImageDestroy this.sprites_computer_keyword(i)
		ImageDestroy this.sprites_computer_keyword_2x(i)
	next i
	
	for i = 0 to Ubound(this.sprites_items_16x16)
		ImageDestroy this.sprites_items_16x16(i)
		ImageDestroy this.sprites_items_16x16_2x(i)
	next i

	
	for i = 0 to Ubound(this.sprites_enemy)
		ImageDestroy this.sprites_enemy(i)
		ImageDestroy this.sprites_enemy_2x(i)
	next i
	
	for i = 0 to Ubound(this.wallpaper)
		ImageDestroy this.wallpaper(i)
		ImageDestroy this.wallpaper_2x(i)
	next i
	
	
	for i = 0 to Ubound(this.sprites_block_moving)
		imagedestroy this.sprites_block_moving(i)
		imagedestroy this.sprites_block_moving_2x(i)
	next i
	
	for i = 0 to Ubound (this.ascii_font_big)
		ImageDestroy this.ascii_font_big(i)
	next i
	
End Destructor

sub level_proto.draw_baloon (x as Long, y as Long, txt as string, image_buffer as FB.Image ptr) 

	'thanks to Dodicat
	'wordwrap routine
	'freebasic.net/forum/viewtopic.php?f=15&t=18666&p=165482&hilit=wordwrap#p165482
    
	dim lines as Ulong = 0
	dim max_len as Ulong = 0
	dim line_len as Ulong = 0
	dim carriage as boolean = false
	dim x_offset as Long
	dim as Ulong cols, rows, i, j
	
	
	'calc the bounds of the comic baloon
	for z as Long=0 to len(txt)-1
		line_len +=1
		if txt[z]=124 then
			lines += 1
			if line_len > max_len then max_len = line_len
            line_len = 0
            carriage = true
		end if
    next z
    'last line check
    if line_len > max_len then max_len = line_len
    
    if not carriage then
		max_len = len(txt)
		lines = 1
	end if
	
	x_offset = -max_len * 8
	
	cols = max_len + 1
	rows = lines + 2
	
	'line image_buffer, (x -16 + x_offset, y - lines * 16 - 16)-step(max_len*16 + 32,16*lines + 48), C_C64_GREY_2, BF
   
	dim as Long _x, _y
    'draw the baloon
    for i = 0 to rows
		for j = 0 to cols
			_x = x - j*16 + (cols *8) - 16
			_y = y-i*16 + 16
			if i = 0 and j = 0 then
				'bottom right
				put image_buffer, (_x,_y), sprites_baloon(8),trans
			elseif i=0 and j = cols then
				'bottom left
				put image_buffer, (_x,_y), sprites_baloon(6),trans
			elseif i=rows and j = 0 then
				'top right
				put image_buffer, (_x,_y), sprites_baloon(2),trans
			elseif i=rows and j = cols then
				'top left
				put image_buffer, (_x,_y), sprites_baloon(0),trans
			elseif i=rows then
				'top bound
				put image_buffer, (_x,_y), sprites_baloon(1),trans
			elseif i=0 then
				'bottom bound
				put image_buffer, (_x,_y), sprites_baloon(7),trans
			elseif j=cols then
				'left bound
				put image_buffer, (_x,_y), sprites_baloon(3),trans
			elseif j=0 then
				'right bound
				put image_buffer, (_x,_y), sprites_baloon(5),trans
			else
				'top bound
				put image_buffer, (_x,_y), sprites_baloon(4),trans
			
			end if
			'line image_buffer, (x - j*16 + (cols *8) - 16, y-i*16 + 16)-step(16,16), C_WHITE, BF
		next j
	next i
	'triangle
    put image_buffer, (_x + cols*8 + 32,y + 30 ), sprites_baloon(10),trans
    
   ' line image_buffer, (x -16 + x_offset - 4, y - lines * 16 - 16 - 4)-step(max_len*16 + 40,16*lines + 56), C_C64_DARK_GREY_GREY_1, BF
    
	dim as Long dx=x,dy=y - lines * 16,_pos,count=0

	'draw the txt
    for z as Long=0 to len(txt)-1
        _pos=dx+16*count
        
        if txt[z]=124 then
            count=0
            dy=dy+16
            
            continue for
        end if
        this.print_font (_pos + x_offset, dy, chr(txt[z]), image_buffer)
        
        count=count+1
    next z
	
	

end sub

sub level_proto.print_font (x as Ulong, y as Ulong, txt as string, image_buffer as FB.Image ptr)
	dim as ulong i, _x
	
	_x = x
	for i = 1 to len(txt)
		if i <= 127 then
			put image_buffer, (_x, y), ascii_font_big(asc(txt, i)), trans
			_x+=16
		end if
	next i
		

end sub

function level_proto.get_player_start_position() as position_proto
	dim position as position_proto
	position.x = this.player_start_position.x
	position.y = this.player_start_position.y
	
	return position
end function

sub level_proto.set_player_start_position(x as Ulong, y as Ulong)
	this.player_start_position.x = x
	this.player_start_position.y = y
end sub

sub level_proto.load_level(level_number as Ulong, level_file_name as string, difficulty_ratio as single)

	'IMPORTANT!
	this.keyword_to_find = 0

	#IFDEF DEBUG_MODE

		if len(level_file_name)  > 1 then
			load_level_file (level_file_name, this.tiles() )
		else
			load_level_file ("levels/level"+ str(level_number) + ".lev", this.tiles() )
		end if
		
	#ELSE
	
		load_level_file ("levels/level"+ str(level_number) + ".lev", this.tiles() )

	#ENDIF

	
	initialize_level_tiles (this.tiles())
	this.initialize_level_items (difficulty_ratio)
	
	limit_upper_left.x = 0
	limit_upper_left.y = 0
	
	limit_lower_right.x = Ubound(this.tiles) * TILE_W
	limit_lower_right.y = Ubound(this.tiles, 2) * TILE_H
	
	'important
	this.is_completed = false

end sub

function level_proto.delete_selected_items (item as item_proto ptr) as item_proto ptr


'translated from a C snippet
' from https://codeforwin.org/2018/05/c-program-to-delete-all-nodes-by-key-in-linked-list.html#delete-all

    
    dim as item_proto ptr prev, cur, head
    head = item
	if head = NULL then 
		return NULL
	else
    '/* Check if head node contains key */
    while (Cbool(head <> NULL) andalso head->delete_me = true)
    '{
        '// Get reference of head node
        prev = head

        '// Adjust head node link
        head = head->next_p

        '// Delete prev since it contains reference to head node
        deallocate(prev)

        'totalDeleted+
    '}
    wend

    prev = NULL
    cur  = head

    '/* For each node in the list */
    while (cur <> NULL)
    '{
        '// Current node contains key
        if (cur->delete_me = true) then
        '{
            '// Adjust links for previous node
            if (prev <> NULL) then
            '{
                prev->next_p = cur->next_p
            '}
            end if

            '// Delete current node
            deallocate(cur)

            cur = prev->next_p

            'totalDeleted++;
        '} 
        else
        '{
            prev = cur
            cur = cur->next_p
        end if      

    wend

    return head
    end if
    
end function



sub level_proto.draw_searching_bar(x as single, y as single, value as Ubyte, image_buffer as FB.Image ptr)
	dim i as Ulong
	dim rotating_bar (0 to 7) as string = { "|", "/", "-", "\", "|", "/", "-", "\"} 
	
	line image_buffer, (x-16, y-24)-step(224, 96), C_C64_BLUE, BF
	'line image_buffer, (x-2, y-2)-step(104, 32), C_C64_GREY_2, BF
	'line image_buffer, (x, y+16)-step(100, 12), C_C64_DARK_GREY_GREY_1, BF	
	'line image_buffer, (x, y+16)-step(100, 4), C_C64_Black, BF	
	'line image_buffer, (x, y+16)-step(value, 12), rgb(255 - int(value*2.5),int(value*2.5), 0), BF	
	
	
	print_font (x, y, "SEARCHING" + "  " +rotating_bar(CUlng((Timer*10) mod 8)), image_buffer)
	print_font (x, y + 24, "[          ]", image_buffer)

	for i = 0 to value\10
		print_font (x + i*16 + 16, y + 24, "*", image_buffer)
	next i

	
end sub

sub level_proto.draw_energy(x as single, y as single, value as Ubyte, enemy_type as Ubyte, difficulty_ratio as single, image_buffer as FB.Image ptr)
	
	dim percent_width as single
	dim enemy_tot_energy as Ulong
	
	select case enemy_type
		case ENEMY_TYPE_GREEN_ROBOT
			enemy_tot_energy = ENEMY_TYPE_GREEN_ROBOT_ENERGY * difficulty_ratio
		case ENEMY_TYPE_BLACK_BALL
			enemy_tot_energy = ENEMY_TYPE_BLACK_BALL_ENERGY * difficulty_ratio
		case ENEMY_TYPE_GREEN_GUY
			enemy_tot_energy = ENEMY_TYPE_GREEN_GUY_ENERGY * difficulty_ratio
		case ENEMY_TYPE_EYEGLASS_GUY
			enemy_tot_energy = ENEMY_TYPE_EYEGLASS_GUY_ENERGY * difficulty_ratio
		case ENEMY_TYPE_FLYING_ROBOT
			enemy_tot_energy = ENEMY_TYPE_FLYING_ROBOT_ENERGY * difficulty_ratio
		case ENEMY_TYPE_FLOOR_SPIDER
			enemy_tot_energy = ENEMY_TYPE_FLOOR_SPIDER_ENERGY * difficulty_ratio
		case ENEMY_TYPE_PROGRAMMER
			enemy_tot_energy = ENEMY_TYPE_PROGRAMMER_ENERGY * difficulty_ratio
		case ENEMY_TYPE_JASC
			enemy_tot_energy = ENEMY_TYPE_JASC_ENERGY * difficulty_ratio
		case else
			enemy_tot_energy = 100 * difficulty_ratio
	end select
	
	percent_width = ENEMY_BAR_ENERGY_WIDTH * value / enemy_tot_energy
	
	'line image_buffer, (x-4, y-4)-step(108, 36), C_C64_WHITE, BF
	'line image_buffer, (x-2, y-2)-step(104, 32), C_C64_GREY_2, BF
	line image_buffer, (x, y+16)-step(ENEMY_BAR_ENERGY_WIDTH, 12), C_C64_DARK_GREY_GREY_1, BF	
	line image_buffer, (x, y+16)-step(ENEMY_BAR_ENERGY_WIDTH, 4), C_C64_Black, BF	
	line image_buffer, (x, y+16)-step(percent_width, 12), rgb(255 - int(percent_width*2.5),int(percent_width*2.5), 0), BF	
	
	
end sub

sub level_proto.initialize_level_items(difficulty_ratio as single)
	
	dim as integer i, j
	dim as single speed, direction
	
	for i = 0 to Ubound(this.tiles)
		for j = 0 to Ubound(this.tiles,2)
		
			'enter location
			if 	this.tiles(i,j).attributes.tile_type  = mode_meta andalso _
				this.tiles(i,j).attributes.id = 1 then
					this.set_player_start_position (j*TILE_W + TILE_W\2 , i*TILE_H + TILE_H\2)
			end if
			
			'exit location
			if 	this.tiles(i,j).attributes.tile_type  = mode_meta andalso _
				this.tiles(i,j).attributes.id = 2 then
					'this.set_player_start_position (j*TILE_W + TILE_W\2 , i*TILE_H + TILE_H\2)
					this.items = this.add_item(	@this.items, j*TILE_W, i*TILE_H, _
												ITEM_BIG_W, ITEM_BIG_H, _
												0,0,ITEM_ID_EXIT_LOCATION, "",0, difficulty_ratio)
					this.items->is_active = false
					
			end if
		
		
			if this.tiles(i,j).attributes.tile_type  = mode_object then
				select case this.tiles(i,j).attributes.id
					
					case ITEM_ID_HORSE_FACING_RIGHT
					
						this.items = this.add_item(	@this.items, _
													j*TILE_W - TILE_W, _
													i*TILE_H - TILE_H, _
													TILE_W*2, TILE_H*2, 0,ITEM_ID_HORSE_SPEED,ITEM_ID_HORSE_FACING_RIGHT, "",0, difficulty_ratio)
													
					case ITEM_ID_HORSE_FACING_LEFT
					
						this.items = this.add_item(	@this.items, _
													j*TILE_W, _
													i*TILE_H - TILE_H, _
													TILE_W*2, TILE_H*2, _PI,ITEM_ID_HORSE_SPEED,ITEM_ID_HORSE_FACING_LEFT, "",0, difficulty_ratio)
					
					
					case ITEM_ID_CANNON_LEFT_RIGHT 
					
						this.items = this.add_item(	@this.items, _
													j*TILE_W, _
													i*TILE_H + (TILE_H - ITEM_LITTLE_H)\2, _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_CANNON_LEFT_RIGHT, "",0, difficulty_ratio)
					case ITEM_ID_CANNON_RIGHT_LEFT
					
						this.items = this.add_item(	@this.items, _
													j*TILE_W + (TILE_W - ITEM_LITTLE_W), _
													i*TILE_H + (TILE_H - ITEM_LITTLE_H)\2, _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_CANNON_RIGHT_LEFT, "",0, difficulty_ratio)
					
					case ITEM_ID_JEFF
						this.items = this.add_item(	@this.items, j*TILE_W, i*TILE_H, _
													TILE_W, ITEM_LITTLE_H, ITEM_ID_UPDOWN_PLATFORM_SPEED,_PI_HALF,_
													ITEM_ID_JEFF, "",this.tiles(i,j).attributes.other, difficulty_ratio)
					
					case ITEM_ID_UPDOWN_PLATFORM
						this.items = this.add_item(	@this.items, j*TILE_W, i*TILE_H, _
													TILE_W, ITEM_LITTLE_H, ITEM_ID_UPDOWN_PLATFORM_SPEED,_PI_HALF,_
													ITEM_ID_UPDOWN_PLATFORM, "",0, difficulty_ratio)
					
					case ITEM_ID_MISSILE_LAUNCHER	

						this.items = this.add_item(	@this.items, _
													j*TILE_W + (TILE_W - ITEM_LITTLE_W)\2, _
													i*TILE_H + (TILE_H - ITEM_LITTLE_H)\2, _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_MISSILE_LAUNCHER, "",0, difficulty_ratio)

					case ITEM_ID_CANNON_BOTTOM_TOP
					
						this.items = this.add_item(	@this.items, _
													j*TILE_W + (TILE_W - ITEM_LITTLE_W)\2, _
													i*TILE_H + (TILE_H - ITEM_LITTLE_H), _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_CANNON_BOTTOM_TOP, "",0, difficulty_ratio)

					case ITEM_ID_POWER_UP
						
						this.items = this.add_item(	@this.items, _
													j*TILE_W + (TILE_W - ITEM_LITTLE_W)\2, _
													i*TILE_H + (TILE_H - ITEM_LITTLE_H)\2, _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_POWER_UP, "",0, difficulty_ratio)
					case ITEM_ID_1UP
						
						this.items = this.add_item(	@this.items, _
													j*TILE_W + (TILE_W - ITEM_LITTLE_W)\2, _
													i*TILE_H + (TILE_H - ITEM_LITTLE_H)\2, _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_1UP, "",0, difficulty_ratio)
													
					case ITEM_ID_KEY_YELLOW
						
						this.items = this.add_item(	@this.items, _
													j*TILE_W + (TILE_W - ITEM_LITTLE_W)\2, _
													i*TILE_H + (TILE_H - ITEM_LITTLE_H)\2, _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_KEY_YELLOW, "",0, difficulty_ratio)

					case ITEM_ID_KEY_RED
						
						this.items = this.add_item(	@this.items, _
													j*TILE_W + (TILE_W - ITEM_LITTLE_W)\2, _
													i*TILE_H + (TILE_H - ITEM_LITTLE_H)\2, _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_KEY_RED, "",0, difficulty_ratio)

					case ITEM_ID_KEY_BLUE

						this.items = this.add_item(	@this.items, _
													j*TILE_W + (TILE_W - ITEM_LITTLE_W)\2, _
													i*TILE_H + (TILE_H - ITEM_LITTLE_H)\2, _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_KEY_BLUE, "",0, difficulty_ratio)

					case ITEM_ID_SYS64738
					
						this.items = this.add_item(	@this.items, _
													j*TILE_W + (TILE_W - ITEM_LITTLE_W)\2, _
													i*TILE_H + (TILE_H - ITEM_LITTLE_H)\2, _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_SYS64738, "",0, difficulty_ratio)
						
					case ITEM_ID_COIN
					
						this.items = this.add_item(	@this.items, _
													j*TILE_W + (TILE_W - ITEM_LITTLE_W)\2, _
													i*TILE_H + (TILE_H - ITEM_LITTLE_H)\2, _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_COIN, "",0, difficulty_ratio)

					case ITEM_ID_AMMO_FLOPPY
					
						this.items = this.add_item(	@this.items, _
													j*TILE_W + (TILE_W - ITEM_LITTLE_W)\2, _
													i*TILE_H + (TILE_H - ITEM_LITTLE_H)\2, _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_AMMO_FLOPPY, "",0, difficulty_ratio)
					
					case ITEM_ID_MEDPACK
					
						this.items = this.add_item(	@this.items, _
													j*TILE_W + (TILE_W - ITEM_LITTLE_W)\2, _
													i*TILE_H + (TILE_H - ITEM_LITTLE_H)\2, _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_MEDPACK, "",0, difficulty_ratio)
					
					case ITEM_ID_KEYWORD
						this.items = this.add_item(@this.items, j*TILE_W, i*TILE_H, ITEM_KEYWORD_W, ITEM_KEYWORD_H, 0,0,ITEM_ID_KEYWORD, "",0, difficulty_ratio)
						this.keyword_to_find += 1

					case ITEM_ID_ENEMY
						select case this.tiles(i,j).attributes.other
							case ENEMY_TYPE_GREEN_ROBOT
								speed = ENEMY_GREEN_ROBOT_SPEED
								direction = _PI
							case ENEMY_TYPE_BLACK_BALL
								speed = ENEMY_BLACK_BALL_SPEED
								direction = _PI
							case ENEMY_TYPE_GREEN_GUY
								speed = ENEMY_GREEN_GUY_SPEED
								direction = _PI
							case ENEMY_TYPE_EYEGLASS_GUY
								speed = ENEMY_EYEGLASS_GUY_SPEED
								direction = _PI
							case ENEMY_TYPE_FLYING_ROBOT
								speed = ENEMY_FLYING_ROBOT_SPEED
								direction = _PI_HALF
							case ENEMY_TYPE_FLOOR_SPIDER
								speed = ENEMY_TYPE_FLOOR_SPIDER_SPEED
								direction = 0
							case ENEMY_TYPE_PROGRAMMER
								speed = ENEMY_TYPE_PROGRAMMER_SPEED
								direction = 0
							case ENEMY_TYPE_CHARLES_BRONSON
								speed = ENEMY_TYPE_CHARLES_BRONSON_SPEED
								direction = 0
							case ENEMY_TYPE_JASC
								speed = ENEMY_TYPE_JASC_SPEED
								direction = _PI
							case else
								speed = 1
								direction = _PI
						end select
						this.items = this.add_item	(@this.items, j*TILE_W, i*TILE_H, ENEMY_W, ENEMY_H, _
													direction, speed, ITEM_ID_ENEMY, "",_
													this.tiles(i,j).attributes.other, difficulty_ratio)
				end select
			end if
		next j
	next i

end sub

function level_proto.add_item(head as item_proto ptr ptr, _
							x as Ulong, y as Ulong, w as Ulong, h as Ulong, _
							d as single, s as single, id as Ulong, label as string, _
							other as Ubyte, difficulty_ratio as single)  as item_proto ptr
    dim as item_proto ptr p = callocate(sizeof(item_proto))
	p->initialize_item(x , y, w, h, d, s, id, label, other, difficulty_ratio)
	p->next_p = *head
    *head = p
    return p
end function

sub level_proto.delete_all_items(head as item_proto ptr)
	dim temp as item_proto ptr
	while (head <> NULL)
		temp = Head
		head = temp->next_p
		delete(temp)
		temp = NULL
	wend
end sub

sub level_proto.draw_items(item as item_proto ptr, x as single, y as single, difficulty_ratio as single, image_buffer as FB.Image ptr)
	dim c as Ulong
	dim kw as item_proto ptr
	kw = item
	
	
	while (item <> NULL)
		select case item->id

			case ITEM_ID_JEFF
				if item->is_reached_by_player then
					item->draw_item(x, y, this.sprites_enemy_2x(ITEM_ID_JEFF_SPRITE + 5 + CUlng(timer*10) mod 5), image_buffer)
					if item->msg_slot >= 0 andalso item->msg_slot <= Ubound(this.jeff_tips) then
						draw_baloon (item->x - x , item->y - y - 80, this.jeff_tips(item->msg_slot), image_buffer)
					else
						draw_baloon (item->x - x , item->y - y - 80, "Hello!", image_buffer)
					end if 
				else
					item->draw_item(x, y, this.sprites_enemy_2x(ITEM_ID_JEFF_SPRITE + CUlng(timer*10) mod 5), image_buffer)
					

				end if
				
				
			case ITEM_ID_HORSE_FACING_LEFT
			
				item->draw_item(x, y, this.sprites_horse_2x _
				(15 + (CUlng(timer*10)) mod 15), image_buffer)
				'line image_buffer, (item->x - x,item->y - y)-step(item->w, item->h), C_RED, BF
		
			case ITEM_ID_HORSE_FACING_RIGHT
			
				item->draw_item(x, y, this.sprites_horse_2x _
				((CUlng(timer*15)) mod 15), image_buffer)
				'line image_buffer, (item->x - x,item->y - y)-step(72*2, 42*2), C_RED, BF
		
			case ITEM_ID_EXIT_LOCATION
				if item->is_active then
					item->draw_item(x, y, this.sprites_items_32x24_2x _
					(ITEM_ID_EXIT_LOCATION_DOOR_OPEN_SPRITE), image_buffer)
				else
					item->draw_item(x, y, this.sprites_items_32x24_2x _
					(ITEM_ID_EXIT_LOCATION_DOOR_CLOSED_SPRITE), image_buffer)
				end if
				
		
			case ITEM_ID_BALLISTIC_ENEMY_BULLET
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_BALLISTIC_ENEMY_BULLET_SPRITE + (CUlng(timer*10) + item->sprite_offset) mod 4), image_buffer)
				
			case ITEM_ID_FLYING_BOMB
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_FLYING_BOMB_SPRITE), image_buffer)

			case ITEM_ID_UPDOWN_PLATFORM
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_UPDOWN_PLATFORM_SPRITE_A), image_buffer)
				item->draw_item(x - 32, y, this.sprites_items_16x16_2x _
				(ITEM_ID_UPDOWN_PLATFORM_SPRITE_B), image_buffer)
				
			case ITEM_ID_CANNON_LEFT_RIGHT
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_CANNON_LEFT_RIGHT_SPRITE + (CUlng(timer*10) + item->sprite_offset) mod 4), image_buffer)
				
			case ITEM_ID_CANNON_RIGHT_LEFT
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_CANNON_RIGHT_LEFT_SPRITE + (CUlng(timer*10) + item->sprite_offset) mod 4), image_buffer)
				
			case ITEM_ID_CANNON_BOTTOM_TOP
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_CANNON_BOTTOM_TOP_SPRITE + (CUlng(timer*10) + item->sprite_offset) mod 4), image_buffer)
			
			case ITEM_ID_MISSILE_LAUNCHER
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_MISSILE_LAUNCHER_SPRITE + item->angle_to_sprite_frame()), image_buffer)
			
			case ITEM_ID_MISSILE
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_MISSILE_SPRITE + item->angle_to_sprite_frame()), image_buffer)
				
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_MISSILE_BLINK_SPRITE + (CUlng(timer*5) + item->sprite_offset) mod 4), image_buffer)
		
			case ITEM_ID_CANNON_BULLET
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_ENEMY_BULLET_0_SPRITE + (CUlng(timer*20) + item->sprite_offset) mod 4), image_buffer)
			
			case ITEM_ID_1UP
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_1UP_SPRITE + (CUlng(timer*5) + item->sprite_offset) mod 4), image_buffer)
				
			case ITEM_ID_POWER_UP
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_POWER_UP_SPRITE + (CUlng(timer*5) + item->sprite_offset) mod 4), image_buffer)
				
			case ITEM_ID_CLOUD
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_CLOUD_SPRITE + (CUlng(timer*5) + item->sprite_offset) mod 4), image_buffer)
			
			case ITEM_ID_ENEMY_BULLET_0
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_ENEMY_BULLET_0_SPRITE + (CUlng(timer*20) + item->sprite_offset) mod 4), image_buffer)
		
			case ITEM_ID_KEY_YELLOW
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_KEY_YELLOW_SPRITE), image_buffer)
				
			case ITEM_ID_KEY_RED
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_KEY_RED_SPRITE), image_buffer)
			
			case ITEM_ID_KEY_BLUE
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_KEY_BLUE_SPRITE), image_buffer)

			case ITEM_ID_MEDPACK
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_MEDPACK_SPRITE), image_buffer)
			
			case ITEM_ID_ENEMY_HURT_FLASH
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_ENEMY_HURT_FLASH_SPRITE + (CUlng(timer*10) + item->sprite_offset) mod 4), image_buffer)
				
			case ITEM_ID_BLINK
				item->draw_item(x , y , this.sprites_items_16x16_2x _
				(ITEM_ID_BLINK_SPRITE + (CUlng(timer*10) + item->sprite_offset) mod 8), image_buffer)

			case ITEM_ID_MEGA_BLINK
				item->draw_item(x , y , this.sprites_mega_blink(CUlng(timer*10) mod 8),  image_buffer)

			case ITEM_ID_SHEET
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_SHEET_SPRITE + (CUlng(timer*10) + item->sprite_offset) mod 8), image_buffer)
			
			case ITEM_ID_COIN
			
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_COIN_SPRITE + (CUlng(timer*10) + item->sprite_offset) mod 8), image_buffer)

			case ITEM_ID_AMMO_FLOPPY_FROM_DISPENSER
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_AMMO_FLOPPY_SPRITE), image_buffer)
				
			case ITEM_ID_AMMO_FLOPPY
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_AMMO_FLOPPY_SPRITE + (CUlng(timer*5) + item->sprite_offset) mod 8), image_buffer)

			
			case ITEM_ID_SYS64738
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_SYS64738_SPRITE + (CUlng(timer*5) + item->sprite_offset) mod 8), image_buffer)


			case ITEM_ID_ENEMY
				item->draw_item(x, y, this.sprites_enemy_2x(CUlng(timer*10) mod 5 + item->sprite_offset + item->enemy_type*10), image_buffer)
				
				'draw energy bar for a while if hitted by player floppies
				if item-> is_hurt then
				'if Timer - item->is_hurt_begin_time < 0.5 then
					this.draw_energy(item->x - x, item->y - y + item->h + 5, item->energy, item->enemy_type, difficulty_ratio, image_buffer)
				end if
				
			case ITEM_ID_PLAYER_BULLET_DIRECTIONAL
				item->draw_item(x, y , this.sprites_items_16x16_2x _
				(ITEM_ID_PLAYER_BULLET_SPRITE + (CUlng(timer*15) + item->sprite_offset) mod 8), image_buffer)

			case ITEM_ID_PLAYER_BULLET
				item->draw_item(x, y , this.sprites_items_16x16_2x _
				(ITEM_ID_PLAYER_BULLET_SPRITE + (CUlng(timer*15) + item->sprite_offset) mod 8), image_buffer)
		
			case ITEM_ID_BOX_DESTRUCTION_PARTICLE
				item->draw_item(x, y, this.sprites_items_16x16_2x _
				(ITEM_ID_WOOD_PIECES_SPRITE + (CUlng(timer*20) + item->sprite_offset) mod 8), image_buffer)
			
			case ITEM_ID_FLOPPY_DESTRUCTION_PARTICLE
				line image_buffer, (item->x - x, item->y - y)-step(4,4), C_WHITE, BF
			
			case ITEM_ID_KEYWORD
			
				if item->is_active then
					'draw a working computer
					item->draw_item(x, y, this.sprites_computer_keyword_2x((CUlng(timer*10) + item->sprite_offset) mod 8), image_buffer)
					
					if not item->is_reached_by_player then
						'draw an arrow above to highlight it
						item->draw_item(x, y + 48 - int(cos(Timer*4)*10), this.sprites_items_32x24_2x(SEARCH_ARROW_SPRITE), image_buffer)
					end if
				else
					'draw a computer with a blank screen
					item->draw_item(x, y, this.sprites_computer_keyword_2x(8), image_buffer)
				end if
			
			
			case ITEM_ID_MSG_LABEL
			
				this.print_font (item->x - x, item->y - y, item->label, image_buffer)
			
				'draw string image_buffer, (item->x - x + 1, item->y - y + 1), item->label, C_C64_LIGHT_BLUE
				'draw string image_buffer, (item->x - x, item->y - y), item->label
			
		end select
		item = item->next_p
		c+=1
	wend
	
	'draw the computer searching bar above all
	while (kw <> NULL)
		
		if Cbool(kw->id =  ITEM_ID_KEYWORD) andalso kw->is_reached_by_player andalso kw->is_active then
			this.draw_searching_bar(kw->x - x - 64, kw->y - y - kw->h - 64 + int(cos(Timer*4)*10), ITEM_KEYWORD_ENERGY - kw->energy, image_buffer)
		end if
		kw = kw->next_p
	wend
	
	deallocate kw
	kw = 0
	

end sub

sub level_proto.mark_all_items_to_be_deleted ()
	dim head as item_proto ptr
	
	head = this.items

	while (head <> NULL)
		head->delete_me = true
		head = head->next_p
	wend
	
end sub

function level_proto.delete_selected_item (item as item_proto ptr) as item_proto ptr

	'recursive way to remove 

	if (item = NULL) then ' Found the tail
       return NULL
	   
	elseif (item->delete_me) then
	   
	   dim next_item as item_proto ptr
		' Found one to delete
		
		next_item = item->next_p
		
		deallocate(item)
		item = NULL
		
		return next_item
   else
	 ' Just keep going
		item->next_p = delete_selected_item(item->next_p)
		return item
	end if
	
end function


sub level_proto.update_level_items (points as Ulong ptr, player_position as position_proto, sound_handler as sound_handler_proto, difficulty_ratio as single)

	dim as Ulong i, j, k
	dim item as item_proto ptr
	item = this.items
	
	
	'check collision of the enemies bullets, missiles with player floppies
	while (item <> NULL)			
		dim other_objects as item_proto ptr
		
		if 	item->id = ITEM_ID_MISSILE orelse _
			item->id = ITEM_ID_CANNON_BULLET orelse _
			item->id = ITEM_ID_BALLISTIC_ENEMY_BULLET orelse _
			item->id = ITEM_ID_ENEMY_BULLET_0 orelse _
			item->id = ITEM_ID_FLYING_BOMB then
			
			other_objects = this.items
			while (other_objects <> NULL)
				if 	CBool(other_objects -> id = ITEM_ID_PLAYER_BULLET) orelse _
					CBool(other_objects -> id = ITEM_ID_PLAYER_BULLET_DIRECTIONAL) _
				andalso _
					is_collision(item->x, item->y, _
									item->x+ item->w, item->y + item->h, _
									other_objects->x, other_objects->y, _
									other_objects->x + other_objects->w, _
									other_objects->y + other_objects->h) then
					
					
						'delete the floppy
						other_objects->	delete_me = true
						
						'delete the bullet / missile
						item->			delete_me = true
						
						'some flashing while the bullet is reached
						this.items = this.add_item(@this.items, item->x, item->y, _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0, 0, _
													ITEM_ID_ENEMY_HURT_FLASH, "", 0, difficulty_ratio)
													
					end if
			other_objects = other_objects->next_p
			wend
		end if
		item = item->next_p
	wend
	
	
	item = this.items
	
	while (item <> NULL)

	
		if not item->delete_me then
		select case item->id
		
			case ITEM_ID_HORSE_FACING_RIGHT to ITEM_ID_HORSE_FACING_LEFT
			
				'the horse runs in right direction, if hits a wooden block, it stops,
				'if hits a wall, it is deleted
				item->x += item->speed * cos(item->direction)
			
				item->get_bounding_tiles(TILE_W, TILE_H, Ubound(this.tiles), Ubound(this.tiles, 2))
				for j = item->bounding_tile(3) to item->bounding_tile(1)
					for i = item->bounding_tile(0)  to item->bounding_tile(2)
				
						if tiles(i, j).attributes.tile_type = 1 then
						
							select case tiles(i, j).attributes.id
								'horse stopped toward wooden boxes
								case block_wood_box
						
									'horse facing right			
									if 	is_point_into_area(item->x + item->w, item->y + item->h\2 + item->h\4, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) orelse _
										is_point_into_area(item->x + item->w, item->y + item->h\2 - item->h\4, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
									 
										item->x = j * TILE_W - item->w - 1
									
									end if
									
									'horse facing left
									if 	is_point_into_area(item->x , item->y + item->h\2 + item->h\4, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) orelse _
										is_point_into_area(item->x , item->y + item->h\2 - item->h\4, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
									 
										item->x = j * TILE_W + TILE_W + 1
									
									end if
									
								'horse disappears if hits a block
								case block_full to block_edge_top
								
									'horse facing right			
									if 	is_point_into_area(item->x + item->w, item->y + item->h\2 + item->h\4, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) orelse _
										is_point_into_area(item->x + item->w, item->y + item->h\2 - item->h\4, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
									 
										item->delete_me = true
										
										'create a mega blink
										this.items = this.add_item(@this.items, item->x + item->w\2, item->y +  item->h\2, _
																	64, 64, 0, 0, ITEM_ID_MEGA_BLINK, "", 0, difficulty_ratio)
									
									end if
									
									'horse facing left
									if 	is_point_into_area(item->x , item->y + item->h\2 + item->h\4, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) orelse _
										is_point_into_area(item->x , item->y + item->h\2 - item->h\4, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
									 
										item->delete_me = true
										
										'create a mega blink
										this.items = this.add_item(@this.items, item->x + item->w\2, item->y +  item->h\2, _
																	64, 64, 0, 0, ITEM_ID_MEGA_BLINK, "", 0, difficulty_ratio)
									
									end if
									
								end select
						
						end if

					next i
				next j
				
				'collision of the horse  with the computer containing keyword_____________________
				dim other_objects as item_proto ptr
				other_objects = this.items
				while (other_objects <> NULL)

					if CBool(other_objects -> id = ITEM_ID_KEYWORD) andalso _
						other_objects -> is_active andalso _
						is_collision(item->x, item->y, _
										item->x+ item->w, item->y + item->h, _
										other_objects->x, other_objects->y, _
										other_objects->x + other_objects->w, _
										other_objects->y + other_objects->h) then
						
						other_objects->	is_active = false
						other_objects->	energy = 0
						other_objects-> delete_me = true
						this.keyword_to_find -= 1
						'some blinking
						this.items = this.add_item	(@this.items, other_objects->x, other_objects->y, _
													ITEM_COIN_W, ITEM_COIN_H, 0, 0, ITEM_ID_BLINK, "", 0, difficulty_ratio)
						'some fancy text
						this.create_floating_label (other_objects->x - len("format c: /u")*4, other_objects->y-16, "format c: /u")
						
						for i as Ulong = 0 to rnd * 3 + 3
							'generate some flying sheet 
							this.items = this.add_item(@this.items, other_objects->x, other_objects->y, _
														ITEM_COIN_W, ITEM_COIN_H, _PI/4 + rnd*(_PI_HALF), GRAVITY*2 + rnd*3, _
														ITEM_ID_SHEET, "", 0, difficulty_ratio)
						next i
						
						'create a mega blink
							this.items = this.add_item(@this.items, other_objects->x, other_objects->y, _
														64, 64, 0, 0, ITEM_ID_MEGA_BLINK, "", 0, difficulty_ratio)
													
					end if
					other_objects = other_objects->next_p
				wend
		
		
			case ITEM_ID_EXIT_LOCATION
				if this.keyword_to_find <= 0 then item->is_active = true
		
			case ITEM_ID_MISSILE
			
				
					item->x += item->speed * cos(item->direction)
					item->y += item->speed * -sin(item->direction)
					
					'update direction in order to get the player position
					if rnd*100 > 75 then
						item->direction += item->get_diff_angle(_abtp(item->x, item->y, player_position.x, player_position.y), item->direction)/8
					end if
					
					item->get_bounding_tiles(TILE_W, TILE_H, Ubound(this.tiles), Ubound(this.tiles, 2))
					for j = item->bounding_tile(3) to item->bounding_tile(1)
						for i = item->bounding_tile(0)  to item->bounding_tile(2)
							'SOLID BLOCKS
						if tiles(i, j).attributes.tile_type = 1 and tiles(i, j).attributes.id <> block_semi_block and tiles(i, j).attributes.id <> block_null then
							item->delete_me=true
							this.items = this.add_item(@this.items, item->x, item->y, ITEM_LITTLE_W, ITEM_LITTLE_H, 0, 0, ITEM_ID_CLOUD, "", 0, difficulty_ratio)
						end if
						
						next i
					next j
				
				
		
			case ITEM_ID_MISSILE_LAUNCHER

				if manhattan_distance(item->x, item->y, player_position.x, player_position.y) < 300 then
					'update direction in order to get the player position
					item->direction = _abtp(item->x, item->y, player_position.x, player_position.y)
					if timer - item->initialization_time > ITEM_ID_CANNON_BOTTOM_TOP_INTERVAL then
						item->initialization_time = Timer
						this.items = this.add_item(@this.items, item->x, item->y, ITEM_LITTLE_W, ITEM_LITTLE_H, _
						_abtp(item->x, item->y, player_position.x, player_position.y),	_		
						GRAVITY/2, ITEM_ID_MISSILE, "", 0, difficulty_ratio)
						
						sound_handler.set_queued_sound(SFX_MISSILE_LAUNCH)
					end if
				end if
			
			case ITEM_ID_CANNON_LEFT_RIGHT
				if timer - item->initialization_time > ITEM_ID_CANNON_HORIZONTAL_INTERVAL then
					item->initialization_time = Timer
					this.items = this.add_item(@this.items, item->x, item->y, ITEM_LITTLE_W, ITEM_LITTLE_H, 0, GRAVITY, ITEM_ID_CANNON_BULLET, "", 0, difficulty_ratio)
					
					if manhattan_distance(item->x, item->y, player_position.x, player_position.y) <  SFX_MIN_DIST_TO_HEAR then
						sound_handler.set_queued_sound(SFX_BULLET_1_LAUNCH)
					end if
				
				end if
				
			case ITEM_ID_CANNON_RIGHT_LEFT
				if timer - item->initialization_time > ITEM_ID_CANNON_HORIZONTAL_INTERVAL then
					item->initialization_time = Timer
					this.items = this.add_item(@this.items, item->x, item->y, ITEM_LITTLE_W, ITEM_LITTLE_H, _PI, GRAVITY, ITEM_ID_CANNON_BULLET, "", 0, difficulty_ratio)
					
					if manhattan_distance(item->x, item->y, player_position.x, player_position.y) <  SFX_MIN_DIST_TO_HEAR then
						sound_handler.set_queued_sound(SFX_BULLET_1_LAUNCH)
					end if
				
				end if
		
			case ITEM_ID_CANNON_BOTTOM_TOP
				if timer - item->initialization_time > ITEM_ID_CANNON_BOTTOM_TOP_INTERVAL then
					item->initialization_time = Timer
					this.items = this.add_item(@this.items, item->x, item->y, ITEM_LITTLE_W, ITEM_LITTLE_H, _PI_HALF, GRAVITY, ITEM_ID_CANNON_BULLET, "", 0, difficulty_ratio)
					
					if manhattan_distance(item->x, item->y, player_position.x, player_position.y) <  SFX_MIN_DIST_TO_HEAR then
						sound_handler.set_queued_sound(SFX_BULLET_1_LAUNCH)
					end if
				
				end if
				
			case ITEM_ID_CANNON_BULLET
				item->y += item->speed * -sin(item->direction)
				item->x += item->speed * cos(item->direction)
			
				item->get_bounding_tiles(TILE_W, TILE_H, Ubound(this.tiles), Ubound(this.tiles, 2))
				
				for j = item->bounding_tile(3) to item->bounding_tile(1)
					for i = item->bounding_tile(0)  to item->bounding_tile(2)
						'SOLID BLOCKS
					if tiles(i, j).attributes.tile_type = 1 and tiles(i, j).attributes.id <> block_semi_block and tiles(i, j).attributes.id <> block_null then
						this.items = this.add_item(@this.items, item->x, item->y, ITEM_LITTLE_W, ITEM_LITTLE_H, 0, 0, ITEM_ID_CLOUD, "", 0, difficulty_ratio)
						
						item->delete_me=true
												
						if manhattan_distance(item->x, item->y, player_position.x, player_position.y) <  SFX_MIN_DIST_TO_HEAR then
							sound_handler.set_queued_sound(SFX_EXPLOSION_1)
						end if

					end if
					
					next i
				next j
			
		
			case ITEM_ID_BALLISTIC_ENEMY_BULLET
				item->speed *= GRAVITY_ACCEL
				item->y += GRAVITY
				item->x += item->speed * cos(item->direction)
				item->y += item->speed * -sin(item->direction)
				
				
				
				item->get_bounding_tiles(TILE_W, TILE_H, Ubound(this.tiles), Ubound(this.tiles, 2))
				
				for j = item->bounding_tile(3) to item->bounding_tile(1)
					for i = item->bounding_tile(0)  to item->bounding_tile(2)
						'SOLID BLOCKS
					if tiles(i, j).attributes.tile_type = 1 and tiles(i, j).attributes.id <> block_semi_block and tiles(i, j).attributes.id <> block_null then
							
						item->delete_me=true
						sound_handler.set_queued_sound(SFX_EXPLOSION_2)
					end if
					
					next i
				next j
				
			case ITEM_ID_ENEMY_BULLET_0
				item->x += item->speed * cos(item->direction)
				item->y += item->speed * -sin(item->direction)
				
				item->get_bounding_tiles(TILE_W, TILE_H, Ubound(this.tiles), Ubound(this.tiles, 2))
				
				for j = item->bounding_tile(3) to item->bounding_tile(1)
					for i = item->bounding_tile(0)  to item->bounding_tile(2)
						'SOLID BLOCKS
					if tiles(i, j).attributes.tile_type = 1 and tiles(i, j).attributes.id <> block_semi_block and tiles(i, j).attributes.id <> block_null then
							
						item->delete_me=true
						sound_handler.set_queued_sound(SFX_EXPLOSION_1)

					end if
					
					next i
				next j
				
			case ITEM_ID_FLYING_BOMB
				
				item->y += item->speed * -sin(item->direction)
				
				item->get_bounding_tiles(TILE_W, TILE_H, Ubound(this.tiles), Ubound(this.tiles, 2))
				
				for j = item->bounding_tile(3) to item->bounding_tile(1)
					for i = item->bounding_tile(0)  to item->bounding_tile(2)
						'SOLID BLOCKS
					if tiles(i, j).attributes.tile_type = 1 and tiles(i, j).attributes.id <> block_semi_block and tiles(i, j).attributes.id <> block_null then

						this.items = this.add_item(@this.items, item->x, item->y, ITEM_LITTLE_W, ITEM_LITTLE_W, 0, 0, ITEM_ID_CLOUD, "", 0, difficulty_ratio)
						item->delete_me=true
						sound_handler.set_queued_sound(SFX_EXPLOSION_2)

					end if
					
					next i
				next j


			case ITEM_ID_CLOUD
				
				
				if Timer - item->initialization_time > 0.5 then
					item->delete_me=true
				end if
				
			case ITEM_ID_MEGA_BLINK
				
				if Timer - item->initialization_time > 1 then
					item->delete_me=true
				end if
				
		
			case ITEM_ID_SHEET
				item->x += item->speed * cos(item->direction)
				item->y += item->speed * -sin(item->direction)
				item->speed *= FLOPPY_PARTICLE_FRICTION
				item->y += GRAVITY
			
				if Timer - item->initialization_time > 0.5 then
					item->delete_me=true
				end if
		
			case ITEM_ID_KEYWORD
			
				if item->energy <= 0 then item->is_active = false

		
			case ITEM_ID_AMMO_FLOPPY_FROM_DISPENSER
				
				item->y += item->speed * -sin(item->direction)
				item->speed *= FLOPPY_PARTICLE_FRICTION
				item->y += GRAVITY
				
				if Timer - item->initialization_time > 0.5 then
					item->delete_me=true
				end if
				
			case ITEM_ID_FLOPPY_DESTRUCTION_PARTICLE
				
				item->x += item->speed * cos(item->direction)
				item->y += item->speed * -sin(item->direction)
				item->speed *= FLOPPY_PARTICLE_FRICTION
				item->y += GRAVITY
				
				if Timer - item->initialization_time > 0.5 then
					item->delete_me=true
				end if
				
			case ITEM_ID_ENEMY_HURT_FLASH
				
				if Timer - item->initialization_time > 0.45 then
					item->delete_me=true
				end if
				
			case ITEM_ID_BLINK
				
				if Timer - item->initialization_time > 1 then
					item->delete_me=true
				end if
		
			case ITEM_ID_MSG_LABEL
				item-> y -= 2
				if Timer - item->initialization_time > 1.5 then
					item->delete_me=true
				end if
		
			case ITEM_ID_BOX_DESTRUCTION_PARTICLE
				item->x += item->speed * cos(item->direction)
				item->y += item->speed * -sin(item->direction)
				item->speed *= PLAYER_BULLET_FRICTION
				item->y += GRAVITY
				'delete this item after a while
				if Timer - item->initialization_time > 0.5 then
					item->delete_me=true
				end if
		
			case ITEM_ID_PLAYER_BULLET_DIRECTIONAL to ITEM_ID_PLAYER_BULLET
			
				
					item->x += item->speed * cos(item->direction)
					item->y += item->speed * -sin(item->direction)
					
					if item->id = ITEM_ID_PLAYER_BULLET then
						item->speed *= PLAYER_BULLET_FRICTION
						item->y += GRAVITY
					else
						if 	(Timer - item->initialization_time) > _
							ITEM_ID_PLAYER_BULLET_DIRECTIONAL_SPAN_LIFE then
								item->delete_me = true
								'create some fog
								this.items = this.add_item(@this.items, item->x, item->y, ITEM_LITTLE_W, ITEM_LITTLE_H, 0, 0, ITEM_ID_CLOUD, "", 0, difficulty_ratio)

						end if
					end if
					
					'delete the bullet if it goes outside the level or touches any solid block
					if item->x < 0 or item-> y < 0 then item->delete_me = true
					
					item->get_bounding_tiles(TILE_W, TILE_H, Ubound(this.tiles), Ubound(this.tiles, 2))
					
					for j = item->bounding_tile(3) to item->bounding_tile(1)
						for i = item->bounding_tile(0)  to item->bounding_tile(2)
							'SOLID BLOCKS
						if tiles(i, j).attributes.tile_type = 1 and tiles(i, j).attributes.id <> block_semi_block and tiles(i, j).attributes.id <> block_null then
							for k = 0 to 9
								this.items = this.add_item(@this.items, item->x, item->y, 4, 4, _PI/4 + rnd*(_PI_HALF), GRAVITY*2, ITEM_ID_FLOPPY_DESTRUCTION_PARTICLE, "", 0, difficulty_ratio)
							next k
							
							item->delete_me=true
							'generate some particles
							'destroy the box, if hitted
							if tiles(i, j).attributes.id = block_wood_box then
								tiles(i, j).attributes.tile_type = 0
								tiles(i, j).attributes.id = 0
								'generate some particles
								for k = 0 to 9
									this.items = this.add_item(	@this.items, item->x, item->y, 4, 4, _
																_PI_QUARTER + rnd*(_PI_HALF), _
																GRAVITY*2, _
																ITEM_ID_BOX_DESTRUCTION_PARTICLE, "", 0, difficulty_ratio)
								next k
								sound_handler.set_queued_sound(SFX_WOOD_BOX_EXPLOSION)

							end if
						end if
						
						next i
					next j
				
			'platoform up/down
			case ITEM_ID_UPDOWN_PLATFORM
				item->get_bounding_tiles(TILE_W, TILE_H, Ubound(this.tiles), Ubound(this.tiles, 2))
				
				for j = item->bounding_tile(3) to item->bounding_tile(1)
					for i = item->bounding_tile(0)  to item->bounding_tile(2)
						dim reverse as boolean
						reverse = false
						'SOLID BLOCKS
						if tiles(i, j).attributes.tile_type = 1  then
								'BOTTOM
								if is_point_into_area(item->x , item->y + item->h, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
									item->y = i * TILE_H - item->h
									reverse = true
								end if
								'TOP
								if is_point_into_area(item->x , item->y, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
									item->y = i * TILE_H + TILE_H + 1
									reverse = true
								end if
								
								if reverse then
									if (item->direction) > 0 then
										item->direction = -item->direction
										item->sprite_offset = 5
									else
										item->direction = -item->direction
										item->sprite_offset = 0
									end if
								end if
							end if
						next i
				next j
				
				item->y += item->speed * -sin(item->direction)
			
			'enemy
			case ITEM_ID_ENEMY
				
				
				'update position__________________________________________________
				select case item->enemy_type
					case ENEMY_TYPE_FLYING_ROBOT
						item->y += item->speed * -sin(item->direction)
					case ENEMY_TYPE_BLACK_BALL
						item->x += item->speed * cos(item->direction)
					case else
						item->x += item->speed * cos(item->direction)
						item->y += GRAVITY
				end select
				
				
				if item->is_hurt andalso CBool (Timer - item->is_hurt_begin_time > 0.5) then
					item->is_hurt = false
				end if

				item->get_bounding_tiles(TILE_W, TILE_H, Ubound(this.tiles), Ubound(this.tiles, 2))
				
				for j = item->bounding_tile(3) to item->bounding_tile(1)
					for i = item->bounding_tile(0)  to item->bounding_tile(2)
						dim reverse as boolean
						reverse = false
						'SOLID BLOCKS
						if tiles(i, j).attributes.tile_type = 1  then
						
							select case item->enemy_type
						
								case ENEMY_TYPE_FLYING_ROBOT
									'BOTTOM
									if is_point_into_area(item->x + item->w\2, item->y + item->h, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
										item->y = i * TILE_H - item->h
										reverse = true
									end if
									'TOP
									if is_point_into_area(item->x + item->w\2, item->y, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
										item->y = i * TILE_H + TILE_H + 1
										reverse = true
									end if
									
									if reverse then
										if (item->direction) > 0 then
											item->direction = -item->direction
											item->sprite_offset = 5
										else
											item->direction = -item->direction
											item->sprite_offset = 0
										end if
									end if
								
								case else
							
									
								
									'COLLISION CHECK WITH THE TILES______________________________________________________________________________________________
								
									'RIGHT
									if is_point_into_area(item->x + item->w, item->y + item->h\2, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
										item->x = j * TILE_W - item->w - 1
										reverse = true
									end if
									'BOTTOM
									if is_point_into_area(item->x + item->w\2, item->y + item->h, j * TILE_W, i*TILE_H, j * TILE_W+TILE_W, i*TILE_H+TILE_H) then
										item->y = i * TILE_H - item->h
									end if
									''LEFT
									if is_point_into_area(item->x , item->y + item->h\2, j * TILE_W, i*TILE_H, j * TILE_W + TILE_W, i*TILE_H+TILE_H) then
										item->x = (j+1) * TILE_W 
										reverse = true
									end if
									
									if reverse then
										if abs (item->direction) = 0 then
											item->direction = _PI
											item->sprite_offset = 5
										else
											item->direction = 0
											item->sprite_offset = 0
										end if
									end if
								
							end select
						end if

					next i
					
				next j
				
				
				
				
				
				'interaction with the player
				
				select case item->enemy_type
				
					case ENEMY_TYPE_BLACK_BALL 
						'check distance in order to fire against the player
						'fire once after the enemy interval has passed
						if 	timer - item->initialization_time > ENEMY_TYPE_BLACK_BALL_INTERVAL andalso	_					
							manhattan_distance (item->x, item->y, player_position.x, player_position.y) _
							< ENEMY_TYPE_BLACK_BALL_MIN_DISTANCE_ACTIVATION then
							
							item->initialization_time = Timer
					
							this.items = this.add_item(@this.items, item->x + item->w\2, item->y, ITEM_LITTLE_W, ITEM_LITTLE_H, _
							- _PI_HALF, ITEM_ID_FLYING_BOMB_SPEED, ITEM_ID_FLYING_BOMB, "",0, difficulty_ratio)
							
							sound_handler.set_queued_sound(SFX_BULLET_1_LAUNCH)

							
						end if
	
					case ENEMY_TYPE_GREEN_GUY
						if 	timer - item->initialization_time > ENEMY_TYPE_GREEN_GUY_INTERVAL andalso	_
							manhattan_distance (item->x + 100 * cos (item->direction), item->y, player_position.x, player_position.y)_
							< ENEMY_TYPE_GREEN_GUY_MIN_DISTANCE_ACTIVATION  then
							
							item->initialization_time = Timer
							
							this.items = this.add_item(@this.items, item->x + item->w\2, item->y, _
							ITEM_LITTLE_W, ITEM_LITTLE_H, _
							_PI_HALF/2 - (_PI_HALF * CLng(player_position.x < item->x)), _
							sqr(GRAVITY_ACCEL * distance (item->x, item->y, player_position.x, player_position.y)/ sin (_PI_HALF/2)), _
							ITEM_ID_BALLISTIC_ENEMY_BULLET, "",0, difficulty_ratio)
							
							sound_handler.set_queued_sound(SFX_BULLET_1_LAUNCH)
						
							if item->x < player_position.x then
								item->direction = 0
								item->sprite_offset = 0
							else
								item->direction = _PI
								item->sprite_offset = 5
							end if
						
						end if
						
					case ENEMY_TYPE_FLYING_ROBOT
						'check distance in order to fire against the player
						'fire once after the enemy interval has passed
						if 	timer - item->initialization_time > ENEMY_TYPE_FLYING_ROBOT_INTERVAL andalso	_					
							manhattan_distance (item->x, item->y, player_position.x, player_position.y) _
							< ENEMY_TYPE_FLYING_ROBOT_MIN_DISTANCE_ACTIVATION then
							
							item->initialization_time = Timer
							this.items = this.add_item(@this.items, item->x, item->y, ITEM_LITTLE_W, ITEM_LITTLE_H, _
											_abtp(item->x, item->y, player_position.x, player_position.y),	_		
											6, ITEM_ID_MISSILE, "", 0, difficulty_ratio)
											
							sound_handler.set_queued_sound(SFX_BULLET_2_LAUNCH)
						end if
					
				
						
					case ENEMY_TYPE_EYEGLASS_GUY 
						'turn himself in direction of the player if the player is too close
						if 	manhattan_distance (item->x, item->y, player_position.x, player_position.y) _
							< ENEMY_TYPE_EYEGLASS_GUY_MIN_DISTANCE_ACTIVATION then
							
							if item->x < player_position.x then
								item->direction = 0
								item->sprite_offset = 0
							else
								item->direction = _PI
								item->sprite_offset = 5
							end if
							
							'fire against the player
							if 	timer - item->initialization_time > ENEMY_TYPE_EYEGLASS_GUY_INTERVAL then
							
								item->initialization_time = Timer
										
								this.items = this.add_item(@this.items, item->x + item->w\2, item->y, ITEM_LITTLE_W, ITEM_LITTLE_H, _
								_abtp(item->x, item->y, player_position.x, player_position.y), (rnd*2) + 7, _
								ITEM_ID_ENEMY_BULLET_0, "",0, difficulty_ratio)
								
								sound_handler.set_queued_sound(SFX_BULLET_1_LAUNCH)
								
							end if
							
						end if
						
					
					case ENEMY_TYPE_FLOOR_SPIDER
						'if the player is too close, it goes toward the player running VERY fast!
						if manhattan_distance (item->x, item->y, player_position.x, player_position.y) < ENEMY_TYPE_FLOOR_SPIDER_MIN_DISTANCE_ACTIVATION then
					
							if item->speed < item->speed_default * 2 then
								item->speed *=1.05
							end if
							
							
							if item->x < player_position.x then
								item->direction = 0
								item->sprite_offset = 0
							else
								item->direction = _PI
								item->sprite_offset = 5
							end if
						
						else
							item -> speed =  item->speed_default
						end if
						
					'the programmer, in idle mode, moves himself in a random way, runs at random speed
					'at random intervals and also turn randomly
					case ENEMY_TYPE_PROGRAMMER
						
						'if the player is too close, him goes toward the player
						if 	manhattan_distance (item->x + cos(item->direction)*ENEMY_TYPE_PROGRAMMER_MIN_DISTANCE_ACTIVATION, item->y, player_position.x, player_position.y) _
							< ENEMY_TYPE_PROGRAMMER_MIN_DISTANCE_ACTIVATION then
					
							if item->speed < item->speed_default*2 then
								item->speed *=1.1
							end if
							
							if item->x < player_position.x then
								item->direction = 0
								item->sprite_offset = 0
							else
								item->direction = _PI
								item->sprite_offset = 5
							end if
							
							'fire against the player
							
							if 	timer - item->initialization_time > ENEMY_TYPE_PROGRAMMER_INTERVAL then
							
								item->initialization_time = Timer
								
								this.items = this.add_item(@this.items, item->x + item->w\2, item->y, _
								ITEM_LITTLE_W, ITEM_LITTLE_H, _
								_PI_HALF/2 - (_PI_HALF * CLng(player_position.x < item->x)), _
								sqr(GRAVITY_ACCEL * distance (item->x, item->y, player_position.x, player_position.y)/ sin (_PI_HALF/2)) + 3, _
								ITEM_ID_BALLISTIC_ENEMY_BULLET, "",0, difficulty_ratio)
								
								sound_handler.set_queued_sound(SFX_BULLET_3_LAUNCH)
							
							end if
							
							
						
						else
							if 	timer - item->initialization_time > 5 then
							item->speed = rnd(item->speed_default - 1) + 1
							item->initialization_time = Timer + (rnd*2)
								if frac(item->initialization_time) mod 2 then
									item->direction = 0
									item->sprite_offset = 0
								else
									item->direction = _PI
									item->sprite_offset = 5
								end if
							end if
						end if
						
					case ENEMY_TYPE_CHARLES_BRONSON
						'if the player is too close, him fire against him
						if 	timer - item->initialization_time > ENEMY_TYPE_CHARLES_BRONSON_INTERVAL andalso	_
							manhattan_distance (item->x, item->y, player_position.x, player_position.y)_
							< ENEMY_TYPE_CHARLES_BRONSON_MIN_DISTANCE_ACTIVATION  then
							
							item->initialization_time = Timer
							'fire against the player
							this.items = this.add_item(@this.items, item->x + item->w\2, item->y, ITEM_LITTLE_W, ITEM_LITTLE_H, _
										_abtp(item->x, item->y, player_position.x, player_position.y), (rnd*2) + 7, _
										ITEM_ID_ENEMY_BULLET_0, "",0, difficulty_ratio)
										
							sound_handler.set_queued_sound(SFX_BULLET_1_LAUNCH)
						
							if item->x < player_position.x then
								item->direction = 0
								item->sprite_offset = 0
							else
								item->direction = _PI
								item->sprite_offset = 5
							end if
						
						end if


				end select
				
				'each enemy (except the flying robot) turns in direction of the player if hitted by a his floppy_______
				'follow the player if hitted from a floppy
				if item->is_hurt andalso CBool(item->enemy_type <> ENEMY_TYPE_FLYING_ROBOT) then
				
					if item->x < player_position.x then
						item->direction = 0
						item->sprite_offset = 0
					else
						item->direction = _PI
						item->sprite_offset = 5
					end if
				
				end if

				'_________________________________________________________________
				

				
				'check collision of the enemies with player bullets ot with the horse___________
				
				dim other_objects as item_proto ptr
				dim points_to_be_added as Ulong
				
				other_objects = this.items
				while (other_objects <> NULL)
				
					'collision with the horse____________________________________________
					if not item->delete_me andalso _
						CBool(other_objects -> id = ITEM_ID_HORSE_FACING_RIGHT) orelse _
						CBool(other_objects -> id = ITEM_ID_HORSE_FACING_LEFT) andalso _
						is_collision(item->x, item->y, _
										item->x+ item->w, item->y + item->h, _
										other_objects->x, other_objects->y, _
										other_objects->x + other_objects->w, _
										other_objects->y + other_objects->h) then
						
						item->	energy = 0
						
						'some flashing while the enemy is hurt
						this.items = this.add_item(@this.items, item->x, item->y, _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0, 0, _
													ITEM_ID_ENEMY_HURT_FLASH, "", 0, difficulty_ratio)
													
					end if
				
					'collision with player bullets_______________________________________
					if 	not item->delete_me andalso _
						CBool(other_objects -> id = ITEM_ID_PLAYER_BULLET) orelse _
						CBool(other_objects -> id = ITEM_ID_PLAYER_BULLET_DIRECTIONAL) andalso _
						is_collision(item->x, item->y, _
										item->x+ item->w, item->y + item->h, _
										other_objects->x, other_objects->y, _
										other_objects->x + other_objects->w, _
										other_objects->y + other_objects->h) then
						'collision with floppy subtracts energy from enemy
						
							'subtract the energy
							item->energy -= FLOPPY_ENERGY
							'delete the floppy
							other_objects->	delete_me = true
							
							'some flashing while the enemy is hurt
							this.items = this.add_item(@this.items, other_objects->x, other_objects->y, _
														ITEM_LITTLE_W, ITEM_LITTLE_H, 0, 0, _
														ITEM_ID_ENEMY_HURT_FLASH, "", 0, difficulty_ratio)
							
							item->is_hurt = true
							item->is_hurt_begin_time = Timer
							
					end if
						
					if CBool(item->energy <= 0) andalso not item->delete_me then
					
						item->			delete_me = true
						
						'add points to the player
						select case item->enemy_type
							case ENEMY_TYPE_GREEN_ROBOT
								points_to_be_added = ENEMY_TYPE_GREEN_ROBOT_POINTS * difficulty_ratio
							case ENEMY_TYPE_BLACK_BALL
								points_to_be_added = ENEMY_TYPE_BLACK_BALL_POINTS * difficulty_ratio
							case ENEMY_TYPE_GREEN_GUY
								points_to_be_added = ENEMY_TYPE_GREEN_GUY_POINTS * difficulty_ratio
							case ENEMY_TYPE_EYEGLASS_GUY
								points_to_be_added = ENEMY_TYPE_EYEGLASS_GUY_POINTS * difficulty_ratio
							case ENEMY_TYPE_FLYING_ROBOT
								points_to_be_added = ENEMY_TYPE_FLYING_ROBOT_POINTS * difficulty_ratio
							case ENEMY_TYPE_FLOOR_SPIDER
								points_to_be_added = ENEMY_TYPE_FLOOR_SPIDER_POINTS * difficulty_ratio
							case ENEMY_TYPE_PROGRAMMER
								points_to_be_added = ENEMY_TYPE_PROGRAMMER_POINTS * difficulty_ratio
							case ENEMY_TYPE_CHARLES_BRONSON
								points_to_be_added = ENEMY_TYPE_CHARLES_BRONSON_POINTS * difficulty_ratio
							case ENEMY_TYPE_JASC
								points_to_be_added = ENEMY_TYPE_JASC_POINTS * difficulty_ratio
							case else
								points_to_be_added = 100 * difficulty_ratio
						end select
						
						*points += points_to_be_added
						this.create_floating_label (item->x, item->y, "+ " + str(points_to_be_added))
						'some blinking
						this.items = this.add_item(@this.items, item->x, item->y, _
													ITEM_LITTLE_W, ITEM_LITTLE_H, 0, 0, _
													ITEM_ID_BLINK, "", 0, difficulty_ratio)
						
						'if the difficulty ratio is > 1 and the enmy is not a green robot
						'create a bouns: coin, medpack, sys64738, 1 up or powerup
						
						if difficulty_ratio > 1 andalso item->enemy_type <> ENEMY_TYPE_GREEN_ROBOT then
							k = int(rnd* 100)
							select case k
								case 0 to 70
									this.items = this.add_item(	@this.items, item->x, item->y, _
												ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_COIN, "",0, difficulty_ratio)
								case 71 to 80
									this.items = this.add_item(	@this.items, item->x, item->y, _
												ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_AMMO_FLOPPY, "",0, difficulty_ratio)
								case 81 to 90
									this.items = this.add_item(	@this.items, item->x, item->y, _
												ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_MEDPACK, "",0, difficulty_ratio)
								case 91 to 95
									this.items = this.add_item(	@this.items, item->x, item->y, _
												ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_SYS64738, "",0, difficulty_ratio)
								case 96
									this.items = this.add_item(	@this.items, item->x, item->y, _
												ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_1UP, "",0, difficulty_ratio)
								case else
									this.items = this.add_item(	@this.items, item->x, item->y, _
												ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_POWER_UP, "",0, difficulty_ratio)
							end select
						else
							this.items = this.add_item(	@this.items, item->x, item->y, _
												ITEM_LITTLE_W, ITEM_LITTLE_H, 0,0,ITEM_ID_COIN, "",0, difficulty_ratio)
						end if
		
					end if
				
				other_objects = other_objects->next_p
				wend
				'______________________________________________________________
				
				
				
		end select
		end if
		item = item->next_p
	wend
	
end sub

sub level_proto.create_floating_label (x as single, y as single, label as string)
	this.items = this.add_item(	@this.items, x, y, 0, 0, 0, 0, ITEM_ID_MSG_LABEL, label, 0, 0)
end sub


sub level_proto.draw_level(x as single, y as single, difficulty_ratio as single, image_buffer as FB.Image ptr)


	
	dim as integer i, j
	
	'wallpaper with parallax effect
	for i = -1 to 4
		for j = -1 to 4
			'wallpaper
			put image_buffer,  (	320*i - (x * 1.02) mod 320 , 240*j - y/16), this.wallpaper_2x(this.wallpaper_slot), pset
		next j
	next i
	
	for i = -1 to 4
		'scenario
		put image_buffer,  (	320*i - (x * 1.04) mod 320 , Ubound(tiles) * TILE_H - 240 - y), this.wallpaper_2x(this.scenario_slot), trans
	
	next i
	
	this.get_visible_tiles (x , y , TILE_W, TILE_H, Ubound(tiles), Ubound(tiles, 2))

	'draws only the visible tiles
	
	for j = this.visible_bounding_tile(3) to this.visible_bounding_tile(1)
		for i = this.visible_bounding_tile(0)  to this.visible_bounding_tile(2)
			
			
			'wallpaper blocks
			'just a bound check
			if this.tiles(i,j).attributes.id_wallp <256 andalso this.tiles(i,j).attributes.id_wallp >= 0 then
				put image_buffer,  (	this.tiles(i,j).x - x, _
										this.tiles(i,j).y - y ), _
										this.bitmap_wallpaper_2x(tiles(i,j).attributes.id_wallp), _
										trans
			end if
							
			
			
			'bitmap tiles
			select case this.tiles(i,j).attributes.tile_type 
				'blocks
				case 1 
					'do not draw null blocks, those are placed only in order to create a perimeter for the enemies
					
					
					if this.tiles(i,j).attributes.id <> block_null then
						
						select case this.tiles(i,j).attributes.id
							case block_roll_chemical_poison
							
							put image_buffer, (	this.tiles(i,j).x - x, _
												this.tiles(i,j).y - y ), _
												this.sprites_block_moving_2x(BLOCK_CHEMICAL_POISON_ID_SPRITE + (CUlng(timer*10)) mod 4), _
												trans
							case block_roll_clockwise
							
							put image_buffer, (	this.tiles(i,j).x - x, _
												this.tiles(i,j).y - y ), _
												this.sprites_block_moving_2x((CUlng(timer*10)) mod 4), _
												trans
												
							case block_roll_counterclockwise
							
							put image_buffer, (	this.tiles(i,j).x - x, _
												this.tiles(i,j).y - y ), _
												this.sprites_block_moving_2x(BLOCK_ROLL_CCLOCKWISE_ID_SPRITE + (CUlng(timer*10)) mod 4), _
												trans
							
							case block_evanescence
							
							put image_buffer, (	this.tiles(i,j).x - x, _
												this.tiles(i,j).y - y ), _
												this.sprites_block_moving_2x(BLOCK_EVANESCENCE_ID_SPRITE +3 - (this.tiles(i,j).attributes.power -1)\25), _
												trans
							
							
							case else
							'just a bound check
							if (tiles(i,j).attributes.id) < 32 then
								put image_buffer,  (	this.tiles(i,j).x - x, _
														this.tiles(i,j).y - y ), _
														this.bitmap_block_2x(tiles(i,j).attributes.id), _
														trans
							end if
							
							
							
						end select
					
					end if
					
					
				

			end select
			

		next i
	next j
	
	
	
	this.draw_items(items, x , y , difficulty_ratio, image_buffer)
	
		
	
end sub

sub level_proto.update_level_blocks()
	dim as ulong i, j

	for i = 0 to Ubound(this.tiles)
		for j = 0 to (Ubound(this.tiles,2))
			'if this.tiles(i,j).attributes.tile_type = 1 and this.tiles(i,j).attributes.id = block_horizontal_moving then
					'this.tiles(i,j).x += rnd * 2
			
			'end if
				
			
		next j
	next i

end sub


sub level_proto.delete_visible_items (x1 as Long, y1 as Long, x2 as Long, y2 as Long, item_id as Ulong)
	dim as item_proto ptr temp, head
	head = this.items
	
	while (head <> NULL)
		temp = Head
		head = temp->next_p
		
		if 	temp->id = item_id andalso _
			temp->x > x1 andalso temp->x < x2 andalso _ 
			temp->y > y1 andalso temp->y < y2 then
		
			temp->delete_me = true
		end if
	wend
end sub

sub level_proto.get_visible_tiles (x as single, y as single, w as Ulong, h as Ulong, lr as Ulong, lc as Ulong)

	this.visible_bounding_tile(0) = (y) \ h 
	this.visible_bounding_tile(3) = (x) \ w 
	this.visible_bounding_tile(1) = (x+SCR_W) \ w 
	this.visible_bounding_tile(2) = (y+SCR_H) \ h 
	
	'bounding check
	if (this.visible_bounding_tile(3) < 0) 		then this.visible_bounding_tile(3)	= 0
	if (this.visible_bounding_tile(3) > lc) 	then this.visible_bounding_tile(3)	= lc
	if (this.visible_bounding_tile(1) < 0) 		then this.visible_bounding_tile(1) 	= 0
	if (this.visible_bounding_tile(1) > lc) 	then this.visible_bounding_tile(1) 	= lc
	if (this.visible_bounding_tile(0) < 0) 		then this.visible_bounding_tile(0) 	= 0
	if (this.visible_bounding_tile(0) > lr) 	then this.visible_bounding_tile(0) 	= lr
	if (this.visible_bounding_tile(2) < 0) 		then this.visible_bounding_tile(2) 	= 0
	if (this.visible_bounding_tile(2) > lr) 	then this.visible_bounding_tile(2)	= lr

end sub


sub level_proto.set_time_left(timing as Ulong)

	this.time_left = Timer + timing

end sub

function level_proto.get_time_left() as Long

	return Clng (this.time_left - Timer)
	
end function

sub level_proto.load_custom_block_icons(slot as Ulong)
	'dim i as Ulong
	'#IFDEF DEBUG_MODE
	'utility_consmessage("loading block tiles from: " + "img/block_icons_" + str(slot) + ".bmp")
	'#ENDIF
	'load_sprite_sheet 	(this.bitmap_block(), 		512, 48, 16, 2,	"img/block_icons.bmp")
	''load_sprite_sheet 	(this.bitmap_block(), 		512, 48, 16, 2,	"img/block_icons_" + str(slot) + ".bmp")
	
	'for i = 0  to Ubound(this.bitmap_block)
		'this.bitmap_block_2x		(i) = imagescale(this.bitmap_block(i), TILE_W, TILE_H)
	'next i
	
end sub


sub level_proto.set_scenario_slot(byval slot as Ulong)
	this.scenario_slot = slot
end sub

sub level_proto.set_wallpaper_slot(byval slot as Ulong)
	this.wallpaper_slot = slot
end sub


sub level_proto.load_block_icons(slot as Ulong)

	load_sprite_sheet 	(this.bitmap_block(), 		512, 48, 16, 2,	"img/block_icons_" + str(slot) + ".bmp")
	
	for i as Ulong = 0 to Ubound(this.bitmap_block)
		this.bitmap_block_2x		(i) = imagescale(this.bitmap_block(i), TILE_W, TILE_H)
	next i

end sub

sub level_proto.load_txt (filename as string, txt() as string)

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
