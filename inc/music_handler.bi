'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


type music_handler_proto

	declare constructor()
	declare destructor()

	declare sub play_background_music(music_slot as Ulong)

	private:
	
	Device as SoundDevice = SoundDevice()

	music as SoundBuffer = SoundBuffer(SampleBuffer("audio/music/the_nada_one.mod"))
		
		
	''''SoundBuffer(SampleBuffer("audio/music/drozerix_-_neon_techno.mod"))}
	'SoundBuffer(SampleBuffer("audio/music/forestry.mod")),_
	'SoundBuffer(SampleBuffer("audio/music/kc-dancinonamiga.mod")),_
	'SoundBuffer(SampleBuffer("audio/music/once_is_not_enough.mod")),_
	'SoundBuffer(SampleBuffer("audio/music/pxf_protrck2.mod")),_
	'SoundBuffer(SampleBuffer("audio/music/sgs-c306.mod")),_
	'SoundBuffer(SampleBuffer("audio/music/sgs-crlz.mod")),_
	'SoundBuffer(SampleBuffer("audio/music/sgs-excl.mod")),_
	'SoundBuffer(SampleBuffer("audio/music/sgs-rt03.mod")),_
	'SoundBuffer(SampleBuffer("audio/music/sgs-rt04.mod")),_
	'SoundBuffer(SampleBuffer("audio/music/the_hunt_for_lars.mod")),_
	'SoundBuffer(SampleBuffer("audio/music/the_nada_one.mod"))}

end type


constructor music_handler_proto()
	music.volume = 50

end constructor

destructor music_handler_proto()
	dim i as Ulong
	
	'for i = 0 to Ubound(music)
	'	music(i).Destroy()
	'next i
	music.pause
	music.Destroy()
	
end destructor

sub music_handler_proto.play_background_music(music_slot as Ulong)
	music.Play
	'music(music_slot).Play
end sub

