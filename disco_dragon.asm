; =============================================================================
; Disco Dragon Boss
; =============================================================================

lorom

incsrc sprite_ram.asm

incsrc sprite_engine/sprite_macros.asm
incsrc sprite_engine/sprite_functions_hooks.asm

org $298000
incsrc sprite_engine/sprite_new_table.asm

org $308000
incsrc sprite_engine/sprite_new_functions.asm

;==============================================================================
; Sprite Properties
;==============================================================================

!SPRID              = $53 ; The sprite ID you are overwriting (HEX)
!NbrTiles           = 99  ; Number of tiles used in a frame
!Harmless           = 00  ; 00 = Sprite is Harmful,  01 = Sprite is Harmless
!HVelocity          = 01  ; Is your sprite going super fast? put 01 if it is
!Health             = 20  ; Number of Health the sprite have
!Damage             = 08  ; (08 is a whole heart), 04 is half heart
!DeathAnimation     = 00  ; 00 = normal death, 01 = no death animation
!ImperviousAll      = 00  ; 00 = Can be attack, 01 = attack will clink on it
!SmallShadow        = 00  ; 01 = small shadow, 00 = no shadow
!Shadow             = 00  ; 00 = don't draw shadow, 01 = draw a shadow 
!Palette            = 00  ; Unused in this DiscoDragon (can be 0 to 7)
!Hitbox             = $06  ; 00 to 31, can be viewed in sprite draw tool
!Persist            = 00  ; 01 = your sprite continue to live offscreen
!Statis             = 00  ; 00 = is sprite is alive?, (kill all enemies room)
!CollisionLayer     = 00  ; 01 = will check both layer for collision
!CanFall            = 00  ; 01 sprite can fall in hole, 01 = can't fall
!DeflectArrow       = 00  ; 01 = deflect arrows
!WaterSprite        = 00  ; 01 = can only walk shallow water
!Blockable          = 00  ; 01 = can be blocked by link's shield?
!Prize              = 00  ; 00-15 = the prize pack the sprite will drop from
!Sound              = 00  ; 01 = Play different sound when taking damage
!Interaction        = 00  ; ?? No documentation
!Statue             = 00  ; 01 = Sprite is statue
!DeflectProjectiles = 00  ; 01 = Sprite will deflect ALL projectiles
!ImperviousArrow    = 00  ; 01 = Impervious to arrows
!ImpervSwordHammer  = 00  ; 01 = Impervious to sword and hammer attacks
!Boss               = $01  ; 00 = normal sprite, 01 = sprite is a boss

%Set_Sprite_Properties(Sprite_DiscoDragon_Prep, Sprite_DiscoDragon_Long)

; =============================================================================

Sprite_DiscoDragon_Long:
{
  PHB : PHK : PLB

  JSR Sprite_DiscoDragon_Draw ; Call the draw code
  JSL Sprite_CheckActive   ; Check if game is not paused
  BCC .SpriteIsNotActive   ; Skip Main code is sprite is innactive

  ; JSR Sprite_DiscoDragon_Main ; Call the main sprite code
  JSR DiscoDragon_MainMove

.SpriteIsNotActive
  
  PLB ; Get back the databank we stored previously
  RTL ; Go back to original code
}

; =============================================================================

Sprite_DiscoDragon_Prep:
{  
  PHB : PHK : PLB
    
  ; Set initial sprite properties

  PLB
  RTL
}

; =============================================================================

Sprite_DiscoDragon_Main:
{
  LDA.w SprAction, X ; Load the current action of the sprite
  JSL UseImplicitRegIndexedLocalJumpTable

  dw Sprite_DiscoDragon_Action_00 ; Action 00

  Sprite_DiscoDragon_Action_00:
  {

    RTS
  }
}

; =============================================================================

print pc
Sprite_DiscoDragon_Draw:
{
  JSL Sprite_PrepOamCoord
  LDY    $0E
  LDA    $00 : CLC : ADC    $04 : STA    ($90), Y : PHA ; X position
  LDA    $02 : CLC : ADC    $06 : INY : PHA : STA    ($90), Y ; Y position
  
  PHX ; push the sprite index

  LDX    $0A ; Load the number of tiles
  LDA    $0D : CMP #$04 : BNE .DR1C10 : PLX : PHX
  LDA    $0DF0, X : CMP #$01
  LDA    $0DE0, X : BCC .DR1C0D ; Direction
  CLC : ADC    #$08
.DR1C0D
  CLC : ADC    #$08 : TAX

.DR1C10
  LDA    DiscoDragon_CharData, X : INY : STA    ($90), Y ; Tile Data
  TXA : AND    #$07 : TAX
  LDA    DiscoDragon_AttackData, X
  PLX ; Reload Sprite Index
  ORA    $03 : INY : STA    ($90), Y ; Palette/priority
;
  LDA    $0D : CMP    #$04 : BNE    .DR1C20
;
  PLA : STA !ENEMY_HELP_1 ; Likely storing XY pos and reusing for the head
  PLA : STA !ENEMY_HELP_2
  RTS

.DR1C20
  PLA
  PLA
  RTS
}

; END OF SPRITE ENGINE CODE 
; =============================================================================


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%		Dragon 1                     		  %
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DragonPoint_Data0:
{
  db	$00, $00, $00, $00
  db	$00, $00, $00, $00
  db	$00, $00, $00, $00
  db	$00, $00, $00, $00
  db	$00, $00, $00, $00
  db	$00, $00, $00, $00
  db	$00, $00, $00, $00
  db	$00, $00, $00, $00
  db	$00, $00, $00, $00
  db	$00, $00, $00, $00
;
  db	$00, $00, $00, $04
  db	$00, $00, $04, $08
  db	$00, $04, $08, $0C
  db	$00, $00, $00, $FC
  db	$00, $00, $FC, $F8
  db	$00, $FC, $F8, $F4
}

; =============================================================================

DragonPoint_Data1:
{
  db	$00, $00, $00, $00
  db	$00, $04, $04, $04
  db	$00, $08, $08, $08
  db	$00, $0C, $0C, $0C
  db	$00, $0C, $10, $10
  db	$00, $0C, $14, $14
  db	$00, $0C, $18, $18
  db	$00, $0C, $18, $1C
  db	$00, $0C, $18, $20
  db	$00, $0C, $18, $24
;
  db	$00, $0C, $18, $24
  db	$00, $0C, $18, $24
  db	$00, $0C, $18, $24
  db	$00, $0C, $18, $24
  db	$00, $0C, $18, $24
  db	$00, $0C, $18, $24
  db	$00, $0C, $18, $24
  db	$00, $0C, $18, $24
  db	$00, $0C, $18, $24
  db	$00, $0C, $18, $24
}

; =============================================================================
; -- fire data --

DragonFireX_Data:
{
  db $00, $00, $00, $00, $00, $00
  db $05, $0B, $11, $18, $20, $2A
  db $08, $10, $19, $23, $2E, $3C
  db $05, $0B, $11, $18, $20, $2A
  db $00, $00, $00, $00, $00, $00
  db	-$05,-$0B,-$11,-$18,-$20, -$2A
  db	-$08,-$10,-$19,-$23,-$2E, -$3C
  db	-$05,-$0B,-$11,-$18,-$20, -$2A
}

DragonFireY_Data:
{
  db $08, $10, $19, $23, $2E, $3C
  db $05, $0B, $11, $18, $20, $2A
  db $00, $00, $00, $00, $00, $00
  db -$05,-$0B,-$11,-$18,-$20,-$2A
  db -$08,-$10,-$19,-$23,-$2E,-$3C
  db -$05,-$0B,-$11,-$18,-$20,-$2A
  db $00, $00, $00, $00, $00, $00
  db $05, $0B, $11, $18, $20, $2A
}

; =============================================================================

!KEYA2 = $F4

DiscoDragon_MainMove:
{
;
  LDA	!KEYA2 : AND #$08 : BEQ .DRM00
  INC	!ENEMY_CHAR_POINT, X
  LDA	!ENEMY_CHAR_POINT, X : CMP #$10 : BCC	.DRM00
  STZ	!ENEMY_CHAR_POINT, X
.DRM00:
;
  JSR	DiscoDragon_Count
  JSL Sprite_OAM_AllocateDeferToPlayer

  ; REP #$20
  ; LDA	!OAM_ADDR : CLC : ADC #$0018 : STA !OAM_ADDR
  ; LDA	!OAM_SUB_ADDR : ADC	#$0018/4 : STA	!OAM_SUB_ADDR
  ; SEP #$20
;
  LDA	#$0C*4
  STA	!WORKF  	; haikei
;
  STZ	!WORKE : LDA #$04 : STA !WORKD

.DiscoDragon_Move_010
  JSR	DiscoDragon_Move_020
;
  LDA	!WORKF : SEC : SBC #$0C : STA	!WORKF
;
  LDA	!WORKE : CLC : ADC #$04 : STA !WORKE
;
  DEC	!WORKD : BPL .DiscoDragon_Move_010
;
  LDY	#$02 : LDA #$04 : JSR	Allow_OAM_Check ; Allow OAM Check 
;-- fire set -----
  LDA	!ENEMY_TIMER_1, X : BEQ	.Dragon_FireChar090
;
  PHA
  JSL Sprite_OAM_AllocateDeferToPlayer
  ; REP #$20
  ; LDA	!OAM_ADDR : SEC : SBC	#$0018 : STA	!OAM_ADDR
  ; LDA	!OAM_SUB_ADDR : SEC : SBC	#$0018/4 : STA	!OAM_SUB_ADDR
  ; SEP	#$20
;
  PLA
  LSR	A
  LSR	A
  NOP
  TAY
  LDA	Dragon_FireChar0, Y : STA	!WORK1
  LDA	Dragon_FireChar1, Y : STA	!WORK0
;- - - - - - - 
  LDA	!ENEMY_CHAR_DIRECTION, X
  ASL	A : ASL	A
  ADC	!ENEMY_CHAR_DIRECTION, X
  ADC	!ENEMY_CHAR_DIRECTION, X
  STA	!WORK2
;
  PHX
  LDX	!WORK1 : BMI .Dragon_FireChar070
;
  LDY	#$00

.Dragon_FireChar010
  PHX : TXA : CLC : ADC	!WORK2
  TAX
  LDA	!ENEMY_HELP_2 : CLC : ADC DragonFireX_Data, X : STA ($90), Y
  LDA	!ENEMY_HELP_1 : CLC : ADC DragonFireY_Data, X : INY : STA ($90), Y	
  PLX
  LDA	Dragon_FireCharData, X : INY : STA	($90), Y
  TXA
  EOR	!FRAME_COUNTER
  ASL #5 ; ASL 5 times
  AND	#$40 : ORA	#$23
  INY : STA	($90), Y : INY
  DEX
  CPX	!WORK0
  BNE	.Dragon_FireChar010
;
.Dragon_FireChar070
  PLX
  LDY	#$02 : LDA #$05
  JSR	Allow_OAM_Check ; ; Allow OAM Check (potential hook)

.Dragon_FireChar090
  RTS
}

;============================================

Dragon_FireChar0:
{
  db -1,-1,-1,-1,-1,-1,-1,-1,$05,$05,$05,$05,$05,$05,$05,$05
  db $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
  db $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
  db $05,$05,$05,$04,$03,$02,$01,$00,-1,-1,-1,-1,-1,-1,-1,-1
}

Dragon_FireChar1:
{
  db $00,$00,$00,$00,$00,$00,$00,$00,$04,$03,$02,$01,$00,-1,-1,-1
  db -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
  db -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
  db -1,-1,-1,-1,-1,-1,-1,-1,$00,$00,$00,$00,$00,$00,$00,$00
}

Dragon_FireCharData:
{
  db $6E, $6E, $6C, $6C, $4E, $4C, $4C, $4C
}

;- - - - - - - - - - - - - - - - - - -
Dragon_Revise:
{
  db $00, $04, $00, $FC
}

RotationMatrixData:
{
; 0--127
  dw $0000, $0003, $0006, $0009, $000C, $000F, $0012, $0015
  dw $0019, $001C, $001F, $0022, $0025, $0028, $0028, $002E
  dw $0031, $0035, $0038, $003B, $003E, $0041, $0044, $0047
  dw $004A, $004D, $0050, $0053, $0056, $0059, $005C, $005F
  dw $0061, $0064, $0067, $006A, $006D, $0070, $0073, $0075
  dw $0078, $007B, $007E, $0080, $0083, $0086, $0088, $008B
  dw $008E, $0090, $0093, $0095, $0098, $009B, $009D, $009F
  dw $00A2, $00A4, $00A7, $00A9, $00AB, $00AE, $00B0, $00B2
  dw $00B5, $00B7, $00B9, $00BB, $00BD, $00BF, $00C1, $00C3
  dw $00C5, $00C7, $00C9, $00CB, $00CD, $00CF, $00D1, $00D3
  dw $00D4, $00D6, $00D8, $00D9, $00DB, $00DD, $00DE, $00E0
  dw $00E1, $00E3, $00E4, $00E6, $00E7, $00E8, $00EA, $00EB
  dw $00EC, $00ED, $00EE, $00EF, $00F1, $00F2, $00F3, $00F4
  dw $00F4, $00F5, $00F6, $00F7, $00F8, $00F9, $00F9, $00FA
  dw $00FB, $00FB, $00FC, $00FC, $00FD, $00FD, $00FE, $00FE
  dw $00FE, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF
;128--255
  dw $0100
  dw $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $00FF, $00FE
  dw $00FE, $00FE, $00FD, $00FD, $00FC, $00FC, $00FB, $00FB
  dw $00FA, $00F9, $00F9, $00F8, $00F7, $00F6, $00F5, $00F4
  dw $00F4, $00F3, $00F2, $00F1, $00EF, $00EE, $00ED, $00EC
  dw $00EB, $00EA, $00E8, $00E7, $00E6, $00E4, $00E3, $00E1
  dw $00E0, $00DE, $00DD, $00DB, $00D9, $00D8, $00D6, $00D4
  dw $00D3, $00D1, $00CF, $00CD, $00CB, $00C9, $00C7, $00C5
  dw $00C3, $00C1, $00BF, $00BD, $00BB, $00B9, $00B7, $00B5
  dw $00B2, $00B0, $00AE, $00AB, $00A9, $00A7, $00A4, $00A2
  dw $009F, $009D, $009B, $0098, $0095, $0093, $0090, $008E
  dw $008B, $0088, $0086, $0083, $0080, $007E, $007B, $0078
  dw $0075, $0073, $0070, $006D, $006A, $0067, $0064, $0061
  dw $005F, $005C, $0059, $0056, $0053, $0050, $004D, $004A
  dw $0047, $0044, $0041, $003E, $003B, $0038, $0035, $0031
  dw $002E, $002B, $0028, $0025, $0022, $001F, $001C, $0019
  dw $0015, $0012, $000F, $000C, $0009, $0006, $0003
}

!ENINDX = $0FA0

;
DiscoDragon_Move_020:
{
  STZ	!WORK2 : STZ !WORKF
;
  LDY	!WORKD : BEQ	.DiscoDragon_Move_205
;
  LDA	!ENEMY_WORK_2, X : PHP : BPL	.DiscoDragon_Move_190
  EOR	#$FF : INC	A

.DiscoDragon_Move_190
  STA	!WORK2
  CPY	#$04 : BEQ	.DiscoDragon_Move_200
  LSR	!WORK2
  LDA	!WORK2
  CPY	#$02 : BEQ	.DiscoDragon_Move_200
  LSR	!WORK2
  CPY	#$01 : BEQ	.DiscoDragon_Move_200
  NOP
  ADC	!WORK2 : STA	!WORK2

.DiscoDragon_Move_200
  PLP
  BMI	.DiscoDragon_Move_201
  LDA	!WORK2
  EOR	#$FF : INC A
  STA	!WORK2

.DiscoDragon_Move_201
  LDA	!FRAME_COUNTER
  LSR #3 ; LSR A 3 times
  NOP
  NOP
  CLC : ADC	!WORKD : AND	#$03
  PHY : TAY
  LDA	!WORK2 : CLC : ADC	Dragon_Revise, Y : STA !WORK2
  PLY
;
  LDA	!ENEMY_CHAR_POINT, X
  STA	!WORKF : CPY	#$04 : BEQ	.DiscoDragon_Move_300
  LSR	!WORKF
  LDA	!WORKF : CPY	#$02 : BEQ	.DiscoDragon_Move_300
  LSR	!WORKF : CPY	#$01 : BEQ	.DiscoDragon_Move_300
  NOP
  ADC	!WORKF : STA !WORKF

.DiscoDragon_Move_300
;
  STZ	!WORKF
;
  LDA	#$00
  LDY	!WORKD
  BEQ	.DiscoDragon_Move_021
;
  LDA	!ENEMY_CHAR_POINT, X
  ASL	A
  ASL	A
  ADC	!WORKD
  DEC	A
  TAX
  LDA	DragonPoint_Data1, X
  STA	!WORKF
;;;
.DiscoDragon_Move_205
  LDY	#$00
  LDA	DragonPoint_Data0, X
  LDA	!WORK2 : BPL .DiscoDragon_Move_021
  DEY

.DiscoDragon_Move_021
  CLC
  LDX	!ENINDX
  ADC	!ENEMY_WORK_1, X : STA !WORK0
  TYA
  ADC	!ENEMY_WORK_0, X : AND	#$01 : STA !WORK1
;
  PHX
  ; MEM16
  ; IDX16
  REP	#$30
;
  LDA	!WORK0 : CLC : ADC #$0020 : AND #$01FF
  LSR #6 ; LSR A 6 times
  STA	!WORKA
;
  LDA	!WORK0 : CLC : ADC #$0080 : AND #$01FF : STA	!WORK2
;
  LDA	!WORK0 : AND #$00FF : ASL	A : TAX
  LDA	RotationMatrixData, X : STA !WORK4
;
  LDA	!WORK2 : AND #$00FF : ASL	A : TAX
  LDA	RotationMatrixData, X : STA !WORK6
  ; MEM8
  ; IDX8
  SEP	#$30		
  PLX
; NECK CHAIN CODE
  LDA	!WORK4 : STA	$4202
  ; WORKF - Hankei (radius)
  LDA	!WORKF : LDY $05 : BNE .kusari_F0
  STA	$4203
  ; db def ? what mean 
  db $EA, $EA, $EA, $EA, $EA, $EA, $EA, $EA
  ASL	$4216
  LDA	$4217 : ADC	#$00

.kusari_F0
  LSR	!WORK1 : BCC	.kusari_00
  EOR	#$FF : INC A

.kusari_00
  STA	!WORK4		; XAD
; TODO investigate this
  LDA	!WORK6 : STA	$4202
  LDA	!WORKF : LDY !WORK7 : BNE	.kusari_08
  STA	$4203
  db $EA, $EA, $EA, $EA, $EA, $EA, $EA, $EA
  ASL	$4216
  LDA	$4217
  ADC	#$00

.kusari_08
  LSR	!WORK3 : BCC .kusari_10
  EOR	#$FF : INC A

.kusari_10
  STA !WORK6 ; YAD
;-- oam set -
  JSR	OAM_Check ; TODO investigate this 
  JSL Sprite_OAM_AllocateDeferToPlayer
;
  LDY	!WORKE
  LDA	!WORK0 : CLC : ADC	!WORK4 : STA	($90), Y : PHA
  LDA	!WORK2 : CLC : ADC	!WORK6 : INY : PHA : STA	($90), Y : PHX 
  LDX	!WORKA : LDA	!WORKD : CMP	#$04 : BNE .DR1C10 : PLX : PHX
  LDA	!ENEMY_TIMER_1, X : CMP	#$01
  LDA	!ENEMY_CHAR_DIRECTION, X : BCC .DR1C0D
  CLC : ADC	#$08
  
.DR1C0D
  CLC : ADC	#$08 : TAX

.DR1C10
  LDA	DiscoDragon_CharData, X : INY : STA	($90), Y
  TXA : AND	#$07 : TAX
  LDA	DiscoDragon_AttackData, X : PLX : ORA	!WORK3 : INY : STA	($90), Y
;
  LDA	!WORKD : CMP	#$04 : BNE	.DR1C20
;
  PLA : STA	!ENEMY_HELP_1 
  PLA : STA	!ENEMY_HELP_2
  RTS

.DR1C20
  PLA
  PLA
  RTS
}

;- - - - - - - - - - - - -

DiscoDragon_CharData:
{
  db $62, $60, $64, $60, $62, $60, $64, $60
  db $40, $48, $44, $48, $40, $48, $44, $48
  db $42, $4A, $46, $4A, $42, $4A, $46, $4A
}

; ADT - AttackData is a guess NEEDS CONFIRMATION
DiscoDragon_AttackData:
{
  db $00, $00, $00, $80, $80, $C0, $40, $40
}

;----------------------------------------------------------
; only 80h angle serch data !
DiscoDragon_NeckDirection:
{
;;;;;;;   xspd->
  db $00, $00, $00, $00, $00, $00, $00, $02 ; Y
  db $00, $00, $00, $00, $00, $00, $00, $02 ; |
  db $00, $00, $00, $00, $00, $00, $00, $02 ; V
  db $00, $00, $00, $00, $00, $00, $00, $02
  db $00, $00, $00, $00, $00, $00, $00, $01
  db $00, $00, $00, $00, $00, $00, $00, $01
  db $00, $00, $00, $00, $00, $00, $00, $01
  db $00, $00, $00, $00, $01, $01, $01, $01
}

DiscoDragon_NeckDirection2:
{
  db $00, $01, $02, $00
  db $04, $03, $02, $00
  db $00, $07, $06, $00
  db $04, $05, $06, $00
}

; DiscoDragon_NeckDirection:
; It represents the dragon's movement pattern in terms of X and Y speeds. 
; Each entry corresponds to a specific angle at which the dragon will move.
;  The first entry (Y-axis) shows that the dragon's Y speed is 0 for the first 7 angles, and then it increases to 2 for the remaining angles.
; The second entry (X-axis) follows the same pattern as the Y-axis, with the X speed being 0 for the first 7 angles and then increasing to 2 for the remaining angles.

; DiscoDragon_NeckDirection2:
; The table is divided into four rows, each representing a different phase of movement.
; Each entry in the row corresponds to a specific angle at which the dragon will move.
; The values in the table represent the direction of movement. 
; For example, 0 indicates no movement, and positive values indicate movement in a specific direction.

;----
DiscoDragon_NeckSearch:
{
  TXA : EOR	!FRAME_COUNTER : AND	#$07 : BNE .return
;
  LDA	#$07
  JSR	Player_Search
  LDA	!WORK0 : BPL	.DKS010
  EOR	#$FF : INC	A

.DKS010
  ASL #3 : STA	!WORK2 
  LDA	!WORK1 : BPL .DKS020
  EOR	#$FF : INC	A

.DKS020
  ORA	!WORK2
  TAY
  LDA	!WORK1 : ASL	A
  LDA	!WORK0 : ROR	A
  LSR #4 ; LSR A 4 times
  AND	#$0C : ORA DiscoDragon_NeckDirection, Y : TAY
  LDA	DiscoDragon_NeckDirection2, Y : STA !ENEMY_CHAR_DIRECTION, X

.return
  RTS
}

; =============================================================================

DiscoDragon_CountAddr:
{
  db $01, $FF
}

DiscoDragon_CountTailDirection:
{
  db $40, $C0
}

; =============================================================================

DiscoDragon_Count:
{
  STZ	!ENEMY_COUNT_FLAG, X
  LDA	!ENEMY_ACTION, X
  JSL	UseImplicitRegIndexedLocalJumpTable

.disco_dragon_jump_table
  dw DiscoDragon_Wait
  dw DiscoDragon_Long
  dw DiscoDragon_Move
  dw DiscoDragon_Fire
}

;--------------------------------------

DiscoDragon_StartLow:
{
  db $80, $80, $00, $00
}

DiscoDragon_StartHigh:
{
  db $00, $01, $00, $01
}

; =============================================================================

DiscoDragon_Wait:
{
  JSR	Enemy_Player_XY_Check ; get player position 
  LDA	!WORKE : CLC : ADC #$30 : CMP #$60 : BCS	.return
  LDA	!WORKF : CLC : ADC #$30 : CMP #$60 : BCS	.return
;
  INC	!ENEMY_ACTION, X ; Move to DiscoDragon_Long
;
  LDA	DiscoDragon_StartLow, Y : STA	!ENEMY_WORK_1, X
  LDA	DiscoDragon_StartHigh, Y : STA	!ENEMY_WORK_0, X

.return
  RTS
}

;--------------------------------------

print pc
DiscoDragon_Long:
{
  LDA	!FRAME_COUNTER : AND	#$01 : BNE .return
;
  INC	!ENEMY_CHAR_POINT, X
  LDA	!ENEMY_CHAR_POINT, X : CMP	#$20 : BNE .return
;
  INC	!ENEMY_ACTION, X
  LDA	#$80 : STA !ENEMY_TIMER_2, X

.return
  RTS
}

;--------------------------------------
;--------------------------------------
;--------------------------------------

DiscoDragon_Move:
{
  JSR	DiscoDragon_NeckSearch		; kubi muku (neck direction) serch !
;
  LDA	!ENEMY_WORK_1, X : CLC : ADC	#$00 : STA	!ENEMY_WORK_1, X	; angle 
  LDA	!ENEMY_WORK_0, X : ADC	#$00 : AND #$01 : STA	!ENEMY_WORK_0, X
;
  LDA	!ENEMY_TIMER_0, X : BNE	.D1CT12
;
  LDA	!ENEMY_MUKI, X : AND #$01
  TAY
  ;                                    $01 or $FF
  LDA	!ENEMY_WORK_2, X : CLC : ADC DiscoDragon_CountAddr, Y : STA !ENEMY_WORK_2, X
  CMP	DiscoDragon_CountTailDirection, Y : BNE	.D1CT12
;
  LDA	#$30 : STA !ENEMY_TIMER_0, X
;
  INC	!ENEMY_MUKI, X

.D1CT12
  LDA	!ENEMY_TIMER_2, X : BNE	.return
;
  LDA	#$7F : STA	!ENEMY_TIMER_1, X
;
  INC	!ENEMY_ACTION, X

.return
		RTS
}

;====================================================

DiscoDragon_Fire:
{  
  LDA	#$01 : STA !ENEMY_COUNT_FLAG, X
;
  LDA	!ENEMY_TIMER_1, X : BNE	.return
;
  LDA	#$80 : STA !ENEMY_TIMER_2, X
  DEC	!ENEMY_ACTION, X		
.return
  RTS
}

; END OF DRAGON CODE
; =============================================================================


; =============================================================================
; Player_Search

;----------------------------
Player_Search:
{
  JSR	Player_Search2
;----------------------------
  LDA	!WORK0 : STA	!ENEMY_Y_VELOCITY, X
  LDA	!WORK1 : STA	!ENEMY_X_VELOCITY, X
  RTS
}

;			
;-----------------------------------------
Player_Search_Clear:
{
  STZ	!WORK0
  RTS
}

;
Player_Search2:
{
  STA	!WORK1
  CMP	#$00 : BEQ Player_Search_Clear
  PHX : PHY
;
  JSR	Enemy_Player_Y_Check
  STY	!WORK2
;
  LDA	!WORKE : BPL	.PS00
  EOR	#$FF : INC	A

.PS00
  STA	!WORKC
;
  JSR	Enemy_Player_X_Check : STY !WORK3
;
  LDA	!WORKF : BPL	.PS10
  EOR	#$FF : INC	A
.PS10
  STA	!WORKD
;
  LDY	#$00
  LDA	!WORKD : CMP	!WORKC : BCS	.PS20
  INY
  PHA
  LDA	!WORKC : STA	!WORKD
  PLA
  STA	!WORKC
.PS20
  STZ	!WORKB
  STZ	!WORK0
;
  LDX	!WORK1		; Base speed
.PS30
  LDA	!WORKB
  CLC
  ADC	!WORKC
  CMP	!WORKD
  BCC	.PS40
;
  SBC	!WORKD
  INC	!WORK0
.PS40
  STA	!WORKB
  DEX
  BNE	.PS30
;
  TYA
  BEQ	.PS50
;
  LDA	!WORK0
  PHA
  LDA	!WORK1
  STA	!WORK0
  PLA
  STA	!WORK1

.PS50
  LDA	!WORK0 : LDY	!WORK2 : BEQ	.PS60
  EOR	#$FF : INC A
  STA	!WORK0

.PS60
  LDA	!WORK1 : LDY	!WORK3  : BEQ	.PS70
  EOR	#$FF : INC A
  STA	!WORK1

.PS70
  PLY
  PLX
  RTS
}


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%   		OAM clear check sub.     		%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;--------------------------------------------
Allow_OAM_Check:
{
  JSR	AllowCheck
;
  PHX
;
;;		LDY	#$00
  ; IDX16
  REP	#$10
  LDX	!OAM_ADDR
  STX	!WORKC
  LDX	!OAM_SUB_ADDR
  STX	!WORKE
.GSCL00
  LDX	!WORKE
;
  LDA	!WORKB
  BPL	.GSCL08
  LDA	!OAMSB, X
  AND	#$02
.GSCL08
  STA	!OAMSB, X
.GSCL09.
;-- X Check ---
  LDY	#$0000
  LDX	!WORKC
  LDA	!OAM_MAIN, X
  SEC
  SBC	!WORK7
  BPL	.GSCL10
  DEY

.GSCL10
  CLC : ADC	!WORK2 : STA !WORK4
  TYA : ADC	!WORK3 : STA !WORK5
  JSR	On_OAM_Check
  BCC	.GSCL11
  LDX	!WORKE
  INC	!OAMSB, X
;;		ORA	#00000001B
;;		STA	!OAMSB-!OAMSB, X
.GSCL11
;-- Y check --
  LDY	#$0000
  LDX	!WORKC
  INX
  LDA	!OAM_MAIN, X
  SEC
  SBC	!WORK6
  BPL	.GSCL12
  DEY
.GSCL12
  CLC
  ADC	!WORK0
  STA	!WORK9
  TYA
  ADC	!WORK1
  STA	!WORKA
  JSR	On_OAM_Check_Vert
  BCC	.GSCL20
.GSCL18
  LDA	#$F0
  STA	!OAM_MAIN, X

.GSCL20
  INX
  INX
  INX
  STX	!WORKC
  INC	!WORKE
  DEC	!WORK8
  BPL	.GSCL00
;
  ; IDX8
  SEP	#$10
;;		LDX	!ENINDX
  PLX
  RTS
}

;---------------------------------------------

AllowCheck:
{  
  STY	!WORKB
  STA	!WORK8
  LDA	!ENEMY_Y_POS, X : STA !WORK0
  SEC : SBC	!BG2_VERT_SCROLL_REG : STA	!WORK6

  LDA	!ENEMY_YH, X : STA	!WORK1
  LDA	!ENEMY_X, X : STA	!WORK2
  SEC : SBC	!BG2_HORIZ_SCROLL_REG : STA	!WORK7

  LDA	!ENEMY_X_POS, X : STA !WORK3
  RTS
}

;------------------------------

On_OAM_Check:
{  
  ;MEM16
  REP	#$20
  LDA	!WORK4 : SEC : SBC !BG2_HORIZ_SCROLL_REG : CMP #$0100
  ; MEM8
  SEP	#$20
  RTS
}

; =============================================================================

OAM_Check:
{
  STZ	!ENEMY_PAUSE, X
;
;;		LDA	!ENEMY_X_POS, X
;;		XBA
;;		LDA	!ENEMY_X, X
  ; MEM16
  REP	#$20
  LDA	!ENEMY_CACHED_X : SEC : SBC	!BG2_HORIZ_SCROLL_REG : STA	!WORK0 : CLC
;;		ADC	#0040H
;;		CMP	#0170H+10H
  ADC	#$0040
  CMP	#$0170
  ; MEM8
  SEP	#$20
  BCS	.O2T010
;
  LDA	!ENEMY_Z_POS, X
  STA	!WORK5
  STZ	!WORK5
;
;;		LDA	!ENEMY_YH, X
;;		XBA
;;		LDA	!ENEMY_Y_POS, X
  ; MEM16
  REP	#$20
  LDA	!ENEMY_CACHED_Y
  SEC
  SBC	!BG2_VERT_SCROLL_REG
  PHA
  SEC
  SBC	!WORK4
  STA	!WORK2
  PLA
  CLC
;;		ADC	#0040H
;;		CMP	#0170H+10H
  ADC	#$0040
  CMP	#$0170
  ; MEM8
  SEP	#$20
  BCC	.O2T022
;
  LDA	!ENEMY_HITBOX, X
  AND	#$20
;;		BNE	.O2T022		 ; Nagai yatsu ?
;					 ; no.
  BEQ	.O2T0102
;
.O2T022
  CLC
;;		LDA	!ENEMY_X, X
;;		SEC
;;		SBC	!BG2_HORIZ_SCROLL_REG
;;		STA	!WORK0
;;		LDA	!ENEMY_X_POS, X
;;		SBC	!BG2_HORIZ_SCROLL_REG1
;;		STA	!WORK1
;
;;                LDA     !ENEMY_Y_POS, X
;;;              SEC
;;                SBC     !ENEMY_Z_POS, X
;;;              PHP
;;                SEC
;;                SBC     !BG2_VERT_SCROLL_REG
;;		STA	!WORK2
;;                LDA     !ENEMY_YH, X
;;                SBC     !BG2_VERT_SCROLL_REG1
;;                PLP
;;                SBC     #00H
;;                PLP
;;                ADC     #00H
;;		STA	!WORK3
;
;;		LDA	!WORK0
;;		SEC
;;		SBC	#10H
;;		STA	!ENEMY_RELATIVE_Y
;
.O2T038
  LDA	!ENEMY_PROPS, X
  EOR	!ENEMY_OBJ_PRIORITY, X
  STA	!WORK5
  STZ	!WORK4
  LDA	!WORK0 : STA	!ENEMY_RELATIVE_X
  LDA	!WORK2 : STA	!ENEMY_RELATIVE_Y
  LDY	#$00
  RTS

.O2T010
  ; MEM16
  REP	#$20
  LDA	!ENEMY_CACHED_Y
  SEC
  SBC	!BG2_VERT_SCROLL_REG
  SEC
  SBC	!WORK4
  STA	!WORK2
  ; MEM8
  SEP	#$20
;
.O2T0102
  INC	!ENEMY_PAUSE, X
;;		LDA	SLMODE
;;		CMP	#MD_djply
;;		BEQ	.O2T020
;
  LDA	!ENEMY_DEFLECTION, X
  BMI	.O2T020
;
  JSL	EnemyClear
.O2T020
  PLA
  PLA
  SEC
  BRA	.O2T038
}

;-------------------------------

On_OAM_Check_Vert:
{
  ; MEM16
  REP	#$20
  LDA	!WORK9
  PHA
  CLC
  ADC	#$10
  STA	!WORK9
  SEC
  SBC	!BG2_VERT_SCROLL_REG
  CMP	#$0100
  PLA
  STA	!WORK9
  ; MEM8
  SEP	#$20
  RTS
}

;================================================================
Enemy_Player_XY_Check2:
  JSR	Enemy_Player_XY_Check
  RTL
;- - - - - - - - - - - - - - - - -
Enemy_Player_XY_Check:
{
  JSR	Enemy_Player_X_Check
  STY	!WORK0
  JSR	Enemy_Player_Y_Check
  STY	!WORK1
  LDA	!WORKE
  BPL	.EXY000
  EOR	#$FF
  INC	A
.EXY000
  STA	!ENEMY_HELP_1
  LDA	!WORKF
  BPL	.EXY010
  EOR	#$FF
  INC	A
.EXY010
  CMP	!ENEMY_HELP_1
  BCC	.EXY020
  LDY	!WORK0
  RTS
.EXY020
  LDA	!WORK1
  INC	A
  INC	A
  TAY
  RTS
}

;================================================================

Enemy_Player_X_Check2:
  JSR	Enemy_Player_X_Check
  RTL
;- - - - -
Enemy_Player_X_Check:
{  
  LDY	#$00
  LDA	!PLAYER_X_COORD1
  SEC
  SBC	!ENEMY_X, X
  STA	!WORKF
  LDA	!PLAYER_X_COORD0
  SBC	!ENEMY_X_POS, X
  BPL	.EPX010
  INY
.EPX010
  RTS
}

;=================================================================

Enemy_Player_Y_Check2:
{
  JSR	Enemy_Player_Y_Check
  RTL
}

;- - - - - - - - - - - - - - -

Enemy_Player_Y_Check:
{
  LDY	#$00
  LDA	!PLAYER_Y_COORD1
  CLC
  ADC	#$08
  PHP
  CLC : ADC	!ENEMY_Z_POS, X
  PHP
  SEC
  SBC	!ENEMY_Y_POS, X
  STA	!WORKE
  LDA	!PLAYER_Y_COORD0
  SBC	!ENEMY_YH, X
  PLP
  ADC	#$00
  PLP
  ADC	#$00
  BPL	.return
  INY
.return
  RTS
}

; =============================================================================

GONOF2:
{
  db $7F
  db $BF
  db $DF
  db $EF
  db $F7
  db $FB
  db $FD
  db $FE
}

;******************************************************************************
;*		Enemy clear 				 *
;******************************************************************************
;- - - - RESET ----
EnemyClear:
{
;;		LDA	SLMODE
;;		CMP	#MD_djply
;;		BEQ	EOT0A0
;;		LDA	!ENEMY_DEFLECTION, X
;;		AND	#80H
  LDA	!ENEMY_DEFLECTION, X : AND	#$40 : BNE	.EnemyClear2		; Mujouken clear !
;
  LDA	!DUNGEON_FLAG : BNE .EOT0B0
;
.EnemyClear2
  STZ	!ENEMY_STATE, X
;
  TXA
  ASL	A
  TAY
  ; MEM16
  REP	#$20
  LDA	!ENEMY_INDEX, Y : STA	!WORK0
  CMP	#$FFFF
  PHP
  LSR	A
  LSR	A
  LSR	A
  CLC
  ADC	#!ENEMY_DEATH_STATUS
  STA	!WORK1
  PLP
  ; MEM8
  SEP	#$20
;
  BCS	.EOT0A0			; data set enemy ?
;						; yes ! on off bit clear !
  LDA !ENEMY_DEATH_STATUS ; LDA	#BANK ENEMY_DEATH_STATUS
  STA	!WORK3
;
  PHX
      LDA     !WORK0		; x pos !
      AND     #$07
      TAX 
      LDA     [!WORK1] 
      AND     GONOF2, X
      STA     [!WORK1] 
  PLX
.EOT0A0
  LDA	!DUNGEON_FLAG
  BNE	.EOT0A8
;
		TXA
		ASL	A
		TAY
		LDA	#$FF
		STA	!ENEMY_INDEX, Y
		STA	!ENEMY_INDEX+1, Y
		RTL
;
.EOT0A8
  LDA	#$FF : STA	!ENEMY_INDEX, X

.EOT0B0
  RTL
}


print "End of disco_dragon.asm ", pc