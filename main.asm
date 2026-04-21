asect 0x00
main:
    ldi r0, 0xff
    stsp r0
    ei
loop: 
    wait 
    br loop


asect 0x24
    vector2: dc 0xc0    

asect 0xc0
irq_handler:
    pushall
    
    popall
    rti

end