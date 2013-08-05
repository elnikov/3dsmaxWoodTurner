macroScript Wood_turner
			category: "!z209 scripts"
			tooltip: "Turn and UVW map the woods"
			buttontext: "Wood_Turner"
			Icon:#("UVWUnwrapTools",7)

(
rollout turnMap_roll "WOOD TURNER 1.0" (

	group "UVW Map settings" (
	--	edittext uvw_width "Width:" fieldWidth:100 labelOnTop:false 
	--	edittext uvw_length "Length:" fieldWidth:100 labelOnTop:false 
		edittext uvw_height "Height:" fieldWidth:100 labelOnTop:false text:"4000"  	
	)	
	
	group "Cylinder settings" (
		edittext cylinder_sides "Sides:" fieldWidth:100 labelOnTop:false text:"18"
	)	
	
	group "Rotate settings" (		
        label lbl "Rotate direction" align:#left		
		checkbox chk_x "X" across:3 align:#left checked:True 
		checkbox chk_y"Y" align:#center
		checkbox chk_z "Z" align:#right
		checkbox random_rotate "Random rotate" align:#left checked:true
	)
	
	group "Final settings" (
		checkbox rotate_only "Rotate only" align:#left checked:false
		button btn_go  "Go!" width:150	
		button btn_undo  "UnDo" width:150	
	)
	

	on btn_go pressed do(	
		if rotate_only.state !=true then (
		modPanel.addModToSelection (Edit_Poly ()) ui:on
			
		subobjectLevel = 4
		$.modifiers[#Edit_Poly].SetSelection #Face #{}
-- 		$.modifiers[#Edit_Poly].Select #Face #{14}
		$.modifiers[#Edit_Poly].Select #Face #{1..  cylinder_sides.text as integer}
			
		$.modifiers[#Edit_Poly].SetOperation #SetMaterial
		$.modifiers[#Edit_Poly].materialIDToSet = 0
		$.modifiers[#Edit_Poly].Commit ()
			
		actionMan.executeAction 0 "40044"  -- Selection: Select Invert
		$.modifiers[#Edit_Poly].SetSelection #Face #{19..20}
			
		$.modifiers[#Edit_Poly].SetOperation #SetMaterial
		$.modifiers[#Edit_Poly].materialIDToSet = 1
		$.modifiers[#Edit_Poly].Commit ()		
	
			
		actionMan.executeAction 0 "40021"  -- Selection: Select All
		$.modifiers[#Edit_Poly].SetSelection #Face #{1..20}
		modPanel.addModToSelection (Uvwmap ()) ui:on
		$.modifiers[#UVW_Map].maptype = 1
		$.modifiers[#UVW_Map].cap = on
		$.modifiers[#UVW_Map].height =  uvw_height.text as float	
		
		$.material = meditMaterials[1] 

		actionMan.executeAction 0 "50002"  -- Tools: Select and Rotate
		toolMode.coordsys #view 
	)
		
		rand = random 0 360
		if random_rotate.state ==true then(
			if chk_x.state == true then (	
				rot_box = eulerangles rand 0 0
			--	rotate $ (angleaxis (random 0 360) [1,0,0])					
			)
			else  if chk_y.state == true then (	
				rot_box = eulerangles  0 rand 0				
			--	rotate $ (angleaxis (random 0 360) [0,1,0])	
			)
			else (	
				rot_box = eulerangles  0  0 rand
			--	rotate $ (angleaxis (random 0 360) [0,0,1])	
			)
		)	
		
        rotate $ rot_box

		subobjectLevel = 0	

	)	
	
	on btn_undo pressed do(	
		rand
		if random_rotate.state ==true then(
			if chk_x.state == true then (	
				rot_box = eulerangles -rand 0 0
			)
			else  if chk_y.state == true then (	
				rot_box = eulerangles  0 -rand 0				
			)
			else (	
				rot_box = eulerangles  0  0 -rand
			)
		rotate $ rot_box	
		)			
       
		if rotate_only.state == false then ( 
			deleteModifier $ 1
			deleteModifier $ 1	
		)			
	)
	

	on chk_x changed state do(
		if state == true then(
			chk_y.state = false
			chk_z.state = false
		)else(
			chk_x.state = true
		)
	)
	
	on chk_y changed state do(
		if state == true then(
			chk_z.state = false
			chk_x.state = false
		)else(
			chk_y.state = true
		)
	)
	
	on chk_z changed state do(
		if state == true then(
			chk_x.state = false
			chk_y.state = false
		)else(
			chk_z.state = true
		)
	)	

)
global rand;
createDialog turnMap_roll  180 300
)