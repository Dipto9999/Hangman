% importing the GUI module
import GUI

% declaration of variables
% initialization
var Actual_Word : string := "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"
var Boolean_Result : boolean
var File_Number : int
var Line_List : array 1 .. 31 of string
var Randomized_Number : int
var Strikes : int := 0
var User_Guess : char
var User_Seen : array 1 .. length (Actual_Word) of string

View.Set ("graphics: 810; 400")
Window.Set (defWinId, "title: Hangman")
GUI.SetBackgroundColour (gray)

% pre-declaring procedures with forward procedure
forward procedure Correct_Input
forward function IsEndGame : boolean
forward procedure Gameplay
forward procedure Incorrect_Input_Or_Restoring_Image
forward procedure Letters_On_Window
forward procedure Man_Hanging
forward procedure Randomize_Line
forward procedure Spaces_For_Letters

body function IsEndGame
    var Boolean_Result : boolean := true
    for i : 1 .. length (Actual_Word)
	if User_Seen (i) not = Actual_Word (i) then
	    Boolean_Result := false
	end if
    end for
    result Boolean_Result
end IsEndGame

% procedure to randomize the line from which the word will be taken from
body procedure Randomize_Line
    open : File_Number, "Hangman.txt", get
    % file input and output
    if File_Number > 0 then
	for i : 1 .. 31
	    exit when eof (File_Number)
	    get : File_Number, Line_List (i) : *
	end for
	randint (Randomized_Number, 1, 31)
	Actual_Word := Line_List (Randomized_Number)
	Spaces_For_Letters
	Letters_On_Window
	Man_Hanging
    else
	put "Sorry. The file was not found."
    end if
end Randomize_Line

body procedure Spaces_For_Letters
    for i : 1 .. length (Actual_Word)
	User_Seen (i) := "_ "
    end for
end Spaces_For_Letters

body procedure Letters_On_Window
    colourback (gray)
    put "This is a game of Hangman! Save this man before he is hanged by " ..
    put "typing letters to complete this word!"
    put skip
    for i : 1 .. length (Actual_Word)
	colourback (gray)
	put User_Seen (i) ..
    end for
    put skip
end Letters_On_Window

body procedure Correct_Input
    for i : 1 .. length (Actual_Word)
	if Actual_Word (i) = User_Guess then
	    User_Seen (i) := Actual_Word (i)
	elsif Actual_Word (i) = chr (ord (User_Guess) + 32) then
	    User_Seen (i) := chr (ord (User_Guess) + 32)
	elsif Actual_Word (i) = chr (ord (User_Guess) - 32) then
	    User_Seen (i) := chr (ord (User_Guess) - 32)
	end if
    end for
end Correct_Input

body procedure Incorrect_Input_Or_Restoring_Image
    case Strikes of
	label 1 :
	    Man_Hanging
	    drawline (500, 230, 500, 170, black)
	label 2 :
	    Man_Hanging
	    drawline (500, 230, 500, 170, black)
	    drawline (500, 200, 475, 170, black)
	label 3 :
	    Man_Hanging
	    drawline (500, 230, 500, 170, black)
	    drawline (500, 200, 475, 170, black)
	    drawline (500, 200, 525, 170, black)
	label 4 :
	    Man_Hanging
	    drawline (500, 230, 500, 170, black)
	    drawline (500, 200, 475, 170, black)
	    drawline (500, 200, 525, 170, black)
	    drawline (500, 170, 475, 130, black)
	label 5 :
	    Man_Hanging
	    put "HE GOT HANGED! WAIT FOR THE GAME TO RESET."
	    drawline (500, 230, 500, 170, black)
	    drawline (500, 200, 475, 170, black)
	    drawline (500, 200, 525, 170, black)
	    drawline (500, 170, 475, 130, black)
	    drawline (500, 170, 525, 130, black)
	    delay (2000)
	    cls
	    Actual_Word := "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"
	    Strikes := 0
	    Randomize_Line
	    Gameplay
	label :
	    Man_Hanging
    end case
end Incorrect_Input_Or_Restoring_Image

body procedure Gameplay
    loop
	Boolean_Result := IsEndGame
	if Boolean_Result then
	    put "You Won! The game will be reset."
	    delay (2000)
	    cls
	    Actual_Word := "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"
	    Strikes := 0
	    Randomize_Line
	    Gameplay
	end if
	put "Enter a letter: "
	get User_Guess
	if index (Actual_Word, User_Guess) not= 0 then
	    Correct_Input
	    cls
	    Incorrect_Input_Or_Restoring_Image
	    Letters_On_Window
	elsif User_Guess >= chr (65) and User_Guess <= chr (90) then
	    if index (Actual_Word, chr (ord (User_Guess) + 32)) not= 0 then
		Correct_Input
		cls
		Incorrect_Input_Or_Restoring_Image
		Letters_On_Window
	    else
		Strikes += 1
		cls
		Incorrect_Input_Or_Restoring_Image
		Letters_On_Window
	    end if
	elsif User_Guess >= chr (97) and User_Guess <= chr (122) then
	    if index (Actual_Word, chr (ord (User_Guess) - 32)) not= 0 then
		Correct_Input
		cls
		Incorrect_Input_Or_Restoring_Image
		Letters_On_Window
	    else
		Strikes += 1
		cls
		Incorrect_Input_Or_Restoring_Image
		Letters_On_Window
	    end if
	end if
    end loop
end Gameplay

body procedure Man_Hanging
    drawline (495, 260, 475, 290, black)
    drawline (500, 290, 400, 290, black)
    drawline (400, 290, 400, 100, black)
    drawline (375, 100, 450, 100, black)
    drawoval (500, 250, 20, 20, black)
end Man_Hanging

Randomize_Line
Gameplay

loop
    exit when GUI.ProcessEvent
end loop
