onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /RV32I_tb/dut/clk
add wave -noupdate /RV32I_tb/dut/rst
add wave -noupdate /RV32I_tb/dut/core/program_counter
add wave -noupdate /RV32I_tb/dut/core/raw_bits
add wave -noupdate /RV32I_tb/dut/core/raw_bits_fetched
add wave -noupdate /RV32I_tb/dut/core/mnemonic
add wave -noupdate /RV32I_tb/dut/core/control_unit_state
add wave -noupdate /RV32I_tb/dut/core/control_unit/control_unit_state
add wave -noupdate /RV32I_tb/dut/core/control_unit/control_unit_state_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 393
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
WaveRestoreZoom {0 ns} {52 ns}
