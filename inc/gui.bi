'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


Type gui_proto
	x as Ulong
	y as Ulong
	
	lives 		as Ubyte
	ammo 		as Ubyte
	energy 		as Ubyte
	coins 		as Ubyte
	points 		as Ulong
	yellow_key 	as boolean
	red_key 	as boolean
	blue_key 	as boolean
	
	gui_top_background(0 to 2) as FB.Image ptr
	gui_top_background_2x(0 to 2) as FB.Image ptr
	
	ascii_font_big 		(0 to 127) as FB.Image ptr
	
	hud_items 		(0 to 19) as FB.Image ptr
	hud_items_2x 	(0 to 19) as FB.Image ptr

	
	declare sub draw_gui_header (x as Ulong, y as Ulong, lives as Ubyte, ammo as Ubyte, sys_64738 as Ubyte, _
								energy as Byte, coins as Ubyte, points as Ulong, _
								yellow_key as boolean, red_key as boolean, blue_key as boolean, _
								keyword_to_find as Ulong, time_left as Ulong, image_buffer as FB.Image ptr)
	
	declare sub print_font (x as Ulong, y as Ulong, txt as string, image_buffer as FB.Image ptr)
	
	declare constructor()
	declare destructor()
	
end type

constructor gui_proto()

	this.x = 0
	this.y = 0
	
	load_sprite_sheet 	(this.gui_top_background(), 96, 32, 3, 1,		"img/gui_back_top.bmp")
	load_sprite_sheet 	(this.ascii_font_big(), 	320, 192, 16, 8,	"img/font_ascii_big.bmp")
	load_sprite_sheet 	(this.hud_items(), 			240, 48, 10, 2,		"img/hud_items.bmp")

	
	dim as Ulong i
	
	for i = 0 to Ubound(this.gui_top_background)
		this.gui_top_background_2x(i) = ImageScale (	this.gui_top_background(i), _
														this.gui_top_background(i)-> width  * 2, _
														this.gui_top_background(i)-> height * 2 )
	next i
	
	for i = 0 to Ubound(this.hud_items)
		this.hud_items_2x(i) = ImageScale (	this.hud_items(i), _
											this.hud_items(i)-> width  * 2, _
											this.hud_items(i)-> height * 2 )
	
	next i
	
end constructor

destructor gui_proto()
	
	dim i as Ulong
	
	for i = 0 to Ubound (this.gui_top_background)
		ImageDestroy this.gui_top_background(i)
		ImageDestroy this.gui_top_background_2x(i)
	next i
	
	for i = 0 to Ubound (this.ascii_font_big)
		ImageDestroy this.ascii_font_big(i)
	next i
	
	for i = 0 to Ubound(this.hud_items)
		ImageDestroy this.hud_items(i)
		ImageDestroy this.hud_items_2x(i)
	next i

	
	
end destructor

sub gui_proto.draw_gui_header (x as Ulong, y as Ulong, lives as Ubyte, ammo as Ubyte, sys_64738 as Ubyte, _
							energy as Byte, coins as Ubyte, points as Ulong, _
							yellow_key as boolean, red_key as boolean, blue_key as boolean, _
							keyword_to_find as Ulong, time_left as Ulong, image_buffer as FB.Image ptr)
		
	
	dim as Ulong i, j
	

	
	'Victor icon & energy & lives
	put image_buffer, (12, 12), hud_items_2x(HUD_ID_VICTOR), trans
	print_font ( 12, 70, str(energy) + " %" , image_buffer)
	print_font ( 72, 32, str(lives - 1) , image_buffer)
	

	
	'SYS 64378 icon & quantity
	if sys_64738 > 0 then
		put image_buffer, (228, 12), hud_items_2x(HUD_ID_SYS_64738), trans
		print_font ( 288, 32, str(sys_64738), image_buffer)
	end if
	
	'Coins icon & quantity
	put image_buffer, (108, 12), hud_items_2x(HUD_ID_COIN), trans
	print_font ( 168, 32, str(coins), image_buffer)


	'keywords
	if keyword_to_find > 0 then
		put image_buffer, (336, 12), hud_items_2x(HUD_ID_KEYWORD_LEFT), trans
		print_font ( 396, 32, str(keyword_to_find), image_buffer)
	else
		put image_buffer, (336, 12), hud_items_2x(HUD_ID_KEYWORD_OK), trans
	end if
	
	'points
	print_font ( SCR_W - 108, 12, "Victor", image_buffer)
	print_font ( SCR_W - 108, 32, zero_filled(points), image_buffer)
	
	'timer
	if time_left > 60 then
	
		put image_buffer, (444, 12), hud_items_2x(HUD_ID_TIMER), trans
		
	else
		if Culng(Timer*2) mod 2 = 0 then
			put image_buffer, (444, 12), hud_items_2x(HUD_ID_TIMER), trans
		end if
	end if
	
	print_font ( 468 - len(str(time_left))*8, 64, str(time_left), image_buffer)
	

	'keys

	
	'put image_buffer, (SCR_W - 60, 112), hud_items_2x(HUD_ID_EMPTY_KEY), trans
	
	if (yellow_key) then
		put image_buffer, (SCR_W - 60, 52), hud_items_2x(HUD_ID_YELLOW_KEY), trans
	end if
	
	if (red_key) then
		put image_buffer, (SCR_W - 60, 82), hud_items_2x(HUD_ID_RED_KEY), trans
	end if
	
	if (blue_key) then
		put image_buffer, (SCR_W - 60, 112), hud_items_2x(HUD_ID_BLUE_KEY), trans
	end if
	
	'Floppies icon & quantity
	
	if ammo > 0 then
		put image_buffer, (12, SCR_H - 70), hud_items_2x(HUD_ID_FLOPPY), trans
		print_font ( 36 - len(str(ammo))*8, SCR_H - 44, str(ammo), image_buffer)
	else
		put image_buffer, (12, SCR_H - 70), hud_items_2x(HUD_ID_NO_FLOPPY), trans
	end if
	

	'draw round corners on the vertices of the screen
	put image_buffer, (0, 0), hud_items(11), trans
	put image_buffer, (SCR_w - 24, 0), hud_items(12), trans
	put image_buffer, (0, SCR_H - 24), hud_items(13), trans
	put image_buffer, (SCR_w - 24, SCR_H - 24), hud_items(14), trans
end sub

sub gui_proto.print_font (x as Ulong, y as Ulong, txt as string, image_buffer as FB.Image ptr)
	dim as ulong i, _x
	
	_x = x
	for i = 1 to len(txt)
		if i <= 127 then
			put image_buffer, (_x, y), ascii_font_big(asc(txt, i)), trans
			_x+=16
		end if
	next i
		

end sub
							
							
	





