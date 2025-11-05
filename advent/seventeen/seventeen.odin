package seventeen

import "core:container/queue"
import "core:crypto/hash"
import "core:fmt"
import "core:strings"

Loc :: [2]int

Dir :: enum {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

Move :: struct {
	l: Loc,
	p: string,
}


bytes_to_hex_string :: proc(bytes: []byte) -> string {
	builder := strings.builder_make()
	// defer strings.builder_destroy(&builder)
	for byte_val in bytes[:4] {
		fmt.sbprintf(&builder, "%02x", byte_val)
	}
	return strings.to_string(builder)
}

get_hash :: proc(s: string) -> string {
	bytes := hash.hash(hash.Algorithm.Insecure_MD5, s)
	defer delete(bytes)
	s: string
	s = bytes_to_hex_string(bytes)
	return s
}

is_valid_direction :: proc(l: Loc, d: Dir) -> bool {
	switch d {
	case .UP:
		if l.y - 1 > -1 do return true
	case .DOWN:
		if l.y + 1 < 4 do return true
	case .LEFT:
		if l.x - 1 > -1 do return true
	case .RIGHT:
		if l.x + 1 < 4 do return true
	}
	return false
}

is_valid_letter :: proc(l: u8) -> bool {
	if l == 'b' || l == 'c' || l == 'd' || l == 'e' || l == 'f' {
		return true
	}
	return false
}

get_moves :: proc(m: Move) -> []Move {
	l := m.l
	passcode := m.p
	moves: [dynamic]Move
	// U D L R
	hash := get_hash(passcode)
	// UP
	if is_valid_letter(hash[0]) && is_valid_direction(l, .UP) {
		append(&moves, Move{l = {l.x, l.y - 1}, p = strings.concatenate({passcode, "U"})})
	}
	// DOWN
	if is_valid_letter(hash[1]) && is_valid_direction(l, .DOWN) {
		append(&moves, Move{l = {l.x, l.y + 1}, p = strings.concatenate({passcode, "D"})})
	}
	// LEFT
	if is_valid_letter(hash[2]) && is_valid_direction(l, .LEFT) {
		append(&moves, Move{l = {l.x - 1, l.y}, p = strings.concatenate({passcode, "L"})})
	}
	// RIGHT
	if is_valid_letter(hash[3]) && is_valid_direction(l, .RIGHT) {
		append(&moves, Move{l = {l.x + 1, l.y}, p = strings.concatenate({passcode, "R"})})
	}
	return moves[:]
}

get_shortest_path :: proc(init: Move) -> string {
	q: queue.Queue(Move)

	queue.init(&q)
	queue.append(&q, init)

	current: Move
	for queue.len(q) != 0 {
		current = queue.pop_front(&q)

		if current.l == {3, 3} {
			break
		}

		moves := get_moves(current)
		for m in moves {
			queue.push_back(&q, m)
		}
	}
	return current.p[len(init.p):]
}

get_longest :: proc(init: Move) -> int {
	q: queue.Queue(Move)

	queue.init(&q)
	queue.append(&q, init)

	valid_paths: [dynamic]Move
	current: Move
	for queue.len(q) != 0 {
		current = queue.pop_front(&q)

		if current.l == {3, 3} {
			append(&valid_paths, current)
			continue
		}

		moves := get_moves(current)
		for m in moves {
			queue.push_back(&q, m)
		}
	}
	v_len := len(valid_paths)
	return len(valid_paths[v_len - 1].p[len(init.p):])
}

run :: proc() {

	init := Move {
		l = {0, 0},
		p = "mmsxrhfx",
	}

	short := get_shortest_path(init)
	long := get_longest(init)
	fmt.println(short)
	fmt.println(long)

}
