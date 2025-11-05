package main

import "core:fmt"
import "core:os"
import "core:strconv"

import "guess"
import "trial"

import "advent/eight"
import "advent/eleven"
import "advent/five"
import "advent/four"
import "advent/fourteen"
import "advent/nine"
import "advent/one"
import "advent/seven"
import "advent/six"
import "advent/ten"
import "advent/thirteen"
import "advent/three"
import "advent/twelve"
import "advent/two"

main :: proc() {
	input_buf: [100]byte

	if len(os.args) < 2 {
		s := read_input(input_buf[:])
		run_program(s)
	} else {
		run_program(os.args[1])
	}
}

read_input :: proc(buf: []byte) -> string {
	fmt.print("What program do you want?: ")
	bytes_read, _ := os.read(os.stdin, buf[:])
	return string(buf[:bytes_read - 2])
}

run_program :: proc(name: string) {
	switch name {
	case "one":
		one.run()
	case "two":
		two.run()
	case "three":
		three.run()
	case "four":
		four.run()
	case "five":
		five.run()
	case "six":
		six.run()
	case "seven":
		seven.run()
	case "eight":
		eight.run()
	case "nine":
		nine.run()
	case "ten":
		ten.run()
	case "eleven":
		eleven.run()
	case "twelve":
		twelve.run()
	case "thirteen":
		thirteen.run()
	case "fourteen":
		fourteen.read_keys()
	case "fourteen-build":
	// fourteen.build_keys()
	case "trial":
		trial.run()
	case "guess":
		if len(os.args) >= 3 {
			max, ok := strconv.parse_int(os.args[2])
			if ok {
				guess.run(max)
			} else {
				guess.run()
			}
		} else {
			guess.run()
		}
	case "汉字":
		fmt.println("你好！")
	case:
		fmt.println("There is no program called: ", name)
	}
}

