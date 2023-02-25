onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group General /RV32I_tb/dut/clk
add wave -noupdate -expand -group General /RV32I_tb/dut/rst
add wave -noupdate -expand -group General /RV32I_tb/dut/control_unit_state
add wave -noupdate -expand -group General /RV32I_tb/dut/mnemonic
add wave -noupdate -expand -group Registers /RV32I_tb/dut/rs1_addr_s2
add wave -noupdate -expand -group Registers /RV32I_tb/dut/rs2_addr_s2
add wave -noupdate -expand -group Registers /RV32I_tb/dut/rd_addr_s2
add wave -noupdate -expand -group Registers /RV32I_tb/dut/rs1
add wave -noupdate -expand -group Registers /RV32I_tb/dut/rs2
add wave -noupdate -expand -group Registers /RV32I_tb/dut/rd
add wave -noupdate -expand -group ALU /RV32I_tb/dut/alu_a
add wave -noupdate -expand -group ALU /RV32I_tb/dut/alu_b
add wave -noupdate -expand -group ALU /RV32I_tb/dut/alu_out
add wave -noupdate -expand -group Memory /RV32I_tb/dut/bus_addr
add wave -noupdate -expand -group Memory /RV32I_tb/dut/bus_rddata
add wave -noupdate -expand -group Memory /RV32I_tb/dut/bus_wrdata
add wave -noupdate -expand -group Memory /RV32I_tb/dut/bus_wren
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 297
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {32 ns}
