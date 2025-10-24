package four

import "../shared"
import "core:fmt"
import "core:strings"

run :: proc() {
	fmt.println("four")
	input_path := "D:\\learn\\odin\\fun\\advent\\input\\four.txt"
	input, _ := shared.read_input(input_path)

	letter_frequency: map[rune]int

	rooms := strings.split_lines(input)

	for r in rooms[:1] {
		r_parts := strings.split(r, "[")
		fmt.println(r_parts)
		for l in r_parts[0] {
			if l == '-' {
				continue
			}
			if l >= '0' && l <= '9' {
				continue
			}
			if l in letter_frequency {
				letter_frequency[l] += 1
			} else {
				letter_frequency[l] = 1
			}
		}

		fmt.println(letter_frequency)
		fmt.println(r_parts[1][:len(r_parts[1]) - 1])

		sorted := make([]int, len(letter_frequency))
	}


}
