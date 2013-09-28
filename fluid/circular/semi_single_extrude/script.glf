# Pointwise V17.0 Journal file - Sun Sep 22 15:17:07 2013

package require PWI_Glyph 2.17.0

pw::Application setUndoMaximumLevels 5
pw::Application reset
pw::Application markUndoLevel {Journal Reset}

pw::Application clearModified

pw::Display resetView +Z
pw::Display resetView +Z
set _TMP(mode_1) [pw::Application begin Create]
  set _TMP(PW_1) [pw::SegmentSpline create]
  $_TMP(PW_1) addPoint {0 2.5e-4 0}
  $_TMP(PW_1) addPoint {0 1.0e-4 0}
  set _TMP(con_1) [pw::Connector create]
  $_TMP(con_1) addSegment $_TMP(PW_1)
  unset _TMP(PW_1)
  $_TMP(con_1) calculateDimension
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel {Create 2 Point Connector}

set _TMP(mode_2) [pw::Application begin Create]
  set _TMP(PW_2) [pw::SegmentSpline create]
  $_TMP(PW_2) delete
  unset _TMP(PW_2)
$_TMP(mode_2) abort
unset _TMP(mode_2)
unset _TMP(con_1)
pw::Display resetView +Z
set _CN(1) [pw::GridEntity getByName "con-1"]
set _TMP(PW_3) [pw::Collection create]
$_TMP(PW_3) set [list $_CN(1)]
$_TMP(PW_3) do setDimension 6
$_TMP(PW_3) delete
unset _TMP(PW_3)
pw::Application markUndoLevel {Dimension}

set _TMP(mode_3) [pw::Application begin Modify [list $_CN(1)]]
  set _TMP(PW_4) [$_CN(1) getDistribution 1]
  $_TMP(PW_4) setBeginSpacing 2.0000000000000002e-05
  unset _TMP(PW_4)
$_TMP(mode_3) end
unset _TMP(mode_3)
pw::Application markUndoLevel {Change Spacing(s)}

set _TMP(mode_4) [pw::Application begin Modify [list $_CN(1)]]
  set _TMP(PW_5) [$_CN(1) getDistribution 1]
  $_TMP(PW_5) setEndSpacing 4.0000000000000003e-05
  unset _TMP(PW_5)
$_TMP(mode_4) end
unset _TMP(mode_4)
pw::Application markUndoLevel {Change Spacing(s)}

set _TMP(PW_6) [pw::Collection create]
$_TMP(PW_6) set [list $_CN(1)]
$_TMP(PW_6) do setRenderAttribute PointMode All
$_TMP(PW_6) delete
unset _TMP(PW_6)
pw::Application markUndoLevel {Modify Entity Display}

set _TMP(mode_5) [pw::Application begin Create]
  set _TMP(PW_7) [pw::Edge createFromConnectors [list $_CN(1)]]
  set _TMP(edge_1) [lindex $_TMP(PW_7) 0]
  unset _TMP(PW_7)
  set _TMP(dom_1) [pw::DomainStructured create]
  $_TMP(dom_1) addEdge $_TMP(edge_1)
$_TMP(mode_5) end
unset _TMP(mode_5)
set _TMP(mode_6) [pw::Application begin ExtrusionSolver [list $_TMP(dom_1)]]
  $_TMP(mode_6) setKeepFailingStep true
  $_TMP(dom_1) setExtrusionSolverAttribute Mode Rotate
  set _DM(1) [pw::GridEntity getByName "dom-1"]
  $_TMP(dom_1) setExtrusionSolverAttribute RotateAxisStart {0 0 0}
  $_TMP(dom_1) setExtrusionSolverAttribute RotateAxisEnd [pwu::Vector3 add {0 0 0} {0 0 1}]
  $_TMP(dom_1) setExtrusionSolverAttribute RotateAngle 180
  $_TMP(mode_6) run 8
$_TMP(mode_6) end
unset _TMP(mode_6)
unset _TMP(dom_1)
unset _TMP(edge_1)
pw::Application markUndoLevel {Extrude, Rotate}

set _TMP(mode_7) [pw::Application begin Create]
  set _TMP(PW_8) [pw::SegmentSpline create]
  set _CN(2) [pw::GridEntity getByName "con-2"]
  set _CN(3) [pw::GridEntity getByName "con-3"]
  $_TMP(PW_8) addPoint [$_CN(1) getPosition -arc 1]
  $_TMP(PW_8) addPoint [$_CN(2) getPosition -arc 1]
  set _TMP(con_2) [pw::Connector create]
  $_TMP(con_2) addSegment $_TMP(PW_8)
  unset _TMP(PW_8)
  $_TMP(con_2) calculateDimension
$_TMP(mode_7) end
unset _TMP(mode_7)
pw::Application markUndoLevel {Create 2 Point Connector}

set _TMP(mode_8) [pw::Application begin Create]
  set _TMP(PW_9) [pw::SegmentSpline create]
  set _CN(4) [pw::GridEntity getByName "con-5"]
  $_TMP(PW_9) delete
  unset _TMP(PW_9)
$_TMP(mode_8) abort
unset _TMP(mode_8)
unset _TMP(con_2)
set _TMP(PW_10) [pw::Collection create]
$_TMP(PW_10) set [list $_CN(4)]
$_TMP(PW_10) do setDimension 6
$_TMP(PW_10) delete
unset _TMP(PW_10)
pw::Application markUndoLevel {Dimension}

pw::Application setGridPreference Unstructured
set _TMP(PW_11) [pw::DomainUnstructured createFromConnectors -reject _TMP(unusedCons)  [list $_CN(2) $_CN(4)]]
unset _TMP(unusedCons)
unset _TMP(PW_11)
pw::Application markUndoLevel {Assemble Domains}

set _TMP(mode_9) [pw::Application begin Create]
  set _DM(2) [pw::GridEntity getByName "dom-2"]
  set _TMP(PW_12) [pw::FaceUnstructured createFromDomains [list $_DM(2)]]
  set _TMP(face_1) [lindex $_TMP(PW_12) 0]
  unset _TMP(PW_12)
  set _TMP(PW_13) [pw::FaceStructured createFromDomains [list $_DM(1)]]
  set _TMP(face_2) [lindex $_TMP(PW_13) 0]
  unset _TMP(PW_13)
  set _TMP(extStrBlock_1) [pw::BlockStructured create]
  $_TMP(extStrBlock_1) addFace $_TMP(face_2)
  set _TMP(extExtBlock_1) [pw::BlockExtruded create]
  $_TMP(extExtBlock_1) addFace $_TMP(face_1)
$_TMP(mode_9) end
unset _TMP(mode_9)
set _TMP(mode_10) [pw::Application begin ExtrusionSolver [list $_TMP(extStrBlock_1) $_TMP(extExtBlock_1)]]
  $_TMP(mode_10) setKeepFailingStep true
  $_TMP(extStrBlock_1) setExtrusionSolverAttribute Mode Translate
  $_TMP(extExtBlock_1) setExtrusionSolverAttribute Mode Translate
  $_TMP(extStrBlock_1) setExtrusionSolverAttribute TranslateDirection {1 0 0}
  $_TMP(extExtBlock_1) setExtrusionSolverAttribute TranslateDirection {1 0 0}
  set _BL(1) [pw::GridEntity getByName "blk-1"]
  set _BL(2) [pw::GridEntity getByName "blk-2"]
  $_TMP(extStrBlock_1) setExtrusionSolverAttribute TranslateDirection {0 0 1}
  $_TMP(extExtBlock_1) setExtrusionSolverAttribute TranslateDirection {0 0 1}
  $_TMP(extStrBlock_1) setExtrusionSolverAttribute TranslateDistance 0.01
  $_TMP(extExtBlock_1) setExtrusionSolverAttribute TranslateDistance 0.01
  $_TMP(mode_10) run 100
$_TMP(mode_10) end
unset _TMP(mode_10)
unset _TMP(extExtBlock_1)
unset _TMP(extStrBlock_1)
unset _TMP(face_1)
unset _TMP(face_2)
pw::Application markUndoLevel {Extrude, Translate}

pw::Application setCAESolver {ANSYS FLUENT} 3
pw::Application markUndoLevel {Select Solver}

set _DM(3) [pw::GridEntity getByName "dom-6"]
set _TMP(PW_14) [pw::BoundaryCondition getByName "Unspecified"]
set _DM(4) [pw::GridEntity getByName "dom-3"]
set _DM(5) [pw::GridEntity getByName "dom-4"]
set _DM(6) [pw::GridEntity getByName "dom-5"]
set _DM(7) [pw::GridEntity getByName "dom-7"]
set _DM(8) [pw::GridEntity getByName "dom-9"]
set _DM(9) [pw::GridEntity getByName "dom-10"]
set _TMP(PW_15) [pw::BoundaryCondition create]
pw::Application markUndoLevel {Create BC}

set _TMP(PW_16) [pw::BoundaryCondition getByName "bc-2"]
unset _TMP(PW_15)
$_TMP(PW_16) apply [list [list $_BL(2) $_DM(2)] [list $_BL(1) $_DM(1)]]
pw::Application markUndoLevel {Set BC}

set _TMP(PW_17) [pw::BoundaryCondition create]
pw::Application markUndoLevel {Create BC}

set _TMP(PW_18) [pw::BoundaryCondition getByName "bc-3"]
unset _TMP(PW_17)
$_TMP(PW_16) setName "inlet"
pw::Application markUndoLevel {Name BC}

$_TMP(PW_16) setPhysicalType {Velocity Inlet}
pw::Application markUndoLevel {Change BC Type}

$_TMP(PW_18) setName "outlet"
pw::Application markUndoLevel {Name BC}

$_TMP(PW_18) setPhysicalType {Pressure Outlet}
pw::Application markUndoLevel {Change BC Type}

$_TMP(PW_18) apply [list [list $_BL(2) $_DM(9)] [list $_BL(1) $_DM(7)]]
pw::Application markUndoLevel {Set BC}

set _TMP(PW_19) [pw::BoundaryCondition create]
pw::Application markUndoLevel {Create BC}

set _TMP(PW_20) [pw::BoundaryCondition getByName "bc-4"]
unset _TMP(PW_19)
set _TMP(PW_21) [pw::BoundaryCondition create]
pw::Application markUndoLevel {Create BC}

set _TMP(PW_22) [pw::BoundaryCondition getByName "bc-5"]
unset _TMP(PW_21)
$_TMP(PW_20) setName "symmetry"
pw::Application markUndoLevel {Name BC}

$_TMP(PW_20) setPhysicalType {Symmetry}
pw::Application markUndoLevel {Change BC Type}

$_TMP(PW_22) setName "wall"
pw::Application markUndoLevel {Name BC}

$_TMP(PW_22) setPhysicalType {Wall}
pw::Application markUndoLevel {Change BC Type}

$_TMP(PW_22) apply [list [list $_BL(1) $_DM(5)]]
pw::Application markUndoLevel {Set BC}

$_TMP(PW_20) apply [list [list $_BL(2) $_DM(8)] [list $_BL(1) $_DM(4)] [list $_BL(1) $_DM(5)] [list $_BL(1) $_DM(6)]]
pw::Application markUndoLevel {Set BC}

$_TMP(PW_22) apply [list [list $_BL(1) $_DM(5)]]
pw::Application markUndoLevel {Set BC}

unset _TMP(PW_14)
unset _TMP(PW_16)
unset _TMP(PW_18)
unset _TMP(PW_20)
unset _TMP(PW_22)
set _TMP(PW_23) [pw::VolumeCondition create]
pw::Application markUndoLevel {Create VC}

$_TMP(PW_23) apply [list $_BL(2) $_BL(1)]
pw::Application markUndoLevel {Set VC}

$_TMP(PW_23) setName "fluid"
pw::Application markUndoLevel {Name VC}

$_TMP(PW_23) setPhysicalType {Fluid}
pw::Application markUndoLevel {Change VC Type}

unset _TMP(PW_23)
set _TMP(mode_10) [pw::Application begin CaeExport [pw::Entity sort [list $_BL(1) $_BL(2)]]]
  $_TMP(mode_10) initialize -type CAE {/nfs/mohr/sva/work/rymalc/bin/pointwise/fluid/circular/semi_single_extrude/case.cas}
  if {![$_TMP(mode_10) verify]} {
    error "Data verification failed"
  }
  $_TMP(mode_10) write
$_TMP(mode_10) end
unset _TMP(mode_10)
pw::Application save {/nfs/mohr/sva/work/rymalc/bin/pointwise/fluid/circular/semi_single_extrude/pw.pw}
