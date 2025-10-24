package one

import "../shared"
import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"

run :: proc() {
	input_path := "D:\\learn\\odin\\fun\\advent\\input\\one.txt"
	input, _ := shared.read_input(input_path)
	// input = "R8, R4, R4, R8"
	instructions := strings.split(input, ", ")
	location: [2]int
	direction: Direction = .North
	locations: [dynamic][2]int
	append(&locations, [2]int{0, 0})

	for i in instructions {
		turn: Turn
		if i[0] == 'L' {turn = .L}
		direction = change_direction(direction, turn)

		amount, _ := strconv.parse_int(strings.cut(i, 1))

		switch direction {
		case .North:
			location.y = location.y + amount
		case .East:
			location.x = location.x + amount
		case .South:
			location.y = location.y - amount
		case .West:
			location.x = location.x - amount

		}
		append(&locations, location)

		last_line: [2][2]int
		loc_len := len(locations)
		if len(locations) >= 2 {
			last_line = {locations[loc_len - 2], locations[loc_len - 1]}
		}
		// fmt.println("last line:", last_line)

		if len(locations) >= 3 {
			for i := 0; i < len(locations) - 2; i = i + 1 {
				current_line: [2][2]int = {locations[i], locations[i + 1]}
				if lines_cross(current_line, last_line) {
					fmt.printfln("line: %v -> %v", current_line, last_line)
				}
			}
		}
	}
	fmt.println(locations)
	fmt.println("Location:", location)
	fmt.println("Distance from start: ", math.abs(location.x) + math.abs(location.y))
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

find_cross_point :: proc(a: [2][2]int, b: [2][2]int) -> [2]int {
	return {0, 0}
}

lines_cross :: proc(first: [2][2]int, last: [2][2]int) -> bool {
	if first[1] == last[0] {
		return false
	}

	// first line is horizontal
	if first[0].x != first[1].x {
		min := first[0].x
		max := first[1].x
		if in_range(min, max, last[0].x) || in_range(min, max, last[1].x) {
			if first[0].y == last[0].y {
				return true
			}
			if in_range(last[0].y, last[1].y, first[0].y) {
				fmt.println("cross point: ", first[0].y, last[0].x)
				fmt.println("dist", math.abs(first[0].y) + math.abs(last[0].x))
				return true
			}
		}
	}
	return false
}

in_range :: proc(min: int, max: int, value: int) -> bool {
	loc_min := min
	loc_max := max
	if min > max {
		loc_min = max
		loc_max = min
	}
	if value >= loc_min && value <= loc_max {
		return true
	}

	return false
}
