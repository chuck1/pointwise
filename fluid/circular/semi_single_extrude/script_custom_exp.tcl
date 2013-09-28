# Pointwise V17.0 Journal file - Sun Sep 22 15:17:07 2013

package require PWI_Glyph 2.17.0

pw::Application setUndoMaximumLevels 5
pw::Application reset
pw::Application markUndoLevel {Journal Reset}

pw::Application clearModified


source "/nfs/mohr/sva/work/rymalc/bin/pointwise/proc.glf"

#
# -----------------------------------------------------------------------------------------------------
#

set r_in        1.25e-4
set r_out       2.50e-4
set dim_out     5
set delta_in    2.0e-5
set delta_out   4.0e-5

set steps       12
set angle       180
set dim_core    6

set axis0 {0 0 0}
set axis1 {0 0 1}


#
# -----------------------------------------------------------------------------------------------------
#
set pt_in  [list 0 $r_in  0]
set pt_out [list 0 $r_out 0]

# outer spoke
set con_outer [createTwoPtLineCon $pt_out $pt_in $dim_out $delta_out $delta_in]



# extrude rotate
set ret [createExtRot $con_outer $axis0 $axis1 $angle $steps]
set dom_outer [lindex $ret 0]
puts "return $ret"


#set _CN(2) [pw::GridEntity getByName "con-2"]
set _CN(2) [lindex $ret 2]

set _CN(3) [pw::GridEntity getByName "con-3"]

set con_inner [createTwoPtLineCon [$con_outer getPosition -arc 1] [$_CN(2) getPosition -arc 1] $dim_core]

set _CN(4) [pw::GridEntity getByName "con-5"]

# core domain
set dom_inner [createDomUnstr [list $_CN(2) $con_inner]]


# extrude translate
set ret [createExtTrans [list $dom_inner] [list $dom_outer] [list 0 0 1] 0.01]


#set _TMP(mode_9) [pw::Application begin Create]
#
#	set face_list_inner [pw::FaceUnstructured createFromDomains [list $dom_inner]]
#	set face_inner      [lindex $face_list_inner 0]
#	
#	set face_list_outer [pw::FaceStructured createFromDomains [list $dom_outer]]
#	set face_outer      [lindex $face_list_outer 0]
#	
#	set _TMP(extStrBlock_1) [pw::BlockStructured create]
#	$_TMP(extStrBlock_1) addFace $face_outer
#	
#	set _TMP(extExtBlock_1) [pw::BlockExtruded create]
#	$_TMP(extExtBlock_1) addFace $face_inner
#
#$_TMP(mode_9) end
#unset _TMP(mode_9)
#
#
#set _TMP(mode_10) [pw::Application begin ExtrusionSolver [list $_TMP(extStrBlock_1) $_TMP(extExtBlock_1)]]
#	$_TMP(mode_10) setKeepFailingStep true
#	
#	$_TMP(extStrBlock_1) setExtrusionSolverAttribute Mode Translate
#	$_TMP(extExtBlock_1) setExtrusionSolverAttribute Mode Translate
#	$_TMP(extStrBlock_1) setExtrusionSolverAttribute TranslateDirection {1 0 0}
#	$_TMP(extExtBlock_1) setExtrusionSolverAttribute TranslateDirection {1 0 0}
#
#	$_TMP(extStrBlock_1) setExtrusionSolverAttribute TranslateDirection {0 0 1}
#	$_TMP(extExtBlock_1) setExtrusionSolverAttribute TranslateDirection {0 0 1}
#	$_TMP(extStrBlock_1) setExtrusionSolverAttribute TranslateDistance 0.01
#	$_TMP(extExtBlock_1) setExtrusionSolverAttribute TranslateDistance 0.01
#	
#	$_TMP(mode_10) run 100
#	$_TMP(mode_10) end
#unset _TMP(mode_10)
#unset _TMP(extExtBlock_1)
#unset _TMP(extStrBlock_1)
#pw::Application markUndoLevel {Extrude, Translate}



	
set _BL(1) [pw::GridEntity getByName "blk-1"]
set _BL(2) [pw::GridEntity getByName "blk-2"]
	





#----------------------------------
pw::Application setCAESolver {ANSYS FLUENT} 3
pw::Application markUndoLevel {Select Solver}


#--------------------------
set _DM(3) [pw::GridEntity getByName "dom-6"]
set _DM(4) [pw::GridEntity getByName "dom-3"]
set _DM(5) [pw::GridEntity getByName "dom-4"]
set _DM(6) [pw::GridEntity getByName "dom-5"]
set _DM(7) [pw::GridEntity getByName "dom-7"]
set _DM(8) [pw::GridEntity getByName "dom-9"]
set _DM(9) [pw::GridEntity getByName "dom-10"]
#--------------------------

proc createBC {name listPairs type} {
	set bc [pw::BoundaryCondition create]
	$bc setName $name
	$bc setPhysicalType $type
	$bc apply $listPairs
	
	return $bc
}

set _TMP(PW_14) [pw::BoundaryCondition getByName "Unspecified"]


set bc_inlet  [pw::BoundaryCondition create]
set bc_outlet [pw::BoundaryCondition create]
set bc_sym    [pw::BoundaryCondition create]
set bc_wall   [pw::BoundaryCondition create]



$bc_inlet setName "inlet"
$bc_inlet apply [list [list $_BL(2) $dom_inner] [list $_BL(1) $dom_outer]]
$bc_inlet setPhysicalType {Velocity Inlet}



$bc_outlet setName "outlet"
$bc_outlet setPhysicalType {Pressure Outlet}
$bc_outlet apply [list [list $_BL(2) $_DM(9)] [list $_BL(1) $_DM(7)]]



$bc_sym   setName "symmetry"
$bc_sym   setPhysicalType {Symmetry}
$bc_sym   apply [list [list $_BL(2) $_DM(8)] [list $_BL(1) $_DM(4)] [list $_BL(1) $_DM(6)]]


$bc_wall   setName "wall"
$bc_wall   setPhysicalType {Wall}
$bc_wall   apply [list [list $_BL(1) $_DM(5)]]

#----------------------------------
set vc_fluid [pw::VolumeCondition create]
$vc_fluid   apply [list $_BL(2) $_BL(1)]
$vc_fluid   setName "fluid"
$vc_fluid   setPhysicalType {Fluid}

# export
set _TMP(mode_10) [pw::Application begin CaeExport [pw::Entity sort [list $_BL(1) $_BL(2)]]]
#  $_TMP(mode_10) initialize -type CAE {/nfs/mohr/sva/work/rymalc/bin/pointwise/fluid/circular/semi_single_extrude/case.cas}
  $_TMP(mode_10) initialize -type CAE {case.cas}
  if {![$_TMP(mode_10) verify]} {
    error "Data verification failed"
  }
  $_TMP(mode_10) write
$_TMP(mode_10) end
unset _TMP(mode_10)

# save
#pw::Application save {/nfs/mohr/sva/work/rymalc/bin/pointwise/fluid/circular/semi_single_extrude/pw.pw}
pw::Application save {pw.pw}

# view
pw::Display resetView +Z

