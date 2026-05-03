asect 0x00
br main

map: ds 16
cell_ptr: ds 1
mines_left: ds 1

main:
	setsp 0x00
	ei
main_loop:
    wait
    br main_loop


left:
	pushall
	
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
	
	popall
	rti
	
right:
	pushall
	
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
	
	popall
	rti
	
up:
	pushall
	
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
	
	popall
	rti

down:
	pushall
	
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
	
	popall
	rti

open:
	pushall
	ldi r0, cell_ptr
	ld r0, r0
	
	move r0, r1
	shr r1
	shr r1
	
	ldi r2, map
	add r1, r2
	ld r2, r3
	
	ldi r1, 0x03
	and r1, r0
	
	if 
		tst r0
	is ne
		do
			shr r2
			shr r2
			dec r0
		until z
	fi
		
	if
		ldi r0, 1
		and r2, r0	
	is z
		if 
			ldi r0, 2
			and r2, r0
		is z
			br open_display
		else
			br lose
		fi
	else
		popall
		rts
	fi
	
	popall
	rti

flag:
    pushall

    ldi r0, cell_ptr
    ld r0, r0
    move r0, r1
    shr r1
    shr r1
    ldi r2, map
    add r1, r2
    ld r2, r3

    ldi r1, 3
    and r0, r1
    
    ldi r1, 1
    ldi r3, 2
    
    if 
		tst r0
    is ne
        do
            shl r1
            shl r1
            shl r3
            shl r3
            dec r0
        until z
    fi
    
    push r3
    
    ld r2, r3
    xor r1, r3
    st r2, r3
    
    pop r0
    move r3, r1
    and r0, r1
    
    if 
		tst r1
    is ne
        popall
        pushall

        shr r0         
        move r3, r1
        and r0, r1
        
        ldi r2, mines_left
        ld r2, r0
        
        if 
			tst r1
        is ne
            dec r0
			if 
				tst r0
			is z
				br win
			fi
        else
            inc r0
        fi
        st r2, r0
    fi
    
    popall
    rti

reset:
	clr r0
	clr r1
	clr r2
	clr r3
	
	ldi r0, mines_left
	ldi r1, 0x0A
	st r0, r1
	rti
	
load_map: 
	br map
	rti
	
win: wait	

lose: wait

open_display: 
	rti

end