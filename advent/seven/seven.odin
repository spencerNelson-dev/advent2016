package seven

import "../shared"
import "core:fmt"
import "core:strings"

run :: proc() {
	fmt.println("seven")
	input_path := "D:\\learn\\odin\\fun\\advent\\input\\seven.txt"
	input, _ := shared.read_input(input_path)

	lines := strings.split_lines(input)
	// lines = {"abba[mnop]qrst", "abcd[bddb]xyyx", "aaaa[qwer]tyui", "ioxxoj[asdfgh]zxcvbn"}
	// lines = {"aba[bab]xyz", "xyx[xyx]xyx", "aaa[kek]eke", "zazbz[bzb]cdb"}

	count := 0
	count_2 := 0


	for l in lines {
		abbas: [dynamic]string
		bad_abbas: [dynamic]string
		abas: [dynamic]string
		babs: [dynamic]string
		in_brackets := false
		for i := 0; i < len(l) - 2; i += 1 {
			if l[i] == '[' {
				in_brackets = true
				continue
			}
			if l[i] == ']' {
				in_brackets = false
				continue
			}

			if i < len(l) - 3 && abba_test(l[i:i + 4]) {
				if in_brackets {
					append(&bad_abbas, l[i:i + 4])
				} else {
					append(&abbas, l[i:i + 4])
				}
			}

			if aba_test(l[i:i + 3]) {
				if in_brackets {
					append(&babs, l[i:i + 3])
				} else {
					append(&abas, l[i:i + 3])
				}
			}

		}
		if len(abbas) > 0 && len(bad_abbas) == 0 {
			count += 1
		}
		// fmt.println(abas, babs)
		outer: for aba in abas {
			for bab in babs {
				if aba[0] == bab[1] && aba[1] == bab[0] {
					fmt.println("testing: ", aba, bab)
					count_2 += 1
					break outer
				}
			}
		}
	}
	fmt.println("TSL count: ", count)
	fmt.println("SSL count: ", count_2)

}

abba_test :: proc(s: string) -> (result: bool) {
	// fmt.println("testing: ", s)
	if s[0] != s[0 + 1] && (s[0] == s[0 + 3] && s[0 + 1] == s[0 + 2]) {
		result = true
	}
	return
}

aba_test :: proc(s: string) -> (result: bool) {
	// fmt.println("testing: ", s)
	if s[0] == s[2] && s[0] != s[1] {
		result = true
	}
	if s[1] == '[' || s[1] == ']' {
		result = false
	}
	return result
}
