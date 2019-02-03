'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


type level_data_proto
	as Ulong time_left
	as string*20 heading
	as string*20 language_name
	as string*20 tip_1
	as string*20 tip_2
	as Ubyte img
	as Ubyte scenario
	as Ubyte wallpaper
	as Ubyte music_slot
end type

dim level_data ( 0 to ...) as level_data_proto => { _
		( 180, _
		"    Forrhex  Dump   ", _
		"   R U B Y L A N D  ",_
		"Collect all keywords",_
		"by standing upon PCs",_
		0, 4, 0, 0 ),_
		( 360, _
		"  Server side story ", _
		"   P E R L T O W N  ",_
		"  Collect 100 coins ",_
		"to get an extra-life",_
		0, 4, 1, 1 ),_
		( 360, _
		"Someone like it .DOT", _
		"      The VB Net    ",_
		"Using SYS64738 speed",_
		"up keyword's  search",_
		0, 6, 3, 2 ),_
		( 420, _
		"    Inside the VM   ", _
		"    JAVA the Hutt   ",_
		" Keep away from the ",_
		"      green guy     ",_
		0, 5, 2, 3 ),_
		( 420, _
		"To kill a mockingbit", _
		"   P Y T H O N Y A  ", _
		"       Warning!     ",_
		"    Flying robots   ",_
		0, 6, 3, 0),_
		( 480, _
		"        OOPs!       ", _
		"     C PLUS PLUS    ", _
		" Take a V to became ",_
		"     SuperVictor    ",_
		0, 7, 1, 1),_
		( 600, _
		"The lord of the bits", _
		"          C         ", _
		" Keep away from the ",_
		"   DARKISTRA guys   ",_
		0, 5, 3, 2),_
		( 600,_
		"The FBC strikes back", _
		"   A S S E M B L Y  ",_
		" JMP! JMP! JMP! JMP!",_
		"JMP! JMP! JMP! JMP! ",_
		0, 6, 3, 3),_
		( 600, _
		"The wrath  of Victor", _
		"    MACHINE CODE    ",_
		"Unleash the power of",_
		"     the  horse!    ",_
		0, 5, 3, 0)_
		}


