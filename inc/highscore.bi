'this code is released under the terms of
'GNU LESSER GENERAL PUBLIC LICENSE
'Version 3, 29 June 2007
'see COPING.txt in root folder


type HighScore
    as string playername
    as string score
    as string dateof
   
    declare sub Set ( pn as string, inscore as string, indateof as string )
end type

sub HighScore.Set ( pn as string, inscore as string, indateof as string )
   
    this.playername = pn
    this.score = inscore
    this.dateof = indateof
   
end sub


type HighScoreTable
    dim as HighScore     Record(HIGHSCORE_ENTRIES)
    dim as string        filename
    
    dim as Long score_position
   
    declare sub Load ( fn as string = "txt/highscores")
    declare sub Insert ( in_score as HighScore )
    declare sub Save ()
    declare sub PrintHST ()
    declare sub Display(image_buffer as FB.Image ptr)
       
end type

sub HighScoreTable.Insert ( in_score as HighScore )
   
	score_position = 0
   
    for i as integer = 1 to HIGHSCORE_ENTRIES
        if val(in_score.score) > val(Record(i).score) then
            for ii as integer = HIGHSCORE_ENTRIES to i step -1
                Record(ii).score = Record(ii-1).score
                Record(ii).playername = Record(ii-1).playername
                Record(ii).dateof = Record(ii-1).dateof               
            next
            Record(i).score = in_score.score
            Record(i).playername = in_score.playername
            Record(i).dateof = in_score.dateof
            score_position = i
            exit for
        endif
   
    next
   
end sub

sub HighScoreTable.Save ()
   
    if filename = "" then filename = "txt/highscores"
       
   
    open filename for output as #1
       
    for i as integer = 1 to HIGHSCORE_ENTRIES
        print #1, Record(i).playername
        print #1, Record(i).Score
        print #1, Record(i).Dateof
    next
   
    close #1

end sub

sub HighScoreTable.Load ( fn as string = "txt/highscores" )
   
    open fn for input as #1
   
    for i as integer = 1 to HIGHSCORE_ENTRIES
        line input #1, Record(i).playername
        line input #1, Record(i).Score
        line input #1, Record(i).dateof
    next
   
    this.filename = fn
    close #1
   
end sub

sub HighScoreTable.PrintHST()
   
    for i as integer = 1 to HIGHSCORE_ENTRIES
        ? i,Record(i).playername, Record(i).Score,Record(i).DateOf
    next

end sub

sub HighScoreTable.Display(image_buffer as FB.Image ptr)
   

Draw String image_buffer, (150, 31), "Player", &hff
Draw String image_buffer, (350, 31), "Score", &hff
Draw String image_buffer, (490, 31), "Date", &hff

for i as integer = 1 to HIGHSCORE_ENTRIES
    
   
    
    Draw String image_buffer,  ( 150, 31 + (i*25) ), Record(i).Playername
    Draw String image_buffer, ( 350, 31 + (i*25) ), Record(i).Score
    Draw String image_buffer, ( 490, 31 + (i*25) ), Record(i).Dateof
    
    
next

   
end sub

