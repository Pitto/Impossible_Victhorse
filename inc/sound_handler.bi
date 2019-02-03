'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


type sound_handler_proto
	
	declare constructor()
	
	declare sub set_queued_sound(sound_slot as Ulong)
	declare function get_queued_sound() as Ulong


	is_active as boolean
	
	private:
		queued_sound as Ulong
		
	
end type


constructor sound_handler_proto()

	queued_sound = 0 

end constructor

sub sound_handler_proto.set_queued_sound(sound_slot as Ulong)

	this.queued_sound = sound_slot
	
end sub

function sound_handler_proto.get_queued_sound() as Ulong

	return this.queued_sound
	
end function
