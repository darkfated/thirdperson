CreateClientConVar('third_person', 0, true, false)
CreateClientConVar('third_person_ud', 0, true, false, '', -15, 15)
CreateClientConVar('third_person_rl', 0, true, false, '', -20, 20)
CreateClientConVar('third_person_fb', -60, true, false, '', -120, 30)
CreateClientConVar('third_person_ang', 0, true, false, '', -45, 45)

hook.Add('ShouldDrawLocalPlayer', 'DarkFated.ThirdPerson', function()
	if GetConVar('third_person'):GetBool() then
		return !LocalPlayer():InVehicle()
	end
end)

hook.Add('CalcView', 'DarkFated.ThirdPerson', function(pl, origin, ang, fov)
	if GetConVar('third_person'):GetBool() and !pl:InVehicle() then
		return {
			origin = util.TraceLine({
				start = origin,
				endpos = origin + (ang:Up() * GetConVar('third_person_ud'):GetInt()) + (ang:Right() * GetConVar('third_person_rl'):GetInt()) + (ang:Forward() * GetConVar('third_person_fb'):GetInt()),
				filter = pl
			}).HitPos + (ang:Forward() * 16),
			angles = Vector(ang.x, ang.y, ang.z + GetConVar('third_person_ang'):GetInt()),
			fov = fov
		}
	end
end)

local color_header = Color(61, 61, 61)
local color_background = Color(44, 44, 44)
local color_close = Color(253, 116, 92)

concommand.Add('third_person_menu', function()
	local menu_thirdperson = vgui.Create('DFrame')
	menu_thirdperson:SetSize(300, 175)
	menu_thirdperson:Center()
	menu_thirdperson:MakePopup()
	menu_thirdperson:ShowCloseButton(false)
	menu_thirdperson:SetTitle('Third Person Settings')
	menu_thirdperson.Paint = function(_, w, h)
		draw.RoundedBox(8, 0, 0, w, h, color_background)
		draw.RoundedBoxEx(8, 0, 0, w, 24, color_header, true, true, false, false)
	end

	local cls = vgui.Create('DButton', menu_thirdperson)
	cls:SetSize(16, 16)
	cls:SetPos(menu_thirdperson:GetWide() - cls:GetWide() - 4, 4)
	cls:SetText('')
	cls.DoClick = function()
		menu_thirdperson:Close()
	end
	cls.Paint = function(_, w, h)
		draw.RoundedBox(6, 0, 0, w, h, color_close)
	end

	local Checkbox = vgui.Create('DCheckBoxLabel', menu_thirdperson)
	Checkbox:Dock(TOP)
	Checkbox:DockMargin(0, 2, 0, 0)
	Checkbox:SetText('Enable the third person')
	Checkbox:SetConVar('third_person')

	local slider_ud = vgui.Create('DNumSlider', menu_thirdperson)
	slider_ud:Dock(TOP)
	slider_ud:DockMargin(2, 0, 0, 0)
	slider_ud:SetText('Up/down position')
	slider_ud:SetMin(-15)
	slider_ud:SetMax(15)
	slider_ud:SetDecimals(0)
	slider_ud:SetConVar('third_person_ud')

	local slider_rl = vgui.Create('DNumSlider', menu_thirdperson)
	slider_rl:Dock(TOP)
	slider_rl:DockMargin(2, 0, 0, 0)
	slider_rl:SetText('Right/left position')
	slider_rl:SetMin(-20)
	slider_rl:SetMax(20)
	slider_rl:SetDecimals(0)
	slider_rl:SetConVar('third_person_rl')

	local slider_fb = vgui.Create('DNumSlider', menu_thirdperson)
	slider_fb:Dock(TOP)
	slider_fb:DockMargin(2, 0, 0, 0)
	slider_fb:SetText('Forward/back position')
	slider_fb:SetMin(-120)
	slider_fb:SetMax(-30)
	slider_fb:SetDecimals(0)
	slider_fb:SetConVar('third_person_fb')

	local slider_ang = vgui.Create('DNumSlider', menu_thirdperson)
	slider_ang:Dock(TOP)
	slider_ang:DockMargin(2, 0, 0, 0)
	slider_ang:SetText('Camera rotation')
	slider_ang:SetMin(-45)
	slider_ang:SetMax(45)
	slider_ang:SetDecimals(0)
	slider_ang:SetConVar('third_person_ang')
end)

// For Sandbox
list.Set('DesktopWindows', 'ThirdPersonMenu', {
	title = 'Third Person',
	icon = 'icon16/cake.png',
	onewindow = false,
	init = function()
		RunConsoleCommand('third_person_menu')
	end,
})
