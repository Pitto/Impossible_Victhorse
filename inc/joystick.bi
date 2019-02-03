'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


'' A simple class to help us deal with the joystick
' adapted from a snipped by paul doe - -- see topic: https://www.freebasic.net/forum/viewtopic.php?f=15&t=26673
type joystick_proto
   public:
      is_present as boolean
      result as Ulong
      declare function hold( byval as long ) as boolean
      declare function pressed( byval as long ) as boolean
      declare function released( byval as long ) as boolean
      
      declare function lever_up_pressed() as boolean
      declare function lever_down_pressed() as boolean
      
      declare function get_x() as single
      declare function get_y() as single
      declare function get_id() as Ulong
	declare sub update()
      declare constructor()
      
   private:
      '' These will store the states of the keys
      m_oldKey( 0 to 26 )   as boolean
      m_newKey( 0 to 26 )   as boolean
      
      lu_oldState as Boolean
      lu_newState as Boolean
      ld_oldState as Boolean
      ld_newState as Boolean
      
      
      id as Ulong
      buttons as integer
      x as single
      y as single
       
      
      
end type

constructor joystick_proto ()

	dim i as Ulong
	for i = 0 to 15
		if GetJoystick(i,buttons,x,y) = 0 then
			this.id = i
			this.is_present = true
			exit for
		end if
	next i

	for i = 0 to Ubound (m_oldKey)
		m_oldKey(i) = false
		m_newKey(i) = false
	next i

	lu_oldState = false
	lu_newState = false
	ld_oldState = false
	ld_newState = false


end constructor

sub joystick_proto.update()
	this.result = GetJoystick(this.id,this.buttons,this.x,this.y)
end sub

function joystick_proto.get_x() as single

	return this.x
end function

function joystick_proto.get_y() as single

	return this.y
end function

function joystick_proto.get_id() as Ulong
	return this.id
end function

function joystick_proto.hold( byval index as long ) as boolean
   '' Returns whether a key is being held
   return( cbool( this.buttons And (1 Shl index) ) )
end function

function joystick_proto.pressed( byval index as long ) as boolean
   '' Returns whether a key was pressed
   'this.result = GetJoystick(this.id,this.buttons,this.x,this.y)
   
   m_oldKey( index ) = m_newKey( index )
   m_newKey( index ) = cbool( this.buttons And (1 Shl index)) 'multiKey( index ) )
   
   return( m_oldKey( index ) = false andAlso m_newKey( index ) = true )
end function

function joystick_proto.released( byval index as long ) as boolean
   '' Returns whether a key was released
   'this.result = GetJoystick(this.id,this.buttons,this.x,this.y)
   
   m_oldKey( index ) = m_newKey( index )
   m_newKey( index ) = cbool( this.buttons And (1 Shl index) )
   
   return( m_oldKey( index ) = true andAlso m_newKey( index ) = false )
end function

function joystick_proto.lever_up_pressed() as boolean

	lu_oldState = lu_newState
	
	if this.get_y() > 0.2 then
		lu_newState = true
	else
		lu_newState = false
	end if
	
	return lu_oldState = false andAlso lu_newState = true

end function

function joystick_proto.lever_down_pressed() as boolean

	ld_oldState = ld_newState
	
	if this.get_y() < -0.2 and this.get_y() > -1.1 then
		ld_newState = true
	else
		ld_newState = false
	end if
	
	return ld_oldState = false andAlso ld_newState = true

end function
