package ten

import "../shared"
import "core:fmt"
import "core:strconv"
import "core:strings"


bots: map[string][2]int

bots_init :: proc(lines: []string, bots: ^map[string][2]int) {
	for l in lines {
		// fmt.println(l)
		parts := strings.split(l, " ")
		if parts[0] == "value" {
			value := strconv.atoi(parts[1])
			bot := parts[5]

			give_to_bot(bot, value)
		}
	}
}

give_to_bot :: proc(bot: string, value: int) {
	current, ok := &bots[bot]
	if ok {
		if value > current.y {
			current^ = {current.y, value}
		} else {
			current^ = {value, current.y}
		}
	} else {
		bots[bot] = {0, value}
	}

}

run_instruction :: proc(bot: string, lines: []string) {
	low_bot: string
	high_bot: string
	for l in lines {
		parts := strings.split(l, " ")
		if parts[1] == bot && parts[0] != "value" {
			low_bot = parts[6]
			high_bot = parts[11]
			if parts[5] == "output" {
				low_bot = strings.concatenate({low_bot, parts[5]})
			}
			if parts[10] == "output" {
				high_bot = strings.concatenate({high_bot, parts[10]})
			}
			current, _ := &bots[bot]
			if bot == "138" {
				fmt.printfln(
					"bot %v compares chips: %v, %v -> %v, %v",
					bot,
					current.x,
					current.y,
					low_bot,
					high_bot,
				)
			}
			if current.x == 17 && current.y == 61 {
				fmt.println("**********************")
			}
			give_to_bot(low_bot, current.x)
			give_to_bot(high_bot, current.y)
			current^ = {0, 0}
		}
	}
	if bot_full(low_bot) {
		run_instruction(low_bot, lines)
	}
	if bot_full(high_bot) {
		run_instruction(high_bot, lines)
	}

}

run :: proc() {

	input_path := "D:\\learn\\odin\\fun\\advent\\input\\ten.txt"
	input, _ := shared.read_input(input_path)

	lines := strings.split_lines(input)

	bots_init(lines, &bots)

	for b in bots {
		c, _ := &bots[b]
		if c.x > 0 && c.y > 0 {
			// fmt.println("run for", b)
			run_instruction(b, lines)
			// fmt.println(bots)
		}
	}
	zero := bots["0output"]
	one := bots["1output"]
	two := bots["2output"]
	fmt.println(zero, one, two, zero.y * one.y * two.y)
}

bot_full :: proc(bot: string) -> bool {
	cargo := bots[bot]
	if cargo.x != 0 && cargo.y != 0 {
		return true
	}
	return false
}
