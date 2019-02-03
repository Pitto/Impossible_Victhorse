'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


'types__________________________________________________________________
type tile_proto
	w			as integer
	h			as integer
	x 			as integer
	y 			as integer
	value		as Ulongint
	attributes	as proto_tile_attributes
	is_selected	as boolean
	collide_flag as boolean
end type

type keyword_proto
	x as Long
	y as Long
	speed as Long
	_color as Ulong
	id as Ulong
	label as string
	is_found as boolean
end type

type position_proto
	x as Ulong
	y as Ulong
end type
