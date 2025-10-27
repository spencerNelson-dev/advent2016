package five
import "core:crypto/hash"
import "core:fmt"
import "core:strconv"
import "core:strings"

run :: proc() {
	input := "reyedfim"
	password: [dynamic]byte
	pass_2: [8]byte = 255
	pass_2_found: int
	count: int
	count_buff: [64]byte

	for len(password) < 8 || pass_2_found < 8 {
		num := strconv.itoa(count_buff[:], count)
		test := strings.concatenate({input, num})
		new := hash.hash(hash.Algorithm.Insecure_MD5, test)
		defer delete(new)

		if new[0] == 0 && new[1] == 0 && new[2] < 16 {
			append(&password, new[2])
		}
		if new[0] == 0 && new[1] == 0 && new[2] < 8 {
			if pass_2[new[2]] == 255 {
				pass_2[new[2]] = new[3] / 16
				pass_2_found += 1
			}
		}
		count += 1
	}

	fmt.printfln("%x", password)
	fmt.printfln("%x", pass_2)
}
