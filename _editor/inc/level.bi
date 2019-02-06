Type proto_level
	number as UShort 'N° of level
	style as UShort 'graphic style of the level
	cols as Ulong
	rows as Ulong	
	redim tiles (0 to 0, 0 to 0) 	as tile_proto
	
	Declare Constructor(number as UShort, style as UShort)
	Declare Destructor()
End Type


Constructor proto_level(number as UShort, style as UShort)
	
	load_level_file ("level.lev", this.level_tiles() )
	init_level_tiles (this.level_tiles())
	
	
End Constructor
