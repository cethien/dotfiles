package module_toml

import (
	"math/rand/v2"
)

var Kaomojis = []string{
	"▼・ᴥ・▼",
	"U・ᴥ・U",
	"( º A º )",
	"(U ˆᴥˆ U)",
	"(=^・ω・^=)",
	"/ᐠ｡ꞈ｡ᐟ\\",
	"ฅ(^•ﻌ•^ฅ)",
	"(=｀ω´=)",
}

func GetRandomKaomoji() string {
	if len(Kaomojis) == 0 {
		return "▼・ᴥ・▼"
	}
	return Kaomojis[rand.IntN(len(Kaomojis))]
}
