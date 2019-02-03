declare Sub utility_consmessage (Byref e As String)

declare Sub utility_logerror (Byref e As String)


declare sub load_level_file 		(filename as string, level_tiles() as tile_proto)
declare sub initialize_level_tiles 	(level_tiles() as tile_proto)
declare sub draw_arrow				(x as single, y as single, rds as single, a_l as single, cl as Uinteger)

declare function _abtp 				(x1 as single,y1 as single,x2 as single,y2 as single) as single
declare function is_point_into_area	(xp as single, yp as single, x1 as single, y1 as single, x2 as single, y2 as single) as boolean
declare function distance 			(x1 as single, y1 as single, x2 as single, y2 as single) as single
declare sub draw_level				(level_tiles() as tile_proto, x as single, y as single)
declare sub load_sprite_sheet 		( 	bmp() as Ulong ptr, w as integer, h as integer, _
										cols as integer, rows as integer, _
										Byref bmp_path as string)

declare function manhattan_distance (x1 as Ulong, y1 as Ulong, x2 as Ulong, y2 as Ulong) as Ulong




declare sub draw_button (x as integer, y as integer, w as integer,_
							h as integer, label as string,_
							is_selected as boolean)
							
declare function zero_filled(n as Ulong) as string
							
declare function ImageScale(byval s as fb.Image ptr, _
                    byval w as integer, _
                    byval h as integer) as fb.Image ptr
                    
declare function is_collision( 	Ax1 as single, Ay1 as single, _
						Ax2 as single, Ay2 as single, _
						Bx1 as single, By1 as single, _
						Bx2 as single, By2 as single ) as boolean
                    

function zero_filled(n as Ulong) as string

	if n < 10 then
		return "00000" + str(n)
	elseif n < 100 then
		return "0000" + str(n)
	elseif n < 1000 then
		return "000" + str(n)
	elseif n < 10000 then
		return "00" + str(n)
	elseif n < 100000 then
		return "0" + str(n)
	else 
		return str(n)
	end if


end function                 
                    
                    
				
							
function ImageScale(byval s as fb.Image ptr, _
                    byval w as integer, _
                    byval h as integer) as fb.Image ptr
  #macro SCALELOOP()
  for ty = 0 to t->height-1
    ' address of the row
    pr=ps+(y shr 20)*sp
    x=0 ' first column
    for tx = 0 to t->width-1
      *pt=pr[x shr 20]
      pt+=1 ' next column
      x+=xs ' add xstep value
    next
    pt+=tp ' next row
    y+=ys ' add ystep value
  next
  #endmacro
  ' no source image
  if s        =0 then return 0
  ' source widh or height legal ?
  if s->width <1 then return 0
  if s->height<1 then return 0
  ' target min size ok ?
  if w<2 then w=1
  if h<2 then h=1
  ' create new scaled image
  dim as fb.Image ptr t=ImageCreate(w,h,RGB(0,0,0))
  ' x and y steps in fixed point 12:20
  dim as Long xs=&H100000*(s->width /t->width ) ' [x] [S]tep
  dim as Long ys=&H100000*(s->height/t->height) ' [y] [S]tep
  dim as integer x,y,ty,tx
  select case as const s->bpp
  case 1 ' color palette
    dim as ubyte    ptr ps=cptr(ubyte ptr,s)+32 ' [p]ixel   [s]ource
    dim as uinteger     sp=s->pitch             ' [s]ource  [p]itch
    dim as ubyte    ptr pt=cptr(ubyte ptr,t)+32 ' [p]ixel   [t]arget
    dim as uinteger     tp=t->pitch - t->width  ' [t]arget  [p]itch
    dim as ubyte    ptr pr                      ' [p]ointer [r]ow
    SCALELOOP()
  case 2 ' 15/16 bit
    dim as ushort   ptr ps=cptr(ushort ptr,s)+16
    dim as uinteger     sp=(s->pitch shr 1)
    dim as ushort   ptr pt=cptr(ushort ptr,t)+16
    dim as uinteger     tp=(t->pitch shr 1) - t->width
    dim as ushort   ptr pr
    SCALELOOP()
  case 4 ' 24/32 bit
    dim as ulong    ptr ps=cptr(Ulong ptr,s)+8
    dim as uinteger     sp=(s->pitch shr 2)
    dim as ulong    ptr pt=cptr(Ulong ptr,t)+8
    dim as uinteger     tp=(t->pitch shr 2) - t->width
    dim as ulong    ptr pr
    SCALELOOP()
  end select
  return t
  #undef SCALELOOP
end function
	

sub draw_button (x as integer, y as integer, w as integer,_
							h as integer, label as string,_
							is_selected as boolean)
							
	Line (x,y)-(x+w,y+h),C_GRAY,BF
	Line (x,y)-(x+w,y+h),C_WHITE,B
	
	if (is_selected) then
		Line (x,y)-(x+w,y+h),C_DARK_RED,BF
		Line (x,y)-(x+w,y+h),C_GRAY,B
	end if
	
	draw string (x + (w \ 2) - len(label)*4, y + h\2 - 2), label
	
end sub

function manhattan_distance (x1 as Ulong, y1 as Ulong, x2 as Ulong, y2 as Ulong) as Ulong

	return abs(x1-x2)+abs(y1-y2)

end function


										

function distance (x1 as single, y1 as single, x2 as single, y2 as single) as single
    return Sqr(((x1-x2)*(x1-x2))+((y1-y2)*(y1-y2)))
end function



function is_point_into_area(xp as single, yp as single, x1 as single, y1 as single, x2 as single, y2 as single) as boolean

	if xp >= x1 and xp < x2 and yp >= y1 and yp < y2 then
		return true
	else
		return false
	end if

end function



sub load_level_file (filename as string, level_tiles() as tile_proto)

	'modified version of a snippet by MrSwiss
	'Loading a CSV file into an array
	'https://www.freebasic.net/forum/viewtopic.php?t=25693
	
	dim as string textline, token, tokens()
	dim as integer pos1 = 1, pos2 , filenum, res, i, j

	filenum = Freefile
	res 	= Open (filename, For Input, As #filenum)
	
	
	redim level_tiles(0 to 0, 0 to 0)

	i = 0
	if res = 0 then 
		While (Not Eof(filenum))
			
			Line Input #filenum, textline ' Get one whole text line
			
			redim tokens(0 to 0)
			
			do
				' next semicolor position
				pos2 = instr(pos1, textline, ";")
				' if new semicolon found,
				' take the substring between the last semicolon and it
				if pos2 > 0 Then
					token = mid(textline, pos1, pos2 - pos1)    ' calc. len (new)
				Else
					token = Mid(textline, pos1)
				end if
			   
				' add the token to the end of the array (slightly inefficient)
				tokens(ubound(tokens)) = token
				redim preserve tokens(0 to ubound(tokens)+1)
				
			   
				pos1 = pos2 + 1 ' added + 1
			loop until pos2 = 0
			
			redim preserve level_tiles(0 to i, 0 to Ubound(tokens)-2)
			
			for j = 0 to Ubound(level_tiles, 2)
				level_tiles(i, j).attributes.value = CUlngint("&h"+(tokens(j)))
			next j
			
			i +=1
			
		Wend

		Close #filenum
	end if

end sub

sub initialize_level_tiles (level_tiles() as tile_proto) 

	dim as integer i, j

	for i = 0 to Ubound(level_tiles)
		for j = 0 to Ubound(level_tiles,2)
			level_tiles(i,j).w 				= TILE_W
			level_tiles(i,j).h 				= TILE_H
			level_tiles(i,j).x				= j*TILE_W
			level_tiles(i,j).y				= i*TILE_H
			level_tiles(i,j).is_selected 	= false
		next j
	next i

end sub

sub draw_arrow(x as single, y as single, rds as single, a_l as single, cl as Uinteger)
    line (x, y)-(x + a_l * cos(rds), y + a_l *  -sin(rds)),cl
    line (x + a_l * cos(rds), y + a_l *  -sin(rds))-(x + a_l/1.5 * cos(rds-0.5), y + a_l/1.5 *  -sin(rds-0.5)),cl
    line (x + a_l * cos(rds), y + a_l *  -sin(rds))-(x + a_l/1.5 * cos(rds+0.5), y + a_l/1.5 *  -sin(rds+0.5)),cl
end sub


function _abtp (x1 as single,y1 as single,x2 as single,y2 as single) as single
	return -Atan2(y2-y1,x2-x1)
end function


sub load_sprite_sheet ( 	bmp() as Ulong ptr, w as integer, h as integer, _
						cols as integer, rows as integer, _
						Byref bmp_path as string)
	

	dim as Ulong  c, x, y, t_w, t_h, tl 
	

	
	tl = cols * rows
	t_w = w\cols
	t_h = h\rows
	y = 0
	x = 0
	
	#IFDEF DEBUG_MODE

	'check if specified file exists
	   if FileExists(bmp_path)  then
			utility_consmessage("loading bitmap: " + bmp_path)
	   else
			utility_consmessage("WARNING!: " + bmp_path + "doesn't exist")
	   end if
	   
	#ENDIF
	
	BLOAD bmp_path, 0

	for c = 0 to Ubound(bmp)
		if c > 0 and c mod cols = 0 then
			y+= t_h 
			x = 0 
		end if
		bmp(c) = IMAGECREATE (t_w, t_h)
		GET (x, y)-(x + t_w - 1, y + t_h - 1), bmp(c)
		x += t_w

	next c
	
	

end sub


function is_collision( 	Ax1 as single, Ay1 as single, _
						Ax2 as single, Ay2 as single, _
						Bx1 as single, By1 as single, _
						Bx2 as single, By2 as single ) as boolean
						
	if (Ay2 < By1) orelse (Ay1 > By2) orelse (Ax2 < Bx1) orelse (Ax1 > Bx2) then
		return false
	else
		return true
	end if
	
end function


Sub utility_consmessage (Byref e As String)
  Dim As Integer f = Freefile()
  Open cons For Output As #f
  Print #f, e
  Close #f
End Sub

Sub utility_logerror (Byref e As String)
  Dim As Integer f = Freefile()
 
  Open "errorlog.txt" For Append As #f
  Print #f, Date & Chr(9) & Time & Chr(9) & e
  Close #f
End Sub
