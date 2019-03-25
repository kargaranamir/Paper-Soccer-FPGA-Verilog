
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name top_v2 -dir "E:/you can find any information about courses here/my courses/fpga competition/ISE_directory/TOP_v2/top_v2/planAhead_run_3" -part xc6slx9tqg144-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "E:/you can find any information about courses here/my courses/fpga competition/ISE_directory/TOP_v2/top_v2/TOP.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/you can find any information about courses here/my courses/fpga competition/ISE_directory/TOP_v2/top_v2} }
set_property target_constrs_file "TOP.ucf" [current_fileset -constrset]
add_files [list {TOP.ucf}] -fileset [get_property constrset [current_run]]
link_design
