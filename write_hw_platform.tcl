#
# write_hw_platform.tcl  Tcl script for write_hw_platform
#
#
# Open Project
#
set project_directory       [file dirname [info script]]
set project_name            "kv260_sample_platform"
#
#
#
if {[info exists project_name     ] == 0} {
    set project_name        "project"
}
if {[info exists project_directory] == 0} {
    set project_directory   [pwd]
}
open_project [file join $project_directory $project_name]
#
# Setting platform properties
#
set_property "platform.design_intent.embedded"        {true} [current_project]
set_property "platform.design_intent.datacenter"     {false} [current_project]
set_property "platform.design_intent.server_managed" {false} [current_project]
set_property "platform.design_intent.external_host"  {false} [current_project]
set_property "platform.default_output_type"        {sd_card} [current_project]
set_property "platform.uses_pr"                      {false} [current_project]
#
# Write pre-synthesis expandable XSA
#
write_hw_platform -hw     -force -file [file join "." [format "%s_hw.xsa"    $project_name]]
write_hw_platform -hw_emu -force -file [file join "." [format "%s_hwemu.xsa" $project_name]]
#
# Close Project
#
close_project
