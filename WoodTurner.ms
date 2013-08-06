macroScript Wood_turner
			category: "!z209 scripts"
			tooltip: "Turn and UVW map the woods"
			buttontext: "Wood_Turner"
			Icon:#("UVWUnwrapTools",7)

(
rollout woodTurner_roll "WOOD TURNER 1.1" (

	group "UVW Map settings" (
		edittext uvw_height "Height:" fieldWidth:110 labelOnTop:false text:"4000"  	
	)	
	
	group "Cylinder settings" (
		edittext cylinder_sides "Sides:" fieldWidth:100 labelOnTop:false text:"18"
		edittext cylinder_segs "Segs:" fieldWidth:100 labelOnTop:false text:"1"
		button btn_getCylParam  "Get parameters" width:150	
	)

	group "Material settings" (
		edittext material_number "Material №:" fieldWidth:85 labelOnTop:false text:"1"
		edittext material_id1 "ID 1:" fieldWidth:120 labelOnTop:false text:"1"
		edittext material_id2 "ID 2:" fieldWidth:120 labelOnTop:false text:"2"
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
		label lbl_wrn1 "Внимание: Операция вращения" align:#left	
		label lbl_wrn2 "является неотменяемой." align:#left	
		label lbl_wrn3 "Не стоит нажимать Go!" align:#left	
		label lbl_wrn4 "несколько раз." align:#left
		button btn_go  "Go!" width:150	
		button btn_undo  "UnDo" width:150	
	)
	
	on btn_getCylParam  pressed do(
		try (
			cylinder_sides.text = $.sides as string
			cylinder_segs.text = $.heightsegs as string
		)
		catch (
			messagebox "Unknown selected object."
		)
	)

	on btn_go pressed do(	
		

		if rotate_only.state !=true then (
		modPanel.addModToSelection (Edit_Poly ()) ui:on
			
		subobjectLevel = 4
		$.modifiers[#Edit_Poly].SetSelection #Face #{}
-- 		$.modifiers[#Edit_Poly].Select #Face #{14}
		$.modifiers[#Edit_Poly].Select #Face #{1..  cylinder_sides.text as integer * cylinder_segs.text as integer}
			
		$.modifiers[#Edit_Poly].SetOperation #SetMaterial
		$.modifiers[#Edit_Poly].materialIDToSet = material_id1.text as integer - 1
		$.modifiers[#Edit_Poly].Commit ()
			
		actionMan.executeAction 0 "40044"  -- Selection: Select Invert
	--	$.modifiers[#Edit_Poly].SetSelection #Face #{cylinder_sides.text as integer + 1 .. cylinder_sides.text as integer + 2}
			
		$.modifiers[#Edit_Poly].SetOperation #SetMaterial
		$.modifiers[#Edit_Poly].materialIDToSet = material_id2.text as integer - 1
		$.modifiers[#Edit_Poly].Commit ()		
	
			
		actionMan.executeAction 0 "40021"  -- Selection: Select All
		$.modifiers[#Edit_Poly].SetSelection #Face #{1.. cylinder_sides.text as integer + 2}
		modPanel.addModToSelection (Uvwmap ()) ui:on
		$.modifiers[#UVW_Map].maptype = 1
		$.modifiers[#UVW_Map].cap = on
		$.modifiers[#UVW_Map].height =  uvw_height.text as float	
		
		$.material = meditMaterials[material_number.text as integer] 

		actionMan.executeAction 0 "50002"  -- Tools: Select and Rotate
		toolMode.coordsys #view 
	)
		
	
		if random_rotate.state ==true then(
		
			rand = random 0 360
			
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
			
			rotate $ rot_box
		)	       

		subobjectLevel = 0	
		
		undo_active = true
	)	
	
	on btn_undo pressed do(	
		if undo_active == true then (
			rand
			if random_rotate.state == true then(
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
		undo_active = false
	)
	

	on chk_x changed state do(
		if random_rotate.state == true then(
			if state == true then(
				chk_y.state = false
				chk_z.state = false
			)else(
				chk_x.state = true
			)
		)else(
			chk_x.state = false
		)
	)
	
	on chk_y changed state do(
		if random_rotate.state == true then(
			if state == true then(
				chk_z.state = false
				chk_x.state = false
			)else(
				chk_y.state = true
			)
		)else(
			chk_y.state = false
		)
	)
	
	on chk_z changed state do(
		if random_rotate.state == true then(
			if state == true then(
				chk_x.state = false
				chk_y.state = false
			)else(
				chk_z.state = true
			)
		)else(
			chk_z.state = false
		)
	)	
	
	on random_rotate changed state do(
		if state == true then(
			chk_y.state = false
			chk_z.state = false
			chk_x.state = true
		)else(
			chk_y.state = false
			chk_z.state = false
			chk_x.state = false
			rotate_only.state = false
		)
	)
	
	on rotate_only changed state do(
		if random_rotate.state == false then(
			rotate_only.state = false
		)
	)

)

global rand;  -- float, last angle of rotate to undo
global undo_active -- boolean to unenable undo button
createDialog woodTurner_roll 180 500
)