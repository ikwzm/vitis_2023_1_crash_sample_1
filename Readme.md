AMD Vitis 2023.1 Crash Sample 1
=====================================================================

### Environment

#### WSL

```console
PS C:\Users\xxxx> wsl --version
WSL バージョン: 1.2.5.0
カーネル バージョン: 5.15.90.1
WSLg バージョン: 1.0.51
MSRDC バージョン: 1.2.3770
Direct3D バージョン: 1.608.2-61064218
DXCore バージョン: 10.0.25131.1002-220531-1700.rs-onecore-base2-hyp
Windows バージョン: 10.0.19045.2965
PS C:\Users\xxxx> wsl -l -v
  NAME      STATE           VERSION
* Ubuntu    Running         1
```

#### AMD Vivado 2023.1

```console
shell$ vivado -version
vivado v2023.1 (64-bit)
Tool Version Limit: 2023.05
SW Build 3865809 on Sun May  7 15:04:56 MDT 2023
IP Build 3864474 on Sun May  7 20:36:21 MDT 2023
SharedData Build 3865790 on Sun May 07 13:33:03 MDT 2023
Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
```

### Build and Crash

#### Create Project

```console
shell$ vivado -mode batch -source create_project.tcl -log create_project.log
```
or

```
Vivado > Tools > Run Tcl Script... > create_project.tcl
```

#### Implementation

```console
shell$ vivado -mode batch -source implementation.tcl 

****** Vivado v2023.1 (64-bit)
  **** SW Build 3865809 on Sun May  7 15:04:56 MDT 2023
  **** IP Build 3864474 on Sun May  7 20:36:21 MDT 2023
  **** SharedData Build 3865790 on Sun May 07 13:33:03 MDT 2023
    ** Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
    ** Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.

source implementation.tcl
# set project_directory       [file dirname [info script]]
# set project_name            "kv260_sample_platform"
# if {[info exists project_name     ] == 0} {
#     set project_name        "project"
# }
# if {[info exists project_directory] == 0} {
#     set project_directory   [pwd]
# }
# open_project [file join $project_directory $project_name]
Scanning sources...
Finished scanning sources
INFO: [IP_Flow 19-234] Refreshing IP repositories
INFO: [IP_Flow 19-1704] No user IP repositories specified
INFO: [IP_Flow 19-2313] Loaded Vivado IP repository '/home/ichiro/Xilinx/Vivado/2023.1/data/ip'.
open_project: Time (s): cpu = 00:00:05 ; elapsed = 00:00:06 . Memory (MB): peak = 0.000 ; gain = 0.000 ; free physical = 21286 ; free virtual = 119776
# launch_runs synth_1 -job 4
WARNING: [Vivado 12-7122] Auto Incremental Compile:: No reference checkpoint was found in run synth_1. Auto-incremental flow will not be run, the standard flow will be run instead.
realloc(): invalid pointer
Abnormal program termination (6)
Please check '/home/ichiro/work/vitis_2023_1_crash_sample_1/hs_err_pid782.log' for details
```

