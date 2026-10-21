package main

import (
	"crypto/rand"
	"fmt"
	"math/big"
	"time"
)

const base36 = "0123456789abcdefghijklmnopqrstuvwxyz"

func RandomHash(n int) string {
	b := make([]byte, n)
	for i := range b {
		v, err := rand.Int(rand.Reader, big.NewInt(int64(len(base36))))
		if err != nil {
			panic(err)
		}
		b[i] = base36[v.Int64()]
	}
	return string(b)
}

func main() {
	for {
		fmt.Println(RandomHash(6))
		time.Sleep(5 * time.Second)
	}
}
