'enums__________________________________________________________________

enum proto_input_mode
	input_error = 0
	input_add_polygon = 1
	input_add_point = 2
	input_close_polygon = 3
	input_selection
	input_direct_selection
	input_move_node_up
	input_move_node_down
	input_move_node_left
	input_move_node_right
	input_delete_node
	input_hand
	add_vertex
	del_vertex
	add_edge 
	del_edge
	move_vertex
	set_start
	set_end
	input_save_as_lpe_file
	input_erase_all
	input_erase_polygon
	input_export_as_svg
	input_load_lpe_file
	input_create_random_polygons
end enum

enum proto_console_message
	cm_undefined_error = 0
	cm_PEN_Tool
	cm_TOOL_Selection
	cm_TOOL_Direct_Selection
	cm_TOOL_Hand
	cm_Point_Added
	cm_Polygon_Closed
	cm_Polygon_s_deleted
	cm_FILE_SAVED
	cm_FILE_EXPORTED
	cm_Wireframe_ON
	cm_Wireframe_OFF
	cm_Centroids_ON
	cm_Centroids_OFF
	cm_Bitmap_ON
	cm_Bitmap_OFF
	cm_Points_ON
	cm_Points_OFF
end enum

enum proto_icon
	icon_direct_selection = 0
	icon_direct_selection_over
	icon_selection
	icon_selection_over
	icon_pen
	icon_pen_is_pressed
	icon_pen_snap
	icon_pen_del_node
	icon_pen_close_node
	icon_convert_point
	icon_drag_handle
	icon_hand
	icon_hand_is_pressed
	icon_zoom_plus
	icon_zoom_minus
	icon_draw_box
	icon_draw_circle
	icon_precise_cursor
	icon_ctrl
	icon_ctrl_is_pressed
	icon_spacebar
	icon_spacebar_is_pressed
	icon_shift
	icon_shift_is_pressed
	icon_alt
	icon_alt_is_pressed
	icon_box_dark
	icon_box_light
	icon_save
	icon_svg_export
	icon_bottom_bar
	icon_top_bar
	icon_scissor
	icon_file_new
	icon_file_open
end enum

enum proto_tile_mode
	mode_empty 	= 0
	mode_block 	= 1
	mode_object	= 2
	mode_meta	= 3
	mode_wallp  = 4
	mode_hand	= 5
	mode_select	= 6
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
