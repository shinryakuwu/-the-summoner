;; DECLARE SOME VARIABLES HERE
  .rsset $0000  ;;start variables at ram location 0
  
buttons          .rs 1  ; .rs 1 means reserve one byte of space, store button state in this variable
                        ; A B select start up down left right
mainloop         .rs 1  ; 0 - don't perform main loop logic, 1 - perform
action           .rs 1  ; action state ( 1 - action active, 0 - not, 2 - text render done, 3 - timeout state)
bgrender         .rs 1  ; 0 - don't perform bg render, 1 - perform
direction        .rs 1  ; either down(0) up(1) left(2) of right(3)
direction2       .rs 1  ; used to compare to direction variable
singleattribute  .rs 1  ; set to 1 if needed to fill attribute table with the same number
attributenumber  .rs 1  ; define single attribute to load
mvcounter        .rs 1  ; counter for cat movement animation
animatecounter   .rs 1  ; counter for animating objects on locations
framenum         .rs 1  ; number of the current animation frame for cat
objectframenum   .rs 1  ; number of the current animation frame for surroundings
skeletonframenum .rs 1  ; number of the current animation frame for dancing skeletons
trnsfrm          .rs 1  ; tile transform state variable
trnsfrmcompare   .rs 1  ; additional variable for main transform subroutine
cattileslow      .rs 1  ; used to address the needed tile set
cattileshigh     .rs 1
warpXYlow        .rs 1  ; used to address warp coordinates
warpXYhigh		   .rs 1
staticrender     .rs 1  ; either true(1) or false(0)
location         .rs 1  ; location identifier ( 0 - village, 1 - cat house, 2 - village 2, 3 - skeleton house)
currentbglow     .rs 1  ; 16-bit variable to point to current background
currentbghigh    .rs 1
curntspriteslow  .rs 1  ; 16-bit variable to point to current set of sprites
curntspriteshigh .rs 1
ramspriteslow    .rs 1  ; load sprites starting from RAM address stored in this variable
ramspriteshigh   .rs 1
spritescompare   .rs 1  ; compare iterator to this value during load sprites loop
currentattrlow   .rs 1  ; 16-bit variable to point to current background attributes
currentattrhigh  .rs 1
passable         .rs 1  ; either passable(1) or not(0)
passablecheck2   .rs 1  ; either true(1) or false(0)
multiplier       .rs 1  ; variable for multiplication subroutine
mathresultlow    .rs 1  ; 16-bit variable for storing multiplication result
mathresulthigh   .rs 1
currentXtile     .rs 1  ; variable for determining the bg tile next to the cat
currentYtile     .rs 1  ; variable for determining the bg tile next to the cat
currentYtilelow  .rs 1  ; 16-bit variable for determining the bg tile next to the cat
currentYtilehigh .rs 1
switchtile       .rs 1  ; tile (and maybe attribute) for replacement used for object animation
textpointer      .rs 1  ; points at the letter to render
currenttextlow   .rs 1  ; 16-bit variable to point to current text to display
currenttexthigh  .rs 1
textppuaddrlow   .rs 1  ; 16-bit variable for coordinates of current letter to be rendered
textppuaddrhigh  .rs 1
textpartscounter .rs 1
textcursor       .rs 1  ; stores cursor that should be rendered in current text part
cleartextstate   .rs 1  ; defines a line to be cleared within a frame
candycounter     .rs 1  ; stores the number of candy left to collect
eventnumber      .rs 1  ; stores the identificator of an event that is going to be performed
walkbackwards    .rs 1  ; 0 - no, 1 - yes

;; DECLARE SOME CONSTANTS HERE

MVRIGHT = %00000001
MVLEFT = %00000010
MVDOWN = %00000100
MVUP = %00001000
ACTIONBUTTONS = %11000000
CATANIMATIONSPEED = $0A
OBJECTSANIMATIONSPEED = $18
INITIALTEXTPPUADDR = $22E0
ENDOFTEXT = $FE
