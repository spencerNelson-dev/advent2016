package thriteen

import "core:container/queue"
import "core:fmt"
import "core:math"
import "core:math/bits"
import "core:os"

INPUT :: 1350
GOAL :: Loc{31, 39}
MAX_STEP :: 100

Loc :: [2]int

history: [dynamic]Position

Position :: struct {
	loc:   Loc,
	count: int,
}

is_open :: proc(l: Loc) -> bool {
	num := (l.x * l.x) + (3 * l.x) + (2 * l.x * l.y) + l.y + (l.y * l.y) + INPUT
	s := fmt.aprintf("%b", num)
	count := bits.count_ones(num)
	if count % 2 == 0 {
		return true
	}
	return false
}

is_valid_loc :: proc(l: Loc) -> bool {
	if l.x < 0 || l.y < 0 {
		return false
	}
	return true
}

get_positions :: proc(p: Position) -> []Position {
	list: [dynamic]Position

	moves: [4]Loc = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}}
	for m in moves {
		new := p.loc + m
		if is_valid_loc(new) {
			append(&list, Position{loc = new, count = p.count + 1})
		}
	}
	return list[:]
}

dist_to_goal :: proc(l: Loc) -> int {
	dx := math.abs(GOAL.x - l.x)
	dy := math.abs(GOAL.y - l.y)
	return dx + dy
}

ive_been_here_before :: proc(p: Position) -> bool {
	for h in history {
		if h.loc == p.loc {
			return true
		}
	}
	return false
}

run :: proc() {
	buf: [10]byte

	p := Position {
		loc = Loc{1, 1},
	}
	q: queue.Queue(Position)
	queue.init(&q)

	queue.push(&q, p)

	dist := 100
	c: Position
	for queue.len(q) > 0 {
		c = queue.pop_front(&q)
		if ive_been_here_before(c) {
			continue
		}
		if c.count > MAX_STEP {
			continue
		}
		append(&history, c)

		if c.loc == GOAL {
			break
		}

		moves := get_positions(c)
		for m in moves {
			d := dist_to_goal(m.loc)
			if is_open(m.loc) {
				// queue.push(&q, m)
				if d >= dist {
					queue.push_back(&q, m)
				}
				if d < dist {
					dist = d
					queue.push_front(&q, m)
				}
			}
		}
	}
	fmt.println(c)
	fmt.println(len(history))
}
