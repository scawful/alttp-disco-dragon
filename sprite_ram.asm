
; =============================================================================
; RAM Addresses
; =============================================================================

; Work Registers
!WORK0 = $00
!WORK1 = $01
!WORK2 = $02
!WORK3 = $03
!WORK4 = $04
!WORK5 = $05
!WORK6 = $06
!WORK7 = $07
!WORK8 = $08
!WORK9 = $09
!WORKA = $0A
!WORKB = $0B
!WORKC = $0C
!WORKD = $0D
!WORKE = $0E
!WORKF = $0F ; radius

!PLAYER_X_COORD1 = $22
!PLAYER_X_COORD0 = $23

; (Dungeon, Overworld) Flag that is set to 1 if the player is in indoors and 0 otherwise.
!DUNGEON_FLAG = $1B

; Points to current position in the low OAM buffer (the first 512 bytes)
!OAM_ADDR = $90

; Points to current position in the high OAM table buffer (latter 32 bytes)
!OAM_SUB_ADDR = $92

!OAMSB = $0A20
!OAMSB2 = $0A60

!OAM_MAIN = $0800

; BG2 horizontal scroll register (BG2HOFS / $210D)
!BG2_HORIZ_SCROLL_REG = $E2

; BG2 vertical scroll register (BG2VOFS / $210E)
!BG2_VERT_SCROLL_REG = $E8

; Main delay timer for sprites. Usually used to time intervals between state
; transitions, and also for certain time sensitive events, like playing a
; sound effect on a specific frame.
!ENEMY_TIMER_0 = $0DF0

; $0E00[0x10], "(Sprite) Auxiliary Delay Timer 1"
!ENEMY_TIMER_1 = $0E00

; $0E10[0x10] - (Sprite) Auxiliary Delay Timer 2
!ENEMY_TIMER_2 = $0E10

; $0EB0[0x10] "(Sprite) Direction head is facing."
!ENEMY_CHAR_DIRECTION = $0EB0

; $0DC0[0x10] "(Sprite) Designates which graphics to use."
!ENEMY_CHAR_POINT = $0DC0

; $0FB5[0x01] "Used in constructing special designation $0E30[]. 
; Two most significant bits of the value. also used in calculating sprite damage. 
; $0DD0[] is stored here on a temporary basis. 
; Used for looping sprites through various routines."
!ENEMY_HELP_1 = $0FB5

; $0FB6[0x01] "Used as scratch space for various sprite routines.
; Used in construction of special designation $0E30[]. 
; Three least significant bits of the value."
!ENEMY_HELP_2 = $0FB6

; $1A[0x01] "Frame Counter. 8-bit size. Wraps after 255 back to 0. Often used for calculating timing delays."
!FRAME_COUNTER = $1A

; $0D90[0x10] "(Sprite) In some creatures, used as an index for determining $0DC0."
!ENEMY_WORK_0 = $0D90

; $0DA0[0x10] "(Sprite) Usage varies considerably for each sprite type."
!ENEMY_WORK_1 = $0DA0

; $0DB0[0x10] "(Sprite) hard to say at this point. Various usages?"
; TODO: double check this
!ENEMY_WORK_2 = $0DB0

; Sprite Animation Clock
!ENEMY_COUNT_FLAG = $0EC0

; Controls whether the sprite has been spawned yet. 0 - no. Not 0 - yes. 
; Also used as an AI pointer via UseImplicitRegIndexedLocalJumpTable
!ENEMY_ACTION = $0D80 

; $0DE0[0x10] - (Sprite)
    
;     A position counter for the statue sentry? May have other uses
    
;     Seems that some sprites use this as an indicator for cardinal direction?
;     (Octorocks, for example).
    
;     udlr ?
    
;     0 - up
;     1 - down
;     2 - left
;     3 - right
    
;     Some sprites, like the Desert Barrier, have this reversed:
;     0 - right
;     1 - left
;     2 - down
;     3 - up
    
;     The Giant Moldorm uses this one somewhat more like the expanded cardinal
;     directions. Each state corresponds to an angular step of 22.5 degrees.
    
;     0  - East
;     1  - East-Southeast
;     2  - South East
;     3  - South-Southeast
;     4  - South
;     5  - South-Southwest
;     6  - South West
;     7  - West-Southwest
;     8  - West
;     9  - West-Northwest
;     10 - North West
;     11 - North-Northwest
;     12 - North
;     13 - North-Northeast
;     14 - Northeast
;     15 - East-Northeast
    
;     Or diagramatically:
    
;                     12               
;              11     |     13         
;        10           |          14    
;                     |                
;      9              |             15 
;                     |                
;                     |                
;     8 --------------+-------------- 0
;                     |                
;                     |                
;      7              |             1  
;                     |                
;           6         |         2      
;                5    |    3           
;                     4                
    
;     Distances are of course rough, and relative, as this is text, and the
;     relative distances may appear differently on various displays and editors.
    
;     The Statue Sentry sprite has an even more finely grained direction system
;     that uses this same variable as its indicator. It has 0x40 states, where
;     each states corresponds to an angular step of 5.625 degrees. However, its
;     orientation is different in that the step values increase as the eye rotates
;     counter-clockwise, unlike the Giant Moldorm's rotation scheme. The starting
;     position of 0 is located directly to the left, with 0x10 being south, 0x20
;     east, and 0x30 north.
    
;     The Spark sprite has two sets of 4 cardinal direction states. The first set
;     is for clockwise oriented adhesion to wall surfaces as is travels, and the
;     other set (0x04 to 0x07) indicates adhesion but in the counterclockwise
;     attitude.
    
;     As always, more exceptional uses of this variable may exist.
!ENEMY_MUKI = $0DE0 ; SprMiscC

!ENEMY_Y_VELOCITY = $0D40
!ENEMY_X_VELOCITY = $0D50

; $0F50[0x10] -   (Sprite)
;     The layout of this variable is the same as the 4th byte of each OAM entry.
;     That is,

;     vhoopppN
    
;     v - vflip
;     h - hflip
;     o - priority
;     p - palette
;     N - name table
    
;     The 'N' bit operates as the the top bit of the CHR index in our case,
;     because the game has the two name tables placed consecutively in vram.
!ENEMY_PROPS = $0F50

;Screen relative X coordinate of a sprite (only lowest 8 bits)
!ENEMY_RELATIVE_X = $0FA8

; Screen relative Y coordinate of a sprite (only lowest 8 bits)
!ENEMY_RELATIVE_Y = $0FA9

; The lower byte of a sprite's X - coordinate.
!ENEMY_X = $0D10

; The high byte of a sprite's Y - coordinate.
!ENEMY_YH = $0D20

; Pause button for sprites apparently. If nonzero they don't do anything.
!ENEMY_PAUSE = $0F00

; Cached 16-bit version of the current sprite's Y coordinate.
!ENEMY_CACHED_Y = $0FDA

;$0F60[0x10] -   (Sprite)    
; isphhhhh

; i - Ignore collision settings and always check tile interaction on the same
;     layer that the sprite is on.

; s - 'Statis'. If set, indicates that the sprite should not be considered as
;     "alive" in routines that try to check that property. Functionally, the
;     sprites might not actually be considered to be in statis though.
    
;     Example: Bubbles (aka Fire Faeries) are not considered alive for the
;     purposes of puzzles, because it's not expected that you always have
;     the resources to kill them. Thus, they always have this bit set.

; p - 'Persist' If set, keeps the sprite from being deactivated from being
;     too far offscreen from the camera. The sprite will continue to move and
;     interact with the game map and other sprites that are also active.

; h - 5-bit value selecting the sprite's hit box dimensions and perhaps other
;     related parameters.
!ENEMY_HITBOX = $0F60

; Object priority stuff for sprites
!ENEMY_OBJ_PRIORITY = $0B89

; $0CAA[0x10] -   (Sprite)
;     Deflection properties bitfield
    
;     abcdefgh
    
;     a - If set... creates some condition where it may or may not die
;     b - Same as bit 'a' in some contexts (Zora in particular)
;     c - While this is set and unset in a lot of places for various sprites, its
;         status doesn't appear to ever be queried. Based on the pattern of its
;         usage, however, the best deduction I can make is that this was a flag
;         intended to signal that a sprite is an interactive object that Link can
;         push against, pull on, or otherwise exerts a physical presence.
;         In general, it might have indicated some kind of A button (action
;         button) affinity for the sprite, but I think this is merely informative
;         rather than something relevant to gameplay.
;     d - If hit from front, deflect Ice Rod, Somarian missile,
;         boomerang, hookshot, and sword beam, and arrows stick in
;         it harmlessly.  If bit 1 is also set, frontal arrows will
;         instead disappear harmlessly.  No monsters have bit 4 set
;         in the ROM data, but it was functional and interesting
;         enough to include. 
;     e - If set, makes the sprite collide with less tiles than usual
;     f - If set, makes sprite impervious to sword and hammer type attacks
;     g - ???? Seems to make sprite impervious to arrows, but may have other
;         additional meanings.
;     h - disabled???
!ENEMY_DEFLECTION = $0CAA


; $0BC0[0x20] -   (Sprite / Dungeon?)
;     contains the index of the sprite (i.e. its position in the $0E20[0x10] array
;     only seems to be modified in the initial dungeon loading routine (room transitions 
;     don't appear to write here.)
!ENEMY_INDEX = $0BC0

; $0DD0[0x10] -   (Sprite)
;     General state of the sprite. Usage of values other than those listed will
;     almost certainly crash the game, so do not attempt to use them.
    
;     0x00 - Sprite is dead, totally inactive
;     0x01 - Sprite falling into a pit with generic animation.
;     0x02 - Sprite transforms into a puff of smoke, often producing an item
;     0x03 - Sprite falling into deep water (optionally making a fish jump up?)
;     0x04 - Death Mode for Bosses (lots of explosions).
;     0x05 - Sprite falling into a pit that has a special animation (e.g. Soldier)
;     0x06 - Death Mode for normal creatures.
;     0x08 - Sprite is being spawned at load time. An initialization routine will
;            be run for one frame, and then move on to the active state (0x09) the
;            very next frame.
;     0x09 - Sprite is in the normal, active mode.
;     0x0A - Sprite is being carried by the player.
;     0x0B - Sprite is frozen and / or stunned.
!ENEMY_STATE = $0DD0

; Link's Y-Coordinate (mirrored at $0FC4)
!PLAYER_Y_COORD1 = $20
!PLAYER_Y_COORD0 = $21

; (Sprite) Height value (how far the enemy is from its shadow)
!ENEMY_Z_POS = $0F70

; The lower byte of a sprite's Y - coordinate.
!ENEMY_Y_POS = $0D00

; The high byte of a sprite's X - coordinate.
!ENEMY_X_POS = $0D30

; 16 bit position of the sprite 
!ENEMY_CACHED_X = $0FD8

; Death status for overworld sprites
!ENEMY_DEATH_STATUS = $7FEF80