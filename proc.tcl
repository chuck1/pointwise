proc createExtRot {con axis0 axis1 angle steps} {
	set creator [pw::Application begin Create]
	set edgelist [pw::Edge createFromConnectors [list $con]]
	set edge [lindex $edgelist 0]
	
	puts "create from connector $con"
	puts "create from edge $edge"
	
	set dom [pw::DomainStructured create]
	$dom addEdge $edge
	
	$creator end

	set extruder [pw::Application begin ExtrusionSolver [list $dom]]
	
	$extruder setKeepFailingStep true

	$dom setExtrusionSolverAttribute Mode Rotate
	$dom setExtrusionSolverAttribute RotateAxisStart $axis0
	$dom setExtrusionSolverAttribute RotateAxisEnd [pwu::Vector3 add $axis0 $axis1]
	$dom setExtrusionSolverAttribute RotateAngle $angle
	
	$extruder run $steps
	
	$extruder end
	
	set ret [list $dom]
	
	set a 1
	while {$a <= [$dom getEdgeCount]} {
		set edge [$dom getEdge $a]
	
		puts "edge $edge"
	
		set b 1
		while {$b <= [$edge getConnectorCount]} {
			set con [$edge getConnector $b]
			
			lappend ret {*}$con
			
			puts "  connector $con"
			
			set c 1
			while {$c <= [$con getSegmentCount]} {
				set seg [$con getSegment $c]

				puts "    segment $seg"

				set c [expr $c + 1]
			}
			
			set begin [$con getNode Begin]
			set end [$con getNode End]
			
			set point [$begin getPoint]			

			puts "    begin $begin"
			puts "      point $point"
			puts "    end $end"
			
			set b [expr $b + 1]
		}
		
		set a [expr $a + 1]
	}
	
	return $ret
}

proc createDomUnstr { conlist } {
	pw::Application setGridPreference Unstructured
	set dom [pw::DomainUnstructured createFromConnectors -reject _TMP(unusedCons) $conlist]
	return $dom
}

proc createTwoPtLineCon {pt0 pt1 dim {delta0 0.0} {delta1 0.0}} {
	set creator [pw::Application begin Create]
	set con [pw::Connector create]
	
	set seg [pw::SegmentSpline create]
	$seg addPoint $pt0
	$seg addPoint $pt1
  	
	$con addSegment $seg

	$con setDimension $dim
	$con setRenderAttribute PointMode All

	if {$delta0 > 0.0} {
		[$con getDistribution 1] setEndSpacing $delta0
	}

	if {$delta1 > 0.0} {
		[$con getDistribution 1] setBeginSpacing $delta1
	}

	$creator end
	return $con
}


proc createExtTrans { dom_list_unstr dom_list_str direction distance } {
	
	
	set creator [pw::Application begin Create]
		# unstructured
	        set face_list_unstr [pw::FaceUnstructured createFromDomains $dom_list_unstr]
		
		set extExtBlock     [pw::BlockExtruded create]
		
		foreach face $face_list_unstr {
			$extExtBlock addFace $face
		}

		# structured
		set face_list_str   [pw::FaceStructured createFromDomains $dom_list_str]
		
	        set extStrBlock     [pw::BlockStructured create]
		
		foreach face $face_list_str {
			$extStrBlock addFace $face
		}
		
	$creator end
	
	set extruder [pw::Application begin ExtrusionSolver [list $extStrBlock $extExtBlock]]
	        
		$extruder setKeepFailingStep true
		
	        $extStrBlock setExtrusionSolverAttribute Mode Translate
       	        $extStrBlock setExtrusionSolverAttribute TranslateDirection $direction
		$extStrBlock setExtrusionSolverAttribute TranslateDistance $distance



	        $extExtBlock setExtrusionSolverAttribute Mode Translate
		$extExtBlock setExtrusionSolverAttribute TranslateDirection $direction
		$extExtBlock setExtrusionSolverAttribute TranslateDistance $distance
		
		$extruder run 100
	
	$extruder end




	set a 1
	while {$a <= [$dom getEdgeCount]} {
		set edge [$dom getEdge $a]
	
		puts "edge $edge"
	
		set b 1
		while {$b <= [$edge getConnectorCount]} {
			set con [$edge getConnector $b]
			
			lappend ret {*}$con
			
			puts "  connector $con"
			
			set c 1
			while {$c <= [$con getSegmentCount]} {
				set seg [$con getSegment $c]

				puts "    segment $seg"

				set c [expr $c + 1]
			}
			
			set begin [$con getNode Begin]
			set end [$con getNode End]
			
			set point [$begin getPoint]			

			puts "    begin $begin"
			puts "      point $point"
			puts "    end $end"
			
			set b [expr $b + 1]
		}
		
		set a [expr $a + 1]
	}
}	








