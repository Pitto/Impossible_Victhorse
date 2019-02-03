'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


type cheat_proto

	enabled as boolean

	declare sub set_player_energy(value as Ubyte, player as player_proto)
	declare sub set_player_powerup(value as Ubyte, player as player_proto)
	declare sub get_player_floppies(value as Ubyte, player as player_proto)
	declare sub get_player_coins(value as Ubyte, player as player_proto)
	declare sub get_sys64738(value as Ubyte, player as player_proto)
	
	
	declare sub set_all_keywords_as_found()
	declare sub finish_level()
	declare sub get_yellow_key(player as player_proto)
	declare sub get_red_key(player as player_proto)
	declare sub get_blue_key(player as player_proto)
	declare sub set_keyword_to_find(value as Ulong, level as level_proto)
	

	
	declare sub update(keyboard as keyboard_proto, player as player_proto, level as level_proto)
	
	declare constructor()
	

end type

constructor cheat_proto()

	this.enabled = false

end constructor

sub cheat_proto.update(keyboard as keyboard_proto, player as player_proto, level as level_proto)

	if keyboard.released( FB.SC_TAB) then
		this.enabled = not this.enabled
	end if
	
	if this.enabled andalso CBool(multikey (FB.SC_LSHIFT ))then
	
		if keyboard.released( FB.SC_Q) then
			this.set_player_energy(0, player)
		end if
		if keyboard.released( FB.SC_E) then
			this.set_player_energy(100, player)
		end if
		if keyboard.released( FB.SC_P) then
			this.set_player_powerup(true, player)
		end if
		if keyboard.released( FB.SC_F) then
			this.get_player_floppies(50, player)
		end if
		if keyboard.released( FB.SC_C) then
			this.get_player_coins(33, player)
		end if
		if keyboard.released( FB.SC_S) then
			this.get_sys64738(1, player)
		end if
		
		if keyboard.released( FB.SC_Y) then
			this.get_yellow_key(player)
		end if
		if keyboard.released( FB.SC_B) then
			this.get_blue_key(player)
		end if
		if keyboard.released( FB.SC_R) then
			this.get_red_key(player)
		end if
		if keyboard.released( FB.SC_T) then
			level.set_time_left(999)
		end if
		
		if keyboard.released( FB.SC_K) then
			this.set_keyword_to_find(0, level)
		end if
		
		if keyboard.released( FB.SC_Z) then
			player.set_all_keywords_as_non_found()
		end if
		if keyboard.released( FB.SC_X) then
			player.set_all_keywords_as_found()
		end if
		if keyboard.released( FB.SC_L) then
			level.is_completed = true
		end if
		if keyboard.released( FB.SC_1) then
			player.points += 5000
		end if
	
	
	end if
	
end sub

sub cheat_proto.set_player_energy(value as Ubyte, player as player_proto)

	player.energy = value

end sub

sub cheat_proto.set_player_powerup(value as Ubyte, player as player_proto)

	player.is_powerup = value

end sub

sub cheat_proto.get_player_floppies(value as Ubyte, player as player_proto)

	player.ammo_floppies += value

end sub

sub cheat_proto.get_player_coins(value as Ubyte, player as player_proto)

	player.coins += value

end sub

sub cheat_proto.get_sys64738(value as Ubyte, player as player_proto)

	player.ammo_sys_64738 += value

end sub

sub cheat_proto.get_yellow_key(player as player_proto)

	player.has_yellow_key = true

end sub

sub cheat_proto.get_blue_key(player as player_proto)

	player.has_blue_key = true

end sub

sub cheat_proto.get_red_key(player as player_proto)

	player.has_red_key = true

end sub

sub cheat_proto.set_keyword_to_find (value as Ulong, level as level_proto)

	level.keyword_to_find = value

end sub
