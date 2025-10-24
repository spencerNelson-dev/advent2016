package one

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

run :: proc() {
	input_path := "D:\\learn\\odin\\fun\\advent\\input\\one.txt"
	input, _ := read_input(input_path)
	instructions := strings.split(input, " ")

	location: [2]int
	direction: Direction = .North

	for i in instructions {
		turn: Turn
		if i[0] == 'L' {turn = .L}
		direction = change_direction(direction, turn)

		amount := i[1]

		fmt.println(instructions)
		fmt.println(turn, amount, i)

		// switch direction {
		// case .North:
		// 	location.y = location.y + amount

		// }

	}
}

Direction :: enum {
	North,
	East,
	South,
	West,
}

Turn :: enum {
	R,
	L,
}

change_direction :: proc(init: Direction, turn: Turn) -> Direction {
	switch init {
	case .North:
		if turn == .R {return .East} else {return .West}
	case .East:
		if turn == .R {return .South} else {return .North}
	case .South:
		if turn == .R {return .West} else {return .East}
	case .West:
		if turn == .R {return .North} else {return .South}
	}
	return init
}

read_input :: proc(filepath: string) -> (string, bool) {
	data, ok := os.read_entire_file_from_filename(filepath)
	if !ok {
		return "", ok
	}
	return string(data), true
}
