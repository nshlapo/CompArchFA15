#Computer Architecture Homework 2
##Nur Shlapobersky

###Test Bench Results

####Adder:
|A B Cin | Sum Cout | Expected|
|--------|----------|---------|
|0  0  0 |  0    0  |   0  0|
|0  0  1 |  1    0  |   1  0|
|0  1  0 |  1    0  |   1  0|
|0  1  1 |  0    1  |   0  1|
|1  0  0 |  1    0  |   1  0|
|1  0  1 |  0    1  |   0  1|
|1  1  0 |  0    1  |   0  1|
|1  1  1 |  1    1  |   1  1|

####Decoder:
|En A0 A1| O0 O1 O2 O3 | Expected|
|--------|-------------|----------|
|0  0  0 |  0  0  0  0 | All false|
|0  1  0 |  0  0  0  0 | All false|
|0  0  1 |  0  0  0  0 | All false|
|0  1  1 |  0  0  0  0 | All false|
|1  0  0 |  1  0  0  0 | O0 Only|
|1  1  0 |  0  1  0  0 | O1 Only|
|1  0  1 |  0  0  1  0 | O2 Only|
|1  1  1 |  0  0  0  1 | O3 Only|


####Multiplexer:
|in0 in1 in2 in3 | ad0 ad1 | out | Expected|
|----------------|---------|-----|---------|
|1   0   0   0   |   0  0  |  1  |  1|
|1   0   1   1   |   1  0  |  0  |  0|
|0   0   1   0   |   0  1  |  1  |  1|
|1   1   1   0   |   1  1  |  0  |  0|

###Delay Propagations
![Full Adder](/home/nshlapo/Documents/CompArchFA15/HW/HW2/adder_wave.png)

![Decoder](/home/nshlapo/Documents/CompArchFA15/HW/HW2/decoder_wave.png)

![4:1 Multiplexer](/home/nshlapo/Documents/CompArchFA15/HW/HW2/mux_wave.png)