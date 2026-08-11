package main

import (
	"math/rand/v2"
)

var Kaomojis = map[string][]string{
	"dog": {
		"▼・ᴥ・▼",
		"U・ᴥ・U",
		"( º A º )",
		"(U ˆᴥˆ U)",
	},
	"cat": {
		"(=^・ω・^=)",
		"/ᐠ｡ꞈ｡ᐟ\\",
		"ฅ(^•ﻌ•^ฅ)",
		"(=｀ω´=)",
	},
}

// GetRandomKaomoji wählt einmalig einen Kaomoji aus Hund oder Katze
func GetRandomKaomoji() string {
	category := "dog"
	if rand.IntN(2) == 1 {
		category = "cat"
	}
	list := Kaomojis[category]
	return list[rand.IntN(len(list))]
}
