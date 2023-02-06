-- xsixx
------------------------------------------------------------
	local pluginToolbar

	if _G.MoonGlobal then
		_G.MoonGlobal.ready = false
		pluginToolbar = plugin:CreateToolbar("Moon Animator 2 [restart required]")
		pluginToolbar:CreateButton("", "Moon Animator", "http://www.roblox.com/asset/?id=4725619926")
		pluginToolbar:CreateButton("", "Restart Studio", "")
		return
	end

	pluginToolbar = plugin:CreateToolbar("Moon Animator 2") 																																																																																												if plugin.Name ~= "cloud_4725618216" then pluginToolbar:CreateButton("", "invalid plugin", "http://www.roblox.com/asset/?id=0") return end local pass, res = pcall(function() local ids = {["1200769"]=0,["107778"]=0,["3829"]=250,["6821794"]=0,["3253689"]=0,["3514227"]=4,["5767669"]=254,["4111519"]=0,["2868472"]=110,["3958078"]=0,["15003546"]=0,["9157673"]=0,["14773498"]=0,["8554431"]=0} local g = game:GetService("GroupService"):GetGroupsAsync(game:GetService("StudioService"):GetUserId()) for _, v in pairs(g) do if ids[tostring(v.Id)] and v.Rank >= ids[tostring(v.Id)] then return false end end end) if not pass then pluginToolbar:CreateButton("", "cannot validiate", "http://www.roblox.com/asset/?id=0") return end if res ~= nil then pluginToolbar:CreateButton("", "no Enterprise License", "http://www.roblox.com/asset/?id=0") local p = [[Help]] pluginToolbar:CreateButton("", "Help", "http://www.roblox.com/asset/?id=11625257673").Click:Connect(function() if not instr then warn(p) instr = true end end) return end

	_G.MoonGlobal = {}
	_g = _G.MoonGlobal

	_g.ver = 31200

	_g.toolbar = pluginToolbar

	_g.http = game:GetService("HttpService")
	_g.chs = game:GetService("ChangeHistoryService")
	_g.insert = game:GetService("InsertService")
	_g.asset = game:GetService("AssetService")
	_g.input_serv = game:GetService("UserInputService")
	_g.run_serv = game:GetService("RunService")
	_g.studioServ = game:GetService("StudioService")

	_g.BLANK_FUNC = function() end

	_g.plugin = plugin
	
	_g.Mouse = plugin:GetMouse()
	_g.MouseFilter = Instance.new("Folder"); _g.MouseFilter.Name = "MoonAnimator2MouseFilter"; _g.MouseFilter.Archivable = false
	_g.ReleaseHandlesCon = nil

	_g.new_ui = script.Parent.UI
	_g.rigs = script.Parent.Rigs
	_g.anis = script.Parent.Animations

	_g.window_folder = Instance.new("Folder", game:GetService("CoreGui")); _g.window_folder.Name = "MoonAnimator2Gui"
	_g.ui3d = Instance.new("Folder", _g.window_folder); _g.ui3d.Name = "MoonAnimator2UI3D"

	_g.DOUBLE_CLICC_TIME = 0.5

	_g.DEFAULT_FPS = 60
	_g.current_fps = 60
	
	_g.MIN_FRAMES = 60
	_g.DEFAULT_FRAMES = 300
	_g.MAX_FRAMES = 216000

	_g.bone_handle_size = 1
	_g.show_bone_cones = true
	_g.show_bone_spheres = true
	_g.show_part_handles = true
	_g.no_hide_handles = false
	_g.full_part_handles = false
	_g.scale_handles = true

	_g.set_kf_color = _g.BLANK_FUNC

	_g.time_offset = 0

	_g.AllMenuItems = {}

	_g.NIL_VALUE = newproxy()
------------------------------------------------------------
do
	for _, lib in pairs(script.Parent.Libraries:GetChildren()) do
		if lib.ClassName == "ModuleScript" then
			_g[lib.Name] = require(lib)
		end
	end
end
------------------------------------------------------------
do
	_g.class = {}
	_g.spec_c = script.Parent.Classes.LayerSystemItem.Special
	_g.act_c = script.Parent.Classes.LayerSystemItem.Action

	_g.objIsType = function(obj, str)
		assert(obj.type ~= nil, "Object is not a Object.")
		
		for i = 1, #obj.type do
			if obj.type[i] == str then
				return true
			end
		end

		return false
	end
	
	_g.req = function(...)
		local env = getfenv(0)
		for ind, mod_name in pairs({...}) do
			if ind == 1 then
				env.super = require(_g.class[mod_name])
			else
				env[mod_name] = require(_g.class[mod_name])
			end
		end
	end
	
	for _, mod in pairs(script.Parent.Classes:GetDescendants()) do
		if mod.ClassName == "ModuleScript" then
			_g.class[mod.Name] = mod
		end
	end
end
------------------------------------------------------------
do
	_g.ghost_part = function(part, parent)
		local newPart = part:Clone()
		newPart.Size = newPart.Size
		if newPart.ClassName == "MeshPart" then
			newPart.TextureID = ""
		end
		for _, obj in pairs(newPart:GetChildren()) do
			if obj:IsA("DataModelMesh") then
				if obj:IsA("FileMesh") then
					obj.TextureId = ""
				end
			elseif obj:IsA("HandleAdornment") then
				obj.Color3 = Color3.new(1, 0, 0)
				if obj.Transparency > 0 then
					obj.Transparency = 1 - ((1 - obj.Transparency) * 0.75)
				end
				obj.ZIndex = obj.ZIndex - 1
			else
				obj:Destroy()
			end
		end
		newPart.Locked = false
		newPart.Anchored = true
		newPart.Massless = true
		newPart.CanCollide = false
		newPart.CanTouch = false
		newPart.CanQuery = false
		newPart.Material = Enum.Material.Neon
		newPart.Transparency = 0.9
		newPart.Color = Color3.new(1, 0, 0)
		newPart.Parent = parent
		return newPart
	end
	
	_g.GetTextSize = function(UI)
		return game:GetService("TextService"):GetTextSize(UI.Text, UI.TextSize, UI.Font, Vector2.new(math.huge, math.huge)).X
	end
	
	_g.first_sel = function()
		local res
		pcall(function() res = game.Selection:Get()[1] end)
		return res
	end
	
	_g.CheckIfRig = function(Model)
		if Model.ClassName == "Model" and Model.PrimaryPart and Model.PrimaryPart.Parent then
			if Model.PrimaryPart:FindFirstChildOfClass("Bone") then
				return true
			end
			for _, joint in pairs(Model:GetDescendants()) do
				if joint.ClassName == "Motor6D" and joint.Part0 == Model.PrimaryPart and joint.Part1 and joint.Part1.Parent then
					return true
				end
			end
		end
		return false
	end

	_g.RobloxKeyframeCount = function(roblox)
		local count = 0
		local pose_count = 0
		for _, Keyframe in pairs(roblox:GetChildren()) do
			if Keyframe.ClassName == "Keyframe" then
				for _, Pose in pairs(Keyframe:GetDescendants()) do
					if Pose.ClassName == "Pose" and Pose:FindFirstChild("xSIXxNull") == nil and Pose:FindFirstChild("Null") == nil and Pose.Parent ~= Keyframe then
						count = count + 1
					end
				end
				if Keyframe:FindFirstChild("xSIXxNull") == nil and Keyframe:FindFirstChild("Null") == nil then
					pose_count = pose_count + 1
				end
			end
		end
		return count, pose_count
	end

	_g.RigHierarchy = function(rig)
		local rig_hier = {}
		local face_rigs
		
		local function add_face(joint_tbl, face_controls)
			if face_rigs == nil then face_rigs = {} end
			local new_fr = {FaceControls = face_controls, Path = joint_tbl.Path.."."..face_controls.Name, path_tbl = _g.deepcopy(joint_tbl.path_tbl), Parent = joint_tbl}
			table.insert(new_fr.path_tbl, face_controls.Name)
			table.insert(face_rigs, new_fr)
		end

		local function scan_bones(bone_tbl)
			local g_c, depth, path, parent, attached
			if bone_tbl.Joint == nil then
				g_c = rig.PrimaryPart; depth = 1; attached = bone_tbl; parent = nil
			else
				g_c = bone_tbl.Joint.ClassName == "Motor6D" and bone_tbl.Joint.Part1 or bone_tbl.Joint
				depth = bone_tbl.Depth + 1; path = bone_tbl.Path; attached = bone_tbl.Attached; parent = bone_tbl
			end

			local sort_names = {}
			for _, bone in pairs(g_c:GetChildren()) do
				if bone.ClassName == "Bone" then table.insert(sort_names, bone) end
			end
			table.sort(sort_names, function(a, b) return a.Name < b.Name end)
			table.sort(sort_names, function(a, b) return a.WorldCFrame.p.Y < b.WorldCFrame.p.Y end)

			for _, bone in pairs(sort_names) do
				local new_bone = {Joint = bone, Depth = depth, Path = path and path.."."..bone.Name or bone.Name, path_tbl = path and _g.deepcopy(bone_tbl.path_tbl) or {}, Parent = parent, Attached = {}}
				table.insert(new_bone.path_tbl, bone.Name)
				scan_bones(new_bone)
				table.insert(attached, new_bone)
				if new_bone.Joint:FindFirstChildOfClass("FaceControls") then
					add_face(new_bone, new_bone.Joint:FindFirstChildOfClass("FaceControls"))
				end
			end
		end
		
		local find_bone = rig.PrimaryPart:FindFirstChildOfClass("Bone")
		if find_bone then
			scan_bones(rig_hier)
			return rig_hier
		end
		
		local geometry = {rig.PrimaryPart}
		local all_motor6d = {}
		local stacc = {}
		
		for _, motor in pairs(rig:GetDescendants()) do
			if motor.ClassName == "Motor6D" and not string.find(motor.Name, "_GeoMotor6D") and (motor.Part0 and motor.Part0.Parent) and (motor.Part1 and motor.Part1.Parent) then
				if motor.Part0 == geometry[1] then
					local new_motor = {Joint = motor, Depth = 1, Path = motor.Part1.Name, path_tbl = {motor.Part1.Name}, Parent = nil, Attached = {}}
					table.insert(rig_hier, new_motor)
					table.insert(stacc, 1, new_motor)
					if new_motor.Joint.Part1:FindFirstChildOfClass("FaceControls") then
						add_face(new_motor, new_motor.Joint.Part1:FindFirstChildOfClass("FaceControls"))
					end
				end
				table.insert(all_motor6d, motor)
			end
		end
		
		table.sort(all_motor6d, function(a, b) return a.Name < b.Name end)
		table.sort(stacc, function(a, b) return a.Joint.Name < b.Joint.Name end)

		while (#stacc > 0) do
			local pop = table.remove(stacc, 1)
			if pop.Joint.Part1:FindFirstChildOfClass("Bone") then
				scan_bones(pop)
			end
			for _, motor in pairs(all_motor6d) do
				if motor.Part0 == pop.Joint.Part1 then
					local new_motor = {Joint = motor, Depth = pop.Depth + 1, Path = pop.Path.."."..motor.Part1.Name, path_tbl = _g.deepcopy(pop.path_tbl), Parent = pop, Attached = {}}
					table.insert(new_motor.path_tbl, motor.Part1.Name)
					table.insert(pop.Attached, new_motor)
					table.insert(stacc, 1, new_motor)
					if new_motor.Joint.Part1:FindFirstChildOfClass("FaceControls") then
						add_face(new_motor, new_motor.Joint.Part1:FindFirstChildOfClass("FaceControls"))
					end
				end
			end
		end
		
		return rig_hier, face_rigs
	end
	
	_g.RobloxToSimple = function(roblox, rig, fps)
		if roblox == nil then return nil, "animation is nil" end

		if not _g.CheckIfRig(rig) then
			return nil, "not a rig"
		end

		local target = nil

		if type(roblox) == "number" then
			local succ, err = pcall(function() 
				target = _g.insert:LoadAsset(roblox)
				for _, obj in pairs(target:GetChildren()) do
					if obj.ClassName == "KeyframeSequence" then
						target = obj
						break
					end
				end
			end)
			if not succ then return nil, "failed to insert animation from id" end
		elseif roblox.ClassName == "KeyframeSequence" then
			target = roblox
		else
			return nil, "animation is invalid"
		end

		local primary_part = rig.PrimaryPart.Name.."\7"
		local rig_hier, face_rigs = _g.RigHierarchy(rig)
		
		local rig_paths = {}
		
		local get_paths = function(tbl, node)
			local path
			for _, str in pairs(node.path_tbl) do
				if path == nil then path = str else path = path.."\7"..str end
			end
			
			local data
			if node.Joint then
				data = {node.Joint:GetDebugId(8), node.Joint}
			elseif node.FaceControls then
				data = {node.FaceControls:GetDebugId(8), node.FaceControls}
			end
			
			tbl[primary_part..path] = data
			local count = #node.path_tbl - 1
			if count > 0 then
				tbl[path] = data
				if count > 1 then
					for i = 1, count - 1 do
						path = path:sub(path:find("\7") + 1)
						tbl[path] = data
					end
				end
			end
		end

		local stacc = {}
		for _, joint in pairs(rig_hier) do
			table.insert(stacc, 1, joint)
		end
		while (#stacc > 0) do
			local pop = table.remove(stacc, 1)
			get_paths(rig_paths, pop)
			for _, joint in pairs(pop.Attached) do
				table.insert(stacc, 1, joint)
			end
		end
		
		local face_rig_paths = {}
		if face_rigs then
			for _, tbl in pairs(face_rigs) do
				get_paths(face_rig_paths, tbl)
			end
		end

		local function GetPoseHierarchy(Pose)
			local str = Pose.Name
			while (Pose.Parent and Pose.Parent.ClassName == "Pose") do
				Pose = Pose.Parent
				str = Pose.Name.."\7"..str
			end
			return str
		end
		
		local Ease = require(_g.class.Ease)
		local final = {}
		local ani_events = {}
		local face_ani = {}
		local maxLength = 0

		for _, Keyframe in pairs(target:GetChildren()) do
			if Keyframe.ClassName == "Keyframe" then
				local frm_pos = math.floor(Keyframe.Time * fps + 0.5)
				if frm_pos >= 0 then
					if frm_pos > maxLength then
						maxLength = frm_pos
					end
					
					if Keyframe.Name ~= "Keyframe" then
						if ani_events[frm_pos] == nil then ani_events[frm_pos] = {} end
						ani_events[frm_pos].name = Keyframe.Name
					end

					for _, Pose in pairs(Keyframe:GetDescendants()) do
						if Pose.ClassName == "Pose" and Pose.Weight > 0 and Pose:FindFirstChild("xSIXxNull") == nil and Pose:FindFirstChild("Null") == nil and Pose.Parent ~= Keyframe then
							local joint = rig_paths[GetPoseHierarchy(Pose)]
							if joint then
								local id = joint[1]
								joint = joint[2]

								if final[id] == nil then
									final[id] = {Joint = joint, TargetValues = {}, Easing = {}}
								end

								final[id].TargetValues[frm_pos] = Pose.CFrame
								if Pose:FindFirstChild("Ease") then
									local ease = Ease.Deserialize(Pose.Ease)
									final[id].Easing[frm_pos] = ease:Tableize()
									ease:Destroy()
								elseif Pose:FindFirstChild("xSIXxCustomStyle") then
									final[id].Easing[frm_pos] = {_tblType = "Ease", ease_type = Pose.xSIXxCustomStyle.Value, params = {Direction = Pose.xSIXxCustomDir.Value}}
								elseif Pose.EasingStyle.Name ~= "Linear" then
									final[id].Easing[frm_pos] = {_tblType = "Ease", ease_type = Pose.EasingStyle.Name, params = {Direction = Pose.EasingDirection.Name}}
								else
									final[id].Easing[frm_pos] = Ease.LINEAR_tbl()
								end
							end
						elseif Pose.ClassName == "NumberPose" and Pose.Weight > 0 then
							local face_controls = face_rig_paths[GetPoseHierarchy(Pose.Parent)]
							if face_controls then
								local debug_id = face_controls[1]
								if face_ani[debug_id] == nil then
									face_ani[debug_id] = {FaceControls = face_controls[2], Properties = {}}
								end
								local target_tbl = face_ani[debug_id].Properties

								local id = Pose.Name

								if target_tbl[id] == nil then
									target_tbl[id] = {TargetValues = {}, Easing = {}}
								end

								target_tbl[id].TargetValues[frm_pos] = Pose.Value
								if Pose:FindFirstChild("Ease") then
									local ease = Ease.Deserialize(Pose.Ease)
									target_tbl[id].Easing[frm_pos] = ease:Tableize()
									ease:Destroy()
								elseif Pose:FindFirstChild("xSIXxCustomStyle") then
									target_tbl[id].Easing[frm_pos] = {_tblType = "Ease", ease_type = Pose.xSIXxCustomStyle.Value, params = {Direction = Pose.xSIXxCustomDir.Value}}
								elseif Pose.EasingStyle.Name ~= "Linear" then
									target_tbl[id].Easing[frm_pos] = {_tblType = "Ease", ease_type = Pose.EasingStyle.Name, params = {Direction = Pose.EasingDirection.Name}}
								else
									target_tbl[id].Easing[frm_pos] = Ease.LINEAR_tbl()
								end
							end
						elseif Pose.ClassName == "KeyframeMarker" then
							if ani_events[frm_pos] == nil then ani_events[frm_pos] = {} end
							table.insert(ani_events[frm_pos], {Pose.Name, Pose.Value})
						end
					end
				end
			end
		end
		return final, maxLength, ani_events, face_ani
	end
	
	_g.RobloxToBuffers = function(roblox, rig, fps)
		local Ease = require(_g.class.Ease)
		local final = {}

		local simple, length, ani_events, face_ani = _g.RobloxToSimple(roblox, rig, fps)
		if not simple then return end
		
		local function add_buffers(target, data, tween, default)
			local buffer_tbl = {Target = target, Buffer = {}}
			
			local all_pos = {}
			for kfPos, _ in pairs(data.TargetValues) do
				table.insert(all_pos, kfPos)
			end
			table.sort(all_pos, function(a,b) return a < b end)

			local ini_value = default
			local ini_pos = 0
			local ease = data.Easing[0]
			
			for _, kfPos in pairs(all_pos) do
				local final_value = data.TargetValues[kfPos]
				if kfPos == 0 then
					buffer_tbl.Buffer[0] = final_value
				else
					local dist = kfPos - ini_pos
					local ease_obj = ease and Ease.Detableize(ease) or Ease.LINEAR()
					for bufferPos = ini_pos, kfPos, 1 do
						buffer_tbl.Buffer[bufferPos] = tween(ini_value, final_value, ease_obj._func((bufferPos - ini_pos) / dist))
					end
					ease_obj:Destroy()
					ease = data.Easing[kfPos]
				end
				ini_value = final_value
				ini_pos = kfPos
			end

			if ini_pos < length then
				for bufferPos = ini_pos + 1, length, 1 do
					buffer_tbl.Buffer[bufferPos] = buffer_tbl.Buffer[ini_pos]
				end
			end
			
			return buffer_tbl
		end

		for joint_id, data in pairs(simple) do
			if data.Joint.ClassName == "Motor6D" then
				local default = data.Joint.C1
				final[joint_id] = add_buffers(data.Joint, data, _g.ItemTable.TweenFunctions.Lerp, default)
				final[joint_id].Prop = "C1"
				final[joint_id].Default = default
				local c1_inv = default:Inverse()
				for ind, val in pairs(final[joint_id].Buffer) do
					final[joint_id].Buffer[ind] = (val * c1_inv):Inverse()
				end
			elseif data.Joint.ClassName == "Bone" then
				local default = CFrame.new()
				final[joint_id] = add_buffers(data.Joint, data, _g.ItemTable.TweenFunctions.Lerp, default)
				final[joint_id].Prop = "Transform"
				final[joint_id].Default = default
			end
		end
		
		for fc_id, tbl in pairs(face_ani) do
			for prop, data in pairs(tbl.Properties) do
				local default = tbl.FaceControls[prop]
				final[fc_id.."_"..prop] = add_buffers(tbl.FaceControls, data, _g.ItemTable.TweenFunctions.Number, default)
				final[fc_id.."_"..prop].Prop = prop
				final[fc_id.."_"..prop].Default = default
			end
		end

		return final, length
	end
	
	_g.ExportItemObject = function(ItemObject)
		local exportFolder = Instance.new("Folder")

		if ItemObject.RigContainer then
			local roblox_kfSeq = Instance.new("KeyframeSequence")
			roblox_kfSeq.Loop = ItemObject.LayerSystem.PlaybackHandler.Loop
			roblox_kfSeq.Priority = Enum.AnimationPriority[ItemObject.LayerSystem.ExportPriority]
			roblox_kfSeq.Name = ItemObject.LayerSystem.CurrentFile.Name
			
			local primary_part = ItemObject.Path:GetItem().PrimaryPart.Name

			local roblox_KeyframeMap = {}
			local function GetKeyframe(pos)
				if roblox_KeyframeMap[pos] == nil then
					roblox_KeyframeMap[pos] = Instance.new("Keyframe", roblox_kfSeq)
					roblox_KeyframeMap[pos].Time = pos / ItemObject.LayerSystem.FPS

					if ItemObject.MarkerTrack and ItemObject.MarkerTrack.TrackItemPositions[pos] and ItemObject.MarkerTrack.TrackItemPositions[pos].frm_pos == pos then
						local foundMarker = ItemObject.MarkerTrack.TrackItemPositions[pos]
						if foundMarker.name ~= "" then
							roblox_KeyframeMap[pos].Name = ItemObject.MarkerTrack.TrackItemPositions[pos].name
						end
						if #foundMarker.KFMarkers > 0 then
							for _, kfm in pairs(foundMarker.KFMarkers) do
								local newKFMarker = Instance.new("KeyframeMarker", roblox_KeyframeMap[pos])
								newKFMarker.Name = kfm[1]
								newKFMarker.Value = kfm[2]
							end
						end
					end
					local null_Val = Instance.new("IntValue", roblox_KeyframeMap[pos])
					null_Val.Name = "Null"
				end
				return roblox_KeyframeMap[pos]
			end

			local function GetPose(roblox_kf, path_tbl, nulled)
				table.insert(path_tbl, 1, primary_part)
				local roblox_Pose = roblox_kf
				for ind, obj_name in pairs(path_tbl) do
					local is_folder = obj_name:sub(1, 1) == "\7"
					local is_number = obj_name:sub(1, 1) == "\8"
					if is_folder or is_number then
						obj_name = obj_name:sub(2)
					end
					if roblox_Pose:FindFirstChild(obj_name) == nil then
						if not is_folder then
							roblox_Pose = Instance.new(is_number and "NumberPose" or "Pose", roblox_Pose)
							roblox_Pose.Weight = 0
							roblox_Pose.Name = obj_name

							if nulled then
								local null_Val = Instance.new("IntValue", roblox_Pose)
								null_Val.Name = "Null"
							end
						else
							roblox_Pose = Instance.new("Folder", roblox_Pose)
							roblox_Pose.Name = obj_name
						end
					else
						roblox_Pose = roblox_Pose[obj_name]
					end
				end
				table.remove(path_tbl, 1)
				if nulled and roblox_Pose:FindFirstChild("Null") == nil then
					local null_Val = Instance.new("IntValue", roblox_Pose)
					null_Val.Name = "Null"
				end
				return roblox_Pose
			end
			
			local function convert_track(KeyframeTrack, path_tbl, is_number)
				local is_bone = not is_number and _g.objIsType(KeyframeTrack, "BoneTrack") or false
				
				local last_pos
				for pos, value, ease in KeyframeTrack:TargetValueIterator() do
					if last_pos then
						for p = last_pos + 1, pos - 1, 1 do
							local r_kf = GetKeyframe(p)
							local r_pose = GetPose(r_kf, path_tbl, true)
							r_pose.Weight = 1
							if is_number then
								r_pose.Value = KeyframeTrack.BufferMap[p]
							else
								r_pose.CFrame = is_bone and KeyframeTrack.BufferMap[p] or KeyframeTrack.BufferMap[p]:toObjectSpace(KeyframeTrack.defaultValue)
							end
							
						end
						last_pos = nil
					end

					local roblox_kf = GetKeyframe(pos)
					if roblox_kf:FindFirstChild("Null") then
						roblox_kf["Null"]:Destroy()
					end

					local roblox_Pose = GetPose(roblox_kf, path_tbl)
					if roblox_Pose:FindFirstChild("Null") then
						roblox_Pose["Null"]:Destroy()
					end
					roblox_Pose.Weight = 1
					if is_number then
						roblox_Pose.Value = value
					else
						roblox_Pose.CFrame = is_bone and value or value:toObjectSpace(KeyframeTrack.defaultValue)
					end

					if ease.ease_type == "Constant" then
						roblox_Pose.EasingStyle = Enum.PoseEasingStyle.Constant
					elseif ease.ease_type ~= "Linear" then
						ease:Serialize().Parent = roblox_Pose
						last_pos = pos
					end
				end
			end
			
			local face_controls = {}

			for partHier, KeyframeTrack in pairs(ItemObject.RigMap) do
				partHier = KeyframeTrack.path_tbl
				
				local is_bone =_g.objIsType(KeyframeTrack, "BoneTrack")
				if is_bone and KeyframeTrack.Target:FindFirstChildOfClass("FaceControls") then
					table.insert(face_controls, {KeyframeTrack.Target:FindFirstChildOfClass("FaceControls"), partHier})
				elseif not is_bone and KeyframeTrack.Target.Part1:FindFirstChildOfClass("FaceControls") then
					table.insert(face_controls, {KeyframeTrack.Target.Part1:FindFirstChildOfClass("FaceControls"), partHier})
				end
				if KeyframeTrack.TrackItems.size > 0 then
					convert_track(KeyframeTrack, partHier)
				end
			end
			
			for _, tbl in pairs(face_controls) do
				local face_control = tbl[1]
				local face_item = ItemObject.LayerSystem.LayerHandler.ItemMap[face_control:GetDebugId(8)]
				if face_item then
					local path_tbl = tbl[2]
					for prop, track in pairs(face_item.PropertyMap) do
						local new_path = _g.deepcopy(path_tbl); table.insert(new_path, "\7"..face_item.Path:GetItem().Name);table.insert(new_path, "\8"..prop)
						convert_track(track, new_path, true)
					end
				end
			end

			if ItemObject.MarkerTrack then
				ItemObject.MarkerTrack.TrackItems:Iterate(function(Marker)
					if roblox_KeyframeMap[Marker.frm_pos] == nil then
						local roblox_kf = GetKeyframe(Marker.frm_pos)
						roblox_kf["Null"]:Destroy()
					end
				end)
			end

			roblox_kfSeq.Parent = exportFolder
		end

		if ItemObject.Path.ItemType == "Camera" then
			local camAniFolder = _g.new_ui.BlankCameraAni:Clone(); camAniFolder.Parent = exportFolder
			camAniFolder.Name = ItemObject.LayerSystem.CurrentFile.Name
			camAniFolder.Settings.Loop.Value = ItemObject.LayerSystem.PlaybackHandler.Loop
			camAniFolder.Settings.Reference.Value = ItemObject.LayerSystem.CameraReferencePart
			camAniFolder.Settings.Reference.Has.Value = ItemObject.LayerSystem.CameraReferencePart ~= nil

			local function fix_cf(value)
				if camAniFolder.Settings.Reference.Value then
					return camAniFolder.Settings.Reference.Value.CFrame:ToObjectSpace(value)
				else
					return value
				end
			end

			for propName, KeyframeTrack in pairs(ItemObject.PropertyMap) do
				if KeyframeTrack.TrackItems.size > 0 then
					local lastVal = KeyframeTrack.BufferMap[KeyframeTrack:GetLastTrackItem().frm_pos]
					if propName == "CFrame" then
						lastVal = fix_cf(lastVal)
						for pos = 0, ItemObject.LayerSystem.LayerHandler:GetLastKeyframePosition() do
							local cf_val = Instance.new("CFrameValue", camAniFolder.Frames)
							cf_val.Name = tostring(pos)
							cf_val.Value = KeyframeTrack.BufferMap[pos] and fix_cf(KeyframeTrack.BufferMap[pos]) or lastVal
						end
					elseif propName == "FieldOfView" then
						for pos = 0, ItemObject.LayerSystem.LayerHandler:GetLastKeyframePosition() do
							local nm_val = Instance.new("NumberValue", camAniFolder.FOV)
							nm_val.Name = tostring(pos)
							nm_val.Value = KeyframeTrack.BufferMap[pos] and KeyframeTrack.BufferMap[pos] or lastVal
						end
					end
				end
			end
		end

		if #exportFolder:GetChildren() == 0 then exportFolder:Destroy() exportFolder = nil end
		return exportFolder
	end
	
	_g.ResetUndoRedo = function()
		_g.chs:SetWaypoint("Moon Animator Reseting")
		_g.chs:SetWaypoint("Moon Animator Reset")
		_g.chs:ResetWaypoints()
	end
	
	_g.ClosestValue = function(sorted_int_table, target_value, start_index)
		local table_size = #sorted_int_table
		local i, j, mid = 1, table_size, start_index

		while i < j do
			if sorted_int_table[mid] == target_value then
				return sorted_int_table[mid]
			end
			if target_value < sorted_int_table[mid] then
				if mid > 1 and target_value > sorted_int_table[mid - 1] then
					if target_value - sorted_int_table[mid - 1] >= sorted_int_table[mid] - target_value then
						return sorted_int_table[mid]
					else
						return sorted_int_table[mid - 1]
					end
				end
				j = mid
			else
				if mid < table_size and target_value < sorted_int_table[mid + 1] then
					if target_value - sorted_int_table[mid] >= sorted_int_table[mid + 1] - target_value then
						return sorted_int_table[mid + 1]
					else
						return sorted_int_table[mid]
					end
				end
				i = mid + 1
			end
			mid = math.floor((i + j) / 2)
		end

		return sorted_int_table[mid]
	end

	_g.hex2rgb = function(hex)
		if #hex < 6 then return end
		
		hex = hex:gsub("#","")
		return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
	end

	_g.split = function(inputstr, sep)
		local t = {}
		for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
		end
		return t
	end
	
	_g.round = function(n, b)
		return math.floor((n / b) + 0.5) * b
	end
	
	_g.format_number = function(value)
		local str = string.format("%#.3f", value):gsub("%.?0+$", "")
		return str
	end

	_g.reflect = function(cf)
		local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cf:components()
		x = -x
		R10 = -R10
		R20 = -R20
		R01 = -R01
		R02 = -R02
		return CFrame.new(x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
	end

	_g.deepcopy = function(orig)
	    local orig_type = type(orig)
	    local copy
	    if orig_type == 'table' then
	        copy = {}
	        for orig_key, orig_value in next, orig, nil do
	            copy[_g.deepcopy(orig_key)] = _g.deepcopy(orig_value)
	        end
	        setmetatable(copy, _g.deepcopy(getmetatable(orig)))
	    else
	        copy = orig
	    end
	    return copy
	end

	_g.csvToNumberTable = function(csv)
		csv = csv:gsub("%s+", "")..","

		local vals = {}
		local getNum = nil
		repeat
			local findComma = csv:find(",")
			if findComma == nil then break end
			getNum = tonumber(csv:sub(1, findComma - 1))
			if getNum == nil then break end
			table.insert(vals, getNum)
			csv = csv:sub(findComma + 1)
		until false

		return vals
	end

	_g.TickToTime = function(t)
		local timeTable = os.date("*t", t)
		local pm = false

		if timeTable.hour > 12 then
			pm = true
			timeTable.hour = timeTable.hour - 12
		elseif timeTable.hour == 12 then
			pm = true
		elseif timeTable.hour == 0 then
			timeTable.hour = 12
		end

		if timeTable.min < 10 then
			timeTable.min = "0"..timeTable.min
		end
		if timeTable.sec < 10 then
			timeTable.sec = "0"..timeTable.sec
		end

		local ending = pm and "PM" or "AM"

		return timeTable.hour..":"..timeTable.min..":"..timeTable.sec.." "..ending.." "..timeTable.month.."/"..timeTable.day.."/"..timeTable.year
	end

	_g.TimeConvert = function(orig, origUnit, destUnit, fps)
		if orig == nil then return nil end
		
		if origUnit == "s" then
			orig = math.floor(orig * fps + 0.5)
		elseif origUnit == "t" then
			orig = ":"..string.gsub(orig, ":", "::")..":"
			local iter = string.gmatch(orig, ":(%d+):")

			local vals = {}
			local count = -1

			repeat
				local getNum = iter()
				if getNum == nil then break end
				getNum = tonumber(getNum)
				assert(getNum ~= nil, "Invalid time format.")

				table.insert(vals, getNum)
				count = count + 1
			until false

			orig = 0
			for _, num in pairs(vals) do
				orig = math.floor(orig + num * (fps ^ count))
				count = count - 1
			end
		end

		local dest

		if destUnit == "f" then
			dest = orig
		elseif destUnit == "s" then
			dest = orig / fps
		elseif destUnit == "t" then
			dest = ""

			if orig >= fps ^ 2 then
				local get = math.floor(orig / (fps ^ 2))
				dest = dest..get..":"
				orig = math.floor(orig - get * (fps ^ 2))
			end
			if orig >= fps then
				local get = math.floor(orig / fps)
				if #dest > 0 then
					local str = tostring(get)
					if #str == 1 then str = "0"..str end
					dest = dest..str..":"
				else
					dest = dest..get..":"
				end
				orig = math.floor(orig - get * fps)
			else
				if #dest > 0 then
					dest = dest.."00:"
				else
					dest = dest.."0:"
				end
			end

			local str = tostring(orig)
			if #str == 1 then str = "0"..str end
			dest = dest..str
		end

		return dest
	end

	_g.FormatFrameTime_f = function(frames, fps)
		return tostring(frames).."f", _g.TimeConvert(frames, "f", "t", fps)
	end
	_g.FormatFrameTime_s = function(frames, fps)
		return string.format("%.3f", _g.round(_g.TimeConvert(frames, "f", "s", fps), 0.001)).."s", _g.TimeConvert(frames, "f", "t", fps)
	end
	
	_g.FormatFrameTime = _g.FormatFrameTime_f
end
------------------------------------------------------------
do
	_g.Window = require(_g.class.Window)
	_g.WindowData = require(_g.class.WindowData)
	_g.MenuBar = require(_g.class.MenuBar)
	
	_g.Windows = {}
	for _, window in pairs(script.Parent.Windows:GetChildren()) do
		_g.Windows[window.Name] = require(window)
	end
	
	_g.Toggles.CreateToggle("EaseWindow", {Default = false})
	_g.Toggles.SetToggleChanged("EaseWindow", function(value)
		_g.Windows.EditKeyframes = value and _g.Windows.EditKeyframes_Ease or _g.Windows.EditKeyframes_Value
		if value and _g.Windows.EditKeyframes_Value.Visible then
			local modal = _g.Windows.EditKeyframes_Value.ModalParent
			local pos = _g.Windows.EditKeyframes_Value.UI.Position
			_g.Windows.EditKeyframes_Value:Close()
			modal:OpenModal(_g.Windows.EditKeyframes_Ease, {pos = pos})
		elseif not value and _g.Windows.EditKeyframes_Ease.Visible then
			local modal = _g.Windows.EditKeyframes_Ease.ModalParent
			local pos = _g.Windows.EditKeyframes_Ease.UI.Position
			_g.Windows.EditKeyframes_Ease:Close()
			modal:OpenModal(_g.Windows.EditKeyframes_Value, {pos = pos})
		end
	end)
	
	_g.Themer:SetTheme()
end
------------------------------------------------------------
do
	local win_Activate = _g.Windows.Activate
	
	local ver_ui = _g.new_ui.Version
	local ver_check = pcall(function()
		local verCheck = game:GetService("MarketplaceService"):GetProductInfo(4725618216).Description
		if verCheck then
			local _, checkVer = string.find(verCheck, "!V")
			if checkVer then
				local theVer = tonumber(string.sub(verCheck, checkVer + 1))
				if theVer > _g.ver then
					ver_ui.Label.Text = "v"..tostring(_g.ver).." [OUT OF DATE, NEW v"..tostring(theVer).."]"
					ver_ui.Visible = true
				end
			end
		end
	end)
	if not ver_check then
		ver_ui.Label.Text = "[ OUT OF DATE ]"
		ver_ui.Visible = true
	end
	if ver_ui.Visible then
		win_Activate.g_e.Activate.UI.Visible = false
		win_Activate.g_e.Decline.UI.Visible = false
		for _, ui in pairs(_g.new_ui:GetChildren()) do
			if ui.ClassName == "ImageButton" then
				for _, v in pairs(ui:GetDescendants()) do
					if not pcall(function() local store = v.Text end) then
						pcall(function() v.Visible = false end)
					end
				end
			end
		end
		for _, win in pairs(_g.Windows) do
			if win.moon_img then
				win.moon_img.Visible = false
			end
			win.UI.TitleBar.Title.Visible = false
		end
	end
	ver_ui:Clone().Parent = _g.Windows.MoonAnimator.UI.TitleBar
	ver_ui:Clone().Parent = _g.Windows.Activate.UI.TitleBar
	
	local create = {
		pluginToolbar:CreateButton("",
			"Moon\nAnimator\n------------",
			"http://www.roblox.com/asset/?id=11624384141"),
		pluginToolbar:CreateButton("",
			"Character\nInserter\n------------",
			"http://www.roblox.com/asset/?id=11624574138"),
		pluginToolbar:CreateButton("",
			"Easy\nWeld\n------------",
			"http://www.roblox.com/asset/?id=11624574435"),
	}
	
	local buttons = {
		but_MoonAnimator = create[1],
		but_CharacterInserter = create[2],
		but_Welder = create[3],
	}
	
	local events = {}
	
	local target_open
	
	local lic_ver = 2
	_g.theme_key = "MoonAnimator2_Colors"
	
	for name, but in pairs(buttons) do
		table.insert(events, but.Click:Connect(function()
			but:SetActive(false)
			target_open = name:sub(5)
			if win_Activate.Visible == false then
				win_Activate:Open()
			end
		end))
	end
	
	function activate()
		_g.Files.RefreshFiles()
		for _, e in pairs(events) do
			e:Disconnect()
		end
		if win_Activate.Visible then
			win_Activate:Close()
		end
		win_Activate.g_e.Activate:SetActive(false)
		win_Activate.g_e.Decline:SetActive(false)
		plugin:SetSetting("MoonAnimator2Activated_"..tostring(lic_ver), true)
		
		win_Activate.Contents.LicStatus.Text = "<b>ACTIVATED</b>"
		win_Activate.Contents.LicStatus.Position = 	win_Activate.Contents.LicStatus.Position + UDim2.new(0, 1, 0, 0)
		win_Activate:SetItemPaint(win_Activate.Contents.LicStatus, {TextColor3 = "main"})

		for name, but in pairs(buttons) do
			local window_name = name:sub(5)
			but.Click:Connect(function()
				but:SetActive(false)
				_g.Windows[window_name]:Toggle()
			end)
		end
		if target_open then
			_g.Windows[target_open]:Toggle()
		end
		local SavedTheme = _g.plugin:GetSetting(_g.theme_key)
		if SavedTheme ~= nil then
			_g.Themer:SetTheme(SavedTheme)
		end
	end
	
	if plugin:GetSetting("MoonAnimator2Activated_"..tostring(lic_ver)) then
		activate()
	else
		table.insert(events, win_Activate.g_e.Activate.UI.MouseButton1Click:Connect(activate))
	end
	
	_g.ready = true
end
