# go-invoker-clr


The purpose of this project is to provide a Go implementation for hosting and executing .NET assemblies with advanced stealth and evasion capabilities. It enables the execution of .NET payloads from Go code, bypassing AMSI (Antimalware Scan Interface) without memory patching, by leveraging a custom IHostControl interface. This makes it useful for red teaming, penetration testing, and research into Windows internals and evasion techniques.

![go-invoker-clr](go-invoker-slr.png)


**GoInvoker-CLR** is a Go-based implementation inspired by the excellent research **[Being a Good CLR Host](https://github.com/passthehashbrowns/Being-A-Good-CLR-Host)** by **Joshua Magri** from **IBM X-Force Red**.

> ⚠️ **Credit where credit is due**:  
> This project builds heavily upon the outstanding work of others in the community.

## Lineage and Acknowledgements

- This project is primarily based on [**go-clr**](https://github.com/Ne0nd0g/go-clr) by **Ne0nd0g**.
- Ne0nd0g's implementation is itself a maintained and improved fork of the original PoC [**go-clr**](https://github.com/ropnop/go-clr) by **ropnop**.
- The conceptual foundation and architectural guidance come directly from the write-up [**Being a Good CLR Host**](https://github.com/passthehashbrowns/Being-A-Good-CLR-Host) by **Joshua Magri**, whose insights were essential to this project.



---

🙏 **Special thanks to**:  
Joshua Magri, Ne0nd0g, and ropnop — for sharing your work and pushing the community forward.



The purpose is to create our own `IHostControl` interface allowing us to implement the `ProvideAssembly` method. We can then use `Load_2` method instead of `Load_3`, circumventing AMSI entirely.




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
