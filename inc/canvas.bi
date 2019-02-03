'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


type canvas_proto
	original_size as FB.Image ptr
	double_size as FB.Image ptr
	source_area as FB.Image ptr
	declare sub scale_canvas()
	declare sub clear_canvas()
	
	declare constructor()
	declare destructor()
end type

constructor canvas_proto()
	this.original_size = IMAGECREATE (SCR_W, SCR_H)
	this.double_size = IMAGECREATE (SCR_W, SCR_H)
	this.source_area = IMAGECREATE (SCR_W\2, SCR_H\2)

end constructor

destructor canvas_proto()
	ImageDestroy this.original_size
	ImageDestroy this.double_size
	ImageDestroy this.source_area
end destructor

Sub canvas_proto.scale_canvas()
	
	'ImageDestroy this.double_size
	'ImageDestroy this.source_area
	
	'this.double_size = NULL
	'this.source_area = NULL
	
	'this.double_size = IMAGECREATE (SCR_W, SCR_H)
	'this.source_area = IMAGECREATE (SCR_W\2, SCR_H\2)
	
	'if this.double_size <> 0 and this.source_area <> 0 and this.original_size <> 0 then
	
		'GET this.original_size, (160, 120)-(439, 359), this.source_area
		'this.double_size = ImageScale(this.source_area, SCR_W, SCR_H)
		
	'end if

end sub

sub canvas_proto.clear_canvas()
	
	line this.original_size, (0,0)-step(SCR_W, SCR_H), C_C64_Black, BF

end sub
