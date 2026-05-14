asect 0x00
br main 	

cursor: ds 1
mines: ds 1
map: ds 1

main:
	setsp 0xf0
	ei
	jsr reset
main_loop:
	wait
	br main_loop


left:
	ldi r2, cursor
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
	ldi r2, cursor
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
	ldi r2, cursor
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
	ldi r2, cursor
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
set_cells_data:
	ldi r2, cursor
	ld r2, r1
	push r1
	
	shra r1
	shra r1
	
	ldi r2, map
	add r1, r2
	
	ld r2, r0
	
	pop r1
	
	rts
	
#args:
#r1 - cell num

#result
#r0 - corrapted
#r2 - flag mask
#r3 - mine mask
get_cell_masks:	
	ldi r0, 0x03

	ldi r2, 0b10000000
	ldi r3, 0b01000000	

	and r1, r0
	
	while
		tst r0
	stays ne
		shr r3
		shr r3
		
		shr r2
		shr r2
		
		dec r0
	wend
	
	rts
	

open:
	jsr set_cells_data
	push r0
	jsr get_cell_masks
	pop r0
	
	if
		and r0, r2
	is ne
		rti
	fi
	
	if 
		and r0, r3
	is ne
		br lose
	fi
	
	rti

flag:	
	jsr set_cells_data
	push r2 	#addr
	push r0		#data
	jsr get_cell_masks
	#r2 - flag
	#r3 - mine
	ldi r1, mines
	ld r1, r1
	
	if 
		ldi r0, 0b11110000
		and r1, r0
		is z
		pop r0
		push r0
		and r3, r0
		is ne
	then 
		pop r0
		pop r0
		rti
	fi
	
	pop r0
	xor r2, r0
	pop r1
	st r1, r0
	
	if
		and r0, r2
	is z 		#remove flag
		ldi r1, 0x01
		
		if
			and r0, r3
		is ne 	#is mine
			ldi r2, 0x01
		else
			ldi r2, 0x00
		fi
	else		#put flag
		ldi r1, 0xff
		if 
			and r0, r3
		is ne	#is mine
			
			if
				ldi r3, mines
				ld r3, r3
				ldi r2, 0x0f
				and r3, r2
			is z
				br win
			fi
				
			ldi r2, 0xff
		else
			ldi r2, 0x00
		fi
	fi
	
    ldi r3, mines
    ld r3, r0        # r0 = [ФЛАГИ|МИНЫ]

    # 1. Обновляем МИНЫ (биты 0-3)
    move r0, r3      # Копируем оригинал
    add r2, r3       # Складываем (может задеть биты 4-7, это не страшно)
    ldi r2, 0x0F     # Маска младшей тетрады
    and r2, r3       # r3 = [0000|новые_мины]. Теперь старшие биты чисты.

    # 2. Обновляем ФЛАГИ (биты 4-7)
    add r1, r0       # Складываем дельту флагов с оригиналом
    ldi r1, 0xF0     # Маска старшей тетрады
    and r1, r0       # r0 = [новые_флаги|0000]. Теперь младшие биты чисты.

    # 3. Склеиваем результат
    or r3, r0        # Объединяем оба поля
    ldi r3, mines
    st r3, r0        # Сохраняем в память		
    rti

reset:
	ldi r0, mines
	ldi r1, 0xAA
	st r0, r1
	rts
	
win: halt
lose: halt

	
asect 0xf0
dc left, 0x00		#0x00
dc right, 0x00		#0x01
dc up, 0x00			#0x02
dc down, 0x00		#0x03
dc open, 0x00		#0x04
dc flag, 0x00		#0x05
dc reset, 0x00		#0x06

end.