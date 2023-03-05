onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group General -color {Spring Green} /RV32I_tb/dut/core/clk
add wave -noupdate -expand -group General -color {Spring Green} /RV32I_tb/dut/core/rst
add wave -noupdate -expand -group General -color {Spring Green} /RV32I_tb/dut/core/control_unit_state
add wave -noupdate -expand -group General -color {Spring Green} -itemcolor {Pale Green} /RV32I_tb/dut/core/mnemonic
add wave -noupdate -expand -group {Program Counter} -color Orange /RV32I_tb/dut/core/program_counter_s1
add wave -noupdate -expand -group {Program Counter} -color Orange /RV32I_tb/dut/core/program_counter_plus_4_s1
add wave -noupdate -expand -group {Program Counter} -color Orange /RV32I_tb/dut/core/program_counter_plus_imm_s2
add wave -noupdate -expand -group {Program Counter} -color Orange /RV32I_tb/dut/core/program_counter_wren
add wave -noupdate -expand -group Registers -color Violet /RV32I_tb/dut/core/imm_s2
add wave -noupdate -expand -group Registers -color Violet /RV32I_tb/dut/core/rs1_addr
add wave -noupdate -expand -group Registers -color Violet /RV32I_tb/dut/core/rs1_s2
add wave -noupdate -expand -group Registers -color Violet /RV32I_tb/dut/core/rs2_addr
add wave -noupdate -expand -group Registers -color Violet /RV32I_tb/dut/core/rs2_s2
add wave -noupdate -expand -group Registers -color Violet -radix unsigned /RV32I_tb/dut/core/rd_addr
add wave -noupdate -expand -group Registers -color Violet /RV32I_tb/dut/core/rf_wren
add wave -noupdate -expand -group Registers -color Violet /RV32I_tb/dut/core/rf_write_data
add wave -noupdate -expand -group ALU -color Red /RV32I_tb/dut/core/alu/cond_jump
add wave -noupdate -expand -group ALU -color Red /RV32I_tb/dut/core/alu_a
add wave -noupdate -expand -group ALU -color Red /RV32I_tb/dut/core/alu_b
add wave -noupdate -expand -group ALU -color Red /RV32I_tb/dut/core/alu_out
add wave -noupdate -expand -group ALU -color Red /RV32I_tb/dut/core/alu_out_s3
add wave -noupdate -expand -group ALU -color Red /RV32I_tb/dut/core/alu/adder_substracter/a
add wave -noupdate -expand -group ALU -color Red /RV32I_tb/dut/core/alu/adder_substracter/b
add wave -noupdate -expand -group ALU -color Red /RV32I_tb/dut/core/alu/adder_substracter/mode
add wave -noupdate -expand -group ALU -color Red /RV32I_tb/dut/core/alu/adder_substracter/result
add wave -noupdate -expand -group Memory -color Cyan /RV32I_tb/dut/core/bus_addr
add wave -noupdate -expand -group Memory -color Cyan /RV32I_tb/dut/core/bus_rddata
add wave -noupdate -expand -group Memory -color Cyan /RV32I_tb/dut/core/bus_wrdata
add wave -noupdate -expand -group Memory -color Cyan /RV32I_tb/dut/core/bus_wren
add wave -noupdate -expand -group GPIO -color Gray60 /RV32I_tb/dut/gpio/gpio_port_in
add wave -noupdate -expand -group GPIO -color Gray60 /RV32I_tb/dut/gpio/gpio_port_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {305 ns} 0} {{Cursor 2} {43 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 217
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {301 ns} {313 ns}
