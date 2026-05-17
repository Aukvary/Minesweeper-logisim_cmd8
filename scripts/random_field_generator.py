#!/usr/bin/env python3
import random

def generate_real_field():
    # Настройки
    WIDTH = 8
    HEIGHT = 8
    MINE_COUNT = 10  # Количество мин на поле
    TOTAL_SIZE = 256
    
    # 1. Создаем пустое поле (матрица 8x8)
    # Храним просто True (мина) или False (пусто)
    matrix = [[False for _ in range(WIDTH)] for _ in range(HEIGHT)]
    
    # 2. Случайным образом расставляем мины
    mines_placed = 0
    while mines_placed < MINE_COUNT:
        x = random.randint(0, WIDTH - 1)
        y = random.randint(0, HEIGHT - 1)
        if not matrix[y][x]:
            matrix[y][x] = True
            mines_placed += 1
            
    # 3. Формируем байты для Logisim
    field = [0] * TOTAL_SIZE
    
    for y in range(HEIGHT):
        for x in range(WIDTH):
            byte = 0
            
            if matrix[y][x]:
                # Устанавливаем бит 3 (мина)
                byte |= (1 << 3)
            else:
                # Считаем мины вокруг для пустой клетки
                count = 0
                for dy in [-1, 0, 1]:
                    for dx in [-1, 0, 1]:
                        ny, nx = y + dy, x + dx
                        if 0 <= ny < HEIGHT and 0 <= nx < WIDTH:
                            if matrix[ny][nx]:
                                count += 1
                # Записываем количество в биты 0-2
                byte |= (count & 0x07)
            
            # Устанавливаем бит 6 (клетка открыта), чтобы всё было видно
            #byte |= (1 << 6)
            
            # Сохраняем в линейный массив (первые 64 байта)
            field[y * WIDTH + x] = byte

    # 4. Дублируем это же поле в остальные 3 сегмента (как в твоем примере)
    for m in range(1, 4):
        offset = m * 64
        for i in range(64):
            field[offset + i] = field[i]

    # 5. Записываем в файл
    with open(f'./../fields/field_{random.randint(0, 1000)}.img', "w") as f:
        f.write("v2.0 raw\n")
        for b in field:
            f.write(f"{b:02X}\n")
            
    print("Файл real_field.img успешно сгенерирован со случайным полем.")

if __name__ == "__main__":
    generate_real_field()