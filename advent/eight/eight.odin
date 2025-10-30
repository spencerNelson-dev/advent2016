package eight

import "../shared"
import "core:fmt"
import "core:strconv"
import "core:strings"

WIDTH :: 50
HEIGHT :: 6
GRID: [HEIGHT][WIDTH]byte

run :: proc() {
	input_path := "D:\\learn\\odin\\fun\\advent\\input\\eight.txt"
	input, _ := shared.read_input(input_path)

	lines := strings.split_lines(input)
	// lines = {"rect 3x3", "rotate row y=0 by 2", "rotate column x=1 by 5"}

	for l in lines {
		parts := strings.split(l, " ")

		if parts[0] == "rect" {
			draw_rect(parts[1])
		} else {
			rotate(parts[1:])
		}
	}

	print_grid()
	fmt.println("count: ", count_grid())
}

draw_rect :: proc(dimentions: string) {
	parts := strings.split(dimentions, "x")
	width := strconv.atoi(parts[0])
	height := strconv.atoi(parts[1])

	for y := 0; y < height; y += 1 {
		for x := 0; x < width; x += 1 {
			GRID[y][x] = 219
		}
	}

}

rotate :: proc(instructions: []string) {
	if instructions[0] == "row" {
		new_row: [WIDTH]byte
		row := strconv.atoi(strings.split(instructions[1], "=")[1])
		by := strconv.atoi(instructions[3])
		for x := 0; x < WIDTH - by; x += 1 {
			new_row[x + by] = GRID[row][x]
		}
		for x := WIDTH - by; x < WIDTH; x += 1 {
			new_row[x - (WIDTH - by)] = GRID[row][x]
		}
		GRID[row] = new_row
	} else {
		new_col: [HEIGHT]byte
		col := strconv.atoi(strings.split(instructions[1], "=")[1])
		by := strconv.atoi(instructions[3])
		for y := 0; y < HEIGHT - by; y += 1 {
			new_col[y + by] = GRID[y][col]
		}
		for y := HEIGHT - by; y < HEIGHT; y += 1 {
			new_col[y - (HEIGHT - by)] = GRID[y][col]
		}


		for y := 0; y < HEIGHT; y += 1 {
			GRID[y][col] = new_col[y]
		}
	}
}

print_grid :: proc() {

	for y := 0; y < HEIGHT; y += 1 {
		for x := 0; x < WIDTH; x += 1 {
			if GRID[y][x] > 0 {
				fmt.print('|')
			} else {
				fmt.print(' ')
			}
		}
		fmt.print("\n")
	}

	// for x := 0; x < 1000; x += 1 {
	// 	fmt.println(x, rune(x))
	// }
}

count_grid :: proc() -> (count: int) {
	for y := 0; y < HEIGHT; y += 1 {
		for x := 0; x < WIDTH; x += 1 {
			if GRID[y][x] > 0 {
				count += 1
			}
		}
	}
	return
}
