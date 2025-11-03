package fourteen

import "core:crypto/hash"
import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

INPUT :: "ngcjuoqr"
// INPUT :: "abc"
Valid :: enum {
	Unknown,
	Yes,
	No,
}

Key :: struct {
	index: int,
	hash:  string,
	r:     u8,
	valid: Valid,
	v_num: int,
}

bytes_to_hex_string :: proc(bytes: []byte) -> string {
	builder := strings.builder_make()
	for byte_val in bytes {
		fmt.sbprintf(&builder, "%02x", byte_val)
	}
	return strings.to_string(builder)
}

is_key_contender :: proc(s: string) -> (bool, u8) {
	for j := 0; j < len(s) - 2; j += 1 {
		if s[j] == s[j + 1] && s[j] == s[j + 2] {
			return true, s[j]
		}
	}
	return false, 0
}

is_key_validator :: proc(s: string) -> (bool, u8) {
	for j := 0; j < len(s) - 4; j += 1 {
		if s[j] == s[j + 1] && s[j] == s[j + 2] && s[j] == s[j + 3] && s[j] == s[j + 4] {
			return true, s[j]
		}
	}
	return false, 0
}


key_exists :: proc(list: ^[dynamic]int, t: int)-> bool {
	for l in list {
		if l == t {
			return true
		}
	}
	return false
}

run :: proc() {
	buf: [64]byte

	contenders: [dynamic]Key
	valid_indexes: [dynamic]int
	i: int
	v: int
	main: for v < 65 {
		{
			num := strconv.itoa(buf[:], i)
			salt := strings.concatenate({INPUT, num})
			bytes := hash.hash(hash.Algorithm.Insecure_MD5, salt)
			defer delete(bytes)
			s: string
			for x in 0..< 2016{
				s = bytes_to_hex_string(bytes)
				bytes = hash.hash(hash.Algorithm.Insecure_MD5, s)
					
			}
			
			s = bytes_to_hex_string(bytes)
			// buf: [64]byte
			// fmt.println(s)
			// bytes_read, _ := os.read(os.stdin, buf[:])

			if test, r := is_key_contender(s); test {
				// fmt.println(i, "is a contender")
				key := Key {
					index = i,
					hash  = s,
					r     = r,
				}
				append(&contenders, key)
			}
			if test, r := is_key_validator(s); test {
				// fmt.println(i, s)
				for &c in contenders {

					if c.r == r && i < c.index + 1000 && c.index != i {
						buf: [64]byte
						fmt.println(i, s, r)
						fmt.println(v, c.index, c.hash, c.r, salt)
						bytes_read, _ := os.read(os.stdin, buf[:])

						c.valid = .Yes
						if !key_exists(&valid_indexes, c.index){
						append(&valid_indexes, c.index)
						v += 1
							if v > 63 {
								break main
							}
							
						}
					}
				}
			}
			fmt.print(i, len(valid_indexes), "\r")
			i += 1
		}
	}
	fmt.print("\n")
	slice.sort(valid_indexes[:])
	// fmt.println(len(valid_indexes))
	// fmt.println(valid_indexes)
	fmt.println(valid_indexes[63])
	fmt.println("example abc expect: 22551")
}

// 14651, 14833 -- too low
// part 2 - 20219, too high
