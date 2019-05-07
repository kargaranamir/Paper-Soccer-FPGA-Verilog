
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name top_v2 -dir "E:/you can find any information about courses here/my courses/fpga competition/ISE_directory/TOP_v2/top_v2/planAhead_run_4" -part xc6slx9tqg144-3
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "E:/you can find any information about courses here/my courses/fpga competition/ISE_directory/TOP_v2/top_v2/TOP.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/you can find any information about courses here/my courses/fpga competition/ISE_directory/TOP_v2/top_v2} }
set_property target_constrs_file "TOP.ucf" [current_fileset -constrset]
add_files [list {TOP.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "E:/you can find any information about courses here/my courses/fpga competition/ISE_directory/TOP_v2/top_v2/TOP.ncd"
if {[catch {read_twx -name results_1 -file "E:/you can find any information about courses here/my courses/fpga competition/ISE_directory/TOP_v2/top_v2/TOP.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"E:/you can find any information about courses here/my courses/fpga competition/ISE_directory/TOP_v2/top_v2/TOP.twx\": $eInfo"
}
