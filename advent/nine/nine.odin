package nine

import "../shared"
import "core:fmt"
import "core:strconv"
import "core:strings"

run :: proc() {
	input_path := "D:\\learn\\odin\\fun\\advent\\input\\nine.txt"
	input, _ := shared.read_input(input_path)
	// input = "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN"
	// input = "(3x3)XYZ"
	// input = "X(8x2)(3x3)ABCY"
	// input = "(27x12)(20x12)(13x14)(7x10)(1x12)A"

	output := get_decompressed_string(input)
	fmt.println(len(output))

	test := get_double_length(input)
	fmt.println("extended", test)
}

get_decompressed_string :: proc(input: string) -> (output: string) {
	builder := strings.builder_make()

	resume_index := 0

	for r, i in input {
		if i < resume_index {
			continue
		}
		if r == '(' {
			close_index := strings.index(input[i:], ")") + i
			com_info := input[i + 1:close_index]
			parts := strings.split(com_info, "x")
			after := strconv.atoi(parts[0])
			times := strconv.atoi(parts[1])
			repeated_string := input[close_index + 1:close_index + 1 + after]
			resume_index = close_index + 1 + after
			for x in 0 ..< times {
				strings.write_string(&builder, repeated_string)
			}

		} else {
			strings.write_rune(&builder, r)
		}
	}
	output = strings.to_string(builder)
	return
}

// input = "(27x12)(20x12)(13x14)(7x10)(1x12)A"
get_double_length :: proc(input: string) -> (length: int) {
	resume_index := 0
	for r, i in input {
		if i < resume_index {
			continue
		}
		if r == '(' {
			close := strings.index(input[i:], ")") + i
			com_info := input[i + 1:close]
			after, times := get_parts(com_info)

			inner := input[close + 1:close + 1 + after]
			l := get_double_length(inner)
			length += times * l
			resume_index = close + 1 + after
		} else {
			length += 1
		}
	}
	return
}

get_parts :: proc(com_info: string) -> (length, repeat: int) {
	parts := strings.split(com_info, "x")
	length = strconv.atoi(parts[0])
	repeat = strconv.atoi(parts[1])
	return
}
