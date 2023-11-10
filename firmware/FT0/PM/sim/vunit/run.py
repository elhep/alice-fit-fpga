#!/usr/bin/env python3

from vunit import VUnitCLI, VUnit
from pathlib import Path
from vivado_util import add_vivado_ip

from distutils.dir_util import copy_tree
import os 


ROOT = Path(__file__).parent / ".." /".."

# Check if project is already build
if Path.is_file(ROOT / "build" / "PM12.xpr") == False:
    os.chdir(ROOT)
    os.system("vivado -mode batch -source make.tcl")


project_file = ROOT / "build" / "PM12.xpr"

# Create VUnit instance by parsing command line arguments
cli = VUnitCLI()

# Change the default value of 'output_path'
cli.parser.set_defaults(output_path=(ROOT/"sim"/"modelsim"), tb_path=(ROOT/"sim"/"tb"))
args = cli.parse_args()
vu = VUnit.from_args(args=args)

vu.add_com()
vu.add_osvvm()
vu.add_verification_components()

add_vivado_ip(
    vu,
    output_path=ROOT /"sim"/"modelsim" / "vivado_libs",
    project_file=project_file,
)

# Create library 'lib'
xil_defaultlib = vu.library("xil_defaultlib")
# xil_defaultlib.

# Add all files ending in .vhd in current working directory to library
xil_defaultlib.add_source_files(ROOT/ ".." / ".." / "common"/ "gbt-fpga" / "hdl" / "core_sources" / "*.vhd", vhdl_standard="2008")
xil_defaultlib.add_source_files(ROOT/ ".." / ".." / "common"/ "gbt-fpga" / "hdl" / "core_sources" / "rxframeclk_phalgnr" /"*.vhd", vhdl_standard="2008")
xil_defaultlib.add_source_files(ROOT/ ".." / ".." / "common"/ "gbt-fpga" / "hdl" / "gbt_bank" / "core_sources" /"*.vhd", vhdl_standard="2008")
xil_defaultlib.add_source_files(ROOT/ ".." / ".." / "common"/ "gbt-fpga" / "hdl" / "gbt_bank" / "core_sources" / "gbt_tx" /"*.vhd", vhdl_standard="2008")
xil_defaultlib.add_source_files(ROOT/ ".." / ".." / "common"/ "gbt-fpga" / "hdl" / "gbt_bank" / "core_sources" / "gbt_rx" /"*.vhd", vhdl_standard="2008")
xil_defaultlib.add_source_files(ROOT/ ".." / ".." / "common"/ "gbt-fpga" / "hdl" / "gbt_bank" / "core_sources" / "mgt" /"*.vhd", vhdl_standard="2008")
# xil_defaultlib.add_source_files(ROOT/ ".." / ".." / "common"/ "gbt-fpga" / "hdl" / "gbt_bank" / "*.vhd")
xil_defaultlib.add_source_files(ROOT/ ".." / ".." / "common"/ "gbt-fpga" / "hdl" / "gbt_bank" / "xilinx_k7v7" / "*.vhd", vhdl_standard="2008")
xil_defaultlib.add_source_files(ROOT/ ".." / ".." / "common"/ "gbt-fpga" / "hdl" / "gbt_bank" / "xilinx_k7v7" / "mgt" /"*.vhd", vhdl_standard="2008")
xil_defaultlib.add_source_files(ROOT/ ".." / ".." / "common"/ "gbt-fpga" / "hdl" / "gbt_bank" / "xilinx_k7v7" / "mgt" /"mgt_ip_vhd" /"*.vhd", vhdl_standard="2008")
xil_defaultlib.add_source_files(ROOT/ ".." / ".." / "common"/ "gbt-fpga" / "hdl" / "gbt_bank" / "xilinx_k7v7" / "gbt_tx" /"*.vhd", vhdl_standard="2008")
xil_defaultlib.add_source_files(ROOT/ ".." / ".." / "common"/ "gbt-readout" / "hdl" / "*.vhd")
# xil_defaultlib.add_source_files(ROOT/ ".." / ".." / "common"/ "ipbus" / "hdl" / "*.vhd")
xil_defaultlib.add_source_files(ROOT/ "hdl" / "*.vhd")

# Add Testbenches 
xil_defaultlib.add_source_files(ROOT/"sim" /"tb" /"*.vhd")

# Get list of testbenches 
testbenches = xil_defaultlib.get_test_benches()

for tb in testbenches:
    tb.set_sim_option("disable_ieee_warnings", True)
    wavepath = (ROOT/"sim" /"tb" /str( tb.name +".do"))
    if (wavepath.is_file()):
        tb.set_sim_option("modelsim.init_files.after_load",[str(wavepath)])

vu.add_compile_option('modelsim.vcom_flags', ['-suppress', '1272'])
# vu.add_compile_option('modelsim.vcom_flags', ['-suppress', '1436'])

# Run vunit function
vu.main()