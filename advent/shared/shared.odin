package shared

import "core:os"

read_input :: proc(filepath: string) -> (string, bool) {
	data, ok := os.read_entire_file_from_filename(filepath)
	if !ok {
		return "", ok
	}
	return string(data), true
}
