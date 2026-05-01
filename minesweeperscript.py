import random

class Grid:
    def __init__(self, m, n, initial=0):
        if m <= 0 or n <= 0:
            raise ValueError('Grid size cannot be smaller than 1')
        self.grid = [[initial for r in range(n)] for c in range(m)]
        self.num_columns = m
        self.num_rows = n

    def __call__(self, x, y):
        return self.grid[x][y]

    def set(self, x, y, value):
        self.grid[x][y] = value

    def neighbors(self, x, y):
        for a in range(max(x-1, 0), min(x+2, self.num_columns)):
            for b in range(max(y-1, 0), min(y+2, self.num_rows)):
                if a != x or b != y:
                    yield (a, b)


def is_mine(value):
    return value == -1


def hint(mines, x, y):
    if is_mine(mines(x, y)):
        return mines(x, y)
    else:
        h = 0
        for a, b in mines.neighbors(x, y):
            if mines(a, b) == -1:
                h += 1
        return h


def generate_minefield(m, n, numMines):
    grid = Grid(m, n)
    fields = [(c, r) for r in range(grid.num_rows) for c in range(grid.num_columns)]
    
    #  мины
    for x, y in random.sample(fields, numMines):
        grid.set(x, y, -1)
    
    # числа
    for x, y in fields:
        grid.set(x, y, hint(grid, x, y))
    
    return grid


def pack_cell(value):
    if is_mine(value):
        return 0x08  # 8 = мина
    else:
        return value  # 0-8


def field_to_bytes(grid):

    result = []
    for y in range(grid.num_rows):
        for x in range(grid.num_columns):
            result.append(pack_cell(grid(x, y)))
    return result


def save_cards_to_img(cards, filename):

    with open(filename, 'w', encoding='utf-8') as f:
        f.write("v2.0 raw\n")
        
        for card_num, card_bytes in enumerate(cards, 1):
            f.write(f"\n#card{card_num}\n")
            
            for byte in card_bytes:
                f.write(f"{byte:02X}\n")
    
    total_bytes = sum(len(card) for card in cards)


def print_card(card_bytes, width=8, height=8, card_num=None):

    if card_num:
        print(f"\n карта {card_num}:")
    
    print("   " + " ".join(f"{i:2}" for i in range(width)))
    for y in range(height):
        row = f"{y:2} "
        for x in range(width):
            idx = y * width + x
            val = card_bytes[idx]
            if val == 8:
                row += "  ●"
            elif val == 0:
                row += "  ·"
            else:
                row += f"  {val}"
        print(row)

FIELD_WIDTH = 8
FIELD_HEIGHT = 8
MINES_COUNT = 10
NUM_CARDS = 4

OUTPUT_FILENAME = "minesweeper_4.img"

all_cards = []
for i in range(NUM_CARDS):
    field = generate_minefield(FIELD_WIDTH, FIELD_HEIGHT, MINES_COUNT)
    card_bytes = field_to_bytes(field)
    all_cards.append(card_bytes)
    print_card(card_bytes, card_num=i+1)

save_cards_to_img(all_cards, OUTPUT_FILENAME)
