package main

import (
	"fmt"
	"math/rand/v2"
	"time"
)

const base36 = "0123456789abcdefghijklmnopqrstuvwxyz"

func RandomHash(n int) string {
	b := make([]byte, n)
	for i := range b {
		b[i] = base36[rand.IntN(len(base36))]
	}
	return string(b)
}

func main() {
	for {
		fmt.Println(RandomHash(6))
		time.Sleep(5 * time.Second)
	}
}
