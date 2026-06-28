--[[
	KINETIK - Created by GplateGam - https://github.com/GplateGummy/Polytoria-Kinetik
	[VERSION 1.0.0]
	
	Note: If you see the message multiple times, it means the module is being
    loaded multiple times (which can cause huge performance issues).
]]

if world.IsLocalTest then
	print("[KINETIK]")
end

local ClassesMap = {
	["GUI"] = "GUI",
	["Frame"] = "UIView",
	["Label"] = "UILabel",
	["Button"] = "UIButton",
	["Image"] = "UIImage",
	["TextInput"] = "UITextInput",
	["ScrollFrame"] = "UIScrollView",
	["ViewportFrame"] = "UIViewport",
	["HorizontalLayout"] = "UIHLayout",
	["VerticalLayout"] = "UIVLayout",
	["HorizontalFlow"] = "UIHFlow",
	["VerticalFlow"] = "UIVFlow",
	["GridLayout"] = "UIGridLayout",
}

local PropertyCategories = {
	["Base"] = { "Name", "ClassName", "EditableChildren", "Tags", "NetworkedObjectID", "ObjectID", "ExistInNetwork", "Archivable", "Parent" },
	["GUI"] = { "Visible", "ZIndex" },
	["Transform"] = { "Position", "Size", "PositionRelative", "PositionOffset", "SizeRelative", "SizeOffset", "Rotation", "Scale", "Ratio", "PivotPoint", "ClipDescendants", "Visible", "MaskMode", "IgnoreMouse", "ZIndex", "AbsolutePosition", "AbsoluteSize", "IsVisibleInTree" },
	["Style"] = { "StrokeColor", "StrokeThickness", "StrokeInstance", "Color", "CornerRadius", "TopLeftCornerRadius", "TopRightCornerRadius", "BottomLeftCornerRadius", "BottomRightCornerRadius", "CornerInstance", "Shadow", "ShadowInstance" },
	["Image"] = { "Image", "TextureScale", "TextureOffset", "Color", "StretchMode", "TextureFilter", "FlipHorizontal", "FlipVertical", "Loading" },
	["Input"] = { "Text", "TextColor", "JustifyText", "FontSize", "AutoSize", "MaxAutoSize", "MultiLine", "Placeholder", "PlaceholderColor", "ReadOnlyColor", "IsReadOnly", "FontAsset" },
	["Label"] = { "Text", "TextColor", "OutlineWidth", "OutlineColor", "HorizontalAlignment", "VerticalAlignment", "FontSize", "AutoSize", "MaxAutoSize", "UseRichText", "FontAsset", "TextTrimming", "TextWrapped" },
	["Scroll"] = { "HorizontalScrollMode", "VerticalScrollMode" },
	["Layout"] = { "Spacing", "ChildAlignment" },
	["Flow"] = { "Spacing", "ChildAlignment" },
	["GridLayout"] = { "Spacing", "Columns" },
}

local EventCategories = {
	["Base"] = { "ChildAdded", "ChildRemoved", "ChildDeleting", "ChildDeleted", "PropertyChanged", "Renamed", "TreeEntered", "TreeExited" },
	["Transform"] = { "MouseEnter", "MouseExit", "MouseDown", "MouseUp", "TransformChanged", "VisibilityChanged" },
	["Button"] = { "Clicked" },
	["Input"] = { "Submitted", "Changed", "FocusEnter", "FocusExit" },
}

local MethodCategories = {
	["Base"] = { "GetDescendants", "FindChild", "WaitChild", "FindChildByClass", "FindChildWithTag", "GetChildrenWithTag", "GetDescendantsWithTag", "FindAncestorByClass", "FindChildByIndex", "MoveChild", "GetChildren", "GetChildrenOfClass", "IsAncestorOf", "IsDescendantOf", "IsDescendantOfClass", "New", "AddTag", "RemoveTag", "HasTag", "Reparent", "GetParent", "SetParent", "IsA" },
	["Input"] = { "Focus" },
}

local ClassCategoryMap = {
	["GUI"] = { "Base", "GUI" },
	["Frame"] = { "Base", "Transform", "Style" },
	["Label"] = { "Base", "Transform", "Style", "Label" },
	["Button"] = { "Base", "Transform", "Style", "Label", "Button" },
	["Image"] = { "Base", "Transform", "Image" },
	["TextInput"] = { "Base", "Transform", "Style", "Input" },
	["ScrollFrame"] = { "Base", "Transform", "Scroll" },
	["ViewportFrame"] = { "Base", "Transform" },
	["HorizontalLayout"] = { "Base", "Transform", "Layout" },
	["VerticalLayout"] = { "Base", "Transform", "Layout" },
	["HorizontalFlow"] = { "Base", "Transform", "Flow" },
	["VerticalFlow"] = { "Base", "Transform", "Flow" },
	["GridLayout"] = { "Base", "Transform", "GridLayout" },
}

local PropertyAliases = {
	["Visible"] = { "IsVisible", "Show", "Enabled", "Visibility" },
	["ZIndex"] = { "Z", "Layer" },
	["Position"] = { "Pos", "Location" },
	["AbsolutePosition"] = { "AbsPosition", "AbsolutePos", "AbsPos" },
	["AbsoluteSize"] = { "AbsSize" },
	["PositionRelative"] = { "PosRelative", "PositionRel", "PosRel" },
	["PositionOffset"] = { "PosOffset", "PositionOff", "PosOff" },
	["SizeRelative"] = { "SizeRel" },
	["SizeOffset"] = { "SizeOff" },
	["Rotation"] = { "Rot" },
	["Scale"] = { "Scl" },
	["PivotPoint"] = { "Pivot", "Piv", "PivPoint", "Anchor", "AnchorPoint" },
	["CornerRadius"] = { "Corner" },
	["TopLeftCornerRadius"] = { "TopLeftCorner", "TLCorner", "TLCornerRadius" },
	["TopRightCornerRadius"] = { "TopRightCorner", "TRCorner", "TRCornerRadius" },
	["BottomLeftCornerRadius"] = { "BottomLeftCorner", "BLCorner", "BLCornerRadius" },
	["BottomRightCornerRadius"] = { "BottomRightCorner", "BRCorner", "BRCornerRadius" },
	["Shadow"] = { "Layers", "ShadowLayers" },
	["Color"] = { "Color3" },
	["TextColor"] = { "TxtColor", "TextColor3", "TxtColor3" },
	["FontSize"] = { "TextSize", "TxtSize" },
	["Text"] = { "Txt" },
	["UseRichText"] = { "UseRichTxt", "RichText", "RichTxt" },
	["TextTrimming"] = { "TxtTrimming", "TextTrim", "TxtTrim" },
	["TextWrapped"] = { "TxtWrapped", "TextWrap", "TxtWrap" },
	["JustifyText"] = { "JustifyTxt" },
	["MultiLine"] = { "Multiline", "IsMultiline", "IsMultiLine" },
	["IsReadOnly"] = { "ReadOnly" },
	["ReadOnlyColor"] = { "ReadOnlyColor3", "ReadOnlyTextColor", "ReadOnlyTxtColor", "ReadOnlyTextColor3", "ReadOnlyTxtColor3" },
	["Placeholder"] = { "PlaceholderText", "PlaceholderTxt" },
	["PlaceholderColor"] = { "PlaceholderColor3", "PlaceholderTextColor", "PlaceholderTxtColor", "PlaceholderTextColor3", "PlaceholderTxtColor3" },
	["Image"] = { "Source", "Texture", "ImageSource", "ImageTexture", "Gradient" },
	["FontAsset"] = { "Font", "Typeface", "TypeFace", "FontSource", "FontTexture" },
	["Loading"] = { "IsLoading", "Loaded" },
	["StrokeColor"] = { "BorderColor", "BorderColor3", "StrokeColor3" },
	["StrokeThickness"] = { "BorderThickness", "StrokeWidth", "BorderWidth" },
	["OutlineColor"] = { "OutlineColor3" },
	["OutlineWidth"] = { "OutlineThickness" },
	["Spacing"] = { "Gap", "Space" },
	["Columns"] = { "Cols", "Col", "Column" },
	["ChildAlignment"] = { "Align", "Alignment", "ChildAlign" },
	["HorizontalAlignment"] = { "HAlignment", "HAlign", "HorizontalAlign" },
	["VerticalAlignment"] = { "VAlignment", "VAlign", "VerticalAlign" },
	["HorizontalScrollMode"] = { "HorizontalScroll", "HSM" },
	["VerticalScrollMode"] = { "VerticalScroll", "VSM" },
}

local ReadOnlyProperties = {
	["ClassName"] = true,
	["AbsolutePosition"] = true,
	["AbsoluteSize"] = true,
	["Loading"] = true,
	["NetworkedObjectID"] = true,
	["ObjectID"] = true,
	["ExistInNetwork"] = true,
	["IsVisibleInTree"] = true,
	["StrokeInstance"] = true,
	["CornerInstance"] = true,
	["ShadowInstance"] = true,
}

local ExpectedPropertyTypes = {
    ["Parent"] = "Parent",
    ["Position"] = "Spatial",
    ["Size"] = "Spatial",
    ["Ratio"] = "Vector2",
    ["StrokeColor"] = "Color",
    ["StrokeThickness"] = "Scalar",
    ["StrokeInstance"] = "Instance",
    ["CornerRadius"] = "Scalar",
    ["TopLeftCornerRadius"] = "Scalar",
    ["TopRightCornerRadius"] = "Scalar",
    ["BottomLeftCornerRadius"] = "Scalar",
    ["BottomRightCornerRadius"] = "Scalar",
    ["CornerInstance"] = "Instance",
    ["Shadow"] = "Shadow",
    ["ShadowInstance"] = "Instance",
    ["Image"] = "userdata",
    ["FontAsset"] = "userdata",
}

local Module = {
	Spatial = {},
	Scalar = {},
}

local ActiveWrappers = {}
setmetatable(ActiveWrappers, { __mode = "k" })

local AutoCleaner = {
	Running = false,
	Thread = nil,
}

local AliasCache = {}
for Target, Aliases in PropertyAliases do
	AliasCache[Target] = Target
	for _, Alias in Aliases do
		AliasCache[Alias] = Target
	end
end

local AllowedCache = { Properties = {}, Events = {}, Methods = {} }

for Class, Categories in ClassCategoryMap do
	AllowedCache.Properties[Class] = {}
	AllowedCache.Events[Class] = {}
	AllowedCache.Methods[Class] = {}

	for _, Category in Categories do
		if PropertyCategories[Category] then
			for _, Prop in PropertyCategories[Category] do
				AllowedCache.Properties[Class][Prop] = true
			end
		end
		if EventCategories[Category] then
			for _, Event in EventCategories[Category] do
				AllowedCache.Events[Class][Event] = true
			end
		end
		if MethodCategories[Category] then
			for _, Method in MethodCategories[Category] do
				AllowedCache.Methods[Class][Method] = true
			end
		end
	end

	table.freeze(AllowedCache.Properties[Class])
	table.freeze(AllowedCache.Events[Class])
	table.freeze(AllowedCache.Methods[Class])
end

table.freeze(AllowedCache.Properties)
table.freeze(AllowedCache.Events)
table.freeze(AllowedCache.Methods)
table.freeze(AllowedCache)

local function ResolvePropertyName(InputName)
	return AliasCache[InputName] or InputName
end

local function IsPropertyAllowed(ClassType, PropertyName)
	return AllowedCache.Properties[ClassType] and AllowedCache.Properties[ClassType][PropertyName] == true
end

local function IsEventAllowed(ClassType, EventName)
	return AllowedCache.Events[ClassType] and AllowedCache.Events[ClassType][EventName] == true
end

local function IsMethodAllowed(ClassType, MethodName)
	return AllowedCache.Methods[ClassType] and AllowedCache.Methods[ClassType][MethodName] == true
end

local function GetClassTypeFromInstance(Obj)
	if not Obj or not Obj.ClassName then
		return nil
	end

	for InternalName, EngineName in ClassesMap do
		if EngineName == Obj.ClassName then
			return InternalName
		end
	end

	return nil
end

local function UpdateScaledProperties(Wrapper)
	local Obj = Wrapper.Instance
	if not Obj then
		return
	end

	local Ratio = rawget(Wrapper, "_R")
	if Ratio and Ratio.Y ~= 0 and Ratio.X ~= 0 then
		local ParentSize = nil
		local ParentClassType = GetClassTypeFromInstance(Obj.Parent)

		if ParentClassType and IsPropertyAllowed(ParentClassType, "AbsoluteSize") then
			ParentSize = Obj.Parent.AbsoluteSize
		else
			ParentSize = Vector2.New(Input.ScreenWidth, Input.ScreenHeight)
		end

		if ParentSize.X > 0 and ParentSize.Y > 0 then
			local RatioX = Ratio.X
			local RatioY = Ratio.Y
			local AspectRatio = RatioX / RatioY

			local WidthBasedOnParentHeight = ParentSize.Y * AspectRatio
			local HeightBasedOnParentWidth = ParentSize.X / AspectRatio

			local FinalWidth, FinalHeight

			if WidthBasedOnParentHeight <= ParentSize.X then
				FinalWidth = WidthBasedOnParentHeight
				FinalHeight = ParentSize.Y
			else
				FinalWidth = ParentSize.X
				FinalHeight = HeightBasedOnParentWidth
			end

			local ScaleX = FinalWidth / ParentSize.X
			local ScaleY = FinalHeight / ParentSize.Y

			Obj.SizeRelative = Vector2.New(ScaleX, ScaleY)
		end
	end
end

local function GetDepth(Obj)
	local Depth = 0
	local Current = Obj.Parent
	while Current do
		Depth = Depth + 1
		Current = Current.Parent
	end
	return Depth
end

local function RecalculateBranchDepth(Wrapper)
	if not Wrapper or rawget(Wrapper, "_Destroyed") then
		return
	end

	rawset(Wrapper, "_DP", GetDepth(Wrapper.Instance))
	for _, Child in Wrapper.Instance:GetChildren() do
		local ChildWrapper = ActiveWrappers[Child]
		if ChildWrapper then
			RecalculateBranchDepth(ChildWrapper)
		end
	end
end

local function CreateShadowLayers(Layers)
	if type(Layers) ~= "table" then
		return {}
	end

	local Converted = {}

	for _, LayerData in Layers do
		local Layer = ShadowLayer.New()

		if LayerData.Color ~= nil then Layer.Color = LayerData.Color end
		if LayerData.Offset ~= nil then Layer.Offset = LayerData.Offset end
		if LayerData.Spread ~= nil then Layer.Spread = LayerData.Spread end
		if LayerData.BlendMode ~= nil then Layer.BlendMode = LayerData.BlendMode end

		table.insert(Converted, Layer)
	end

	return Converted
end

local function ExtractShadowLayers(Layers)
    if type(Layers) ~= "table" then
        return {}
    end

    local Converted = {}

    for _, Layer in Layers do
        table.insert(Converted, {
            Color = Layer.Color,
            Offset = Layer.Offset,
            Spread = Layer.Spread,
            BlendMode = Layer.BlendMode
        })
    end

    return Converted
end

local IndividualCornerProperties = {
    "TopLeftRadius",
    "TopRightRadius",
    "BottomLeftRadius",
    "BottomRightRadius",
}

local CornerPropertyMap = {
    ["TopLeftRadius"] = "TopLeftCornerRadius",
    ["TopRightRadius"] = "TopRightCornerRadius",
    ["BottomLeftRadius"] = "BottomLeftCornerRadius",
    ["BottomRightRadius"] = "BottomRightCornerRadius",
}

local SpecialProperties = {
	["Position"] = {
		function(Obj)
			return Module.Spatial.New(Obj.PositionRelative.X, Obj.PositionRelative.Y, Obj.PositionOffset.X, Obj.PositionOffset.Y)
		end,

		function(Obj, NewValue)
			Obj.PositionRelative = Vector2.New(NewValue.Scale.X, NewValue.Scale.Y)
			Obj.PositionOffset = Vector2.New(NewValue.Offset.X, NewValue.Offset.Y)
		end,
	},

	["PositionRelative"] = {
		function(Obj)
			return Obj.PositionRelative
		end,

		function(Obj, NewValue)
			Obj.PositionRelative = NewValue
		end,
	},

	["PositionOffset"] = {
		function(Obj)
			return Obj.PositionOffset
		end,

		function(Obj, NewValue)
			Obj.PositionOffset = NewValue
		end,
	},

	["Size"] = {
		function(Wrapper)
			local Obj = Wrapper.Instance
			return Module.Spatial.New(Obj.SizeRelative.X, Obj.SizeRelative.Y, Obj.SizeOffset.X, Obj.SizeOffset.Y)
		end,

		function(Wrapper, NewValue)
			Wrapper.Instance.SizeRelative = Vector2.New(NewValue.Scale.X, NewValue.Scale.Y)
			Wrapper.Instance.SizeOffset = Vector2.New(NewValue.Offset.X, NewValue.Offset.Y)
			UpdateScaledProperties(Wrapper)
		end,
		true,
	},

	["SizeRelative"] = {
		function(Wrapper)
			return Wrapper.Instance.SizeRelative
		end,

		function(Wrapper, NewValue)
			Wrapper.Instance.SizeRelative = NewValue
			UpdateScaledProperties(Wrapper)
		end,
		true,
	},

	["SizeOffset"] = {
		function(Wrapper)
			return Wrapper.Instance.SizeOffset
		end,

		function(Wrapper, NewValue)
			Wrapper.Instance.SizeOffset = NewValue
			UpdateScaledProperties(Wrapper)
		end,
		true,
	},

	["Parent"] = {
		function(Wrapper)
			return Wrapper.Instance.Parent
		end,

		function(Wrapper, NewValue)
			rawset(Wrapper, "_WP", true)

			if type(NewValue) == "table" and NewValue.Instance then
				Wrapper.Instance.Parent = NewValue.Instance
			else
				Wrapper.Instance.Parent = NewValue
			end

			RecalculateBranchDepth(Wrapper)
			UpdateScaledProperties(Wrapper)
		end,
		true,
	},

	["CornerInstance"] = {
		function(Wrapper)
			return rawget(Wrapper, "_C")
		end,
		nil,
		true,
	},

	["StrokeThickness"] = {
		function(Wrapper)
			local Stroke = rawget(Wrapper, "_S")

			if Stroke then
				return Module.Scalar.New(Stroke.Thickness.Scale, Stroke.Thickness.Offset)
			end

			return Module.Scalar.New(0, 0)
		end,

		function(Wrapper, NewValue)
			local Scalar = type(NewValue) == "number" and Module.Scalar.New(0, NewValue) or NewValue
			local Stroke = rawget(Wrapper, "_S")
			local Visible = Scalar.Offset > 0 or Scalar.Scale > 0

			if Visible then
				if not Stroke then
					Stroke = Instance.New("UIStroke")
					Stroke.Parent = Wrapper.Instance
					rawset(Wrapper, "_S", Stroke)

					local StoredColor = rawget(Wrapper, "_SC")
					if StoredColor ~= nil then
						Stroke.Color = StoredColor
					end
				end

				local Thickness = Stroke.Thickness
				Thickness.Scale = Scalar.Scale
				Thickness.Offset = Scalar.Offset
				Stroke.Thickness = Thickness
			else
				if Stroke then
					Stroke:Destroy()
					rawset(Wrapper, "_S", nil)
				end
			end
		end,
		true,
	},

	["StrokeColor"] = {
		function(Wrapper)
			return rawget(Wrapper, "_SC")
		end,

		function(Wrapper, NewValue)
			rawset(Wrapper, "_SC", NewValue)

			local Stroke = rawget(Wrapper, "_S")
			if Stroke then
				Stroke.Color = NewValue
			end
		end,
		true,
	},

	["StrokeInstance"] = {
		function(Wrapper)
			return rawget(Wrapper, "_S")
		end,
		nil,
		true,
	},

	["Shadow"] = {
		function(Wrapper)
			local Shadow = rawget(Wrapper, "_SHW")
            if not Shadow then 
                return {} 
            end

            return ExtractShadowLayers(Shadow.Layers)
		end,

		function(Wrapper, NewValue)
			local Shadow = rawget(Wrapper, "_SHW")
			local Visible = type(NewValue) == "table" and #NewValue > 0

			if Visible then
				if not Shadow then
					Shadow = Instance.New("UIShadow")
					Shadow.Parent = Wrapper.Instance
					rawset(Wrapper, "_SHW", Shadow)
				end

				Shadow.Layers = CreateShadowLayers(NewValue)
			else
				if Shadow then
					Shadow:Destroy()
					rawset(Wrapper, "_SHW", nil)
				end
			end
		end,
		true,
	},

	["ShadowInstance"] = {
		function(Wrapper)
			return rawget(Wrapper, "_SHW")
		end,
		nil,
		true,
	},

	["Ratio"] = {
		function(Wrapper)
			return rawget(Wrapper, "_R")
		end,
		function(Wrapper, NewValue)
			rawset(Wrapper, "_R", NewValue)
			UpdateScaledProperties(Wrapper)
		end,
		true,
	},

	["CornerRadius"] = {
		function(Wrapper)
			local Corner = rawget(Wrapper, "_C")
			if not Corner then
				return Module.Scalar.New(0, 0)
			end

			local Radius = Corner.TopLeftCornerRadius
			return Module.Scalar.New(Radius.Scale, Radius.Offset)
		end,

		function(Wrapper, NewValue)
			local Scalar = type(NewValue) == "number" and Module.Scalar.New(NewValue, 0) or NewValue
			local Visible = Scalar.Offset > 0 or Scalar.Scale > 0
			local Corner = rawget(Wrapper, "_C")

			if Visible then
				if not Corner then
					Corner = Instance.New("UICorner")
					Corner.Parent = Wrapper.Instance
					rawset(Wrapper, "_C", Corner)
				end

				for _, PropertyName in IndividualCornerProperties do
					local R = Corner[PropertyName]
					R.Scale = Scalar.Scale
					R.Offset = Scalar.Offset
					Corner[PropertyName] = R
				end
			else
				if Corner then
					Corner:Destroy()
					rawset(Wrapper, "_C", nil)
				end
			end
		end,
		true,
	}
}

local function HasVisibleCorners(Corner, ExcludeProperty, NewValue)
	if not Corner then
		return false
	end

	for _, PropertyName in IndividualCornerProperties do
		local Radius = Corner[CornerPropertyMap[PropertyName]]

		if PropertyName == ExcludeProperty and NewValue then
			Radius = NewValue
		end

		if Radius and (Radius.Offset > 0 or Radius.Scale > 0) then
			return true
		end
	end

	return false
end

for _, PropertyName in IndividualCornerProperties do
	SpecialProperties[CornerPropertyMap[PropertyName]] = {
		function(Wrapper)
			local Corner = rawget(Wrapper, "_C")
			if not Corner then
				return Module.Scalar.New(0, 0)
			end

			local Radius = Corner[PropertyName]

			return Module.Scalar.New(Radius.Scale, Radius.Offset)
		end,

		function(Wrapper, NewValue)
			local Scalar = type(NewValue) == "number" and Module.Scalar.New(NewValue, 0) or NewValue

			local Visible = Scalar.Offset > 0 or Scalar.Scale > 0
			local Corner = rawget(Wrapper, "_C")

			if Visible then
				if not Corner then
					Corner = Instance.New("UICorner")
					Corner.Parent = Wrapper.Instance
					rawset(Wrapper, "_C", Corner)
				end

				local Radius = Corner[PropertyName]
				Radius.Scale = Scalar.Scale
				Radius.Offset = Scalar.Offset

				Corner[PropertyName] = Radius
			else
				if Corner then
					if not HasVisibleCorners(Corner, PropertyName, Scalar) then
						Corner:Destroy()
						rawset(Wrapper, "_C", nil)
					end
				end
			end
		end,
		true,
	}
end

local SpatialMetatable = {}

SpatialMetatable.__add = function(A, B)
	return Module.Spatial.New(A.Scale.X + B.Scale.X, A.Scale.Y + B.Scale.Y, A.Offset.X + B.Offset.X, A.Offset.Y + B.Offset.Y)
end

SpatialMetatable.__sub = function(A, B)
	return Module.Spatial.New(A.Scale.X - B.Scale.X, A.Scale.Y - B.Scale.Y, A.Offset.X - B.Offset.X, A.Offset.Y - B.Offset.Y)
end

Module.Spatial.New = function(ScaleX, ScaleY, OffsetX, OffsetY)
	return setmetatable({
		Scale = { X = ScaleX or 0, Y = ScaleY or 0 },
		Offset = { X = OffsetX or 0, Y = OffsetY or 0 },
	}, SpatialMetatable)
end

Module.Spatial.FromScale = function(ScaleX, ScaleY)
	return Module.Spatial.New(ScaleX or 0, ScaleY or 0, 0, 0)
end

Module.Spatial.FromOffset = function(OffsetX, OffsetY)
	return Module.Spatial.New(0, 0, OffsetX or 0, OffsetY or 0)
end

local ScalarMetatable = {}

ScalarMetatable.__add = function(A, B)
	return Module.Scalar.New(A.Scale + B.Scale, A.Offset + B.Offset)
end

ScalarMetatable.__sub = function(A, B)
	return Module.Scalar.New(A.Scale - B.Scale, A.Offset - B.Offset)
end

Module.Scalar.New = function(Scale, Offset)
	return setmetatable({
		Scale = Scale or 0,
		Offset = Offset or 0,
	}, ScalarMetatable)
end

local UIElementMethods = {}

local function HardCleanup(Wrapper)
	local Raw = rawget(Wrapper, "Instance")
	if Raw then
		ActiveWrappers[Raw] = nil
		spawn(function()
			pcall(function()
				Raw:Destroy()
			end)
		end)
	end
	rawset(Wrapper, "Instance", nil)
	rawset(Wrapper, "_Destroyed", true)
end

local function ValidWrapper(Wrapper)
	if type(Wrapper) ~= "table" then return false end
	if rawget(Wrapper, "_Destroyed") then return false end

	local Inst = rawget(Wrapper, "Instance")
	if not Inst then return false end

	local Parent = Inst.Parent
	if Parent == nil and rawget(Wrapper, "_WP") then return false end

	return true
end

local function RunAutoCleaner()
	if AutoCleaner.Running then
		return
	end

	AutoCleaner.Running = true
	AutoCleaner.Thread = coroutine.create(function()
		while true do
			wait(1)

			local HasAny = false

			for Inst, Wrapper in ActiveWrappers do
				if ValidWrapper(Wrapper) then
					HasAny = true
				else
					ActiveWrappers[Inst] = nil
				end
			end

			if not HasAny then
				AutoCleaner.Running = false
				AutoCleaner.Thread = nil
				return
			end
		end
	end)

	coroutine.resume(AutoCleaner.Thread)
end

local function ValidatePropertyType(Instance, ResolvedKey, Value)
	local ExpectedType = ExpectedPropertyTypes[ResolvedKey]

	if not ExpectedType then
		ExpectedType = typeof(Instance[ResolvedKey])
	end

	local ValTypeOf = typeof(Value)
	local ValType = type(Value)
	local IsValid = false

	if Value == nil then
		if ExpectedType == "Instance" or ExpectedType == "Parent" then
			return true
		else
			print(string.format('[KINETIK] Error : Property "%s" cannot be nil.', ResolvedKey))
			return false
		end
	end

	if ExpectedType == "Parent" then
		IsValid = ValType == "userdata" or (ValType == "table" and Value.Instance ~= nil)
	elseif ExpectedType == "Instance" then
		IsValid = ValType == "userdata"
	elseif ExpectedType == "Spatial" then
		IsValid = ValType == "table" and getmetatable(Value) == SpatialMetatable
	elseif ExpectedType == "Scalar" then
		IsValid = ValTypeOf == "number" or (ValType == "table" and getmetatable(Value) == ScalarMetatable)
	elseif ExpectedType == "Shadow" then
		IsValid = ValType == "table"
		if IsValid then
			for _, layer in ipairs(Value) do
				if type(layer) ~= "table" then
					IsValid = false
					break
				end
			end
		end
	elseif ExpectedType == "Vector2" then
		IsValid = ValTypeOf == "Vector2"
	elseif ExpectedType == "Color" then
		IsValid = ValTypeOf == "Color"
	elseif ExpectedType == "userdata" then
		IsValid = ValType == "userdata" or Value == nil
	else
		IsValid = ValTypeOf == ExpectedType
	end

	if not IsValid then
		print(string.format('[KINETIK] Error : Invalid type for property "%s". Expected %s, got %s.', ResolvedKey, ExpectedType, tostring(ValType)))
	end

	return IsValid
end

local function Create(ClassType, StarterProperties)
	local RawInstance = Instance.New(ClassesMap[ClassType])

	local Wrapper = {
		Instance = RawInstance,
		ClassType = ClassType,
		_Destroyed = false,
		_WP = false, -- WasParented
		_DP = 0,     -- Depth
	}

	ActiveWrappers[RawInstance] = Wrapper
	RunAutoCleaner()

	local ProxyMetatable = {
		__index = function(self, Key)
			local Inst = rawget(self, "Instance")
			if rawget(self, "_Destroyed") or not Inst then
				if not rawget(self, "_Destroyed") then
					HardCleanup(self)
				end
				print("[KINETIK] Error : Attempt to index a destroyed UI Wrapper object")
				return nil
			end

			if Key == "Destroy" or Key == "Delete" then
				return function()
					HardCleanup(self)
				end
			end

			if UIElementMethods[Key] then
				return function(_, ...)
					return UIElementMethods[Key](self, ...)
				end
			end

			if Key == "Instance" or Key == "ClassType" then
				return rawget(self, Key)
			end

			local ResolvedKey = ResolvePropertyName(Key)

			if IsPropertyAllowed(self.ClassType, ResolvedKey) then
				if SpecialProperties[ResolvedKey] then
					local Getter = SpecialProperties[ResolvedKey][1]
					local UseWrapper = SpecialProperties[ResolvedKey][3]
					return Getter(UseWrapper and self or Inst)
				end
				return Inst[ResolvedKey]
			end

			if IsMethodAllowed(self.ClassType, ResolvedKey) then
				return function(_, ...)
					return Inst[ResolvedKey](Inst, ...)
				end
			end

			if IsEventAllowed(self.ClassType, ResolvedKey) then
				return Inst[ResolvedKey]
			end

			print(string.format("[KINETIK] Error : %s is not a valid member of %s", tostring(ResolvedKey), self.ClassType))
			return nil
		end,

		__newindex = function(self, Key, Value)
			local Inst = rawget(self, "Instance")
			if rawget(self, "_Destroyed") or not Inst then
				if not rawget(self, "_Destroyed") then
					HardCleanup(self)
				end

				print("[KINETIK] Error : Attempt to modify a destroyed UI Wrapper object")
				return
			end

			local ResolvedKey = ResolvePropertyName(Key)

			if ReadOnlyProperties[ResolvedKey] then
				print(string.format("[KINETIK] Error : %s is read-only and cannot be modified in %s", tostring(ResolvedKey), self.ClassType))
				return
            end

			if IsPropertyAllowed(self.ClassType, ResolvedKey) then
				if not ValidatePropertyType(Inst, ResolvedKey, Value) then
					return nil
				end

				if SpecialProperties[ResolvedKey] then
					local Setter = SpecialProperties[ResolvedKey][2]
					local UseWrapper = SpecialProperties[ResolvedKey][3]
					if Setter then
						Setter(UseWrapper and self or Inst, Value)
						return
					else
						print(string.format("[KINETIK] Error : %s is read-only in %s", tostring(ResolvedKey), self.ClassType))
						return
					end
				end

				Inst[ResolvedKey] = Value
				return
			end

			print(string.format("[KINETIK] Error : %s cannot be assigned to %s", tostring(ResolvedKey), self.ClassType))
		end,
	}

	setmetatable(Wrapper, ProxyMetatable)

	for Key, Value in StarterProperties do
		Wrapper[Key] = Value
	end

	rawset(Wrapper, "_DP", GetDepth(RawInstance))
	UpdateScaledProperties(Wrapper)

	return Wrapper
end

local function ResolveClassType(InputName)
    if ClassesMap[InputName] then
        return InputName
    end

    local LowerInput = InputName:lower()
    for InternalName, EngineName in ClassesMap do
        if InternalName:lower() == LowerInput or EngineName:lower() == LowerInput then
            return InternalName
        end
    end

    return nil
end

function Module:Create(ClassType, StarterProperties, Children)
	if type(ClassType) ~= "string" then
		print(string.format("[KINETIK] Error | Create : ClassType must be a string, got %s", type(ClassType)))
		return nil
	end

	local ResolvedClass = ResolveClassType(ClassType)

    if not ResolvedClass then
		print(string.format('[KINETIK] Error | Create : "%s" is not a valid ClassType or EngineName', tostring(ClassType)))
		return nil
	end

	if StarterProperties ~= nil and type(StarterProperties) ~= "table" then
		print(string.format("[KINETIK] Error | Create : StarterProperties must be a table or nil, got %s", type(StarterProperties)))
		return nil
	end

	if Children ~= nil and type(Children) ~= "table" then
		print(string.format("[KINETIK] Error | Create : Children must be a table or nil, got %s", type(Children)))
		return nil
	end

	local Wrapper = Create(ResolvedClass, {})
	Wrapper.Name = ResolvedClass

	if StarterProperties then
		for RawKey, Value in StarterProperties do
			Wrapper[RawKey] = Value
		end
	end

	if Children then
		for ChildIndex, Child in Children do
			local Success, ErrorMessage = pcall(function()
				if type(Child) == "table" and Child.Instance then
					Child.Parent = Wrapper
				elseif typeof(Child) == "Instance" then
					Child.Parent = Wrapper.Instance
				else
					error("Expected Wrapper or Instance, got " .. typeof(Child))
				end
			end)

			if not Success then
				print("[KINETIK] Error | Create : Failed to parent child at index " .. tostring(ChildIndex) .. " : " .. tostring(ErrorMessage))
			end
		end
	end

	return Wrapper
end

local PreviousWidth = 0
local PreviousHeight = 0

function Module._Update()
	if PreviousWidth ~= Input.ScreenWidth or PreviousHeight ~= Input.ScreenHeight then
		PreviousWidth = Input.ScreenWidth
		PreviousHeight = Input.ScreenHeight

		local Sortable = {}
		for Inst, Wrapper in ActiveWrappers do
			if ValidWrapper(Wrapper) then
				table.insert(Sortable, Wrapper)
			else
				ActiveWrappers[Inst] = nil
			end
		end

		table.sort(Sortable, function(a, b)
			return (rawget(a, "_DP") or 0) < (rawget(b, "_DP") or 0)
		end)

		for _, Wrapper in Sortable do
			UpdateScaledProperties(Wrapper)
		end
	end
end

game.Rendered:Connect(Module._Update)

local CopyStyles = {
	["Albedo"] = { "Color", "StrokeColor", "StrokeThickness" },
	["Appearance"] = { "Color", "StrokeColor", "StrokeThickness", "CornerRadius", "Shadow" },
	["Style"] = { "Color", "StrokeColor", "StrokeThickness", "TopLeftCornerRadius", "TopRightCornerRadius", "BottomLeftCornerRadius", "BottomRightCornerRadius" },
	["Transform"] = { "Position", "Size", "Rotation", "Scale", "PivotPoint" },
	["Layout"] = { "Position", "Size", "Rotation", "Scale" },
	["Text"] = { "Text", "TextColor", "FontSize", "FontAsset", "HorizontalAlignment", "VerticalAlignment" },
	["Typography"] = { "Text", "TextColor", "FontSize", "FontAsset", "HorizontalAlignment", "VerticalAlignment", "OutlineColor", "OutlineWidth" },
	["Sizing"] = { "Size", "SizeRelative", "SizeOffset", "Ratio" },
	["Positioning"] = { "Position", "PositionRelative", "PositionOffset" },
	["Effects"] = { "StrokeColor", "StrokeThickness", "CornerRadius", "Shadow" },
}

function UIElementMethods.Copy(Wrapper, CopyStyle)
	local PropertiesToCopy = {}
	local Style = tostring(CopyStyle or "All"):lower()

	if Style == "all" then
		local Allowed = AllowedCache.Properties[Wrapper.ClassType]
		if Allowed then
			for PropName, _ in Allowed do
				table.insert(PropertiesToCopy, PropName)
			end
		end
	elseif CopyStyles[CopyStyle] then
		PropertiesToCopy = CopyStyles[CopyStyle]
	elseif type(CopyStyle) == "table" then
		PropertiesToCopy = CopyStyle
	end

	local Export = {}
	for _, PropName in PropertiesToCopy do
		local Resolved = ResolvePropertyName(PropName)

		if not ReadOnlyProperties[Resolved] then
			if IsPropertyAllowed(Wrapper.ClassType, Resolved) or SpecialProperties[Resolved] then
				Export[Resolved] = Wrapper[Resolved]
			end
		end
	end

	return Export
end

function UIElementMethods.Paste(Wrapper, Properties)
	if type(Properties) ~= "table" then
		return
	end

	for Key, Value in Properties do
		local ResolvedKey = ResolvePropertyName(Key)

		pcall(function()
			Wrapper[ResolvedKey] = Value
		end)
	end
end

UIElementMethods.Apply = UIElementMethods.Paste
UIElementMethods.ApplyProperties = UIElementMethods.Paste

local TweenProxy = {}
TweenProxy.__index = TweenProxy

function TweenProxy.New(Wrapper, Info, Goals)
	local self = setmetatable({}, TweenProxy)

	self._W = Wrapper -- Wrapper
	self._G = Goals   -- Goals
	self._I = Info    -- Info
	self._TO = nil    -- TweenObject
	self._CC = {}     -- CompletedCallbacks

	self.Completed = {
		Connect = function(_, Callback)
			table.insert(self._CC, Callback)
		end,
		Wait = function(_)
			if not self._TO then
				return
			end
			self._TO.Finished:Wait()
		end,
	}

	return self
end

local function MakeWeakRef(obj)
	return setmetatable({ ref = obj }, { __mode = "v" })
end

local TypeHandlers = {
	["Spatial"] = function(TweenObj, Wrapper, Prop, Start, Target, Duration)
		local RelProp = Prop .. "Relative"
		local OffProp = Prop .. "Offset"
		local WeakWrapper = MakeWeakRef(Wrapper)

		TweenObj:TweenVector2(Vector2.New(Start.Scale.X, Start.Scale.Y), Vector2.New(Target.Scale.X, Target.Scale.Y), Duration, function(V)
			local W = WeakWrapper.ref
			if not W or rawget(W, "_Destroyed") then
				TweenObj:Stop()
				return
			end
			pcall(function()
				W[RelProp] = V
			end)
		end)

		TweenObj:TweenVector2(Vector2.New(Start.Offset.X, Start.Offset.Y), Vector2.New(Target.Offset.X, Target.Offset.Y), Duration, function(V)
			local W = WeakWrapper.ref
			if not W or rawget(W, "_Destroyed") then
				TweenObj:Stop()
				return
			end
			pcall(function()
				W[OffProp] = V
			end)
		end)
	end,

	["Scalar"] = function(TweenObj, Wrapper, Prop, Start, Target, Duration)
		local WeakWrapper = MakeWeakRef(Wrapper)

		local StartV2 = Vector2.New(Start.Scale, Start.Offset)
		local TargetV2 = Vector2.New(Target.Scale, Target.Offset)

		TweenObj:TweenVector2(StartV2, TargetV2, Duration, function(V)
			local W = WeakWrapper.ref
			if not W or rawget(W, "_Destroyed") then
				TweenObj:Stop()
				return
			end
			pcall(function()
				W[Prop] = Module.Scalar.New(V.X, V.Y)
			end)
		end)
	end,

	["Color"] = function(TweenObj, Wrapper, Prop, Start, Target, Duration)
		local WeakWrapper = MakeWeakRef(Wrapper)

		TweenObj:TweenColor(Start, Target, Duration, function(C)
			local W = WeakWrapper.ref
			if not W or rawget(W, "_Destroyed") then
				TweenObj:Stop()
				return
			end
			pcall(function()
				W[Prop] = C
			end)
		end)
	end,

	["number"] = function(TweenObj, Wrapper, Prop, Start, Target, Duration)
		local WeakWrapper = MakeWeakRef(Wrapper)

		TweenObj:TweenNumber(Start, Target, Duration, function(N)
			local W = WeakWrapper.ref
			if not W or rawget(W, "_Destroyed") then
				TweenObj:Stop()
				return
			end
			pcall(function()
				W[Prop] = N
			end)
		end)
	end,

	["Vector2"] = function(TweenObj, Wrapper, Prop, Start, Target, Duration)
		local WeakWrapper = MakeWeakRef(Wrapper)

		TweenObj:TweenVector2(Start, Target, Duration, function(V)
			local W = WeakWrapper.ref
			if not W or rawget(W, "_Destroyed") then
				TweenObj:Stop()
				return
			end
			pcall(function()
				W[Prop] = V
			end)
		end)
	end,

	["Vector3"] = function(TweenObj, Wrapper, Prop, Start, Target, Duration)
		local WeakWrapper = MakeWeakRef(Wrapper)

		TweenObj:TweenVector3(Start, Target, Duration, function(V)
			local W = WeakWrapper.ref
			if not W or rawget(W, "_Destroyed") then
				TweenObj:Stop()
				return
			end
			pcall(function()
				W[Prop] = V
			end)
		end)
	end,
}

local function GetValueType(Val)
	local RawType = typeof(Val)
	if RawType == "table" then
		if Val.Scale and typeof(Val.Scale) == "table" then
			return "Spatial"
		end
		if Val.Scale and typeof(Val.Scale) == "number" then
			return "Scalar"
		end
	end
	return RawType
end

function TweenProxy:Play()
	if self._TO then
		self._TO:Stop()
	end

	local TweenObj = Tween:NewTween()
	self._TO = TweenObj

	TweenObj.Parallel = true
	TweenObj:SetTrans(self._I.EasingStyle or Enums.TweenTransition.Linear)
	TweenObj:SetDirection(self._I.EasingDirection or Enums.TweenDirection.Out)
	TweenObj.Looped = self._I.RepeatCount == -1 or false

	local Duration = self._I.Time or 1

	for PropName, TargetValue in self._G do
		local Resolved = ResolvePropertyName(PropName)
		local StartValue = self._W[Resolved]
		local Type = GetValueType(TargetValue)

		local Handler = TypeHandlers[Type]
		if Handler then
			Handler(TweenObj, self._W, Resolved, StartValue, TargetValue, Duration)
		end
	end

	spawn(function()
		TweenObj.Finished:Wait()
		for _, Callback in self._CC do
			Callback()
		end
	end)

	TweenObj:Play()
end

function TweenProxy:Cancel()
	if self._TO then
		self._TO:Stop()
	end
end

local TweenDirectionAliases = {
	["In"] = Enums.TweenDirection.In,
	["Out"] = Enums.TweenDirection.Out,
	["InOut"] = Enums.TweenDirection.InOut,
	["OutIn"] = Enums.TweenDirection.OutIn,
}

local TweenTransitionAliases = {
	["Linear"] = Enums.TweenTransition.Linear,
	["Sine"] = Enums.TweenTransition.Sine,
	["Quint"] = Enums.TweenTransition.Quint,
	["Quart"] = Enums.TweenTransition.Quart,
	["Quad"] = Enums.TweenTransition.Quad,
	["Expo"] = Enums.TweenTransition.Expo,
	["Exponential"] = Enums.TweenTransition.Expo,
	["Elastic"] = Enums.TweenTransition.Elastic,
	["Cubic"] = Enums.TweenTransition.Cubic,
	["Circ"] = Enums.TweenTransition.Circ,
	["Circular"] = Enums.TweenTransition.Circ,
	["Bounce"] = Enums.TweenTransition.Bounce,
	["Back"] = Enums.TweenTransition.Back,
	["Spring"] = Enums.TweenTransition.Spring,
}

function UIElementMethods.Tween(Wrapper, Info, Goals)
	if rawget(Wrapper, "_Destroyed") then
		error("[KINETIK] Error | Tween : Attempt to TweenObj a destroyed UI Wrapper")
	end

	if not Goals and type(Info) == "table" then
		Goals = Info
		Info = {}
	end

	Goals = Goals or {}
	Info = Info or {}

	if type(Info) == "table" then
		if Info[1] ~= nil then Info.Time = Info[1] end
		if Info[2] ~= nil then Info.EasingStyle = Info[2] end
		if Info[3] ~= nil then Info.EasingDirection = Info[3] end

		Info.Time = Info.Time or 1
		Info.EasingStyle = Info.EasingStyle or Info.TweenTransition or Enums.TweenTransition.Linear
		Info.EasingDirection = Info.EasingDirection or Info.TweenDirection or Enums.TweenDirection.Out

		if typeof(Info.EasingDirection) == "string" then
			Info.EasingDirection = TweenDirectionAliases[Info.EasingDirection] or Enums.TweenDirection.Out
		end

		if typeof(Info.EasingStyle) == "string" then
			Info.EasingStyle = TweenTransitionAliases[Info.EasingStyle] or Enums.TweenTransition.Linear
		end
	end

	return TweenProxy.New(Wrapper, Info, Goals)
end

function Module:CreateTween(Wrapper, Info, Goals)
	return UIElementMethods.Tween(Wrapper, Info, Goals)
end

return Module
