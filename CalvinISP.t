% Calvin C.
% Ms. Dyke
% June 10th, 2011
% Use a music keyboard to make music.
% Declaration Section
import GUI
var mainWin := Window.Open ("position:center;center,graphics:640;400")
View.Set ("nobuttonbar,title:Turing Music Maker")
%It may seem that it is not KISS to have 4 sections that all make integers initialized at 0, but it is easier for organization purposes
var goToMainMenu, makeMusic, exitProgram, instructions, playMusic, listenAgain : int := 0 %GLOBAL BUTTONS
var wholeNote, halfNote, quarterNote, eighthNote, sixteenthNote : int := 0 %NOTE LENGTH GLOBAL BUTTONS
var whole, half, halfDown, quarter, quarterDown, eighth, eighthDown, sixteenth, sixteenthDown : int := 0 %PICTURES
var numberOfNotes, staff, mainStaff, ledger, moveNotes, noteHold : int := 0 %OTHER VARAIBLES AND SPRITES
var finished : boolean := false %IS IT FINISHED?
var noteNumber : flexible array 1 .. 1 of int %NUMBER OF NOTES AFTER THEY REACH THE END OF THE SCREEN
var noteLength : real := 0 %THE NUMBER OF BEATS
var musicString, counterOctave : string := "" %THE MUSIC CODE
var lengthOfNote : string (2) := "1" %THE LENGTH CODE
var noteToAdd, noteToAddDown : int := 0 %THE NOTE TO ADD
% Program Title
proc title
    var font1 := Font.New ("Courier:15")
    cls
    Font.Draw ("Turing Music Maker", (maxx - 216) div 2, maxy - 20, font1, black)
    locate (3, 1)
end title
proc noteType %RADIO AND CLICKED BUTTONS
    if GUI.GetEventWidgetID = wholeNote then %If whole note chosen
	lengthOfNote := "1" %The length is set to whole note
	noteToAdd := whole %The picture to show is the whole note
	noteLength := 4 %Is 4 beats
    elsif GUI.GetEventWidgetID = halfNote then %If half note chosen
	lengthOfNote := "2" %The length is half note
	noteToAdd := half %Picture to show is half note
	noteToAddDown := halfDown
	noteLength := 2 %Is 2 beats
    elsif GUI.GetEventWidgetID = quarterNote then %Quarter Note Chose
	lengthOfNote := "4" %Code for quarter note
	noteToAdd := quarter
	noteToAddDown := quarterDown
	noteLength := 1 %1 beat
    elsif GUI.GetEventWidgetID = eighthNote then
	lengthOfNote := "8" %Code for eighth note
	noteLength := 0.5 %Half of a beate
	noteToAdd := eighth
	noteToAddDown := eighthDown
    elsif GUI.GetEventWidgetID = sixteenthNote then %If sixteenth note chosen
	lengthOfNote := "6" %Code for sixteenth note
	noteLength := 0.25 %A quarter of a beat
	noteToAdd := sixteenth
	noteToAddDown := sixteenthDown
    elsif GUI.GetEventWidgetID = playMusic or GUI.GetEventWidgetID = listenAgain then %If play music was chosen
	Music.Play (musicString)
	Music.Play (counterOctave)
    else
	finished := true %IF finish was chosen
    end if
end noteType
% Processing & Output
proc display %DISPLAY MUSIC CODE
    title
    GUI.Show (goToMainMenu)
    locate (5, 1)
    put "Your music code is: ", musicString
    listenAgain := GUI.CreateButton (265, 200, 0, "Listen Again", noteType) %PLAYS MUSIC
    Music.Play (musicString)
    Music.Play (counterOctave)
end display
proc scroll (value : int) %THE PROCEDURE FOR THE SLIDER BAR
    Sprite.SetPosition (moveNotes, 630 - value, 155, false) %MOVE THE MAIN STAFF
    if upper (noteNumber) > 1 then %MOVE THE INDIVIDUAL NOTES
	for x : 1 .. upper (noteNumber) - 1
	    Sprite.SetPosition (noteNumber (x), ((630 + 520) - value) + (x - 1) * 30, 155, false)
	end for
    else
	if noteNumber (1) not= 0 then %IF IT'S ONLY ONE
	    for x : 1 .. 1
		Sprite.SetPosition (noteNumber (x), ((630 + 520) - value) + (x - 1) * 30, 155, false)
	    end for
	end if
    end if
end scroll
% User Input
proc userInput
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOCAL DECLARATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    var sliderBar, previousx, messageDisplay, finish, mx, my, b, x : int := 0
    var measure : real := 0
    var note, previousl : string := ""
    GUI.Hide (exitProgram) %Hide Main Menu buttons
    GUI.Hide (instructions)
    GUI.Hide (makeMusic)
    title
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GET, DRAW, AND SCALE PICTURES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mainStaff := Pic.FileNew ("pictures/blank staff.jpg") %Get the staff picture
    var keyboard := Pic.FileNew ("pictures/keyboardshort.jpg") %Get the keyboard picture
    mainStaff := Pic.Scale (mainStaff, 640, 150) %Scale them
    keyboard := Pic.Scale (keyboard, 640, 150)
    Pic.Draw (mainStaff, -10, 130, picCopy) %Draw the staff
    Pic.Draw (keyboard, 0, 0, picCopy)
    Pic.Free (keyboard)
    Pic.Free (mainStaff)
    staff := Pic.New (0, 130, 120, 285)
    Pic.SetTransparentColour (staff, 101)
    staff := Sprite.New (staff)
    ledger := Pic.FileNew ("pictures/ledgerline.jpg")
    whole := Pic.FileNew ("pictures/wholenotesmaller.jpg") %Get notes pictures
    half := Pic.FileNew ("pictures/halfnoteupsmaller2.jpg") %23x56
    halfDown := Pic.Rotate (half, 180, 11, 28)
    quarter := Pic.FileNew ("pictures/quarternoteup.jpg") %50x116
    quarterDown := Pic.Rotate (quarter, 180, 25, 58)
    eighth := Pic.FileNew ("pictures/8thnoteupsingle.jpg") %77x116
    eighthDown := Pic.Rotate (eighth, 180, 38, 58)
    sixteenth := Pic.FileNew ("pictures/16thnoteupsingle.jpg") %47x87
    sixteenthDown := Pic.Rotate (sixteenth, 180, 23, 43)
    whole := Pic.Scale (whole, 15, 15) %Scale them
    half := Pic.Scale (half, 17, 45)
    halfDown := Pic.Scale (halfDown, 17, 45)
    quarter := Pic.Scale (quarter, 17, 45)
    quarterDown := Pic.Scale (quarterDown, 17, 45)
    eighth := Pic.Scale (eighth, 17, 45)
    eighthDown := Pic.Scale (eighthDown, 17, 45)
    sixteenth := Pic.Scale (sixteenth, 17, 45)
    sixteenthDown := Pic.Scale (sixteenthDown, 17, 45)
    %Beginning variable preparation
    noteToAdd := whole %Default note
    noteToAddDown := whole
    noteLength := 4 %Default 4 beats
    previousx := 7
    noteNumber (1) := 0
    finished := false
    numberOfNotes := 0
    musicString := ""
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  DRAW BUTTONS AND BARS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    wholeNote := GUI.CreateRadioButton (10, 380, "Whole Note", 0, noteType) %Set all the options
    halfNote := GUI.CreateRadioButton (10, 360, "Half Note", wholeNote, noteType)
    quarterNote := GUI.CreateRadioButton (10, 340, "Quarter Note", halfNote, noteType)
    eighthNote := GUI.CreateRadioButton (10, 320, "Eighth Note", quarterNote, noteType)
    sixteenthNote := GUI.CreateRadioButton (10, 300, "Sixteenth Note", eighthNote, noteType)
    messageDisplay := GUI.CreateTextBox (230, 330, 400, 35)
    playMusic := GUI.CreateButton (115, 320, 0, "Listen So Far", noteType)
    sliderBar := GUI.CreateHorizontalSlider (230, 300, 400, 0, 480, 480, scroll)
    finish := GUI.CreateButton (115, 290, 0, "Finish", noteType)
    GUI.Hide (sliderBar)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ACTUAL PROCESSING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    loop
	Mouse.Where (mx, my, b) %Find position of mouse
	if Mouse.ButtonMoved ("down") and my <= 145 and mx >= 0 and mx <= 640 and my >= 0 then  %If clicked the keyboard
	    if measure + noteLength <= 4 then
		GUI.ClearText (messageDisplay)
		x := ceil (mx div 42.5) %FIND KEY PRESSED
		if x <= 14 and x >= 0 then
		    if x <= 6 then %DRAW NOTE
			Pic.Draw (noteToAdd, 125 + numberOfNotes * 30 - (GUI.GetSliderValue (sliderBar) - 480), round (155 + x * 7.3), picMerge) %Draws the note chosen
		    elsif noteToAdd = whole then
			Pic.Draw (noteToAdd, 125 + numberOfNotes * 30 - (GUI.GetSliderValue (sliderBar) - 480), round (155 + x * 7.3), picMerge) %Draws the note chosen
		    else
			Pic.Draw (noteToAddDown, 125 + numberOfNotes * 30 - (GUI.GetSliderValue (sliderBar) - 480), round (155 + x * 7.3) - 30, picMerge) %Draws the note chosen
		    end if
		    if x = 0 then %If needed, draws ledger lines
			Pic.Draw (ledger, 120 + numberOfNotes * 30 - (GUI.GetSliderValue (sliderBar) - 480), 160, picMerge)
		    elsif x = 12 or x = 13 then
			Pic.Draw (ledger, 120 + numberOfNotes * 30 - (GUI.GetSliderValue (sliderBar) - 480), 248, picMerge)
		    else
			if x = 14 then
			    Pic.Draw (ledger, 120 + numberOfNotes * 30 - (GUI.GetSliderValue (sliderBar) - 480), 248, picMerge)
			    Pic.Draw (ledger, 120 + numberOfNotes * 30 - (GUI.GetSliderValue (sliderBar) - 480), 262, picMerge)
			end if
		    end if
		    numberOfNotes += 1 %Number of notes increases by one
		    measure += noteLength %Number of beats in the measure increase by the note length
		    if measure = 4 then      %If full measure, draw bar line
			Draw.ThickLine (121 + numberOfNotes * 30 - (GUI.GetSliderValue (sliderBar) - 480), 175, 121 + numberOfNotes * 30 - (GUI.GetSliderValue (sliderBar) - 480), 237, 2, 7)
			measure := 0
		    end if
		    if numberOfNotes > 17 then %IF BEYOND THE SCREEN
			noteHold := Pic.New (600, 155, 635, round (155 + 14 * 7.3) + 20) %GET THE NOTE
			Draw.FillBox (600, 155, 635, round (155 + 14 * 7.3) + 20, 0)
			noteNumber (upper (noteNumber)) := Sprite.New (noteHold)
			Sprite.SetHeight (noteNumber (upper (noteNumber)), -100)
			Sprite.SetPosition (noteNumber (upper (noteNumber)), 605, 155, false)
			Sprite.Show (noteNumber (upper (noteNumber)))
			GUI.SetSliderMinMax (sliderBar, 510, numberOfNotes * 30) %CHANGE THE SLIDER BAR
			GUI.SetSliderValue (sliderBar, numberOfNotes * 30)
			new noteNumber, upper (noteNumber) + 1
			Draw.ThickLine (120, 236, 640, 236, 3, 7) %DRAW THE STAFF
			Draw.ThickLine (120, 221, 640, 221, 3, 7)
			Draw.ThickLine (120, 206, 640, 206, 3, 7)
			Draw.ThickLine (120, 191, 640, 191, 3, 7)
			Draw.ThickLine (120, 175, 640, 175, 2, 7)
		    end if
		    if numberOfNotes = 17 then % FIRST TIME Once the notes pass the end of the screen
			GUI.Show (sliderBar)
			moveNotes := Pic.New (120, 155, 640, round (155 + 14 * 7.3) + 20)
			Draw.FillBox (0, 155, 640, round (155 + 14 * 7.3) + 20, 0)
			moveNotes := Sprite.New (moveNotes)
			Sprite.SetHeight (moveNotes, -100) %MAKE SPRITES
			Sprite.SetHeight (staff, -10)
			Sprite.SetPosition (staff, 0, 130, false)
			Sprite.SetPosition (moveNotes, 120, 155, false)
			Sprite.Show (staff)
			Sprite.Show (moveNotes)
			GUI.SetSliderMinMax (sliderBar, 509, numberOfNotes * 30) %SET SLIDER BAR
			GUI.SetSliderValue (sliderBar, numberOfNotes * 30)
		    end if
		    note := ""
		    if previousx >= 0 and previousx <= 6 then %FINDS THE REQUIRED NUMBER OF OCTAVE CHANGES AND SETS THE COUNTEROCTAVE
			if x >= 7 and x <= 13 then
			    note := ">"
			    counterOctave := counterOctave + "<"
			else
			    if x = 14 then
				note := ">>"
				counterOctave := counterOctave + "<<"
			    end if
			end if
		    elsif previousx >= 7 and previousx <= 13 then
			if x >= 0 and x <= 6 then
			    note := "<"
			    counterOctave := counterOctave + ">"
			else
			    if x = 14 then
				note := ">"
				counterOctave := counterOctave + "<"
			    end if
			end if
		    else
			if x >= 0 and x <= 6 then
			    note := "<<"
			    counterOctave := counterOctave + ">>"
			else
			    if x >= 7 and x <= 13 then
				note := "<"
				counterOctave := counterOctave + ">"
			    end if
			end if
		    end if
		    previousx := x
		    for y : 0 .. 2 %FINDS THE CORRECT NOTE TO PLAY
			if x - y * 7 <= 4 and x - y * 7 >= -2 then
			    note := note + chr (98 + x - y * 7 + 1)
			    exit
			end if
		    end for
		    Music.Play (lengthOfNote (1) + note) %Play recently added note
		    if previousl = lengthOfNote (1) then
			musicString := musicString + note %ADD IT TO THE MAIN STRING CODE
		    else
			musicString := musicString + (lengthOfNote (1) + note)
			previousl := lengthOfNote (1)
		    end if
		    % locate (1, 1)
		    % put upper (noteNumber)
		end if
	    else
		GUI.ClearText (messageDisplay) %IF NOT FULL MEASURE
		GUI.AddLine (messageDisplay, "The chosen note lengths to not complete a 4 beat measure, please try again with a different note length.")
	    end if
	end if
	exit when finished or GUI.ProcessEvent
    end loop
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WHEN DONE RESETS PICTURES AND HIDES BUTTONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if upper (noteNumber) > 1 then
	for y : 1 .. upper (noteNumber) - 1
	    Sprite.Free (noteNumber (y))
	end for
	new noteNumber, 1
    end if
    Sprite.Free (staff)
    if numberOfNotes >= 17 then
	Sprite.Free (moveNotes)
    end if
    GUI.Hide (wholeNote)
    GUI.Hide (halfNote)
    GUI.Hide (quarterNote)
    GUI.Hide (eighthNote)
    GUI.Hide (sixteenthNote)
    GUI.Hide (messageDisplay)
    GUI.Hide (playMusic)
    GUI.Hide (sliderBar)
    GUI.Hide (finish)
    display
end userInput
proc goodBye
    var goodByeScreen := Window.Open ("position:center;center,graphics:640;400") %Makes instruction screen
    Window.Show (goodByeScreen)
    Window.SetActive (goodByeScreen)
    Window.Hide (mainWin) %Sets the instruction screen active and hides the main window
    title
    locate (3, 1)
    View.Set ("nobuttonbar,title:Good Bye!")     %Window options
    if noteLength not= 0 then
	put "Thank you for using the Turing Music Maker! Please Play Again Later!"
    else
	put "You have not used the Epic Turing Music Maker! Be sure to try it later!"
    end if
    put ""
    put "Press Any Key To Close The Window."
    locate (24, 1)
    put "Calvin C."
    loop
	exit when hasch     %After button pressed, closes instructions and shows main window again
    end loop
    Window.Close (mainWin)
    Window.Close (goodByeScreen)
end goodBye
proc displayInstructions
    var instructionScreen := Window.Open ("position:center;center,graphics:640;400")     %Makes instruction screen
    Window.Show (instructionScreen)
    Window.SetActive (instructionScreen)
    Window.Hide (mainWin) %Sets the instruction screen active and hides the main window
    View.Set ("nobuttonbar,title:Instructions")     %Window options
    title
    locate (3, 1)
    put "1. Choose Note Length"     %Displays instructions
    put "2. Press a key on the keyboard"
    put "3. Listen or finish making music"
    put ""
    put "Note: This program is so awesome, there is no need to use any pauses."
    put "      Also, sharps and flats may be confusing, so for benefit of the "
    put "      beginner, this program does not have any sharps or flats."
    put ""
    put "Press Any Key To Return To The Main Menu."
    loop
	exit when hasch     %After button pressed, closes instructions and shows main window again
    end loop
    Window.Show (mainWin)
    Window.SetActive (mainWin)
    Window.Close (instructionScreen)
end displayInstructions
% Main Menu
proc mainMenu
    GUI.Hide (goToMainMenu)
    title
    if finished then
	GUI.Hide (listenAgain)
    end if
    exitProgram := GUI.CreateButtonFull ((maxx - 100) div 2, round (maxy * 0.3), 100, "Exit Game", GUI.Quit, 50, 'q', false)     %Buttons
    instructions := GUI.CreateButtonFull ((maxx - 100) div 2, round (maxy * 0.5), 100, "Instructions", displayInstructions, 50, 'i', false)
    makeMusic := GUI.CreateButtonFull ((maxx - 100) div 2, round (maxy * 0.7), 100, "Make Music!", userInput, 50, ' ', true)
end mainMenu
% Program Introduction
proc introduction
    title
    put "Using a piano keyboard, you can make your own music!"     %Introduction
    goToMainMenu := GUI.CreateButton (250, 50, 0, "Go To Main Menu", mainMenu)     %Brings user to the main menu
end introduction
% Main program
introduction
loop
    exit when GUI.ProcessEvent     %Continues on until user presses quit
end loop
goodBye
% End Program
