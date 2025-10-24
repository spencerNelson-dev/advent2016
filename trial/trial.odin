package trial

import "core:fmt"
import "core:math/rand"

run :: proc() {
	fmt.println("Hello There!")
	fmt.println("chcp 65001")
	hello()

	rand_number := rand.int_max(11)
	fmt.printfln("First - %v", rand_number)

	for x := 0; x < 10; x += 1 {
		fmt.printfln("%v - %v", x, rand_number)
		rand_number = rand.int_max(11)
	}

	ma := [4]rune{'吗', '骂', '马', '妈'}

	for m in ma {
		fmt.println(m)
	}

	ni := Character {
		hanzi   = '你',
		pinyin  = "ni3",
		tone    = .Dipping,
		english = "you",
	}

	fmt.println(ni)

}

hello :: proc() {
	fmt.println("你好!")
}

Character :: struct {
	hanzi:   rune,
	pinyin:  string,
	tone:    Tone,
	english: string,
}

Tone :: enum {
	High = 1,
	Rising,
	Dipping,
	Falling,
	Netural,
}
