package six

import "../shared"
import "core:fmt"
import "core:strings"

run :: proc() {
	fmt.println("Six")
	input_path := "D:\\learn\\odin\\fun\\advent\\input\\six.txt"
	input, _ := shared.read_input(input_path)

	lines := strings.split_lines(input)
	counts: [8][26]int
	most: [dynamic]rune
	least: [dynamic]rune


	for l in lines {
		for c, i in l {
			place := c - 'a'
			counts[i][place] += 1
		}
	}

	// fmt.println(counts)

	for l in counts {
		max := 0
		min := 0
		for n, i in l {
			if l[i] > l[max] do max = i
			if l[i] < l[min] do min = i
		}
		append(&most, rune('a' + max))
		append(&least, rune('a' + min))
	}

	fmt.print(most, least)
}
