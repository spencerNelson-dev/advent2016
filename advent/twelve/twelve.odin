package twelve

import "../shared"
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"


reg: map[string]int

run :: proc() {
	fmt.println("twelve")
	buf: [10]byte
	input_path := "D:\\learn\\odin\\fun\\advent\\input\\twelve.txt"
	input, _ := shared.read_input(input_path)

	lines := strings.split_lines(input)
	// lines = []string{"cpy 41 a", "inc a", "inc a", "dec a", "jnz a 2", "dec a"}

	reg["a"] = 0
	reg["b"] = 0
	reg["c"] = 1
	reg["d"] = 0

	for pp := 0; pp < len(lines); {
		inst := lines[pp]
		// fmt.println(pp, inst)
		parts := strings.split(inst, " ")
		switch parts[0] {
		case "cpy":
			f := parts[1]
			s := parts[2]
			if strconv.atoi(f) != 0 {
				reg[s] = strconv.atoi(f)
			} else {
				reg[s] = reg[f]
			}
			pp += 1
		case "inc":
			r := parts[1]
			reg[r] += 1
			pp += 1
		case "dec":
			r := parts[1]
			reg[r] -= 1
			pp += 1
		case "jnz":
			f := parts[1]
			s := parts[2]
			n := strconv.atoi(f)
			// fmt.println(f, s, n)
			// fmt.println(reg)
			if n != 0 {
				pp += strconv.atoi(s)
			} else {
				n = reg[f]
				if n != 0 {
					pp += strconv.atoi(s)
				} else {
					pp += 1
				}
			}
		}
		// bytes_read, _ := os.read(os.stdin, buf[:])
	}
	fmt.println(reg)
}
