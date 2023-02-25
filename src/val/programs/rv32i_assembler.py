import sys
import shutil
from riscv_assembler.convert import AssemblyConverter
cnv = AssemblyConverter(output_type="t")

input_assembly = sys.argv[1]
input_assembly_name = sys.argv[1][:len(sys.argv[1]) -2][2:]
print(input_assembly_name)

try:
    shutil.rmtree(input_assembly_name)
except:
    print("Folder wasnt found, not removing")

cnv.convert(input_assembly)