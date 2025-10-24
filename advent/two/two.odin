package two

import "../shared"
import "core:fmt"
import "core:strings"

run :: proc() {
	decoder := Decoder {
		loc = 5,
	}
	decoder_2 := Decoder {
		loc = 5,
	}

	input_path := "D:\\learn\\odin\\fun\\advent\\input\\two.txt"
	input, _ := shared.read_input(input_path)
	// input = "LLRURUDUULRURRUDURRDLUUUDDDDURUUDLLDLRULRUUDUURRLRRUDLLUDLDURURRDDLLRUDDUDLDUUDDLUUULUUURRURDDLUDDLULRRRUURLDLURDULULRULRLDUDLLLLDLLLLRLDLRLDLUULLDDLDRRRURDDRRDURUURLRLRDUDLLURRLDUULDRURDRRURDDDDUUUDDRDLLDDUDURDLUUDRLRDUDLLDDDDDRRDRDUULDDLLDLRUDULLRRLLDUDRRLRURRRRLRDUDDRRDDUUUDLULLRRRDDRUUUDUUURUULUDURUDLDRDRLDLRLLRLRDRDRULRURLDDULRURLRLDUURLDDLUDRLRUDDURLUDLLULDLDDULDUDDDUDRLRDRUUURDUULLDULUUULLLDLRULDULUDLRRURDLULUDUDLDDRDRUUULDLRURLRUURDLULUDLULLRD"
	code_instructions, _ := strings.split_lines(input)
	for inst in code_instructions {
		process_instruction(&decoder, inst)
		process_instruction_2(&decoder_2, inst)
		append(&decoder.code, decoder.loc)
		append(&decoder_2.code, decoder_2.loc)
	}
	fmt.println(decoder.code)
	fmt.println(decoder_2.code)
}

Decoder :: struct {
	loc:  int,
	code: [dynamic]int,
}

process_instruction :: proc(d: ^Decoder, instruction: string) {
	for i in instruction {
		switch i {
		case 'U':
			switch d.loc {
			case 1, 2, 3:
			case:
				d.loc = d.loc - 3
			}
		case 'R':
			switch d.loc {
			case 3, 6, 9:
			case:
				d.loc = d.loc + 1
			}
		case 'D':
			switch d.loc {
			case 7, 8, 9:
			case:
				d.loc = d.loc + 3
			}
		case 'L':
			switch d.loc {
			case 1, 4, 7:
			case:
				d.loc = d.loc - 1
			}
		}
	}
}

process_instruction_2 :: proc(d: ^Decoder, instruction: string) {
	for i in instruction {
		switch i {
		case 'U':
			switch d.loc {
			case 5, 2, 1, 4, 9:
			case 3, 13:
				d.loc = d.loc - 2
			case 6, 7, 8:
				d.loc = d.loc - 4
			case 10, 11, 12:
				d.loc = d.loc - 4
			}
		case 'R':
			switch d.loc {
			case 1, 4, 9, 12, 13:
			case:
				d.loc = d.loc + 1
			}
		case 'D':
			switch d.loc {
			case 5, 10, 13, 12, 9:
			case 1, 11:
				d.loc = d.loc + 2
			case:
				d.loc = d.loc + 4
			}
		case 'L':
			switch d.loc {
			case 1, 2, 5, 10, 13:
			case:
				d.loc = d.loc - 1
			}
		}
	}

}
