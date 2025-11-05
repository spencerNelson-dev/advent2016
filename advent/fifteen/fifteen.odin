package fifteen

import "core:fmt"


// Disc #1 has 7 positions; at time=0, it is at position 0.
// Disc #2 has 13 positions; at time=0, it is at position 0.
// Disc #3 has 3 positions; at time=0, it is at position 2.
// Disc #4 has 5 positions; at time=0, it is at position 2.
// Disc #5 has 17 positions; at time=0, it is at position 0.
// Disc #6 has 19 positions; at time=0, it is at position 7.

update_disks :: proc(disks: ^[7]int, time: int) {
	disks[0] = time % 7
	disks[1] = time % 13
	disks[2] = (time + 2) % 3
	disks[3] = (time + 2) % 5
	disks[4] = time % 17
	disks[5] = (time + 7) % 19
	disks[6] = time % 11
}

is_drop_time :: proc(disks: ^[7]int) -> bool{
	d := [7]int{6,11,0,1,12,13, 4}
	if disks^ == d {
		return true
	}
	return false
}

run :: proc() {
	fmt.println("Fifteen")

	disks: [7]int
	t: int
	for {
		fmt.print(t, "\r")
		update_disks(&disks, t)
		if is_drop_time(&disks){
			fmt.println(t, disks)
			break
		}
		t += 1
	}
}
