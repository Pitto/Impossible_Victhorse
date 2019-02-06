'' A simple class to help us deal with the keyboard
' by paul doe -- see topic: https://www.freebasic.net/forum/viewtopic.php?f=15&t=26673
type keyboard_proto
   public:
      declare function hold( byval as long ) as boolean
      declare function pressed( byval as long ) as boolean
      declare function released( byval as long ) as boolean
      
      declare constructor()
      
   private:
      '' These will store the states of the keys
      m_oldKey( 0 to 255 )   as boolean
      m_newKey( 0 to 255 )   as boolean
end type

constructor keyboard_proto()

end constructor

function keyboard_proto.hold( byval index as long ) as boolean
   '' Returns whether a key is being held
   return( cbool( multiKey( index ) ) )
end function

function keyboard_proto.pressed( byval index as long ) as boolean
   '' Returns whether a key was pressed
   m_oldKey( index ) = m_newKey( index )
   m_newKey( index ) = cbool( multiKey( index ) )
   
   return( m_oldKey( index ) = false andAlso m_newKey( index ) = true )
end function

function keyboard_proto.released( byval index as long ) as boolean
   '' Returns whether a key was released
   m_oldKey( index ) = m_newKey( index )
   m_newKey( index ) = cbool( multiKey( index ) )
   
   return( m_oldKey( index ) = true andAlso m_newKey( index ) = false )
end function
