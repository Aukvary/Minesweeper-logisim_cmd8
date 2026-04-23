#!/usr/bin/env python3

def generate_minesweeper_final():
    # Создаем список из 256 байт (числа 0-255)
    field = [0] * 256
    
    for m in range(4):
        offset = m * 64
        # 1. Цифры от 0 до 7 (клетки 0-7, открыты - бит 6)
        for i in range(8):
            field[offset + i] = i | (1 << 6)
            
        # 2. Цифры от 0 до 7, выбраны (клетки 8-15, бит 5 и 6)
        for i in range(8):
            field[offset + 8 + i] = i | (1 << 5) | (1 << 6)
            
        # 3. Мина (клетка 16, открыта)
        field[offset + 16] = (1 << 3) | (1 << 6)
        
        # 4. Выбранная мина (клетка 17, открыта)
        field[offset + 17] = (1 << 3) | (1 << 5) | (1 << 6)
        
        # 5. Флаг (клетка 18, закрыта)
        field[offset + 18] = (1 << 4)
        
        # 6. Выбранный флаг (клетка 19, закрыта)
        field[offset + 19] = (1 << 4) | (1 << 5)
    
        # 7. Чередование до конца поля сапера (клетки 20-63)
        for i in range(20, 64):
            if i % 2 == 0:
                field[offset + i] = (1 << 5) # Открытая
            else:
                field[offset + i] = 0        # Закрытая
            
    # Записываем в формате Logisim v2.0 raw (как в твоем main.img)
    with open("test_field.img", "w") as f:
        f.write("v2.0 raw\n")
        for byte in field:
            # Записываем HEX значение заглавными буквами и перенос строки
            f.write(f"{byte:02X}\n")
            
    print("Файл test_field.img успешно сгенерирован в текстовом формате Logisim.")

if __name__ == "__main__":
    generate_minesweeper_final()