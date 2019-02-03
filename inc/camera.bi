'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


type camera_proto
	x as single
	y as single
	w as Ulong
	h as Ulong
	
	bound_x1 as single
	bound_y1 as single
	bound_x2 as single
	bound_y2 as single
	
	
	direction as single
	speed as single
	x_offset as single
	y_offset as single
	
	Declare Constructor()
	Declare Sub update(x as single, y as single)
	declare sub set_bounds(x1 as single, y1 as single, x2 as single, y2 as single)
	declare sub check_bounds()
	declare sub set_position(x as single, y as single)
end type

Constructor.camera_proto()
	x = 0 
	y = 0
	speed = 0
	direction = 0
	w = SCR_W\2
	h = SCR_H\2
end Constructor

sub camera_proto.set_position(x as single, y as single)

	this.x = x
	this.y = y
	
	this.x_offset = this.x - this.w
    this.y_offset = this.y - this.h
    
	this.check_bounds()

end sub

sub camera_proto.check_bounds()

  'bounds check
    if this.x_offset  < this.bound_x1 then this.x_offset = this.bound_x1
    if this.y_offset  < this.bound_y1 then this.y_offset = this.bound_y1
    
    if this.x_offset  > this.bound_x2 then this.x_offset = this.bound_x2
    if this.y_offset  > this.bound_y2 then this.y_offset = this.bound_y2

end sub

sub camera_proto.update(x as single, y as single)

	this.speed = distance(this.x, this.y, x, y) / CAMERA_EASING_RATIO
	if this.speed < 0.1 then this.speed = 0
	this.direction = _abtp(this.x, this.y, x, y)
    this.x += cos(this.direction) *this.speed
    this.y += -sin(this.direction)*this.speed
    
	this.x_offset = this.x - this.w
    this.y_offset = this.y - this.h
    
	this.check_bounds()
    
    
end sub


sub camera_proto.set_bounds(x1 as single, y1 as single, x2 as single, y2 as single)
	this.bound_x1 = x1
	this.bound_y1 = y1
	this.bound_x2 = x2
	this.bound_y2 = y2
end sub
