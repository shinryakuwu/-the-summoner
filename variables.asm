;; DECLARE SOME VARIABLES HERE
  .rsset $0000  ;;start variables at ram location 0
currentXtile     .rs 1  ; variable for determining the bg tile next to the cat
currentYtile     .rs 1  ; variable for determining the bg tile next to the cat
buttons          .rs 1  ; .rs 1 means reserve one byte of space, store button state in this variable
                        ; A B select start up down left right
candycounter     .rs 1  ; stores the number of candy left to collect
candyswitches    .rs 1  ; stores switches for collecting candy
                        ; 00000000
                        ;   ||||||__ old lady candy
                        ;   |||||__ candy man hand
                        ;   ||||__ licorice
                        ;   |||__ ghost candy
                        ;   ||__ boss candy 1
                        ;   |__ boss candy 2
switches         .rs 1  ; stores other switches
                        ; 00000000
                        ;   ||||||__ ghost candy drop
                        ;   |||||__ talked to fren
                        ;   ||||__ took meds
                        ;   |||__ visited ghost house
                        ;   ||__ got ghost pass hint
                        ;   |__ got ghost pass
currentbglow     .rs 1  ; 16-bit variable to point to current background
currentbghigh    .rs 1
curntspriteslow  .rs 1  ; 16-bit variable to point to current set of sprites
curntspriteshigh .rs 1
location         .rs 1  ; location identifier ( 0 - village, 1 - cat house, 2 - village 2, 3 - skeleton house,
                        ; 4 - server room, 5 - bsod, 6 - ghost room 1, 7 - ghost room 2, 8 - park, 9 - ex house)
spritescompare   .rs 1  ; compare iterator to this value during load sprites loop
loadbgcompare    .rs 2  ; loadbgcompare - compare y, loadbgcompare+1 - compare x
singleattribute  .rs 1  ; set to 1 if needed to fill attribute table with the same number
attributenumber  .rs 1  ; define single attribute to load
sleeping         .rs 1  ; main program sets this and waits for the NMI to clear it.
                        ; Ensures the main program is run only once per frame.
action           .rs 1  ; action state ( 1 - action active, 0 - not, 2 - text render done, 3 - timeout state)
bgrender         .rs 1  ; 0 - don't perform bg render, 1 - perform, 2 - bg render with loading palette
nmiwaitcounter   .rs 1  ; defines how many frames nmi should wait
eventwaitcounter .rs 1  ; defines delays in events
direction        .rs 1  ; either down(0) up(1) left(2) of right(3)
direction2       .rs 1  ; used to compare to direction variable
mvcounter        .rs 1  ; counter for cat movement animation
animatecounter   .rs 1  ; counter for animating objects on locations
framenum         .rs 1  ; number of the current animation frame for cat
objectframenum   .rs 1  ; number of the current animation frame for surroundings
skeletonframenum .rs 1  ; number of the current animation frame for dancing skeletons
trnsfrm          .rs 1  ; tile transform state variable
trnsfrmcompare   .rs 1  ; additional variable for main transform subroutine
clearbgcompare   .rs 1  ; additional variable for ClearBG subroutine
cattileslow      .rs 1  ; used to address the needed tile set
cattileshigh     .rs 1
warpXYlow        .rs 1  ; used to address warp coordinates
warpXYhigh		   .rs 1
staticrender     .rs 1  ; either true(1) or false(0)
ramspriteslow    .rs 1  ; load sprites starting from RAM address stored in this variable
ramspriteshigh   .rs 1
currentattrlow   .rs 1  ; 16-bit variable to point to current background attributes
currentattrhigh  .rs 1
passable         .rs 1  ; either passable(1) or not(0)
passablecheck2   .rs 1  ; either true(1) or false(0)
multiplier       .rs 1  ; variable for multiplication subroutine
mathresultlow    .rs 1  ; 16-bit variable for storing multiplication result
mathresulthigh   .rs 1
currenttilelow   .rs 1  ; 16-bit variable for determining the bg tile next to the cat
currenttilehigh  .rs 1
switchtile       .rs 1  ; tile (and maybe attribute) for replacement used for object animation
textpointer      .rs 1  ; points at the letter to render
currenttextlow   .rs 1  ; 16-bit variable to point to current text to display
currenttexthigh  .rs 1
textppuaddrlow   .rs 1  ; 16-bit variable for coordinates of current letter to be rendered
textppuaddrhigh  .rs 1
textpartscounter .rs 1
textcursor       .rs 1  ; stores cursor that should be rendered in current text part
cleartextstate   .rs 1  ; defines a line to be cleared within a frame
eventnumber      .rs 1  ; stores the identificator of an event that is going to be performed
walkbackwards    .rs 1  ; 0 - no, 1 - yes
movecounter      .rs 1  ; defines for how many frames the object will move during an event
eventstate       .rs 1  ; stores the state of an event
glitchcount      .rs 1  ; stores counter for satan glitch event
emptytilesnumber .rs 1  ; number of empty bg tiles in a row
emptytilescount  .rs 1  ; number of empty tile rows before the current tile (required in passability checker)
emptytilerowaddr .rs 2  ; 16-bit variable to temporarily store the address of empty tile row 
                        ; (used in StoreEmptyTilesRowAddress and AddEmptyTilesToCurrentTile)
currentbgparams  .rs 2  ; used for setting params for current location during warp
actionnmi        .rs 1  ; 0 - action check happens in main logic, 1 - action check happens in nmi
dotsstate        .rs 1  ; 0 - inactive, 1 - active
dotscounter      .rs 1  ; stores counter for action dots to process animation
dotsframe        .rs 1  ; stores the number of dots frame (0-3) for animation
olddotsframe     .rs 1  ; stores previous number of dots frame
cachedisable     .rs 1  ; 0 - yes, 1 - no (use cache for updating cat graphics and no cache for all the rest)
catcache         .rs 24

;; DECLARE SOME CONSTANTS HERE

MVRIGHT = %00000001
MVLEFT = %00000010
MVDOWN = %00000100
MVUP = %00001000
ACTIONBUTTONS = %11000000
CANDYGATHERED = %00111111
CATANIMATIONSPEED = $0A
OBJECTSANIMATIONSPEED = $18
INITIALTEXTPPUADDR = $22E0
ENDOFTEXT = $FE
EMPTYBGTILEATTRIBUTE = $0F
EMPTYTILEROWADDRESSES = $80
BGPARAMSADDRESS = $06
BGPARAMSCOMPARE = $0A
DELAYAFTERGHOSTROOM1 = $A0
