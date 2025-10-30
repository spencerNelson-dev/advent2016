#+feature dynamic-literals
package eleven

import "core:container/queue"
import "core:fmt"

Floor :: bit_set[0 ..< 14]
Floors :: [4]Floor

names := [14]string {
	"ThG",
	"ThM",
	"PlG",
	"PlM",
	"StG",
	"StM",
	"PrG",
	"PrM",
	"RuG",
	"RuM",
	"ElG",
	"ElM",
	"DiG",
	"DiM",
}
evaluated: [dynamic]State

State :: struct {
	floors:        Floors,
	elevator:      int,
	count:         int,
	previous_caro: Floor,
	score:         int,
}

pe :: proc(eq_number: int) -> string {
	return names[eq_number]
}

print_floors :: proc(floors: Floors, elevator: int) {
	fmt.println("----------------------------------------")
	#reverse for f, fi in floors {
		a: [14]int
		for v in f {
			a[v] = 1
		}
		// fmt.println(a)
		for v, i in a {
			if v == 1 {
				fmt.printf("%v ", pe(i))
			} else {
				fmt.print("... ")
			}
		}
		if elevator == fi {
			fmt.print(" E")
		}
		fmt.print("\n")
	}
	fmt.println("----------------------------------------")
}

check_floor :: proc(floor: Floor) -> bool {
	gen_set := Floor{0, 2, 4, 6, 8}

	has_gen := card(floor & gen_set) > 0

	if 1 in floor && 0 not_in floor && has_gen {
		return false
	}
	if 3 in floor && 2 not_in floor && has_gen {
		return false
	}
	if 5 in floor && 4 not_in floor && has_gen {
		return false
	}
	if 7 in floor && 6 not_in floor && has_gen {
		return false
	}
	if 9 in floor && 8 not_in floor && has_gen {
		return false
	}
	if 11 in floor && 10 not_in floor && has_gen {
		return false
	}
	if 13 in floor && 12 not_in floor && has_gen {
		return false
	}

	return true
}

build_cargos :: proc(s: State) -> [dynamic]Floor {
	moves: [dynamic]Floor
	set_value := transmute(u16)s.floors[s.elevator]
	i := set_value
	for {
		subset_value := i
		subset := transmute(Floor)subset_value
		if card(subset) > 0 && card(subset) < 3 {
			append(&moves, subset)
		}
		if i == 0 {
			break
		}
		i = (i - 1) & set_value
	}
	return moves
}

update_floors :: proc(floors: [4]Floor, c: Floor, from, to: int) -> Floors {
	// fmt.println("***OLD**")
	// print_floors(floors, from)
	// fmt.println("***OLD**")
	new_floors := floors
	new := c + floors[to]
	old := floors[from] - c
	new_floors[to] = new
	new_floors[from] = old
	// fmt.println("***NEW***", from, to)
	// print_floors(new_floors, to)
	// fmt.println("***NEW***")
	return new_floors
}

compare_floors :: proc(a: Floors, b: Floors) -> bool {
	for v, i in a {
		if v != b[i] {
			return false
		}
	}

	return true
}

floors_same :: proc(floors: Floors) -> bool {
	result: bool
	for e in evaluated {
		if compare_floors(e.floors, floors) {
			return true
		}
	}
	return false
}


build_children :: proc(p: State) -> []State {
	list: [dynamic]State
	cargos := build_cargos(p)
	switch p.elevator {
	case 0:
		for c in cargos {
			if c != p.previous_caro {
				new_1 := c + p.floors[1]
				if check_floor(new_1) {
					new_floors := update_floors(p.floors, c, p.elevator, p.elevator + 1)
					if !floors_same(new_floors) {
						append(
							&list,
							State {
								floors = new_floors,
								elevator = p.elevator + 1,
								count = p.count + 1,
								previous_caro = c,
							},
						)
					}
				}
			}

		}
	case 1:
		for c in cargos {
			// up
			new_2 := c + p.floors[2]
			if check_floor(new_2) {
				new_floors := update_floors(p.floors, c, p.elevator, p.elevator + 1)
				if !floors_same(new_floors) {
					append(
						&list,
						State {
							floors = new_floors,
							elevator = p.elevator + 1,
							count = p.count + 1,
							previous_caro = c,
						},
					)
				}
			}
			// down
			if c != p.previous_caro {
				new_0 := c + p.floors[0]
				if check_floor(new_0) {
					new_floors := update_floors(p.floors, c, p.elevator, p.elevator - 1)
					if !floors_same(new_floors) {
						append(
							&list,
							State {
								floors = new_floors,
								elevator = p.elevator - 1,
								count = p.count + 1,
								previous_caro = c,
							},
						)
					}
				}
			}
		}
	case 2:
		for c in cargos {
			// up
			new_3 := c + p.floors[3]
			if check_floor(new_3) {
				new_floors := update_floors(p.floors, c, p.elevator, p.elevator + 1)
				if !floors_same(new_floors) {
					append(
						&list,
						State {
							floors = new_floors,
							elevator = p.elevator + 1,
							count = p.count + 1,
							previous_caro = c,
						},
					)
				}
			}
			// down
			if c != p.previous_caro {
				new_1 := c + p.floors[1]
				if check_floor(new_1) {
					new_floors := update_floors(p.floors, c, p.elevator, p.elevator - 1)
					if !floors_same(new_floors) {
						append(
							&list,
							State {
								floors = new_floors,
								elevator = p.elevator - 1,
								count = p.count + 1,
								previous_caro = c,
							},
						)
					}
				}
			}
		}
	case 3:
		for c in cargos {
			// down
			if c != p.previous_caro {
				new_2 := c + p.floors[2]
				if check_floor(new_2) {
					new_floors := update_floors(p.floors, c, p.elevator, p.elevator - 1)
					if !floors_same(new_floors) {
						append(
							&list,
							State {
								floors = new_floors,
								elevator = p.elevator - 1,
								count = p.count + 1,
								previous_caro = c,
							},
						)
					}
				}
			}
		}
	}
	return list[:]
}

score_floors :: proc(floors: [4]Floor, goal: Floor) -> (score: int) {
	score += 10 - card(floors[0])
	if floors[0] == {} {
		score += 14 - card(floors[1])
	}
	if floors[0] == {} && floors[1] == {} {
		score += 14 - card(floors[2])
	}

	return
}

run :: proc() {
	floors: Floors
	elevator: int

	// names := [10]string{"ThG", "ThM", "PlG", "PlM", "StG", "StM", "PrG", "PrM", "RuG", "RuM"}
	floors[2] = {6, 7, 8, 9} // {0, 0, 0, 0, 0, 0, 1, 1, 1, 1}
	floors[1] = {3, 5} // {0, 0, 0, 1, 0, 1, 0, 0, 0, 0}
	floors[0] = {0, 1, 2, 4, 10, 11, 12, 13} // {1, 1, 1, 0, 1, 0, 0, 0, 0, 0}
	// floors[0] = {0, 1, 2, 4}

	goal := Floor{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}
	// goal := Floor{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
	top_score := 0
	top_state: State
	print_floors(floors, elevator)

	q: queue.Queue(State)


	queue.init(&q)
	queue.push_back(&q, State{floors = floors, elevator = elevator, count = 0})

	current: State

	main: for queue.len(q) > 0 {
		current = queue.pop_front(&q)

		// fmt.printfln("***score: %v***", current.score)
		// print_floors(current.floors, current.elevator)
		if current.floors[3] == goal {
			break
		}


		children := build_children(current)
		// fmt.println(len(children))
		for &c, i in children {
			score := score_floors(c.floors, goal)
			if score + 1 < top_score {
				append(&evaluated, c)
				continue
			}
			c.score = score
			if score <= top_score {
				queue.push_back(&q, c)
			}
			if score > top_score {
				top_score = score
				top_state = c
				queue.push_front(&q, c)
			}
		}
		fmt.print(top_score, queue.len(q), "\r")
	}

	fmt.print("\n")
	// fmt.println("Current Count:", current.count)
	// print_floors(current.floors, current.elevator)
	fmt.println("top score:", top_score)
	fmt.println("top_count:", top_state.count)
	print_floors(top_state.floors, top_state.elevator)
}
