asect 0x00
br main

map: ds 16
cell_ptr: ds 1
mines_left: ds 1

main:
	ei
	wait


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
	rts
	
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
	rts
	
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
	rts

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
	rts

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
			#just open
		else
			#lose logic
		fi
	else
		popall
		rts
	fi
	
	popall
	rts

flag:
    pushall
    
    # 1. Получаем индекс байта и адрес
    ldi r0, cell_ptr
    ld r0, r0
    move r0, r1
    shr r1
    shr r1
    ldi r2, map
    add r1, r2         # r2 = адрес байта
    ld r2, r3          # r3 = значение байта
    
    # 2. Готовим маски (используем стек для хранения маски мины)
    ldi r1, 3
    and r0, r1         # r0 = номер клетки в байте (0-3)
    
    ldi r1, 1          # Маска флага
    ldi r3, 2          # Маска мины (используем r3 временно)
    
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
    
    push r3            # Сохраняем маску мины в стек
    
    # 3. Переключаем флаг
    ld r2, r3          # Снова читаем байт из памяти в r3
    xor r1, r3
    st r2, r3          # Сохраняем обновленный байт
    
    # 4. Проверяем мину
    pop r0             # Достаем маску мины в r0
    move r3, r1        # Копируем байт в r1 для проверки
    and r0, r1         # Проверяем бит мины
    
    if 
		tst r1
    is ne
        # Если мина была, проверяем состояние флага
        popall         # Временно восстанавливаем r1 из pushall для маски флага
        pushall        # Но нам нужен r1, который был маской флага
        # Чтобы не портить стек pushall, лучше пересчитать или сохранить маску флага
        
        # Упростим: перечитаем флаг из r3
        # r3 сейчас содержит байт после XOR, r0 — маска мины
        # Нам нужна маска флага. Она всегда r0 >> 1
        shr r0         
        move r3, r1
        and r0, r1     # r1 теперь содержит только бит флага
        
        ldi r2, mines_left
        ld r2, r0      # r0 = количество мин
        
        if 
			tst r1
        is ne
            dec r0     # Флаг поставлен на мину
        else
            inc r0     # Флаг снят с мины
        fi
        st r2, r0
    fi
    
    popall
    rts
reset:
	clr r0
	clr r1
	clr r2
	clr r3
	
	ldi r0, mines_left
	ldi r1, 0x0A
	st r0, r1
	
load_map:
	ldi r0, cell_ptr

end