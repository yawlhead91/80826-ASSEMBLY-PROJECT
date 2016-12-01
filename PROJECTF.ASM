;
;       Author : Alex Kirwan R00132481
;
;       File   : ProjectFinal.asm
;       
;       This program is designed to draw an aspect of a kitchen 
;		with interactivity and animation.
;    

TITLE   PROJECTF.ASM

SSEG    SEGMENT PARA STACK 'STACK'         ;Stack segment
        DB      64 DUP('STACK   ')
SSEG    ENDS


DSEG    SEGMENT PARA PUBLIC 'DATA'         ;Code segment
DSEG    ENDS

CSEG    SEGMENT PARA PUBLIC 'CODE'
        ASSUME CS:CSEG, DS:DSEG, SS:SSEG

MAIN    PROC    FAR

        PUSH    DS                        	;These 5 lines are
        MOV     AX,0                       	;required for all .ASM
        PUSH    AX                         	;programs.
        MOV     AX,DSEG                    
        MOV     DS,AX                      

        MOV     AH,00H                 		;SET THE SCREEN TO GRAPHIC MODE
        MOV     AL,18                 
        INT     10H


        MOV     DX,40
        MOV     CX,100

        MOV     AL,4						;DRAW THE FRIDGE
        CALL    DRAWFRIDGE
		
		CALL 	DRAWLIGHT					;DRAW THE LIGHT
		
		CALL	DRAWLIGHTSWITCH				;DRAW THE LIGHTSWTICH
		
		
		MOV		AX,01H						;SHOW MOUSE PINTER
		INT		33H

SETPOINTER:
		MOV		BX,0H						;REST CLICK FLAG
		MOV		AX,03H						;TAKE MOUSE INPUT
		INT		33H
		
		
		CMP		BX,1						;CHECK IF LEFT MOUSE BUTTON WAS CLICKED
		JB		SETPOINTER
		JA		FINNISH						;IF RIGHT MOUSE BUTTON WAS CLICKED END PROGRAM 
		CMP		DX,205						;CHECK CORDINATES FROM CLICK IF WATER BUTTON WAS PRESSED
		JB		SETPOINTER
		CMP		CX,247
		JB		SETPOINTER
		CMP		DX,210
		JA		CHECKGLASS
		CMP		CX,252
		JA		CHECKSWITCH
		CALL	WATERPOUR
		JMP		SETPOINTER

CHECKGLASS:									;CHECK IF THE GLASS WAS CLICKED
		CMP		DX,235
		JB		CHECKSWITCH
		CMP		DX,255
		JA		SETPOINTER
		CMP		CX,243
		JB		SETPOINTER
		CMP		CX,258
		JA		CHECKSWITCH
		CALL    EMPTYGLASS
		JMP		SETPOINTER

CHECKSWITCH:								;CHECK IF THE LIGHT SWTICH WAS CLICKED
		CMP	 	CX,562
		JB		SETPOINTER
		CMP		DX,232
		JB		SETPOINTER
		CMP		CX,567
		JA		SETPOINTER
		CMP		DX,242
		JA		SETPOINTER
		MOV		AL,14
		CALL    DRAWBULB
		JMP		SETPOINTER
		
		
		

        MOV     AH,00H
        INT     16H            			   ; WAIT UNTIL SOMEONE TYPES AT KEYBOARD
FINNISH:	
		MOV     AH,00H                     ;SET THE SCREEN TO TEXT MODE
        MOV     AL,2                    
        INT     10H


        RET                                ;The program ends here.

MAIN    ENDP

;--------------------------------------------------------------------
;
;                SUB PROGRAMES TO DRAW KITCHEN ITEMS
;--------------------------------------------------------------------
;---------------------------------------------------------------------
;DRAWFRIDGE
;  Description :     Draw a fridge 
;  Input:        DX - (row)
;                CX - Column
;                DI - Height
;                SI - Width
;  Registers affected : None
;---------------------------------------------------------------------
DRAWFRIDGE      PROC

        PUSH      CX
        PUSH      DX
        PUSH      DI
        PUSH      SI

        MOV     DI,100			;DRAW FREEZER
        MOV     SI,180 
        CALL    DRAWBOX
		
		MOV		SI,20
		CALL	DRAWRIGHTSLOPE
		
		ADD		CX,180
		CALL	DRAWRIGHTSLOPE
		
		SUB		CX,180
		ADD		DX,105			;DRAW FRIDGE
		MOV     DI,300
        MOV     SI,180 
        CALL    DRAWBOX
		
		SUB		DX,15			;DRAWHANDLE ON FREZZER
		ADD		CX,140
		MOV     DI,5
        MOV     SI,30
		MOV		AL,0
        CALL    DRAWBOX
		
		ADD		DX,25			;DRAW HANDLE ON FRIDGE
		CALL    DRAWBOX
		
		ADD		DX,60			;DRAW WATER DESPENSER
		SUB		CX,10
		MOV     DI,40
        MOV     SI,40
		CALL    DRAWBOX
		
		ADD		CX,17			;DRAW NOZZLE
		MOV     DI,40
        MOV     SI,6
		MOV		DI,10
		MOV		AL,15
		CALL    DRAWBOX
		
		CALL	DRAWGLASS
		
		MOV		DX,20			;MAKE FRIDGE 3D
		MOV		CX,62
		MOV     SI,180
		MOV		AL,4
		CALL	DRAWHLINE
		
		MOV		DI,405
		CALL	DRAWVLINE
		
		MOV		DX,445
		MOV		CX,100
		MOV		SI,20
		CALL	DRAWRIGHTSLOPE
		
		
		MOV		CX,247		    ;ADD BUTTON 
		MOV	    DX,205
		MOV	    AL,14
		MOV		SI,6
		MOV		DI,5
		CALL    DRAWBOX
		
		
        POP     SI
        POP     DI
        POP     DX
        POP     CX
		
       
        RET

DRAWFRIDGE        ENDP
;---------------------------------------------------------------------
;DRAWGLASS
;  Description :     Draw a GLASS
;  Input:        DX - (row)
;                CX - Column
;                DI - Height
;                SI - Width
;  Registers affected : None
;---------------------------------------------------------------------
DRAWGLASS		PROC
		PUSH      CX
        PUSH      DX
        PUSH      DI
        PUSH      SI
		
		MOV		AL,3			
		MOV		CX,243
		MOV		DX,235
		MOV		SI,15
		MOV		DI,20
		CALL	DRAWHLINE
		CALL	DRAWVLINE
		
		ADD		DX,20
		CALL	DRAWHLINE
		
		SUB		DX,20
		ADD		CX,15
		CALL	DRAWVLINE
		
		
		
		POP       SI
        POP       DI
        POP       DX
        POP       CX
		
		RET
DRAWGLASS		ENDP

;---------------------------------------------------------------------
;EMPTYGLASS
;  Description :     EMPTY THE GLASS
;  Input:        DX - (row)
;                CX - Column
;                DI - Height
;                SI - Width
;  Registers affected : None
;---------------------------------------------------------------------
EMPTYGLASS		PROC
		PUSH      CX
        PUSH      DX
        PUSH      DI
        PUSH      SI
		
		MOV		AL,0			
		MOV		CX,244
		MOV		DX,234
		MOV		SI,14
		MOV		DI,20
		CALL	DRAWBOX
		CALL	DRAWGLASS
		
		POP       SI
        POP       DI
        POP       DX
        POP       CX
		
		RET
EMPTYGLASS		ENDP



;---------------------------------------------------------------------
;  WATERPOUR
;  Description :     POUR WATER FROM WATER DESPENSER ON FRIDGE
;  Input:        DX - (row)
;                CX - Column
;                DI - Height
;                SI - Width
;  Registers affected : None
;---------------------------------------------------------------------
WATERPOUR      PROC
        PUSH	 CX
        PUSH     DX
        PUSH     DI
        PUSH     SI
		
	
		MOV		 AL,1
		MOV		 CX,247
		MOV		 DX,221
		MOV		 SI,6
		MOV		 DI,5
POURMORE:							;POUR WATER INTO THE GLASS
		CMP		 DI,34
		JA		 FILLGLASS
		CALL	 DRAWBOX
		ADD		 DI,5
		CALL	 DELAY
		JMP 	 POURMORE
		
		
FILLGLASS: 							;WHEN THE WATER REACHS THE BOTTOM 
		ADD		 DX,32				;OF THE GLASS START TO FILL THE GLASS
		SUB		 CX,3
		MOV		 SI,14
		MOV		 DI,1
		
FILLMORE:
		CMP		DI,15
		JE		STOPPOUR
		CALL	DRAWBOX
		INC		DI
		DEC		DX
		CALL	DELAY
		JMP		FILLMORE
		
		

STOPPOUR:							;STOP  POURING WATER
		MOV		 CX,247
		MOV		 DX,221
		MOV		 SI,6
		MOV		 DI,1
		MOV		 Al,0
		
STOPAGAIN:
		CMP      DI,20
		JE		 FINNISHPOUR
		CALL	 DRAWBOX
		INC		 DI
		CALL	 DELAY
		JMP		 STOPAGAIN
		
		
		
FINNISHPOUR:
		CALL 	 DRAWGLASS
		
		POP      SI
        POP      DI
        POP      DX
        POP      CX

        RET     
WATERPOUR        ENDP

;---------------------------------------------------------------------
;  DRAWLIGHT
;  Description :     Write a pixel to the screen
;  Input:        DX - Screen line (row)
;               CX - Column
;               AL - Colour value
;  Registers affected : None
;---------------------------------------------------------------------
DRAWLIGHT      PROC
        PUSH	 CX
        PUSH     DX
        PUSH     DI
        PUSH     SI
		
		MOV		 DX,0			;DRAW LIGHT WIRE
		MOV		 CX,400
		MOV		 AL,15
		MOV		 DI,30
		CALL	 DRAWVLINE
		
		ADD		 DX,30			;LIGHT FRANE
		SUB	 	 CX,10
		MOV	     AL,7
		MOV		 DI,10
		MOV		 SI,22
		CALL	 DRAWBOX
		
		
		
		MOV		 AL,15
		CALL	 DRAWBULB
		
		
		
		
		POP      SI
        POP      DI
        POP      DX
        POP      CX

        RET     
DRAWLIGHT        ENDP

DRAWBULB      PROC
        PUSH	 CX
        PUSH     DX
        PUSH     DI
        PUSH     SI
		
		MOV		 DX,40
		MOV		 CX,383
		MOV		 SI,40
		MOV		 DI,35
		CALL	 DRAWBOX
		
		POP      SI
        POP      DI
        POP      DX
        POP      CX

        RET     
DRAWBULB        ENDP


;---------------------------------------------------------------------
;  DRAWLIGHTSWITCH
;  Description :     Write a pixel to the screen
;  Input:        DX - Screen line (row)
;               CX - Column
;               AL - Colour value
;  Registers affected : None
;---------------------------------------------------------------------
DRAWLIGHTSWITCH      PROC
        PUSH	 CX
        PUSH     DX
        PUSH     DI
        PUSH     SI
		
		MOV		 CX,550
		MOV		 DX,220
		
		MOV		 AL,7			;DRAW CASESING
		MOV		 SI,30
		MOV		 DI,30
		CALL	 DRAWBOX
		
		
		ADD		 CX,12
		ADD		 DX,12
		MOV		 AL,15
		MOV		 SI,5
		MOV		 DI,10
		CALL	 DRAWBOX
		
		POP      SI
        POP      DI
        POP      DX
        POP      CX

        RET     
DRAWLIGHTSWITCH        ENDP

;---------------------------------------------------------------------
;  WRITEPIXEL
;  Description :     Write a pixel to the screen
;  Input:        DX - Screen line (row)
;               CX - Column
;               AL - Colour value
;  Registers affected : None
;---------------------------------------------------------------------
WRITEPIXEL      PROC
        PUSH    AX
        PUSH    BX
        MOV     AH,0CH
        MOV     BH,0
        INT     10H
        POP     BX
        POP     AX

        RET     
WRITEPIXEL        ENDP

;---------------------------------------------------------------------
;DRAWLINE
;  Description :     Draw a horizontal line to the screen
;  Input:        DX - Screen line (row)
;               CX - Column
;               AL - Colour value
;               SI - Length
;  Registers affected : None
;---------------------------------------------------------------------
DRAWHLINE      PROC

        PUSH    CX
        PUSH    SI

AGAIN_DHL:
        CMP     SI,0
        JE      FINISH_DHL
        CALL    WRITEPIXEL
        INC     CX
        DEC     SI
        JMP     AGAIN_DHL

       
FINISH_DHL:
        POP     SI
        POP     CX
       
        RET
DRAWHLINE        ENDP

;---------------------------------------------------------------------
;DRAWVLINE
;  Description :     Draw a horizontal line to the screen
;  Input:       DX - Screen line (row)
;               CX - Column
;               AL - Colour value
;               DI - height
;  Registers affected : None
;---------------------------------------------------------------------
DRAWVLINE      PROC

        PUSH    DX
        PUSH    DI

AGAIN_DVL:
        CMP     DI,0
        JE      FINISH_DVL
        CALL    WRITEPIXEL
        INC     DX
        DEC     DI
        JMP     AGAIN_DVL

       
FINISH_DVL:
        POP     DI
        POP     DX
       
        RET
DRAWVLINE        ENDP



;---------------------------------------------------------------------
;DRAWRIGHTSLOPE
;  Description :     Draw a line that slopes downwords to the right to the screen
;  Input:       DX - Screen line (row)
;               CX - Column
;               AL - Colour value
;               DI - height
;  Registers affected : None
;---------------------------------------------------------------------
DRAWRIGHTSLOPE      PROC

		PUSH      CX
        PUSH      DX
		PUSH	  SI
		
SLOPEAGAIN:
		CMP		  SI,0
		JE		  FINNISHSLOPE
		CALL	  WRITEPIXEL
		DEC		  DX
		SUB		  CX,2
		DEC		  SI
		JMP		  SLOPEAGAIN
		
FINNISHSLOPE:		
		POP		  SI
		POP		  DX
		POP		  CX
       
        RET
DRAWRIGHTSLOPE        ENDP

;--------------------------------------------------------------
;DRAWBOX
;   DRAW A FILLED BOX
;         DX-ROW
;         CX-COLUMN
;         DI-HEIGHT
;         SI - LENGTH
;--------------------------------------------------------------
DRAWBOX      PROC

        PUSH      CX
        PUSH      DX
		PUSH	  DI
		PUSH	  SI
		
DRAWBAGAIN:		

		CMP		DI,0
		JE		FINNISHBOX
		DEC		DI
		INC		DX
		CALL	DRAWHLINE
		JMP		DRAWBAGAIN
		
FINNISHBOX:

		POP		  SI
		POP		  DI
		POP		  DX
		POP		  CX
		
		RET
DRAWBOX        ENDP

;---------------------------------------------------------------------
;DELAY
;  Description :     Delay time loop 
;  Input:        DX - (row)
;                CX - Column
;                AL - Colour value
;                DI - height
;                SI - Length
;  Registers affected : None
;---------------------------------------------------------------------
DELAY      PROC

        PUSH     CX
        PUSH     DX

        MOV     CX,3H

OUTERLOOP:
        DEC     CX
        CMP     CX,0
        JE      FINISH_DELAY
        MOV     DX,0FFFFH

INNERLOOP:
        DEC     DX
        CMP     DX,0
        JE      OUTERLOOP
        JMP     INNERLOOP

FINISH_DELAY:
        POP      DX
        POP      CX
       
        RET
DELAY        ENDP


CSEG    ENDS
        END     MAIN
