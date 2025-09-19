package main

import (
	"fmt"
)

func main() {
	controlNames := []string{
		"NUL", "SOH", "STX", "ETX", "EOT", "ENQ", "ACK", "BEL", "BS", "TAB",
		"LF", "VT", "FF", "CR", "SO", "SI", "DLE", "DC1", "DC2", "DC3", "DC4",
		"NAK", "SYN", "ETB", "CAN", "EM", "SUB", "ESC", "FS", "GS", "RS", "US",
	}

	fmt.Printf("%-6s %-9s %-9s %-10s\n", "Char", "ASCII Hex", "Dec", "Ctrl Hex")
	fmt.Printf("%-6s %-9s %-9s %-10s\n", "----", "---------", "---", "---------")

	for code := 0; code <= 90; code++ {
		var char string
		if code <= 31 {
			char = controlNames[code]
		} else {
			char = string(rune(code))
		}

		var ctrlHex string
		if code >= 65 && code <= 90 {
			ctrlHex = fmt.Sprintf("0x%02X", code&0x1F)
		} else {
			ctrlHex = "-"
		}

		fmt.Printf("%-6s 0x%02X     %-9d %-10s\n", char, code, code, ctrlHex)
	}
}
