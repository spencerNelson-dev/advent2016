package three

import "../shared"
import "core:fmt"
import "core:strconv"
import "core:strings"

run :: proc() {
	input_path := "D:\\learn\\odin\\fun\\advent\\input\\three.txt"
	input, _ := shared.read_input(input_path)

	triangles := strings.split_lines(input)

	first(triangles)
	second(triangles)
}

second :: proc(triangles: []string) {
	correct_count := 0
	l_index: [3]int
	tri_nums: [3][3]int

	pos := 0
	counter := 0
	for t in triangles {
		tri := strings.split(t, " ")
		index_offset := 0
		for l, i in tri {
			if l == "" {
				index_offset += 1
				continue
			}

			tri_nums[i - index_offset][pos] = strconv.atoi(l)
			if i >= index_offset &&
			   tri_nums[i - index_offset][pos] >
				   tri_nums[i - index_offset][l_index[i - index_offset]] {
				l_index[i - index_offset] = pos
			}
			counter += 1
			if counter > 0 && counter % 3 == 0 {
				pos += 1
			}
			if pos > 2 {

				counter = 0
				pos = 0
				// fmt.println(tri_nums, l_index)
				for j := 0; j < 3; j += 1 {
					if check_tri(tri_nums[j], l_index[j]) do correct_count += 1
				}
				l_index = 0
			}
		}
	}
	fmt.println("Second Correct Tri: ", correct_count)
}

first :: proc(triangles: []string) {
	correct_count := 0

	for t in triangles {

		tri := strings.split(t, " ")
		largest_index := 0
		index_offset := 0
		tri_nums: [3]int
		for l, i in tri {
			if l == "" {
				index_offset += 1
				continue
			}
			tri_nums[i - index_offset] = strconv.atoi(l)
			if i > index_offset && tri_nums[i - index_offset] > tri_nums[largest_index] {
				largest_index = i - index_offset
			}
		}

		switch largest_index {
		case 0:
			if tri_nums[1] + tri_nums[2] > tri_nums[0] do correct_count += 1
		case 1:
			if tri_nums[0] + tri_nums[2] > tri_nums[1] do correct_count += 1
		case 2:
			if tri_nums[0] + tri_nums[1] > tri_nums[2] do correct_count += 1
		}


		largest_index = 0
		index_offset = 0
	}


	fmt.println("First Correct Tri: ", correct_count)

}

check_tri :: proc(tri_nums: [3]int, largest_index: int) -> bool {
	switch largest_index {
	case 0:
		if tri_nums[1] + tri_nums[2] > tri_nums[0] do return true
	case 1:
		if tri_nums[0] + tri_nums[2] > tri_nums[1] do return true
	case 2:
		if tri_nums[0] + tri_nums[1] > tri_nums[2] do return true
	}
	return false
}
