'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder

enum proto_tile_mode
	mode_empty 	= 0
	mode_block 	= 1
	mode_object	= 2
	mode_meta	= 3
	mode_wallp  = 4
	mode_hand	= 5
	mode_select	= 6
end enum

enum proto_action
	action_stand_facing_right = 0
	action_stand_facing_left = 6
	action_run_facing_right = 1
	action_run_facing_left = 7
	action_jump_facing_right = 13
	action_jump_facing_left = 19
	action_fall_facing_right = 25
	action_fall_facing_left = 31
	action_climb_facing_left = 30
	action_climb_facing_right = 24
	action_death = 37
	action_launch_facing_right = 12
	action_launch_facing_left = 18
	action_searching = 36
	
end enum

enum proto_block_type
	block_null 	= 0
	block_full
	block_top
	block_top_left
	block_top_right
	block_edge_left
	block_edge_right
	block_bottom_left
	block_bottom_right
	block_edge_bottom
	block_isolated
	block_hull
	block_edge_top
	block_floppy_dispenser
	block_wood_box
	block_evanescence
	block_spikes_bottom
	block_spikes_left
	block_spikes_right
	block_spikes_top
	block_horizontal_moving
	block_semi_block
	block_solid_metal_alt
	block_door_yellow_key
	block_door_red_key
	block_door_blue_key
	block_roll_clockwise
	block_roll_counterclockwise
	block_roll_chemical_poison
	block_ice
end enum


union proto_tile_attributes
	value as Ulongint
	type
		id 			as Ubyte 'FF
		power		as Ubyte 'FF
		speed		as Ubyte 'ff
		time_on		as Ubyte
		direction	as Ubyte
		id_wallp	as Ubyte
		other		as Ubyte
		tile_type 	as Ubyte 'FF
	end type
end union

enum game_section_proto
	
	_game_section_INTRO
	_game_section_MAIN_MENU
	_game_section_ENTER_NAME
	_game_section_LEVEL_INTRO
	_game_section_LEVEL_INITIALIZE
	_game_section_LEVEL
	_game_section_GAME_OVER
	_game_section_GAME_COMPLETED
	_game_section_TOP_SCORERS
	_game_section_CREDITS

end enum

enum main_menu_buttons_proto

	_main_menu_button_new_game = 0
	_main_menu_button_difficulty 
	_main_menu_button_top_scorers
	_main_menu_button_credits

end enum

