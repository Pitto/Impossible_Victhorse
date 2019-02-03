'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


Type user_input
	direction as single
	x_trigger as single
	x as single
	y as single
	y_speed as single
	speed as single
	is_giving_input as boolean
	is_button_a_pressed as boolean
	is_button_b_pressed as boolean
	is_button_a_released as boolean
	is_button_b_released as boolean
	
	is_jump as boolean
	is_fire as boolean
	jump_power as single
	
	button_a_begin_timer as double
	button_b_begin_timer as double 
	
	Declare Sub get_input(joystick as joystick_proto, keyboard as keyboard_proto)
	Declare Sub draw_input(x as single, y as single)
	declare function get_x() as single
	declare function get_y() as single
	Declare Constructor()

End type

Constructor user_input()

	this.direction = 0
	this.x_trigger = 0
	this.speed = _PL_MAX_SPEED
	
	this.is_giving_input 		= false
	this.is_button_a_pressed	= false
	this.is_button_b_pressed	= false
	this.is_button_a_released	= false
	this.is_button_b_released	= false
	
	this.is_jump 				= false
	this.is_fire				= false
	this.jump_power				= 0

end constructor 

sub user_input.get_input(joystick as joystick_proto, keyboard as keyboard_proto)
	
	is_giving_input = false
	'keyboard
	
	'joystick
	
	if joystick.is_present then 
		joystick.update()
	
		if joystick.pressed(0)  then
			this.is_button_b_pressed = true
			this.is_button_b_released = true
		end if
		
		
		if joystick.pressed(1)  then
			this.is_button_a_pressed = true
			this.is_button_a_released = true
		end if
	end if
	
	if keyboard.pressed( FB.SC_UP ) then
		this.is_button_a_pressed = true
		this.is_button_a_released = true
	end if
	
	if keyboard.pressed( FB.SC_SPACE   ) then
		this.is_button_b_pressed = true
		this.is_button_b_released = true
	end if
	
	
	if this.is_button_a_pressed and this.is_button_a_released then
		this.is_button_a_released = false
		this.is_button_a_pressed = false
		this.is_jump = true
		this.jump_power = timer - button_a_begin_timer
		if this.jump_power > 1 then this.jump_power = 1
	end if
	
	if this.is_button_b_pressed and this.is_button_b_released then
		this.is_button_b_released = false
		this.is_button_b_pressed = false
		this.is_fire = true
	end if
	

	
	this.x = 0
	this.y = 0
	
	'joystick
	if joystick.is_present then
		'this just to prevent wrong input from un-calibrated analogue joystick
		if abs(joystick.get_x()) > 0.1  then
			this.x = joystick.get_x()
			'this.y = joystick.get_y()
			is_giving_input = true
		end if
		
		if abs(joystick.get_y()) > 0.2 then
			this.y = joystick.get_y()
			is_giving_input = true
		end if
		
	end if

	'keyboard
	if keyboard.hold( FB.SC_LEFT ) then
		this.x = -1
		is_giving_input = true
	end if
	
	if keyboard.hold( FB.SC_RIGHT ) then
		this.x = 1
		is_giving_input = true
	end if
	
	if keyboard.hold( FB.SC_DOWN ) then
		this.y = 1
		is_giving_input = true
	end if
	
	
	
	if is_giving_input then this.direction = _abtp (0 , 0, x, y)
	
	this.x_trigger += ((this.x - this.x_trigger) / _PL_X_TRIGGER_EASING_RATIO)
	if this.x_trigger > -0.1 and this.x_trigger < -0 then this.x_trigger = -0
	if this.x_trigger < 0.1 and this.x_trigger > 0 then this.x_trigger = 0
	
end sub

sub user_input.draw_input (x as single, y as single)
	dim line_color as Ulong
	
	if not is_giving_input then
		line_color = C_RED
	else
		line_color = C_GREEN
	end if
	
	circle (x, y), this.speed, line_color
	draw_arrow (x, y, this.direction, this.speed * 10, line_color)
	
	line (x + this.x_trigger * _PL_MAX_SPEED*10, y-10)-(x + this.x_trigger * _PL_MAX_SPEED*10 + 2, y+10), C_PURPLE, BF

end sub

function user_input.get_x () as single
	return this.x
end function

function user_input.get_y () as single
	return this.y
end function
