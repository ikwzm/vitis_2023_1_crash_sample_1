################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2023.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xck26-sfvc784-2LV-c
   set_property BOARD_PART xilinx.com:kv260_som:part0:1.2 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

##################################################################
# CHECK IPs
##################################################################
variable USING_IP_VLNV_LIST
set USING_IP_VLNV_LIST [dict create]
dict set USING_IP_VLNV_LIST zynq_ultra_ps_e  "xilinx.com:ip:zynq_ultra_ps_e:3.5"
dict set USING_IP_VLNV_LIST xlslice          "xilinx.com:ip:xlslice:1.0"
dict set USING_IP_VLNV_LIST proc_sys_reset   "xilinx.com:ip:proc_sys_reset:5.0"
dict set USING_IP_VLNV_LIST clk_wiz          "xilinx.com:ip:clk_wiz:6.0"
dict set USING_IP_VLNV_LIST axi_intc         "xilinx.com:ip:axi_intc:4.1"
dict set USING_IP_VLNV_LIST axi_interconnect "xilinx.com:ip:axi_interconnect:2.1"
set bCheckIPsPassed 1
set bCheckIPs 1

if { $bCheckIPs == 1 } {
    set list_check_ips [join [dict values $USING_IP_VLNV_LIST] " "]
    set list_ips_missing ""
    common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

    foreach ip_vlnv $list_check_ips {
        set ip_obj [get_ipdefs -all $ip_vlnv]
        if { $ip_obj eq "" } {
              lappend list_ips_missing $ip_vlnv
        }
     }

     if { $list_ips_missing ne "" } {
         catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
         set bCheckIPsPassed 0
     }
}

if { $bCheckIPsPassed != 1 } {
    common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
    return 3
}

##################################################################
# DESIGN PROCs
##################################################################

proc create_zynq_ultra_ps { cell_name } {
    variable USING_IP_VLNV_LIST
    set ip_name zynq_ultra_ps_e

    if { [dict exists $USING_IP_VLNV_LIST $ip_name] != 1} {
        catch {
	    common::send_gid_msg -ssname BD::TCL -id 3001 -severity "ERROR" \
		[format "\"%s\" not found in the USING_IP_VLNV_LIST." $ip_name]
	}
	return ""
    }
    
    set cell [create_bd_cell -type ip -vlnv [dict get $USING_IP_VLNV_LIST $ip_name] $cell_name]
    apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1"} $cell
    set_property -dict [list CONFIG.PSU__USE__M_AXI_GP0        {0}  ] $cell
    set_property -dict [list CONFIG.PSU__USE__M_AXI_GP1        {0}  ] $cell
    set_property -dict [list CONFIG.PSU__USE__M_AXI_GP2        {1}  ] $cell
    set_property -dict [list CONFIG.PSU__USE__S_AXI_ACE        {0}  ] $cell
    set_property -dict [list CONFIG.PSU__USE__S_AXI_ACP        {0}  ] $cell
    set_property -dict [list CONFIG.PSU__USE__S_AXI_GP0        {0}  ] $cell
    set_property -dict [list CONFIG.PSU__USE__S_AXI_GP1        {0}  ] $cell
    set_property -dict [list CONFIG.PSU__USE__S_AXI_GP2        {0}  ] $cell
    set_property -dict [list CONFIG.PSU__USE__S_AXI_GP3        {0}  ] $cell
    set_property -dict [list CONFIG.PSU__USE__S_AXI_GP4        {0}  ] $cell
    set_property -dict [list CONFIG.PSU__USE__S_AXI_GP5        {0}  ] $cell
    set_property -dict [list CONFIG.PSU__USE__S_AXI_GP6        {0}  ] $cell
    set_property -dict [list CONFIG.PSU__MAXIGP2__DATA_WIDTH   {32} ] $cell
    set_property -dict [list CONFIG.PSU__USE__IRQ0             {1}  ] $cell
    set_property -dict [list CONFIG.PSU__USE__FABRIC__RST      {1}  ] $cell
    set_property -dict [list CONFIG.PSU__FPGA_PL0_ENABLE       {1}  ] $cell
    set_property -dict [list CONFIG.PSU__FPGA_PL1_ENABLE       {0}  ] $cell
    set_property -dict [list CONFIG.PSU__FPGA_PL2_ENABLE       {0}  ] $cell
    set_property -dict [list CONFIG.PSU__FPGA_PL3_ENABLE       {0}  ] $cell

    set axi_prop ""
    lappend axi_prop M_AXI_HPM0_FPD {memport "M_AXI_GP" sptag ""     memory "" is_range "false"}
    lappend axi_prop M_AXI_HPM1_FPD {memport "M_AXI_GP" sptag ""     memory "" is_range "false"}
    lappend axi_prop S_AXI_HPC0_FPD {memport "S_AXI_HP" sptag "HPC0" memory "" is_range "false"}
    lappend axi_prop S_AXI_HPC1_FPD {memport "S_AXI_HP" sptag "HPC1" memory "" is_range "false"}
    lappend axi_prop S_AXI_HP0_FPD  {memport "S_AXI_HP" sptag "HP0"  memory "" is_range "false"}
    lappend axi_prop S_AXI_HP1_FPD  {memport "S_AXI_HP" sptag "HP1"  memory "" is_range "false"}
    lappend axi_prop S_AXI_HP2_FPD  {memport "S_AXI_HP" sptag "HP2"  memory "" is_range "false"}
    lappend axi_prop S_AXI_HP3_FPD  {memport "S_AXI_HP" sptag "HP3"  memory "" is_range "false"}
    set_property PFM.AXi_PORT $axi_prop $cell

    return $cell
}

proc add_fan_enable { zynq_ultra_ps port_name prefix} {
    variable USING_IP_VLNV_LIST
    set ip_name xlslice

    if { [dict exists $USING_IP_VLNV_LIST $ip_name] != 1} {
        catch {
	    common::send_gid_msg -ssname BD::TCL -id 3001 -severity "ERROR" \
		[format "\"%s\" not found in the USING_IP_VLNV_LIST." $ip_name]
	}
	return ""
    }

    if { $port_name eq "" } {
        set port_name FAN_EN
    }

    if { $prefix eq "" } {
	set prefix ttc0
    }
    
    set cell_name     [format "%s_slice" $prefix   ]
    set net_name_din  [format "%s_din"   $cell_name]
    set net_name_dout [format "%s_dout"  $cell_name]

    set_property -dict [list CONFIG.PSU__TTC0__WAVEOUT__ENABLE {1} ] $zynq_ultra_ps
    set_property -dict [list CONFIG.PSU__TTC0__WAVEOUT__IO {EMIO}  ] $zynq_ultra_ps

    set cell [create_bd_cell -type ip -vlnv [dict get $USING_IP_VLNV_LIST $ip_name] $cell_name]

    set_property -dict [ list CONFIG.DIN_FROM {2} CONFIG.DIN_TO {2} CONFIG.DIN_WIDTH {3} ] $cell

    create_bd_port -dir O -from 0 -to 0 $port_name
    connect_bd_net -net $net_name_dout [get_bd_pins $cell/Dout] [get_bd_ports $port_name] 
    connect_bd_net -net $net_name_din  [get_bd_pins $cell/Din ] [get_bd_pins $zynq_ultra_ps/emio_ttc0_wave_o]
}

proc create_processor_system_reset { clock_net reset_net locked_net prefix } {

    variable USING_IP_VLNV_LIST
    set ip_name   proc_sys_reset
    set cell_name [format "%s" $prefix]

    if { [dict exists $USING_IP_VLNV_LIST $ip_name] != 1} {
        catch {
	    common::send_gid_msg -ssname BD::TCL -id 3001 -severity "ERROR" \
		[format "\"%s\" not found in the USING_IP_VLNV_LIST." $ip_name]
	}
	return ""
    }

    set cell [create_bd_cell -type ip -vlnv [dict get $USING_IP_VLNV_LIST $ip_name] $cell_name]
    if { $clock_net  ne "" } {
        connect_bd_net -net $clock_net  [get_bd_pins $cell/slowest_sync_clk]
    }
    if { $reset_net  ne "" } {
        connect_bd_net -net $reset_net  [get_bd_pins $cell/ext_reset_in    ]
    }
    if { $locked_net ne "" } {
        connect_bd_net -net $locked_net [get_bd_pins $cell/dcm_locked      ]
    }
    return $cell
}

proc create_clock_with_reset { clock_info prefix } {

    variable USING_IP_VLNV_LIST
    set ip_name         clk_wiz
    set cell_name       [format "%s_clk_wiz"    $prefix]
    set locked_net_name [format "%s_clk_locked" $prefix]
    set clk_prop        [dict create] 

    if { [dict exists $USING_IP_VLNV_LIST $ip_name] != 1} {
        catch {
	    common::send_gid_msg -ssname BD::TCL -id 3001 -severity "ERROR" \
		[format "\"%s\" not found in the USING_IP_VLNV_LIST." $ip_name]
	}
	return ""
    }
    set clk_wiz [create_bd_cell -type ip -vlnv [dict get $USING_IP_VLNV_LIST $ip_name] $cell_name]

    if { [dict exists $clock_info clk_in1] } {
	set clock_in_info [dict get $clock_info clk_in1]
	if { [dict exists $clock_in_info net] } {
            set clock_in_net [dict get $clock_in_info net]
	} else {
            set clock_in_net [format "%s_clk_in" $prefix]
	}
        if { [dict exists $clock_in_info port] } {
            set clock_in_port [dict get $clock_in_info port]
	    connect_bd_net -net $clock_in_net [get_bd_pins $clk_wiz/clk_in1] [get_bd_pins $clock_in_port]
	} else {
	    connect_bd_net -net $clock_in_net [get_bd_pins $clk_wiz/clk_in1]
	}
    }
	    
    if { [dict exists $clock_info reset] } {
	set reset_info [dict get $clock_info reset]
	if { [dict exists $reset_info polarity] } {
	    set reset_polarity [dict get $reset_info polarity]
	} else {
	    set reset_polarity {High}
	}
	if { $reset_polarity eq {Low} } {
            set_property -dict [list CONFIG.RESET_TYPE {ACTIVE_LOW} ] $clk_wiz
	}
	if { [dict exists $reset_info net] } {
	    set reset_net_name [dict get $reset_info net ]
	} else {
	    set reset_net_name [format "%s_reset" $prefix]
	}
	if { [dict exists $reset_info port] } {
	    set reset_port [dict get $reset_info port]
            connect_bd_net -net $reset_net_name [get_bd_pins $clk_wiz/resetn] [get_bd_pins $reset_port]
	} else {
            connect_bd_net -net $reset_net_name [get_bd_pins $clk_wiz/resetn]
	}
    }

    foreach i {1 2 3 4 5 6 7} {
	set port [format "clk_out%d" $i]
        if { [dict exists $clock_info $port] } {
	    set port_info [dict get $clock_info $port]
	    set freq_hz   [dict get $port_info freq]
	    set freq_mhz  [expr $freq_hz / 1000000.0]
	    set port_prop [list [format "CONFIG.CLKOUT%d_USED" $i] {true}]
	    lappend port_prop   [format "CONFIG.CLKOUT%d_REQUESTED_OUT_FREQ" $i] $freq_mhz
            if { [dict exists $port_info net ] } {
	        set clock_net_name [dict get $port_info net]
	    } else {
                set clock_net_name [format "%s_%s" $prefix $port]
	    }
	    if { [dict exists $port_info name] } {
		set port_name [dict get $port_info name]
		lappend port_prop [format "CONFIG.CLK_OUT%d_PORT" $i] $port_name
	    } else {
		set port_name $port
	    }		
	    set_property -dict $port_prop $clk_wiz
            connect_bd_net -net $clock_net_name [get_bd_pins $clk_wiz/$port_name]
	    set reset_cell_name [format "%s_reset_%d" $prefix $i]
            set reset_cell [create_processor_system_reset $clock_net_name $reset_net_name $locked_net_name $reset_cell_name]
	    if { [dict exists $port_info is_default] } {
		set is_default [dict get $port_info is_default]
	    } else {
		set is_default "false"
	    }
	    if { [dict exists $port_info id ] } {
	        dict set clk_prop $port_name [dict create]
	        dict set clk_prop $port_name id             [dict get $port_info id]
	        dict set clk_prop $port_name is_default     $is_default
	        dict set clk_prop $port_name proc_sys_reset $reset_cell
	        dict set clk_prop $port_name status         "fixed"
	        dict set clk_prop $port_name freq_hz        $freq_hz
	    }
	}
    }
    set_property PFM.CLOCK $clk_prop $clk_wiz

    connect_bd_net -net $locked_net_name [get_bd_pins $clk_wiz/locked]

    return $clk_wiz
}

proc create_interrupt_controller { zynq_ultra_ps master_port master_clk prefix} {

    variable USING_IP_VLNV_LIST
    set ip_name   axi_intc
    set cell_name [format "%s"     $prefix]
    set irq_name  [format "%s_irq" $prefix]

    if { [dict exists $USING_IP_VLNV_LIST $ip_name] != 1} {
        catch {
	    common::send_gid_msg -ssname BD::TCL -id 3001 -severity "ERROR" \
		[format "\"%s\" not found in the USING_IP_VLNV_LIST." $ip_name]
	}
	return ""
    }
    set cell [create_bd_cell -type ip -vlnv [dict get $USING_IP_VLNV_LIST $ip_name] $cell_name]
    set_property -dict [list CONFIG.C_IRQ_CONNECTION {1} ] $cell

    set config ""
    lappend config Clk_master [list $master_clk]
    lappend config Clk_slave  {Auto}
    lappend config Clk_xvar   {Auto}
    lappend config Master     [list $zynq_ultra_ps/$master_port]
    lappend config Slave      [list $cell/s_axi]
    lappend config ddr_seg    {Auto}
    lappend config intc_ip    {New AXI Interconnect}
    lappend config master_apm {0}
    apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config $config [get_bd_intf_pins $cell/s_axi]

    connect_bd_net -net $irq_name [get_bd_pins $cell/irq] [get_bd_pins $zynq_ultra_ps/pl_ps_irq0]
    set_property PFM.IRQ {intr { id 0 range 32 }} $cell

    return $cell
}

# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }
  #
  # Make sure parentObj is hier blk
  #
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }
  #
  # Save current instance; Restore later
  #
  set oldCurInst [current_bd_instance .]
  #
  # Set parent object as current
  #
  current_bd_instance $parentObj
  #
  # Create instance: zynq_ultra_ps_e_0 and set properties
  #
  set zynq_ultra_ps_e_0 [create_zynq_ultra_ps "zynq_ultra_ps_e_0"]
  # 
  # Add FAN_EN
  #
  add_fan_enable $zynq_ultra_ps_e_0 "FAN_EN" "ttc0"
  # 
  # Add System Clock and Reset
  #
  set clock_info [dict create \
    reset    [dict create net  "pl_reset0" port $zynq_ultra_ps_e_0/pl_resetn0 polarity {Low} ] \
    clk_in1  [dict create net  "pl_clk0"   port $zynq_ultra_ps_e_0/pl_clk0] \
    clk_out1 [dict create name "clk_100" net "sys_clk_100" id "0" is_default "false" freq "100000000"] \
    clk_out2 [dict create name "clk_200" net "sys_clk_200" id "1" is_default "true"  freq "200000000"] \
    clk_out3 [dict create name "clk_400" net "sys_clk_300" id "2" is_default "false" freq "400000000"] \
  ]
  set sys_clk [create_clock_with_reset $clock_info "sys"]
  #
  # Add axi interrupt controller
  #
  set axi_intc_0 [create_interrupt_controller $zynq_ultra_ps_e_0 M_AXI_HPM0_LPD $sys_clk/clk_out2 "axi_intc_0"]
  #
  # Restore current instance
  #
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

