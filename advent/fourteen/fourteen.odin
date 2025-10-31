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
	builder := strings.builder_make(len(bytes) * 2)
	for byte_val in bytes {
		fmt.sbprintf(&builder, "%02x", byte_val)
	}
	return strings.to_string(builder)
}

is_key_contender :: proc(s: string) -> (bool, u8) {
	s := s[31:]
	for j := 0; j < len(s) - 3; j += 1 {
		if s[j] == s[j + 1] && s[j] == s[j + 2] {
			return true, s[j]
		}
	}
	return false, 0
}

is_key_validator :: proc(s: string) -> (bool, u8) {
	s := s[31:]
	for j := 0; j < len(s) - 5; j += 1 {
		if s[j] == s[j + 1] && s[j] == s[j + 2] && s[j] == s[j + 3] && s[j] == s[j + 4] {
			return true, s[j]
		}
	}
	return false, 0
}

count_valid :: proc(con: ^[dynamic]Key) -> int {
	count: int
	for c in con {
		if c.valid == .Yes {
			count += 1
		}
	}
	return count
}

get_nth_valid :: proc(con: ^[dynamic]Key, n: int) -> Key {
	for c in con {
		if c.v_num == n {
			return c
		}
	}
	return Key{}
}

get_key_at_index :: proc(con: ^[dynamic]Key, n: int) -> Key {
	for c in con {
		if c.index == n {
			return c
		}
	}
	return Key{}
}

run :: proc() {
	buf: [64]byte

	contenders: [dynamic]Key
	valid_indexes: [dynamic]int
	i: int
	v: int
	main: for count_valid(&contenders) < 66 {
		{
			num := strconv.itoa(buf[:], i)
			salt := strings.concatenate({INPUT, num})
			bytes := hash.hash(hash.Algorithm.Insecure_MD5, salt)
			defer delete(bytes)

			s := bytes_to_hex_string(bytes)

			if test, r := is_key_contender(s); test {
				key := Key {
					index = i,
					hash  = s,
					r     = r,
				}
				append(&contenders, key)
			}
			if test, r := is_key_validator(s); test {
				fmt.println(i, s)
				for &c in contenders {

					if c.r == r && i < c.index + 1000 && c.index != i {
						// buf: [64]byte
						// fmt.println(i, s, r)
						// fmt.println(v, c.index, c.hash, c.r, salt)
						// bytes_read, _ := os.read(os.stdin, buf[:])

						c.valid = .Yes
						append(&valid_indexes, c.index)
						v += 1
						if v == 66 {
							break main
						}
					}
				}
			}
			i += 1
		}
	}
	slice.sort(valid_indexes[:])
	fmt.println(len(valid_indexes))
	fmt.println(valid_indexes)
	fmt.println(valid_indexes[63])
}

// 14651, 14833 -- too low
