Type testing
  Private:
    nome As String
  Public:
    number As Integer
    link as Ulong ptr
  Declare Sub setNome( ByRef newnome As String )
  Declare function print_nome() as String
  Declare Constructor()
  Declare Destructor()
End Type

constructor testing()
	this.link = allocate(sizeof(Ulong))
	*this.link = 150
	this.number = 50
	this.setNome ("pippo")
end constructor

destructor testing()
	deallocate link
	print *link
end destructor

Sub testing.setnome( ByRef newnome As String )
  this.nome = newnome 
End Sub

function testing.print_nome() as String
	return this.nome
end function

dim i as integer


Dim myVariable(0 to 4) As testing

'' We can access these members anywhere since
'' they're public

'myVariable.setNome( "FreeBASIC" )

print myVariable(0).number
print (*myVariable(0).link)
print myVariable(0).print_nome()
print myVariable(1).number
print (*myVariable(1).link)
print myVariable(1).print_nome()


sleep
