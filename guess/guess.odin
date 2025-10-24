package guess

import "core:fmt"
import "core:math/rand"
import "core:os"
import "core:strconv"

run :: proc(max := 10) {
	buf: [100]byte
	target := rand.int_max(max) + 1
	guess: int
	ok: bool

	for guess != target {

		fmt.println("Guess a number beteen 1 and ", max, ": ")

		bytes_read, _ := os.read(os.stdin, buf[:])
		guess, ok = strconv.parse_int(string(buf[:bytes_read - 2]))

		if guess > target {
			fmt.println("You guessed too high!")
		}
		if guess < target {
			fmt.println("You guessed too low!")
		}
		if guess == target {
			fmt.println("Congrats! That was the number!")
		}
	}
}
