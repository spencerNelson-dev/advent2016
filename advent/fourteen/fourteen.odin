package fourteen

import "core:crypto/hash"
import "core:fmt"
import "core:io"
import "core:mem"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:terminal/ansi"
import "core:thread"
import "core:time"

HASH_LENGTH :: 2016

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
	// defer strings.builder_destroy(&builder)
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


key_exists :: proc(list: ^[dynamic]int, t: int) -> bool {
	for l in list {
		if l == t {
			return true
		}
	}
	return false
}

build_keys :: proc() {
	file, err := os.open("output.txt", os.O_CREATE | os.O_APPEND | os.O_WRONLY, 0o644)
	if err != nil {
		fmt.println("Failed to open file")
	}
	defer os.close(file)
	buf: [64]byte
	for i in 0 ..< 30000 {
		num := strconv.itoa(buf[:], i)
		salt := strings.concatenate({INPUT, num})
		bytes := hash.hash(hash.Algorithm.Insecure_MD5, salt)
		defer delete(bytes)
		s: string
		for x in 0 ..< HASH_LENGTH {
			s = bytes_to_hex_string(bytes)
			bytes = hash.hash(hash.Algorithm.Insecure_MD5, s)

		}
		s = bytes_to_hex_string(bytes)
		_, err = os.write_string(file, fmt.aprintf("%v\n", s))
	}
}

read_keys :: proc() {
	data, ok := os.read_entire_file_from_filename("output.txt")
	if !ok {
		fmt.println("failed to read file")
	}
	hashes := strings.split_lines(string(data))
	keys: [dynamic]Key
	valid_keys: [dynamic]int

	for h, h_index in hashes {
		if is_key, r := is_key_contender(h); is_key {
			k := Key {
				index = h_index,
				hash  = h,
				r     = r,
			}
			append(&keys, k)
		}
		if is_validator, v_r := is_key_validator(h); is_validator {
			fmt.println(h_index, h)
			for &k in keys {

				if k.r == v_r &&
				   h_index > k.index &&
				   h_index - k.index < 1000 &&
				   k.index != h_index {
					append(&valid_keys, k.index)
				}
			}

		}
	}
	slice.sort(valid_keys[:])
	fmt.println(valid_keys[63])
	fmt.println(valid_keys)

}

run :: proc() {
	run_fast()
	buf: [64]byte
	// bytes_read, _ := os.read(os.stdin, buf[:])

	s: time.Stopwatch
	time.stopwatch_start(&s)

	contenders: [dynamic]Key
	valid_indexes: [dynamic]int
	i: int
	v: int
	main: for i < 30000 && v < 65 {
		{
			num := strconv.itoa(buf[:], i)
			salt := strings.concatenate({INPUT, num})
			bytes := hash.hash(hash.Algorithm.Insecure_MD5, salt)
			defer delete(bytes)
			s: string
			if HASH_LENGTH > 1 {
				for x in 0 ..< HASH_LENGTH {
					s = bytes_to_hex_string(bytes)
					bytes = hash.hash(hash.Algorithm.Insecure_MD5, s)

				}

			}

			s = bytes_to_hex_string(bytes)
			// buf: [64]byte
			// fmt.println(i, s)
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
				fmt.println(i, s)
				for &c in contenders {

					if c.r == r && i < c.index + 1000 && c.index != i {
						buf: [64]byte
						// fmt.println(i, s, r)
						// fmt.println(v, c.index, c.hash, c.r, salt)
						// bytes_read, _ := os.read(os.stdin, buf[:])

						c.valid = .Yes
						if !key_exists(&valid_indexes, c.index) {
							append(&valid_indexes, c.index)
							v += 1
							if v > 63 {
								break main
							}

						}
					}
				}
			}
			// fmt.print(i, len(valid_indexes), "\r")
			i += 1
		}
	}
	fmt.print("\n")
	slice.sort(valid_indexes[:])
	// fmt.println(len(valid_indexes))
	// fmt.println(valid_indexes)
	fmt.println("answer:", valid_indexes[63])
	fmt.println(valid_indexes[:])
	time.stopwatch_stop(&s)
	fmt.println("time:", time.clock_from_stopwatch(s))
}

// 14651, 14833 -- too low
// part 2 - 20219, too high

TASK_COUNT :: 30000
THREAD_COUNT :: 3

validators: [dynamic]^Thread_Task

run_fast :: proc() {
	stopwatch: time.Stopwatch
	time.stopwatch_start(&stopwatch)
	task_data_array := make([dynamic]Thread_Task, TASK_COUNT)

	pool: thread.Pool

	pool_alloc: mem.Allocator
	pool_alloc = context.allocator

	thread.pool_init(&pool, pool_alloc, THREAD_COUNT)

	thread.pool_start(&pool)
	defer thread.pool_destroy(&pool)

	for task_index in 0 ..< TASK_COUNT {
		task_alloc: mem.Allocator
		task_alloc = context.allocator

		task_data := &task_data_array[task_index]

		task_data^ = {
			index = task_index,
		}

		thread.pool_add_task(&pool, task_alloc, get_hash, task_data, task_index)
	}

	fmt.println("Wait for tasks to finish")
	thread.pool_finish(&pool)


	valid_indexes: [dynamic]int
	outer: for &h, i in task_data_array {
		if h.index == 647 {
			fmt.println("HERE", h.index, h.hash, h.key)
		}
		if h.key {
			for v in validators {
				if h.r == v.r &&
				   v.index < h.index + 1000 &&
				   v.index > h.index &&
				   h.index != v.index {
					append(&valid_indexes, h.index)
					continue outer
				}
			}
		}
	}
	for v in validators {
		fmt.println(v.index, v.hash)
	}
	fmt.println("answer:", valid_indexes[63])
	fmt.println(valid_indexes[:64])
	time.stopwatch_stop(&stopwatch)
	fmt.println("threads:", THREAD_COUNT, "time:", time.clock_from_stopwatch(stopwatch))
	fmt.println("")
}

get_hash :: proc(task: thread.Task) {
	data := cast(^Thread_Task)task.data
	buf: [64]byte
	num := strconv.itoa(buf[:], data.index)
	salt := strings.concatenate({INPUT, num})
	bytes := hash.hash(hash.Algorithm.Insecure_MD5, salt)
	defer delete(bytes)
	s: string
	if HASH_LENGTH > 1 {
		for x in 0 ..< HASH_LENGTH {
			s := bytes_to_hex_string(bytes)
			bytes = hash.hash(hash.Algorithm.Insecure_MD5, s)

		}

	}
	s = bytes_to_hex_string(bytes)
	if test, r := is_key_contender(s); test {
		data.r = r
		data.key = true
	}
	if test2, _ := is_key_validator(s); test2 {
		append(&validators, data)
	}

	data.hash = bytes_to_hex_string(bytes)
}

Thread_Task :: struct {
	index: int,
	hash:  string,
	r:     u8,
	key:   bool,
}

