onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+random_access_memory -L xpm -L blk_mem_gen_v8_4_4 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.random_access_memory xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {random_access_memory.udo}

run -all

endsim

quit -force
