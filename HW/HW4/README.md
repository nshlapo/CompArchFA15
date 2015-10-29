# CompArch HW b0100: Register File #

###To Run Register and Test Bench
Create a <name>.txt file which has the the names of the module and test files you want to compile, e.g:

```
decoders.v
multiplexer.v
register.v
regfile.v
regfile.t.v
```

Then run
```
iverilog -o exec <name>.txt
./exec
```