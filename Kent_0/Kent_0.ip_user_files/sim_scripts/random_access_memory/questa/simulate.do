onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib random_access_memory_opt

do {wave.do}

view wave
view structure
view signals

do {random_access_memory.udo}

run -all

quit -force
