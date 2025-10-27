package four

import "../shared"
import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:unicode/utf8"

run :: proc() {
	fmt.println("four")
	input_path := "D:\\learn\\odin\\fun\\advent\\input\\four.txt"
	input, _ := shared.read_input(input_path)
	total: int

	rooms := strings.split_lines(input)
	// rooms = {
	// 	"aaaaa-bbb-z-y-x-123[abxyz]",
	// 	"a-b-c-d-e-f-g-h-987[abcde]",
	// 	"not-a-real-room-404[oarel]",
	// 	"totally-real-room-200[decoy]",
	// }
	//
	// rooms = {"qzmt-zixmtkozy-ivhz-343"}

	for r in rooms {
		letter_frequency: map[rune]int
		sector: [dynamic]rune
		check: [dynamic]rune
		check_mode := false
		is_valid := true
		for c, i in r {
			if c == '-' || c == ']' {
				continue
			}
			if c == '[' {
				// fmt.println(letter_frequency)
				check_mode = true
				continue
			}
			if c >= '0' && c <= '9' {
				append(&sector, c)
				continue
			}
			if check_mode {
				append(&check, c)
				if c in letter_frequency {
					c_next := rune(r[i + 1])
					if letter_frequency[c] < letter_frequency[c_next] {
						// fmt.println("false because out of order", c, c_next)
						is_valid = false
					} else if letter_frequency[c] == letter_frequency[c_next] {
						if c > c_next {
							// fmt.println("false because not alphebetical", c, c_next)
							is_valid = false
						}
					}
					delete_key(&letter_frequency, c)
				} else {
					is_valid = false
					// fmt.println("false because not in name", c)
				}
			} else {
				if c in letter_frequency {
					letter_frequency[c] += 1
				} else {
					letter_frequency[c] = 1
				}

			}
		}
		if is_valid {
			// fmt.println(letter_frequency)
			// fmt.println(sector)
			// fmt.println(check)
			a := int(sector[0] - '0') * 100
			b := int(sector[1] - '0') * 10
			c := int(sector[2] - '0')
			total += (a + b + c)
			break_code(r, a + b + c)
		}
	}
	fmt.println(total)
}

break_code :: proc(room: string, sector_id: int) {
	rotate := sector_id % 26
	new: [dynamic]rune
	for c in room {
		if c >= 'a' && c <= 'z' {
			next := int(c) + rotate
			if next > 'z' do next = next - 26
			n := rune(next)
			append(&new, n)
		}
		if c == '-' {
			append(&new, ' ')
		}
		if c == '[' {
			break
		}
	}
	cracked := utf8.runes_to_string(new[:])
	if strings.contains(cracked, "north") {
		fmt.println(cracked, sector_id)
	}
}
