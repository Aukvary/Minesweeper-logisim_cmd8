#!/usr/bin/env python3
import random

def generate_real_field(idx: int):
    WIDTH = 8
    HEIGHT = 8
    MINE_COUNT = 10
    TOTAL_SIZE = 256
    
    field = [0] * TOTAL_SIZE
    
    for m in range(4):
        offset = m * 64
        matrix = [[False for _ in range(WIDTH)] for _ in range(HEIGHT)]
        
        mines_placed = 0
        while mines_placed < MINE_COUNT:
            x = random.randint(0, WIDTH - 1)
            y = random.randint(0, HEIGHT - 1)
            if not matrix[y][x]:
                matrix[y][x] = True
                mines_placed += 1
                
        for y in range(HEIGHT):
            for x in range(WIDTH):
                byte = 0
                
                if matrix[y][x]:
                    byte |= (1 << 3)
                else:
                    count = 0
                    for dy in [-1, 0, 1]:
                        for dx in [-1, 0, 1]:
                            ny, nx = y + dy, x + dx
                            if 0 <= ny < HEIGHT and 0 <= nx < WIDTH:
                                if matrix[ny][nx]:
                                    count += 1
                    byte |= (count & 0x07)
                
                field[offset + (y * WIDTH + x)] = byte

    with open(f'./../fields/field_{idx}.img', "w") as f:
        f.write("v2.0 raw\n")
        for m in range(4):
            for i in range(8):
                row_bytes = []
                for j in range(8):
                    row_bytes.append(f"{field[m * 64 + i * 8 + j]:02X}")
                f.write(" ".join(row_bytes) + "\n")
            f.write('\n')
            
    print(f"Файл field_{idx}.img успешно сгенерирован с 4 разными картами.")

if __name__ == "__main__":
    for i in range(8):
        generate_real_field(i)