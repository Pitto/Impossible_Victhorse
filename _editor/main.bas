'A love letter to Freebasic Editor by Pitto

'This program is free software; you can redistribute it and/or
'modify it under the terms of the GNU General Public License
'as published by the Free Software Foundation; either version 2
'of the License, or (at your option) any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License
'along with this program; if not, write to the Free Software
'Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
'Also add information on how to contact you by electronic and paper mail.

'#######################################################################

' Compiling instructions: fbc -w all -exx "%f"

#include "fbgfx.bi"
#include "file.bi"


Using FB
randomize timer

#include "inc/keyboard.bi"
#include "inc/definitions.bi"
#include "inc/enums.bi"
#include "inc/block_perimeter.bi"
#include "inc/types.bi"
#include "inc/functions.bi"




'MAIN___________________________________________________________________



dim as ulong i, j, k, c



dim keyboard 		as keyboard_proto


redim level_tiles (0 to 0, 0 to 0) 	as tile_proto

dim as string level_file_name
'check if specified file exists
if __FB_ARGC__ > 1 then
   level_file_name = str(Command(1))
   if FileExists(level_file_name)  then
   else
      print "file doesn't exists"
      sleep
      end
   end if
else
   print "ERROR - To launch the editor"
   print "input a valid level file"
   print "---"
   print "example: main level.lev"
   sleep
   end 
end if



load_level_file (level_file_name, level_tiles() )
init_level_tiles (level_tiles())


DIM workpage 				AS INTEGER
workpage = 0

Dim user_mouse 				as mouse_proto

dim gui						as gui_proto
gui.show = false
gui.show_presets = false
gui.select_tab_id 		= 0
gui.select_tab_id_max 	= 6 ' prevents that the tab modify the tile type
gui.paint_right_tiles  = false

dim as proto_tile_mode tile_mode, tile_mode_old
tile_mode = mode_empty

'attributes of the painting tile
dim tile_attributes as proto_tile_attributes
tile_attributes.value = 0
tile_attributes.tile_type = tile_mode
dim copy_paste_tile as proto_tile_attributes
copy_paste_tile.value = 0


dim curr_tile_choords as tile_choords_proto
'selected tile choords
dim selected_single_tile_choords as tile_choords_proto

'dim tile_value as Ulongint = 0

Dim input_mode				as proto_input_mode
dim console_message			as proto_console_message
dim settings as settings_proto

user_mouse.is_dragging = false
user_mouse.is_lbtn_released = false
user_mouse.is_lbtn_pressed = false

dim view_area as view_area_proto

view_area.x = 0
view_area.y = 0
view_area.zoom = 1.0f
view_area.old_zoom = view_area.zoom
view_area.refresh = true

dim key(0 to 82) as key_proto

dim keycodes(0 to 82) as integer = {	SC_ESCAPE, SC_1, SC_2, SC_3, SC_4, _
								SC_5, SC_6, SC_7, SC_8, SC_9, SC_0,_
								SC_MINUS, SC_EQUALS, SC_BACKSPACE, _
								SC_TAB, SC_Q, SC_W, SC_E, SC_R, _
								SC_T,SC_Y,SC_U,SC_I,SC_O,SC_P,_
								SC_LEFTBRACKET, SC_RIGHTBRACKET,_
								SC_ENTER,SC_CONTROL,SC_A,_
								SC_S,SC_D,SC_F,SC_G,SC_H,SC_J,SC_K,SC_L,_
								SC_SEMICOLON,SC_QUOTE,SC_TILDE,SC_LSHIFT,_
								SC_BACKSLASH,SC_Z,SC_X,SC_C,SC_V,SC_B,SC_N,_
								SC_M,SC_COMMA,SC_PERIOD,SC_SLASH,SC_RSHIFT,_
								SC_MULTIPLY,SC_ALT,SC_SPACE,SC_CAPSLOCK,_
								SC_F1,SC_F2,SC_F3,SC_F4,SC_F5,SC_F6,SC_F7,_
								SC_F8,SC_F9,SC_F10,SC_NUMLOCK,SC_SCROLLLOCK,_
								SC_HOME,SC_UP,SC_PAGEUP,SC_LEFT,SC_RIGHT,SC_PLUS,_
								SC_END,SC_DOWN,SC_PAGEDOWN,SC_INSERT,SC_DELETE,_
								SC_F11,SC_F12 }


'setting up initial values of keys
for i = 0 to Ubound(key)-1
	key(i).code = keycodes(i)
	key(i).is_down = false
	key(i).old_is_down = false
	key(i).is_released= false
next i



dim console_messages_strings (0 to 31) as string = { _
											"Undefined error", _
											"TOOL: Pen", _
											"TOOL: Selection", _
											"TOOL: Direct Selection", _
											"TOOL: Hand", _
											"Point Added", _
											"Polygon Closed", _
											"Polygon/s deleted", _
											"FILE SAVED", _
											"FILE EXPORTED", _
											"Wireframe: ON", _
											"Wireframe: OFF", _
											"Centroids: ON", _
											"Centroids: OFF", _
											"Bitmap:    ON", _
											"Bitmap:    OFF", _
											"Points:	ON", _
											"Points:    OFF" }
											
dim on_screen_help() as string
load_whole_txt_file	("data/instructions.txt", on_screen_help())

screenres (SCR_W, SCR_H, 24)
SetMouse SCR_W\2, SCR_H\2, 0



dim enemies_sprites (0 to 9) 		as Ulong ptr													
load_icon_set (enemies_sprites(), 24, 240, 1, 10,"img/enemies_24x240.bmp")


dim pointer_set (0 to 39) 		as Ulong ptr													
load_icon_set (pointer_set(), 240, 96, 10, 4,"img/pointer_set.bmp")

'icons control of the gui
dim icons (0 to 255) 	as tile_proto
'initialize icons positions and value (0-255)
init_gui (icons())

'bitmap data of the gui, one set for each tile mode --------------------
	'mode_block 	= 1
	'mode_object	= 2
	'mode_meta		= 3
	'mode_wallp  	= 4
dim block_icons (0 to 255) as FB.Image ptr
load_icon_set 	(block_icons(), 512, 384, 16, 16,	"../img/block_icons.bmp")
dim object_icons(0 to 255) as FB.Image ptr
load_icon_set 	(object_icons(), 512, 384, 16, 16,	"../img/object_icons.bmp")
dim meta_icons 	(0 to 255) as FB.Image ptr
load_icon_set 	(meta_icons(), 512, 384, 16, 16,	"../img/meta_icons.bmp")
dim wallp_icons (0 to 255) as FB.Image ptr
load_icon_set 	(wallp_icons(), 512, 384, 16, 16,	"../img/wallp_icons.bmp")

dim as FB.Image ptr block_icons_2x (0 to 255)
dim as FB.Image ptr object_icons_2x (0 to 255)
dim as FB.Image ptr meta_icons_2x (0 to 255)
dim as FB.Image ptr wallp_icons_2x (0 to 255)

for i = 0 to Ubound (block_icons_2x)
	block_icons_2x(i) = ImageScale	(	block_icons(i), block_icons(i)->width*2,_
									block_icons(i)->height * 2)
	object_icons_2x(i) = ImageScale	(	object_icons(i), object_icons(i)->width*2,_
									object_icons(i)->height * 2)
	meta_icons_2x(i) = ImageScale	(	meta_icons(i), meta_icons(i)->width*2,_
									meta_icons(i)->height * 2)
	wallp_icons_2x(i) = ImageScale	(	wallp_icons(i), wallp_icons(i)->width*2,_
									wallp_icons(i)->height * 2)
next i

'-----------------------------------------------------------------------


do
	if MULTIKEY (SC_Escape) then exit do
	
	dim as integer i, c
	dim scalechange as single
	dim timer_diff as double
	dim timer_begin as double

	timer_begin = timer
	
	User_Mouse.res = 	GetMouse( 	User_Mouse.x, User_Mouse.y, _
									User_Mouse.wheel, User_Mouse.buttons,_
									User_Mouse.clip)
								
	keyboard_listener	(	@tile_mode, user_mouse, @view_area,_
							@settings, keyboard, level_tiles(), @gui, @tile_attributes )
	
	'this to avoid unwanted clicks while mouse pointer goes outside the
	'working window
	if (User_Mouse.res = 0) then
		mouse_listener		(@user_mouse, @view_area)
	else
		user_mouse.x = user_mouse.old_x
		user_mouse.y = user_mouse.old_y
	end if
	
	
	'update the tile choords where the mouse is over, 
	'if none returns (-1,-1)
	'passes before the row ubound (y) and after the column Ubound (x)
	curr_tile_choords = get_tile_choords (	User_mouse, view_area, _
										Ubound(level_tiles),_
										Ubound(level_tiles,2))
	
	if settings.is_hand_active then
		tile_mode = mode_hand
	end if

	'-------------------------------------------------------------------
	
	'select the item to be painted on level via mouse wheel
	if tile_mode <> mode_select and tile_mode <> mode_wallp then
		tile_attributes.id = mouse_wheel_limit (tile_attributes.id, _
														user_mouse.diff_wheel, _
														255)
	end if
	
	if tile_mode = mode_wallp then
		tile_attributes.id_wallp = mouse_wheel_limit (tile_attributes.id_wallp, _
														user_mouse.diff_wheel, _
														255)
		
	end if
	
	select case tile_mode
	
		case mode_hand
			'pan
			if (user_mouse.is_dragging) then
					view_area.x = view_area.old_x + (user_mouse.x - user_mouse.old_x)
					view_area.y = view_area.old_y + (user_mouse.y - user_mouse.old_y)
				else
					view_area.old_x = view_area.x
					view_area.old_y = view_area.y
			end if
			
			if not settings.is_hand_active then
				tile_mode = mode_empty
			end if
			
		case mode_empty
			'erase a tile's content
			tile_attributes.value = 0
			'tile_attributes.id_wallp = 0

		case mode_block
			tile_attributes.tile_type = mode_block
		
		case mode_object
			tile_attributes.tile_type = mode_object

		case mode_meta
			tile_attributes.tile_type = mode_meta

		case mode_wallp
			'tile_attributes.tile_type = mode_block
			'tile_attributes.id_wallp = mode_block

	end select

	'paint the item on the level
	
	if tile_mode = mode_wallp then
		if user_mouse.is_lbtn_pressed and curr_tile_choords.is_valid then
				dim temp_tile_wallp as proto_tile_attributes
				temp_tile_wallp.value = 	level_tiles	(curr_tile_choords.y ,_
											curr_tile_choords.x).value 
				temp_tile_wallp.id_wallp = tile_attributes.id_wallp
				
				level_tiles	(curr_tile_choords.y ,_
							curr_tile_choords.x).value = temp_tile_wallp.value
		end if
	end if
	
	if tile_mode <> mode_select and tile_mode <> mode_hand and tile_mode <> mode_wallp then
		if user_mouse.is_lbtn_pressed and curr_tile_choords.is_valid then
			'	level_tiles	(curr_tile_choords.y ,_
			'				curr_tile_choords.x).value = tile_attributes.value
							
				dim temp_tile_wallp as proto_tile_attributes
				temp_tile_wallp.value = 	level_tiles	(curr_tile_choords.y ,_
											curr_tile_choords.x).value 
				
				temp_tile_wallp.id 			= tile_attributes.id
				temp_tile_wallp.power 		= tile_attributes.power
				temp_tile_wallp.speed 		= tile_attributes.speed
				temp_tile_wallp.other 		= tile_attributes.other
				temp_tile_wallp.tile_type 	= tile_attributes.tile_type
				
				level_tiles	(curr_tile_choords.y ,_
							curr_tile_choords.x).value = temp_tile_wallp.value
		end if

		

	'selects & modify the item
	elseif tile_mode = mode_select then
		
		'select a single item
		if user_mouse.is_lbtn_released and curr_tile_choords.is_valid then
				deselect_all_level_tiles (level_tiles())
				'mark as selected
				level_tiles	(curr_tile_choords.y ,_
								curr_tile_choords.x).is_selected = true
				tile_attributes.value = level_tiles	(curr_tile_choords.y ,_
													curr_tile_choords.x).value
				selected_single_tile_choords = curr_tile_choords
				user_mouse.is_lbtn_released = false
			
		end if
		'modify it
		select case gui.select_tab_id
			'id
			case 0
				tile_attributes.id = mouse_wheel_limit ( tile_attributes.id, _
														user_mouse.diff_wheel, _
														TILE_FIELD_MAX_VALUE)

			'power
			case 1
				tile_attributes.power = mouse_wheel_limit ( tile_attributes.power, _
													user_mouse.diff_wheel, _
													TILE_FIELD_MAX_VALUE)
			'speed
			case 2
				tile_attributes.speed = mouse_wheel_limit ( tile_attributes.speed, _
													user_mouse.diff_wheel, _
													TILE_FIELD_MAX_VALUE)
			'time_on
			case 3
				tile_attributes.time_on = mouse_wheel_limit ( tile_attributes.time_on, _
												user_mouse.diff_wheel, _
												TILE_FIELD_MAX_VALUE)
			'direction
			case 4
				tile_attributes.direction = mouse_wheel_limit ( tile_attributes.direction, _
												user_mouse.diff_wheel, _
												TILE_FIELD_MAX_VALUE)
			'id_wallp
			case 5
				tile_attributes.id_wallp = mouse_wheel_limit ( tile_attributes.id_wallp, _
												user_mouse.diff_wheel, _
												TILE_FIELD_MAX_VALUE)
			'other
			case 6
				tile_attributes.other = mouse_wheel_limit ( tile_attributes.other, _
												user_mouse.diff_wheel, _
												TILE_FIELD_MAX_VALUE)

		end select
		
		level_tiles	(selected_single_tile_choords.y ,_
					selected_single_tile_choords.x).value = tile_attributes.value
	
	end if
	
	'copy / paste single tile
	if gui.copy then
		copy_paste_tile.value = level_tiles		(selected_single_tile_choords.y ,_
												selected_single_tile_choords.x).value
		gui.copy = false
	end if
	
	if gui.paint_right_tiles then
		for i = 1 to Ubound(level_tiles)-1
			for j = 1 to (Ubound(level_tiles,2))-1
				dim this_tile as proto_tile_attributes
				this_tile.value = level_tiles(i,j).value
				if this_tile.tile_type = mode_block and this_tile.id  <= block_edge_top  and this_tile.id > 0 then
					this_tile.id = get_right_solid_block(i, j, level_tiles(), block_combinations())
					level_tiles(i,j).value = this_tile.value
				end if
			next j
		next i
		gui.paint_right_tiles = false
	end if
	
	'right click to paste on the level tiles the clipboard data
	if user_mouse.is_rbtn_released and curr_tile_choords.is_valid then
		level_tiles	(curr_tile_choords.y ,_
					curr_tile_choords.x).value = copy_paste_tile.value
		user_mouse.is_rbtn_released = false
	end if


	timer_diff = timer - timer_begin
	
	timer_begin = timer
	
	
	screenlock ' Lock the screen
	screenset Workpage, Workpage xor 1 ' Swap work pages.

	cls
	
	'draw a mask color in the background in order to see wallpaper tiles better
	line (0,0)-(SCR_W, SCR_H), &hFF00FF, BF
	
	draw_level (level_tiles(), user_mouse, view_area, _
				block_icons(), object_icons(), _
				meta_icons(), wallp_icons() , enemies_sprites())
				
	'if gui.show_presets then draw_gui (	icons() , user_mouse, object_icons(), object_icons())
				
	if tile_mode = mode_select then
		draw_tile_attributes (tile_attributes, gui.select_tab_id)
	end if
	
	draw_bottom_info 	(tile_mode, _
						view_area, user_mouse, settings, timer_begin, _
						on_screen_help())
	
	dim as Ulong x_coord, y_coord
	x_coord = view_area.x + curr_tile_choords.x * TILE_W
	y_coord = view_area.y + curr_tile_choords.y * TILE_H
	
	''draw the xy choords values of the tile
	'draw string (20,40), "x tile:   " + str(curr_tile_choords.x) + ", y tile: " + str(curr_tile_choords.y)
	'draw string (20,50), "SELECTED  " + str(selected_single_tile_choords.x) + "," + str(selected_single_tile_choords.y)					
	'draw string (20,60), "copypaste " + str(hex(copy_paste_tile.value))					
	'draw string (20,80), "gui.show  " + str(gui.show)					
	'draw string (20,90), "hex       " + str(hex(tile_attributes.value))					
	

	if	curr_tile_choords.is_valid then 
		'draw hex value of the selected tile
		draw_button (User_mouse.x - 64, User_Mouse.y + 20, _
					128, 12, _
					str(hex(level_tiles(curr_tile_choords.y,curr_tile_choords.x).value)),_
					false)
		line (view_area.x + curr_tile_choords.x * TILE_W, view_area.y + curr_tile_choords.y * TILE_H)-step(TILE_W, TILE_H), C_WHITE, B

		

		select case tile_mode
			case mode_block
				draw_single_tile_icon (x_coord, y_coord, block_icons(tile_attributes.id))
				
				if not user_mouse.is_lbtn_pressed then
					for i = 0 to 255
						if i = tile_attributes.id then
							put (user_mouse.x - 32 + i*64 - tile_attributes.id * 64, user_mouse.y + 60), block_icons_2x (i), trans
						else
							put (user_mouse.x - 32 + i*64 - tile_attributes.id * 64, user_mouse.y + 60), block_icons_2x (i), Alpha, 35
						end if
					next i
				end if
				

			case mode_object
			
				'draw the preview of the enemy
				if tile_attributes.id<> 4 then 
					draw_single_tile_icon (x_coord, y_coord, object_icons(tile_attributes.id))
				elseif tile_attributes.other < 9 then
					draw_single_tile_icon (x_coord, y_coord, enemies_sprites(tile_attributes.other))
				end if
				
				if not user_mouse.is_lbtn_pressed then
					for i = 0 to 255
						if i = tile_attributes.id then
							put (user_mouse.x - 32 + i*64 - tile_attributes.id * 64, user_mouse.y + 60), object_icons_2x (i), trans
						else
							put (user_mouse.x - 32 + i*64 - tile_attributes.id * 64, user_mouse.y + 60), object_icons_2x (i), Alpha, 35
						end if
					next i
				end if
				
			case mode_meta
				draw_single_tile_icon (x_coord, y_coord, meta_icons(tile_attributes.id))
				
				if not user_mouse.is_lbtn_pressed then
					for i = 0 to 255
						if i = tile_attributes.id then
							put (user_mouse.x - 32 + i*64 - tile_attributes.id * 64, user_mouse.y + 60), meta_icons_2x (i), trans
						else
							put (user_mouse.x - 32 + i*64 - tile_attributes.id * 64, user_mouse.y + 60), meta_icons_2x (i), Alpha, 35
						end if
					next i
				end if
			case mode_wallp
				draw_single_tile_icon (x_coord, y_coord, wallp_icons(tile_attributes.id_wallp))
			
				if not user_mouse.is_lbtn_pressed then
					for i = 0 to 255
						if i = tile_attributes.id_wallp then
							put (user_mouse.x - 32 + i*64 - tile_attributes.id_wallp * 64, user_mouse.y + 60), wallp_icons_2x (i), trans
						else
							put (user_mouse.x - 32 + i*64 - tile_attributes.id_wallp * 64, user_mouse.y + 60), wallp_icons_2x (i), Alpha, 35
						end if
					next i
				end if
				
		end select
		
						
	end if
	
	draw_mouse_pointer	(	user_mouse.x, user_mouse.y,_
							user_mouse.is_lbtn_pressed, _
							settings.is_snap_point_available, _
							tile_mode, pointer_set())
						
	workpage = 1 - Workpage ' Swap work pages.
	
	screenunlock
	sleep 20,1
	
LOOP

'save data automatically on exit
save_level_file(level_tiles(), level_file_name)

'destroy bitmaps from memory____________________________________________
for i = 0 to Ubound (block_icons_2x)
	ImageDestroy block_icons_2x(i)
	ImageDestroy object_icons_2x(i)
	ImageDestroy meta_icons_2x(i)
	ImageDestroy wallp_icons_2x(i)
	ImageDestroy block_icons(i)
	ImageDestroy object_icons(i)
	ImageDestroy meta_icons(i)
	ImageDestroy wallp_icons(i)

next i

for c = 0 to Ubound(pointer_set)
	ImageDestroy pointer_set(c)
next c
for c = 0 to Ubound(enemies_sprites)
	ImageDestroy enemies_sprites(c)
next c
