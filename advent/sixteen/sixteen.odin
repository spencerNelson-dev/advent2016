#+feature dynamic-literals
package sixteen

import "core:fmt"

dragon_fold :: proc(a: ^[dynamic]int) {
	b := make([]int, len(a))

	for v, i in a {
		n_v: int
		if v == 0 {
			n_v = 1
		}
		b[len(a) - 1 - i] = n_v
	}
	append(a, 0)
	append(a, ..b[:])
}

generate_checksum :: proc(data: []int) -> []int {
	checksum: [dynamic]int
	for i := 0; i < len(data) - 1; i += 2 {
		if data[i] == data[i + 1] {
			append(&checksum, 1)
		} else {
			append(&checksum, 0)
		}
	}
	if len(checksum) % 2 == 0 {
		return generate_checksum(checksum[:])
	}
	return checksum[:]
}


TEST_LENGTH :: 20
LENGTH :: 272
LONG_LENGTH :: 35651584

run :: proc() {
	data: [dynamic]int = {0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1}
	// data: [dynamic]int = {1, 0, 0, 0, 0}
	for len(data) < LONG_LENGTH {
		dragon_fold(&data)
	}

	checksum := generate_checksum(data[:LONG_LENGTH])

	fmt.println(checksum)
}
