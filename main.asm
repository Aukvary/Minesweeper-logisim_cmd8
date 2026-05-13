asect 0x00
br main 	

map: ds 1
cell_ptr: ds 1
mines_left: ds 1

main:
	setsp 0xf0
	ei
	jsr reset
main_loop:
	wait
	br main_loop


left:
	ldi r2, cell_ptr
	ld r2, r0
	
	if 
		ldi r1, 0x07
		and r0, r1
	is z
		ldi r1, 0x07
		add r1, r0
	else
		dec r0
	fi
	
	st r2, r0
	
	rti
	
right:	
	ldi r2, cell_ptr
	ld r2, r0
	
	if 
		ldi r1, 0x07
		ld r2, r3
		inc r3
		and r1, r3
	is z
		neg r1
		add r1, r0
	else
		inc r0
	fi
	
	st r2, r0
	rti
	
up:
	ldi r2, cell_ptr
	ld r2, r0
	
	if 
		ldi r1, 0x08
		cmp r0, r1
	is lt
		ldi r1, 56
		add r1, r0
	else
		ldi r1, 0x08
		sub r0, r1
		move r1, r0
	fi
	
	st r2, r0
	rti

down:
	ldi r2, cell_ptr
	ld r2, r0
	
	if 
		ldi r1, 56
		cmp r0, r1
	is ge
		ldi r1, 56
		sub r0, r1
		move r1, r0
	else
		ldi r1, 0x08
		add r1, r0
	fi
	
	st r2, r0
	rti

# r0 - chunk data
# r1 - cell num
# r2 - chunk addr
get_map_cell:
	ldi r2, cell_ptr
	ld r2, r1
	
	shr r1
	shr r1
	
	ldi r0, map
	add r1, r0
	move r0, r2
	ld r0, r0
	
	rts
	

open:
	ldi r3, 0x03
	and r1, r3
	
	while 
		tst r2
	stays ne
		shr r0
		shr r0
		dec r3
	wend
	
	ldi r3, 0x02
	
	if
		and r0, r3
	is ne
		rti
	fi
	
	ldi r3, 0x01
	
	if 
		and r0, r3
	is ne
		br lose
	fi
	
	rti

flag:
	jsr get_map_cell
	push r2		#addr
	push r0		#data
	
	ldi r0, 0x01
	ldi r2, 0x02
	ldi r3, 0x03
	
	and r1, r3
	
	while
		tst r3
	stays ne
		shl r0
		shl r0
		
		shl r2
		shl r2
		
		dec r3
	wend
	
	if
		ldi r1, mines_left
		ld r1, r1
		ldi r3, 0b11110000
		and r1, r3
		is z
		pop r3
		push r3
		
		and r3, r2
		is z
	then
		rti
	fi
	
	pop r3
	push r0
	xor r2, r3
	
	
	
    rti

reset:
	ldi r0, mines_left
	ldi r1, 0x0A
	st r0, r1
	rts
	
win: halt

lose: halt

open_display: 
	rti
	
asect 0xf0
dc left, 0x00
dc right, 0x00
dc up, 0x00
dc down, 0x00
dc open, 0x00
dc flag, 0x00
dc reset, 0x00

end.