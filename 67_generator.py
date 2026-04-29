#!/usr/bin/env python3

def generate_minesweeper_final():
    # Создаем список из 256 байт (числа 0-255)
    field = [0] * 256
    
    for i in range(256):
        if i % 2 == 0:
            field[i] = (6) | (1 << 6)
        else:
            field[i] = (7) | (1 << 6)
            
    with open("num_field.img", "w") as f:
        f.write("v2.0 raw\n")
        for byte in field:
            f.write(f"{byte:02X}\n")
            
    print("Файл 67_field.img успешно сгенерирован в текстовом формате Logisim.")

if __name__ == "__main__":
    generate_minesweeper_final()