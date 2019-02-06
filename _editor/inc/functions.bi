'functions declarations
declare function _abtp 			(x1 as integer,y1 as integer,x2 as integer,y2 as integer) as single
declare function add_point		(head as point_proto ptr ptr, x as single, y as single) as point_proto ptr
declare function dist 				(x1 as single, y1 as single, x2 as single, y2 as single) as single
'fbGFXAddon by D.J. Peters  
declare function ImageScale		(byval s as fb.Image ptr, _
								byval w as integer, _
								byval h as integer) as fb.Image ptr
								
'Bmp load by noop
declare function Load_bmp( ByRef filename As Const String ) As Any Ptr

declare function calculate_bounds (head as point_proto ptr, centroid as point_proto) as segment_proto
declare function is_overlap( 	Ax1 as single, Ay1 as single, _
								Ax2 as single, Ay2 as single, _
								Bx1 as single, By1 as single, _
								Bx2 as single, By2 as single ) as boolean
								
							
declare function get_tile_choords (	User_mouse as mouse_proto, _
							view_area as view_area_proto, _
							ubound_x as Ulong, _
							ubound_y as Ulong)  as tile_choords_proto
declare function get_icon_selected (icons() as tile_proto, user_mouse as mouse_proto) as Ulong
declare function mouse_wheel_limit (id as Ulong, diff as Ulong, limit as Ulong) as Ulong

'subs declarations______________________________________________________

declare sub add_column_to_level (level_tiles() as tile_proto)
declare sub add_row_to_level (level_tiles() as tile_proto)
declare sub erase_level_data (level_tiles() as tile_proto)
declare sub keyboard_listener(	tile_mode as proto_tile_mode ptr, _
								user_mouse as mouse_proto, _
								view_area as view_area_proto ptr, _
								settings as settings_proto ptr, _
								keyboard as keyboard_proto, _
								level_tiles() as tile_proto,_
								gui as gui_proto ptr,_
								tile_attributes as proto_tile_attributes ptr)
declare sub mouse_listener		(user_mouse as mouse_proto ptr, _
								view_area as view_area_proto ptr)
declare sub reset_key_status(key as key_proto ptr)
declare sub save_level_file(level_tiles() as tile_proto, file_name as string)


declare sub load_whole_txt_file			(Byref fn As String,  filearr() As String)
declare sub draw_button 			(x as integer, y as integer, w as integer,_
									h as integer, label as string,_
									is_selected as boolean)
declare sub draw_bottom_info (	tile_mode as proto_tile_mode, _
								view_area as view_area_proto, _
								user_mouse as mouse_proto, _
								settings as settings_proto, _
								timer_begin as double, _
								on_screen_help() as string)
declare sub load_icon_set ( 	bmp() as Ulong ptr, w as integer, _
								h as integer, cols as integer, rows as integer, _
								Byref bmp_path as string)
declare sub draw_mouse_pointer	(	x as integer, y as integer, _
									lbtn_pressed as boolean, _
									is_snap_point_available as boolean, _
									tile_mode as proto_tile_mode, _
									icon_set() as Ulong ptr)

declare sub get_selection_bounds (user_mouse as mouse_proto ptr)

declare function is_over ( 		Ax1 as integer, Ay1 as integer, _
						Ax2 as integer, Ay2 as integer, _
						Bx as integer, By as integer ) as boolean
declare sub deselect_all_items (items() as tile_proto)
declare sub deselect_all_level_tiles (items() as tile_proto)

declare sub draw_gui (	icons() as tile_proto, user_mouse as mouse_proto, _
						icon_set() as Ulong ptr, block_icons_2x() as Ulong ptr)
						
declare sub draw_level(	level_tiles() as tile_proto, user_mouse as mouse_proto,_
						view_area as view_area_proto, _
						block_icons() as Ulong ptr, _
						object_icons() as Ulong ptr, _
						meta_icons() as Ulong ptr, _
						wallp_icons() as Ulong ptr, _
						enemies_sprites() as Ulong ptr)
						
declare sub init_level_tiles (level_tiles() as tile_proto)
declare sub init_gui(icons() as tile_proto)

declare sub load_level_file (filename as string, level_tiles() as tile_proto)
declare sub draw_single_tile_icon (x as Ulong, y as Ulong, icon as FB.Image ptr)
declare sub draw_tile_attributes (tile_attributes as proto_tile_attributes, tab_id as Ulong)

declare function get_right_solid_block(col as Ulong, row as Ulong, level_tiles() as tile_proto, block_combinations() as Ubyte) as proto_block_type

declare sub erase_enter_location (level_tiles() as tile_proto)
declare sub erase_exit_location (level_tiles() as tile_proto)

declare sub remove_row_from_level (level_tiles() as tile_proto)
declare sub remove_column_from_level (level_tiles() as tile_proto)

function get_right_solid_block(col as Ulong, row as Ulong, level_tiles() as tile_proto, block_combinations() as Ubyte) as proto_block_type
	dim right_solid_block as proto_block_type
	dim perimeter as Ubyte
	dim tile_attributes as proto_tile_attributes
	dim as Ubyte i, j, c
	c = 0
	perimeter = 0
	dim is_pattern_found as boolean
	is_pattern_found = false

	'calc if there are tiles in the perimeter

	' 0 0 0
	' 0 X 0
	' 0 0 0
	

	for i = col-1 to col+1
		for j = row-1 to row+1
			tile_attributes.value = level_tiles(i,j).value
			if tile_attributes.tile_type = 1 and tile_attributes.id  <= block_edge_top and tile_attributes.id > 0 then ' block tile
				select case c
					case 0
						perimeter = perimeter or &b10000000
					case 1
						perimeter = perimeter or &b01000000
					case 2
						perimeter = perimeter or &b00100000
					case 3
						perimeter = perimeter or &b00010000
					'dont' calc the 4 because it's the center	
					
					case 5
						perimeter = perimeter or &b00001000
					case 6
						perimeter = perimeter or &b00000100
					case 7
						perimeter = perimeter or &b00000010
					case 8
						perimeter = perimeter or &b00000001
				end select
			end if
			c+=1
		next j
	next i
	
	
	draw string (50, 200), str(bin(perimeter))
	
	for i = 0 to Ubound (block_combinations)
		if perimeter = block_combinations(i,0) then
			right_solid_block = block_combinations(i,1)
			is_pattern_found = true
			exit for
		end if
	next i
	
	if not is_pattern_found then
		right_solid_block = block_full
	end if
		

	return right_solid_block

end function



'_______________________________________________________________________

'FUNCTIONS______________________________________________________________
function _abtp (x1 as integer,y1 as integer,x2 as integer,y2 as integer) as single
	return -Atan2(y2-y1,x2-x1)
end function



function dist (x1 as single, y1 as single, x2 as single, y2 as single) as single
    return Sqr(((x1-x2)*(x1-x2))+((y1-y2)*(y1-y2)))
end function


'fbGFXAddon by D.J. Peters
function ImageScale(byval s as fb.Image ptr, _
                    byval w as integer, _
                    byval h as integer) as fb.Image ptr
  #macro SCALELOOP()
  for ty = 0 to t->height-1
    ' address of the row
    pr=ps+(y shr 20)*sp
    x=0 ' first column
    for tx = 0 to t->width-1
      *pt=pr[x shr 20]
      pt+=1 ' next column
      x+=xs ' add xstep value
    next
    pt+=tp ' next row
    y+=ys ' add ystep value
  next
  #endmacro
  ' no source image
  if s        =0 then return 0
  ' source widh or height legal ?
  if s->width <1 then return 0
  if s->height<1 then return 0
  ' target min size ok ?
  if w<2 then w=1
  if h<2 then h=1
  ' create new scaled image
  dim as fb.Image ptr t=ImageCreate(w,h,RGB(0,0,0))
  ' x and y steps in fixed point 12:20
  dim as FIXED xs=&H100000*(s->width /t->width ) ' [x] [S]tep
  dim as FIXED ys=&H100000*(s->height/t->height) ' [y] [S]tep
  dim as integer x,y,ty,tx
  select case as const s->bpp
  case 1 ' color palette
    dim as ubyte    ptr ps=cptr(ubyte ptr,s)+32 ' [p]ixel   [s]ource
    dim as uinteger     sp=s->pitch             ' [s]ource  [p]itch
    dim as ubyte    ptr pt=cptr(ubyte ptr,t)+32 ' [p]ixel   [t]arget
    dim as uinteger     tp=t->pitch - t->width  ' [t]arget  [p]itch
    dim as ubyte    ptr pr                      ' [p]ointer [r]ow
    SCALELOOP()
  case 2 ' 15/16 bit
    dim as ushort   ptr ps=cptr(ushort ptr,s)+16
    dim as uinteger     sp=(s->pitch shr 1)
    dim as ushort   ptr pt=cptr(ushort ptr,t)+16
    dim as uinteger     tp=(t->pitch shr 1) - t->width
    dim as ushort   ptr pr
    SCALELOOP()
  case 4 ' 24/32 bit
    dim as ulong    ptr ps=cptr(Ulong ptr,s)+8
    dim as uinteger     sp=(s->pitch shr 2)
    dim as ulong    ptr pt=cptr(Ulong ptr,t)+8
    dim as uinteger     tp=(t->pitch shr 2) - t->width
    dim as ulong    ptr pr
    SCALELOOP()
  end select
  return t
  #undef SCALELOOP
end function

Function Load_bmp( ByRef filename As Const String ) As Any Ptr
	'Bmp load by noop
	'http://www.freebasic.net/forum/viewtopic.php?t=24586
    Dim As Long filenum, bmpwidth, bmpheight
    Dim As Any Ptr img

    '' open BMP file
    filenum = FreeFile()
    If Open( filename For Binary Access Read As #filenum ) <> 0 Then Return NULL

        '' retrieve BMP dimensions
        Get #filenum, 19, bmpwidth
        Get #filenum, 23, bmpheight

    Close #filenum

    '' create image with BMP dimensions
    img = ImageCreate( bmpwidth, Abs(bmpheight) )

    If img = NULL Then Return NULL

    '' load BMP file into image buffer
    If BLoad( filename, img ) <> 0 Then ImageDestroy( img ): Return NULL

    Return img

End Function

function mouse_wheel_limit (id as Ulong, diff as Ulong, limit as Ulong) as Ulong

	dim position as Long
	
	if multikey(SC_LSHIFT) then diff *= 10

	position = id + diff
	
	if position < 0 then position = 0
	if position > limit then position = limit

	return position
	
	
	

end function



Sub save_level_file(level_tiles() as tile_proto, file_name as string)

	Dim as integer i, j
	dim line_output as string


	Dim ff As UByte
	ff = FreeFile
	Open file_name for output As #ff
	
	for i = 0 to Ubound(level_tiles)
		line_output = ""
		for j = 0 to (Ubound(level_tiles,2))
			line_output = line_output + str(hex(level_tiles(i,j).value)) + ";"
		next j
		Print #ff, line_output
	next i
	
	Close #ff
	
end sub



sub keyboard_listener(	tile_mode as proto_tile_mode ptr, _
						user_mouse as mouse_proto, _
						view_area as view_area_proto ptr,_
						settings as settings_proto ptr, _
						keyboard as keyboard_proto, _
						level_tiles() as tile_proto,_
						gui as gui_proto ptr, _
						tile_attributes as proto_tile_attributes ptr)
						
	dim i as Ulong

	if keyboard.pressed( FB.SC_F1 ) then
		settings->is_help_visible = not settings->is_help_visible
	end if
	'navigate through tile values
	if keyboard.pressed( FB.SC_TAB ) then
		if (multikey(SC_LSHIFT)) or (multikey(SC_RSHIFT)) then 
			gui-> select_tab_id -=1
			if gui-> select_tab_id < 0 then
				gui->select_tab_id = gui->select_tab_id_max
			end if
		else
			gui-> select_tab_id +=1
			if gui-> select_tab_id > gui->select_tab_id_max then
				gui->select_tab_id = 0
			end if
		end if
	end if
	
	
	if keyboard.pressed( FB.SC_B ) then *tile_mode = mode_block
	
	if keyboard.pressed( FB.SC_D ) then settings->is_debug = not settings->is_debug
	if keyboard.pressed( FB.SC_E ) then *tile_mode = mode_empty
	if keyboard.pressed( FB.SC_O ) then *tile_mode = mode_object
	if keyboard.pressed( FB.SC_M ) then *tile_mode = mode_meta
	if keyboard.pressed( FB.SC_W ) then *tile_mode = mode_wallp
	if keyboard.pressed( FB.SC_S ) then *tile_mode = mode_select
	if keyboard.pressed( FB.SC_C ) andalso Cbool(*tile_mode = mode_select) then gui->copy = true
	if keyboard.pressed( FB.SC_T ) andalso Cbool(multikey( FB.SC_CONTROL )) then gui->paint_right_tiles = true
	'navigate the level
	if 	not (multikey(FB.SC_CONTROL)) then
	
		if keyboard.pressed( FB.SC_UP ) then view_area -> y +=TILE_H
		if keyboard.pressed( FB.SC_DOWN ) then view_area -> y -=TILE_H
		if keyboard.pressed( FB.SC_LEFT ) then view_area -> x +=TILE_W
		if keyboard.pressed( FB.SC_RIGHT ) then view_area -> x -=TILE_W
	end if
	'add row and columns to the level
	if 	(multikey(FB.SC_CONTROL)) andalso keyboard.pressed( FB.SC_UP ) 		then remove_row_from_level (level_tiles())
	if 	(multikey(FB.SC_CONTROL)) andalso keyboard.pressed( FB.SC_DOWN ) 	then add_column_to_level (level_tiles())
	if 	(multikey(FB.SC_CONTROL)) andalso keyboard.pressed( FB.SC_LEFT ) 	then remove_column_from_level (level_tiles())
	if 	(multikey(FB.SC_CONTROL)) andalso keyboard.pressed( FB.SC_RIGHT ) 	then add_row_to_level (level_tiles())
	

	if keyboard.pressed( FB.SC_DELETE ) andalso multikey( FB.SC_CONTROL )then
		erase_level_data (level_tiles())
	end if
		
	if multikey( FB.SC_SPACE ) then
		settings->is_hand_active = true
	else
		settings->is_hand_active = false
	end if

	'ENEMIES PRESETS -----------------------------------------------------
	if keyboard.pressed( FB.SC_0 ) then
		*tile_mode = mode_object
		tile_attributes->id = 4
		tile_attributes->other = ENEMY_TYPE_GREEN_ROBOT
	end if
	
	if keyboard.pressed( FB.SC_1 ) then
		*tile_mode = mode_object
		tile_attributes->id = 4
		tile_attributes->other = ENEMY_TYPE_BLACK_BALL
	end if
	
	if keyboard.pressed( FB.SC_2 ) then
		*tile_mode = mode_object
		tile_attributes->id = 4
		tile_attributes->other = ENEMY_TYPE_GREEN_GUY
	end if
	
	if keyboard.pressed( FB.SC_3 ) then
		*tile_mode = mode_object
		tile_attributes->id = 4
		tile_attributes->other = ENEMY_TYPE_EYEGLASS_GUY
	end if
	
	if keyboard.pressed( FB.SC_4 ) then
		*tile_mode = mode_object
		tile_attributes->id = 4
		tile_attributes->other = ENEMY_TYPE_FLYING_ROBOT
	end if
	
	if keyboard.pressed( FB.SC_5 ) then
		*tile_mode = mode_object
		tile_attributes->id = 4
		tile_attributes->other = ENEMY_TYPE_FLOOR_SPIDER
	end if
	
	if keyboard.pressed( FB.SC_6 ) then
		*tile_mode = mode_object
		tile_attributes->id = 4
		tile_attributes->other = ENEMY_TYPE_PROGRAMMER
	end if
	
	if keyboard.pressed( FB.SC_7 ) then
		*tile_mode = mode_object
		tile_attributes->id = 4
		tile_attributes->other = ENEMY_TYPE_CHARLES_BRONSON
	end if
	
	if keyboard.pressed( FB.SC_8 ) then
		*tile_mode = mode_object
		tile_attributes->id = 4
		tile_attributes->other = ENEMY_TYPE_JASC
	end if
	
	'Objects PRESETS---------------------------------------------------
	'updown platform
	if keyboard.pressed( FB.SC_U ) then
		*tile_mode = mode_object
		tile_attributes->id = 12
	end if
	
	'Keyword
	if keyboard.pressed( FB.SC_K ) then
		*tile_mode = mode_object
		tile_attributes->id = 1
	end if
	'floppy
	if keyboard.pressed( FB.SC_F ) then
		*tile_mode = mode_object
		tile_attributes->id = 3
	end if
	
	'block presets-------------------------------------------------------
	'limit
	if keyboard.pressed( FB.SC_Z ) then
		*tile_mode = mode_block
		tile_attributes->id = 0
	end if
	
	
	'platform
	if keyboard.pressed( FB.SC_P ) then
		*tile_mode = mode_block
		tile_attributes->id = 21
	end if
	'platform - evanescence
	if keyboard.pressed( FB.SC_V ) then
		*tile_mode = mode_block
		tile_attributes->id = 15
		tile_attributes->power = 100
	end if
	'platform wood boox
	if keyboard.pressed( FB.SC_X ) then
		*tile_mode = mode_block
		tile_attributes->id = 14
	end if
	
	'meta objects
	'enter location
	if keyboard.pressed( FB.SC_I ) then
		erase_enter_location (level_tiles())
	
		*tile_mode = mode_meta
		tile_attributes->id = 1
	end if
	'exit location
	if keyboard.pressed( FB.SC_Q ) then
		erase_exit_location (level_tiles())
	
		*tile_mode = mode_meta
		tile_attributes->id = 2
	end if



	
end sub




sub mouse_listener(user_mouse as mouse_proto ptr, view_area as view_area_proto ptr)
	static old_is_lbtn_pressed as boolean = false
	static old_is_rbtn_pressed as boolean = false
	
	static as integer old_x, old_y
	static store_xy as boolean = false
	static begin_store_xy as boolean = false
	dim as integer scalechange
	
	user_mouse->abs_x = int(user_mouse->x / view_area->zoom + (-view_area->x / view_area->zoom))
	user_mouse->abs_y = int(user_mouse->y / view_area->zoom + (-view_area->y / view_area->zoom))
	
	user_mouse->old_abs_x = int(user_mouse->old_x / view_area->zoom + (-view_area->x / view_area->zoom))
	user_mouse->old_abs_y = int(user_mouse->old_y / view_area->zoom + (-view_area->y / view_area->zoom))
	
	User_Mouse->diff_wheel = 0
	
	if User_Mouse->old_wheel < User_Mouse->wheel then
		User_Mouse->diff_wheel = 1
	end if
	if User_Mouse->old_wheel > User_Mouse->wheel  then
		User_Mouse->diff_wheel = -1
	end if
   

	'recognize if the left button has been pressed
	if User_Mouse->buttons and 1 then
		User_Mouse->is_lbtn_pressed = true
		
		user_mouse->drag_x2 = user_mouse->abs_x
		user_mouse->drag_y2 = user_mouse->abs_y
	else
		User_Mouse->is_lbtn_pressed = false
	end if
	
	'recognize if the right button has been pressed
	if User_Mouse->buttons and 2 then
		User_Mouse->is_rbtn_pressed = true
	else
		User_Mouse->is_rbtn_pressed = false
	end if
	
	'recognize if the left button has been released
	if old_is_lbtn_pressed = false and User_Mouse->is_lbtn_pressed and store_xy = false then 
		store_xy = true
	end if
	
	if store_xy then
		user_mouse->old_x = user_mouse->x
		user_mouse->old_y = user_mouse->y

		store_xy = false
		begin_store_xy = false
	end if
	
	'recognize if the left button has been released
	if old_is_lbtn_pressed and User_Mouse->is_lbtn_pressed = false then 
		User_Mouse->is_lbtn_released = true
	end if
	
	'recognize if the right button has been released
	if old_is_rbtn_pressed and User_Mouse->is_rbtn_pressed = false then 
		User_Mouse->is_rbtn_released = true
	end if
	
	'recognize drag
	if (User_Mouse->is_lbtn_pressed) and CBool((old_x <> user_mouse->x) or (old_y <> user_mouse->y)) then
		user_mouse->is_dragging = true
		'cuspid node
		if multikey(SC_ALT) then
			user_mouse->oppo_x = user_mouse->old_oppo_x
			user_mouse->oppo_y = user_mouse->old_oppo_y
		'normal node
		else
			user_mouse->oppo_x = User_Mouse->old_x - _
						cos (_abtp (User_Mouse->old_x, User_Mouse->old_y, User_Mouse->x, User_Mouse->y)) * _
						(dist(User_Mouse->old_x, User_Mouse->old_y, User_Mouse->x, User_Mouse->y))
			user_mouse->oppo_y = User_Mouse->old_y - _
						-sin(_abtp (User_Mouse->old_x, User_Mouse->old_y, User_Mouse->x, User_Mouse->y)) * _
						(dist(User_Mouse->old_x, User_Mouse->old_y, User_Mouse->x, User_Mouse->y))
			user_mouse->old_oppo_x = user_mouse->oppo_x
			user_mouse->old_oppo_y = user_mouse->oppo_y
		end if			
		
	else
		user_mouse->is_dragging = false
	end if
	
	if user_mouse->is_dragging and begin_store_xy = false then
		begin_store_xy = true
		user_mouse->drag_x1 = user_mouse->abs_x
		user_mouse->drag_y1 = user_mouse->abs_y
	end if
	
	
	   'store the old wheel state
	User_Mouse->old_wheel = User_Mouse->wheel
	'store the old state of left button
	old_is_lbtn_pressed = User_Mouse->is_lbtn_pressed
	'store the old state of left button
	old_is_rbtn_pressed = User_Mouse->is_rbtn_pressed
	
	
end sub


sub pop_values_in_array(array() as integer, eval as integer)
	'given a monodimensional re-dimmable array, pops all the data
	'that are equal to eval and resizes the array
	dim as integer i, j
	
	'transverse whole array, if the array(i) value
	'matches the eval, shift non-eval values of the array on the left.
	for i = Lbound(array) to Ubound(array)
		if array(i) = eval then 
			for j = (i + 1) to Ubound(array)
				if array(j) <> eval then
					swap array(j), array (i)
					exit for
				end if 
			next j
		end if
	next i
	
	'find new first eval value location
	for i = Lbound(array) to Ubound(array)
		if array(i) = eval then 
			exit for
		end if
	next i
	
	'redim the array
	redim preserve array(Lbound(array) to i-1) as integer
	
end sub





sub reset_key_status (key as key_proto ptr)
	key->is_released = false
	key->is_down = false
	key->old_is_down = false
end sub





function is_overlap( 	Ax1 as single, Ay1 as single, _
						Ax2 as single, Ay2 as single, _
						Bx1 as single, By1 as single, _
						Bx2 as single, By2 as single ) as boolean
						
	if (Ay2 < By1) or (Ay1 > By2) or (Ax2 < Bx1) or (Ax1 > Bx2) then
		return false
	else
		return true
	end if
	
end function

function is_over ( 		Ax1 as integer, Ay1 as integer, _
						Ax2 as integer, Ay2 as integer, _
						Bx as integer, By as integer ) as boolean
						
	if (Bx >= Ax1) and (Bx < Ax2) and (By >= Ay1) and (By < Ay2) then
		return true
	else
		return false
	end if
	
end function




SUB load_whole_txt_file(Byref fn As String,  filearr() As String)
    'Thanks to bulrush for this very useful sub
    'this is a snippet based on his source
    'http://www.freebasic.net/forum/viewtopic.php?f=7&t=24284
    'this sub read a whole text file and put it into an array
    Dim As Integer filenum,res,outpos,i,ub
    Dim As String procname,ln

    outpos 	= 1
    filenum = Freefile
    res 	= Open (fn, For Input, As #filenum)

	While (Not Eof(filenum))
		Line Input #filenum, ln ' Get one whole text line
		Redim Preserve filearr(outpos)
		filearr(outpos)	= ln
		outpos += 1
	Wend

    Close #filenum

    ub = Ubound(filearr)
END SUB

sub draw_button (x as integer, y as integer, w as integer,_
							h as integer, label as string,_
							is_selected as boolean)
							
	Line (x,y)-(x+w,y+h),C_GRAY,BF
	Line (x,y)-(x+w,y+h),C_WHITE,B
	
	if (is_selected) then
		Line (x,y)-(x+w,y+h),C_DARK_RED,BF
		Line (x,y)-(x+w,y+h),C_GRAY,B
	end if
	
	draw string (x + (w \ 2) - len(label)*4, y + h\2 - 2), label
	
end sub

sub draw_bottom_info (	tile_mode as proto_tile_mode, _
						view_area as view_area_proto, _
						user_mouse as mouse_proto, _
						settings as settings_proto, _
						timer_begin as double, _
						on_screen_help() as string)
			
	draw_button (0, 		0, BTN_W, BTN_H, "[E]MPTY",	 	(tile_mode xor 0))
	draw_button (BTN_W*1, 	0, BTN_W, BTN_H, "[B]LOCK",	 	(tile_mode xor mode_block))
	draw_button (BTN_W*2, 	0, BTN_W, BTN_H, "[O]BJECT",	(tile_mode xor mode_object))
	draw_button (BTN_W*3, 	0, BTN_W, BTN_H, "[M]ETA",		(tile_mode xor mode_meta))
	draw_button (BTN_W*4, 	0, BTN_W, BTN_H, "[W]ALLP",		(tile_mode xor mode_wallp))
	draw_button (BTN_W*5, 	0, BTN_W, BTN_H, "[S]ELECT",	(tile_mode xor mode_select))
	
	
	draw_button (SCR_W - BTN_W*2, 	0, BTN_W*2, BTN_H, _
				"x: " + str(user_mouse.abs_x) + ", y: " + str(user_mouse.abs_y),_
				true)
	'FPS
	dim fps as single = abs(int(1.0f/(timer_begin-timer)))
	
	draw_button (SCR_W - BTN_W, SCR_H - BTN_H, BTN_W, BTN_H, _
				"FPS: " + str(fps),	true)
				
	'F1 - HELP infos
	dim i as integer
	
	if (settings.is_help_visible) then
		for i = 0 to SCR_H step 2
			line(0, i)-(SCR_W, i), C_DARK_GRAY
		next i
		for i = 0 to Ubound(on_screen_help)-1
			draw string (21, 21 + i * 12), on_screen_help(i), C_BLACK
			draw string (20, 20 + i * 12), on_screen_help(i), C_WHITE
		next i
	end if
end sub




sub draw_mouse_pointer	(	x as integer, y as integer, _
							lbtn_pressed as boolean, _
							is_snap_point_available as boolean, _
							tile_mode as proto_tile_mode, _
							icon_set() as Ulong ptr)
	dim icon as proto_icon

	
	select case tile_mode

		case mode_hand
			if lbtn_pressed then
				icon = icon_hand_is_pressed
			else
				icon = icon_hand
			end if
		case else
			icon = icon_selection
	
	end select

	

	put (x-12, y), icon_set(icon), trans
	
end sub



sub get_selection_bounds (user_mouse as mouse_proto ptr)

	user_mouse->bounding_x1 = user_mouse->drag_x1
	user_mouse->bounding_y1 = user_mouse->drag_y1 
	user_mouse->bounding_x2 = user_mouse->drag_x2
	user_mouse->bounding_y2 = user_mouse->drag_y2
	if user_mouse->bounding_x1 > user_mouse->bounding_x2 then
		swap user_mouse->bounding_x1, user_mouse->bounding_x2
	end if
	if user_mouse->bounding_y1 > user_mouse->bounding_y2 then
		swap user_mouse->bounding_y1, user_mouse->bounding_y2
	end if

end sub



sub load_icon_set ( 	bmp() as Ulong ptr, w as integer, h as integer, _
						cols as integer, rows as integer, _
						Byref bmp_path as string)
	

	dim as Ulong  c, x, y, t_w, t_h, tl 
	tl = cols * rows
	t_w = w\cols
	t_h = h\rows
	y = 0
	x = 0
	
	BLOAD bmp_path, 0

	for c = 0 to Ubound(bmp)
		if c > 0 and c mod cols = 0 then
			y+= t_h 
			x = 0 
		end if
		bmp(c) = IMAGECREATE (t_w, t_h)
		GET (x, y)-(x + t_w - 1, y + t_h - 1), bmp(c)
		x += t_w

	next c

end sub

sub deselect_all_items (items() as tile_proto)
	dim as integer i,j

	for i = 0 to Ubound(items)
		
				items(i).is_selected = false
		
	next i
	
end sub


sub deselect_all_level_tiles (items() as tile_proto)
	dim as integer i,j

	for i = 0 to Ubound(items)
		for j = 0 to (Ubound(items,2))
			items(i,j).is_selected = false
		next j
	next i
	
end sub



sub draw_gui (	icons() as tile_proto, user_mouse as mouse_proto, _
						icon_set() as Ulong ptr, block_icons_2x() as Ulong ptr)
						
	dim as integer i, j
	
	'shadowing
	for i = 0 to SCR_H
		for j = (i mod 2) to SCR_W step 2
			pset (j, i), C_WHITE
		next j
	next i

	for i = 0 to Ubound(icons)
		
			put (icons(i).x, icons(i).y), icon_set(i), trans
			
			if icons(i).is_selected then
				line (	icons(i).x-3, icons(i).y-3)-_
				step	(icons(i).w+6, icons(i).h+6),C_YELLOW ,B
			end if
	
	next i
	
	for i = 0 to Ubound(icons)
		
			line (	icons(i).x, icons(i).y)-_
			step	(icons(i).w, icons(i).h),C_GRAY ,B
			
			if is_over( icons(i).x, icons(i).y, _
					icons(i).x+icons(i).w, _
					icons(i).y+icons(i).h, _
					user_mouse.x, user_mouse.y ) then
							
				line (	icons(i).x, icons(i).y)-_
				step	(icons(i).w, icons(i).h),C_PURPLE ,BF
				
				put (icons(i).x - 16, icons(i).y - 12), block_icons_2x(i), pset

			end if
	next i
	
		
	
end sub


sub draw_level(	level_tiles() as tile_proto, user_mouse as mouse_proto,_
				 view_area as view_area_proto, _
				block_icons() as Ulong ptr, _
				object_icons() as Ulong ptr, _
				meta_icons() as Ulong ptr, _
				wallp_icons() as Ulong ptr, _
				enemies_sprites() as Ulong ptr)

	
	dim as integer i, j, c
	dim tile_sprite_id as proto_tile_attributes
	c=0
	
	for i = 0 to Ubound(level_tiles)
		for j = 0 to (Ubound(level_tiles,2))

			tile_sprite_id.value = level_tiles(i,j).value
			
			'bitmap
			'wallpaper
			put (	level_tiles(i,j).x + view_area.x, _
							level_tiles(i,j).y + view_area.y), wallp_icons(tile_sprite_id.id_wallp), trans
			
			select case tile_sprite_id.tile_type
				'blocks
				case 1 
					put (	level_tiles(i,j).x + view_area.x, _
							level_tiles(i,j).y + view_area.y), block_icons(tile_sprite_id.id), trans
				'object
				case 2 
					if tile_sprite_id.id <> 4 then
						put (	level_tiles(i,j).x + view_area.x, _
								level_tiles(i,j).y + view_area.y), object_icons(tile_sprite_id.id), trans
								
					else
						'draw the right enemy
						put (	level_tiles(i,j).x + view_area.x, _
								level_tiles(i,j).y + view_area.y), enemies_sprites(tile_sprite_id.other), trans
					end if
				'meta
				case 3
					put (	level_tiles(i,j).x + view_area.x, _
							level_tiles(i,j).y + view_area.y), meta_icons(tile_sprite_id.id), trans
				
		
					
			end select
			

			


			c+=1
			
		next j
	next i
	'selected item
	for i = 0 to Ubound(level_tiles)
		for j = 0 to (Ubound(level_tiles,2))
			if level_tiles(i,j).is_selected then
			
	
			'highlight the selected tile
			for c = 0 to 5
				line 	(level_tiles(i,j).x + view_area.x - c, _
						level_tiles(i,j).y + view_area.y - c)-_
						step(TILE_W + c*2, TILE_H + c*2), C_RED, B
				next c
			end if
			
			
			
			next j
	next i
	'grid	
	for i = 0 to Ubound(level_tiles)
		for j = 0 to (Ubound(level_tiles,2))
			
			'grid
			line (	level_tiles(i,j).x + view_area.x-1, _
					level_tiles(i,j).y + view_area.y)-_
			step	(2, 0), C_GRAY
			line (	level_tiles(i,j).x + view_area.x, _
					level_tiles(i,j).y + view_area.y-1)-_
			step	(0, 2), C_GRAY

		next j
	next i
	
	
end sub

sub init_level_tiles (level_tiles() as tile_proto) 

	dim as integer i, j

	for i = 0 to Ubound(level_tiles)
		for j = 0 to Ubound(level_tiles,2)
			level_tiles(i,j).w 				= TILE_W
			level_tiles(i,j).h 				= TILE_H
			level_tiles(i,j).x				= j*TILE_W
			level_tiles(i,j).y				= i*TILE_H
			level_tiles(i,j).is_selected 	= false
		next j
	next i

end sub

sub init_gui(icons() as tile_proto)

	dim as integer i, j, x, y
	x = 0
	y = 0
	
	
	for i = 0 to Ubound(icons)
		
		if i mod 16 = 0 then
			x	= 0
			y 	+= TILE_H + 8
		end if
		icons(i).w = TILE_W
		icons(i).h = TILE_H
		icons(i).x = x
		icons(i).y = y
		x += TILE_W + 8
		icons(i).value 			= i
	next i
	
end sub



sub load_level_file (filename as string, level_tiles() as tile_proto)

	'modified version of a snippet by MrSwiss
	'Loading a CSV file into an array
	'https://www.freebasic.net/forum/viewtopic.php?t=25693
	
	dim as string textline, token, tokens()
	dim as integer pos1 = 1, pos2 , filenum, res, i, j

	filenum = Freefile
	res 	= Open (filename, For Input, As #filenum)

	i = 0
	if res = 0 then 
		While (Not Eof(filenum))
			
			Line Input #filenum, textline ' Get one whole text line
			
			redim tokens(0 to 0)
			
			do
				' next semicolor position
				pos2 = instr(pos1, textline, ";")
				' if new semicolon found,
				' take the substring between the last semicolon and it
				if pos2 > 0 Then
					token = mid(textline, pos1, pos2 - pos1)    ' calc. len (new)
				Else
					token = Mid(textline, pos1)
				end if
			   
				' add the token to the end of the array (slightly inefficient)
				tokens(ubound(tokens)) = token
				redim preserve tokens(0 to ubound(tokens)+1)
				
			   
				pos1 = pos2 + 1 ' added + 1
			loop until pos2 = 0
			
			redim preserve level_tiles(0 to i, 0 to Ubound(tokens)-2)
			
			for j = 0 to Ubound(level_tiles, 2)
				level_tiles(i, j).value = CUlngint("&h"+(tokens(j)))
			next j
			
			i +=1
			
		Wend

		Close #filenum
	end if

end sub


function get_tile_choords (	User_mouse as mouse_proto, _
							view_area as view_area_proto, _
							ubound_y as Ulong, _
							ubound_x as Ulong)  as tile_choords_proto

	
	dim choords as tile_choords_proto
	choords.is_valid = true
	choords.x = int((User_mouse.x - view_area.x)\TILE_W) 
	choords.y = int((User_mouse.y - view_area.y)\TILE_H)

	if choords.x > ubound_x then choords.x = -1
	if choords.y > ubound_y then choords.y = -1
	
	if User_mouse.x < view_area.x then 
		choords.x = -1
	end if
	if User_mouse.y < view_area.y then
		choords.y = -1
	end if
	
	if (choords.x > -1) and (choords.y) > -1 then
		choords.is_valid = true
	else
		choords.is_valid = false
	end if
	
	return choords

end function

function get_icon_selected (icons() as tile_proto, user_mouse as mouse_proto) as Ulong
	dim i as Ulong
	for i = 0 to Ubound(icons)
		if is_over( icons(i).x, icons(i).y, _
				icons(i).x+icons(i).w, _
				icons(i).y+icons(i).h, _
				user_mouse.x, user_mouse.y) then
			return i
		end if
	next i
	
end function

sub draw_single_tile_icon (x as Ulong, y as Ulong, icon as FB.Image ptr)
	put (x,y), icon, trans
end sub

sub draw_tile_attributes (tile_attributes as proto_tile_attributes, tab_id as Ulong)

	static tile_type_labels (0 to 4) as string*16 = { _
										"EMPTY", _
										"BLOCK", _
										"OBJECT", _
										"META", _
										"WALLPAPER"}

	dim c as Ulong
	
	for c = 0 to 7
		select case c
			case 0
				draw_button (0, SCR_H - BTN_H*2 , BTN_W, BTN_H, 			"ID", false)
				draw_button (0, SCR_H - BTN_H, BTN_W, BTN_H, 			str(tile_attributes.id), 		c xor tab_id)
			case 1
				draw_button (BTN_W*C, SCR_H - BTN_H*2 , BTN_W, BTN_H, 			"power", false)
				draw_button (BTN_W*C, SCR_H - BTN_H, BTN_W, BTN_H, 			str(tile_attributes.power), c xor tab_id)
			case 2
				draw_button (BTN_W*C, SCR_H - BTN_H*2 , BTN_W, BTN_H, 			"speed", false)
				draw_button (BTN_W*C, SCR_H - BTN_H, BTN_W, BTN_H, 			str(tile_attributes.speed), c xor tab_id)
			case 3
				draw_button (BTN_W*C, SCR_H - BTN_H*2 , BTN_W, BTN_H, 			"time_on", false)
				draw_button (BTN_W*C, SCR_H - BTN_H, BTN_W, BTN_H, 			str(tile_attributes.time_on), c xor tab_id)
			case 4
				draw_button (BTN_W*C, SCR_H - BTN_H*2 , BTN_W, BTN_H, 			"direction", false)
				draw_button (BTN_W*C, SCR_H - BTN_H, BTN_W, BTN_H, 			str(tile_attributes.direction), c xor tab_id)
			case 5
				draw_button (BTN_W*C, SCR_H - BTN_H*2 , BTN_W, BTN_H, 			"id_wallp", false)
				draw_button (BTN_W*C, SCR_H - BTN_H, BTN_W, BTN_H, 			str(tile_attributes.id_wallp), c xor tab_id)
			case 6
				draw_button (BTN_W*C, SCR_H - BTN_H*2 , BTN_W, BTN_H, 			"other", false)
				draw_button (BTN_W*C, SCR_H - BTN_H, BTN_W, BTN_H, 			str(tile_attributes.other), c xor tab_id)
			case 7
				draw_button (BTN_W*C, SCR_H - BTN_H*2 , BTN_W, BTN_H, 			"Tile type", false)
				draw_button (BTN_W*C, SCR_H - BTN_H, BTN_W, BTN_H, 			tile_type_labels(tile_attributes.tile_type), true)
		end select
	next c



end sub

sub remove_column_from_level (level_tiles() as tile_proto)
	dim as Ulong i, j
	
	redim temp_level_tiles (0 to Ubound(level_tiles), 0 to Ubound(level_tiles, 2)) 	as tile_proto
	
	for i = 0 to Ubound(level_tiles)
		for j = 0 to Ubound(level_tiles, 2)
			temp_level_tiles(i,j) = level_tiles(i,j)
			'level_tiles(i,j).value = 0
		next j
	next i
	
	redim level_tiles (0 to Ubound(level_tiles), 0 to Ubound(level_tiles, 2)-1)
	
	for i = 0 to Ubound(level_tiles)
		for j = 0 to Ubound(level_tiles, 2)
			level_tiles(i,j).value = temp_level_tiles(i,j).value
		next j
	next i
	init_level_tiles (level_tiles())

end sub

sub remove_row_from_level (level_tiles() as tile_proto)
	dim as Ulong i, j
	
	redim temp_level_tiles (0 to Ubound(level_tiles), 0 to Ubound(level_tiles, 2)) 	as tile_proto
	
	for i = 0 to Ubound(level_tiles)
		for j = 0 to Ubound(level_tiles, 2)
			temp_level_tiles(i,j) = level_tiles(i,j)
			'level_tiles(i,j).value = 0
		next j
	next i
	
	redim level_tiles (0 to Ubound(level_tiles) - 1, 0 to Ubound(level_tiles, 2))
	
	for i = 0 to Ubound(level_tiles)
		for j = 0 to Ubound(level_tiles, 2)
			level_tiles(i,j).value = temp_level_tiles(i,j).value
		next j
	next i
	init_level_tiles (level_tiles())

end sub



sub add_column_to_level (level_tiles() as tile_proto)
	dim as Ulong i, j
	
	redim temp_level_tiles (0 to Ubound(level_tiles) + 1, 0 to Ubound(level_tiles, 2)) 	as tile_proto
	
	for i = 0 to Ubound(level_tiles)
		for j = 0 to Ubound(level_tiles, 2)
			temp_level_tiles(i,j) = level_tiles(i,j)
			level_tiles(i,j).value = 0
		next j
	next i
	
	redim level_tiles (0 to Ubound(level_tiles) + 1, 0 to Ubound(level_tiles, 2))
	
	for i = 0 to Ubound(level_tiles)
		for j = 0 to Ubound(level_tiles, 2)
			level_tiles(i,j).value = temp_level_tiles(i,j).value
		next j
	next i
	init_level_tiles (level_tiles())

end sub

sub add_row_to_level (level_tiles() as tile_proto)
	dim as Ulong i, j
	
	redim temp_level_tiles (0 to Ubound(level_tiles), 0 to Ubound(level_tiles, 2)+1) 	as tile_proto
	
	for i = 0 to Ubound(level_tiles)
		for j = 0 to Ubound(level_tiles, 2)
			temp_level_tiles(i,j) = level_tiles(i,j)
			level_tiles(i,j).value = 0
		next j
	next i
	
	redim level_tiles (0 to Ubound(level_tiles), 0 to Ubound(level_tiles, 2)+1)
	
	for i = 0 to Ubound(level_tiles)
		for j = 0 to Ubound(level_tiles, 2)
			level_tiles(i,j).value = temp_level_tiles(i,j).value
		next j
	next i
	init_level_tiles (level_tiles())
	
end sub

sub erase_level_data (level_tiles() as tile_proto)
	dim as Ulong i, j
	dim temp_tile as proto_tile_attributes
	for i = 0 to Ubound(level_tiles)
		for j = 0 to Ubound(level_tiles, 2)
			'create perimeter of blocks
			if i = 0 or i = Ubound(level_tiles) then
				temp_tile.tile_type = mode_block
				temp_tile.id = 1
				level_tiles(i,j).value = temp_tile.value
			elseif j = 0 or j = Ubound(level_tiles, 2) then
				temp_tile.tile_type = mode_block
				temp_tile.id = 1
				level_tiles(i,j).value = temp_tile.value
			else
			level_tiles(i,j).value = 0
			
			end if
		next j
	next i
	init_level_tiles (level_tiles())
end sub


sub erase_enter_location (level_tiles() as tile_proto)
	dim as Ulong i, j
	dim temp_tile as proto_tile_attributes
	for i = 0 to Ubound(level_tiles)
		for j = 0 to Ubound(level_tiles, 2)

			temp_tile.value = level_tiles(i,j).value
			
			if temp_tile.tile_type = mode_meta andalso temp_tile.id = 1 then
				temp_tile.id = 0
				level_tiles(i,j).value = temp_tile.value
			end if

		next j
	next i
end sub

sub erase_exit_location (level_tiles() as tile_proto)
	dim as Ulong i, j
	dim temp_tile as proto_tile_attributes
	for i = 0 to Ubound(level_tiles)
		for j = 0 to Ubound(level_tiles, 2)

			temp_tile.value = level_tiles(i,j).value
			
			if temp_tile.tile_type = mode_meta andalso temp_tile.id = 2 then
				temp_tile.id = 0
				level_tiles(i,j).value = temp_tile.value
			end if

		next j
	next i
end sub

