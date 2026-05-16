#!/usr/bin/env python3

def generate_minesweeper_final():
    # Создаем список из 256 байт (числа 0-255)
    field = [(1 << 3) | (1 << 6)] * 256
            
    with open("mine_field.img", "w") as f:
        f.write("v2.0 raw\n")
        for byte in field:
            f.write(f"{byte:02X}\n")
            
    print("Файл mine_field.img успешно сгенерирован в текстовом формате Logisim.")

if __name__ == "__main__":
    generate_minesweeper_final()