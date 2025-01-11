--赫拉迪克方块(Horadric Cube)
--2025-1-11 / TITIaio
--Github : https://github.com/TITIaio/Horadric-Cube-for-World-of-Warcraft

local AIO = AIO or require("AIO")
if AIO.AddAddon() then
	return
end

local fk_aio = AIO.AddHandlers("aio_fk",{})

local fk_sd = {
	[0] = {
		0,0,0,
		0,0,0,
		0,0,0}, --物品ID 缓冲区
	[2] = {0,0,0}, --转换结果保存区
	[3] = {0,0,0,0,0,0,0,0,0},
	[4] = 32620, --辨识卷轴id
	[5] = 37118, --传送卷轴id
	[6] = 29571, --传送之书id
}
local fk_ui = {
	[0] = {},
	[1] = {},
	[2] = {33,72,111,33,72,111,33,72,111},
	[3] = {66,66,66,27,27,27,-11,-11,-11},
	[4] = {},
	[5] = {},
}
local fk_Fra = {}

fk_Fra.fk_01 = CreateFrame("Frame","fk_box_1",UIParent)
	fk_Fra.fk_01:SetSize(600,600)
	fk_Fra.fk_01:SetPoint("TOPLEFT",-125,-25)
	fk_Fra.fk_01:SetToplevel(true)
	fk_Fra.fk_01:EnableMouse(true)
	fk_Fra.fk_01:SetScript("OnDragStart",fk_Fra.fk_01.StartMoving)
	fk_Fra.fk_01:SetScript("OnHide",fk_Fra.fk_01.StopMovingOrSizing)
	fk_Fra.fk_01:SetScript("OnDragStop",fk_Fra.fk_01.StopMovingOrSizing)
	fk_Fra.fk_01:SetBackdrop({bgFile = "Interface\\UI\\Hor-1024",insets = {left = 4,right = 4,top = 4,bottom = 4}})
	tinsert(UISpecialFrames,"fk_box_1")
	fk_Fra.fk_01:Hide()

fk_Fra.fk_02 = CreateFrame("Button",nil,fk_Fra.fk_01,"UIPanelCloseButton")
	fk_Fra.fk_02:SetPoint("TOPRIGHT",-4,-12)
	fk_Fra.fk_02:EnableMouse(true)
	fk_Fra.fk_02:SetSize(32,32)

fk_Fra.fk_03 = CreateFrame("Button",nil,fk_Fra.fk_01)
	fk_Fra.fk_03:SetSize(45,45)
	fk_Fra.fk_03:SetPoint("CENTER",71,-106)
	fk_Fra.fk_03:EnableMouse(true)
	fk_Fra.fk_03:SetNormalTexture("Interface/UI/Hor_a")
	fk_Fra.fk_03:SetHighlightTexture("Interface/UI/Hor_b")
	fk_Fra.fk_03:SetPushedTexture("Interface/UI/Hor_c")
----------------------
local fk_sx = CreateFrame("Frame",nil,fk_Fra.fk_01)
	fk_sx:SetSize(400,577)
	fk_sx:SetPoint("CENTER",495,-1)
	fk_sx:SetBackdrop({bgFile = "Interface/BUTTONS/WHITE8X8"})
	fk_sx:SetBackdropColor(0,0,0,0.8)
	fk_sx:EnableMouse(true)

fk_sx.SF = CreateFrame("ScrollFrame","$parent_DF",fk_sx,"UIPanelScrollFrameTemplate")
	fk_sx.SF:SetPoint("TOPLEFT",fk_sx,12,-10)
	fk_sx.SF:SetPoint("BOTTOMRIGHT",fk_sx,-30,10)

fk_sx.Text = CreateFrame("EditBox",nil,fk_sx)
	fk_sx.Text:SetMultiLine(true)
	fk_sx.Text:SetSize(350,550)
	fk_sx.Text:SetPoint("TOPLEFT",fk_sx.SF)
	fk_sx.Text:SetPoint("BOTTOMRIGHT",fk_sx.SF)
	fk_sx.Text:SetMaxLetters(99999)
	fk_sx.Text:SetFontObject(GameFontNormal)
	fk_sx.Text:SetAutoFocus(false)
	fk_sx.Text:EnableMouse(false)

fk_sx.SF:SetScrollChild(fk_sx.Text)
fk_sx.Text:SetText("方块共|cFFFF6103 12 |r格,|cFFFF6103 1-9 |r格可放入物品,|cFFFF6103 10-12 |r格为存储区. 右键点击取出, 此区域空间不足将不执行任何操作, 且仅作临时保存\n\n|cFFFF6103转化|r\n\n|cFFFFFFFF方法:|r 放入物品点击转换,无顺序要求\n|cFFFFFFFF消耗:|r 以配方上为准 |cFFFF0000转化均有失败率|r\n\n|cFFFFFFFF说明:|r 大量公式遗失于各地, 通过|cFF57FEFF 互动/交流 |r获得新公式 某些情况可能获得罕见公式，是否|cFF57FEFF 公开|r 取决于你，也可将错误的公式告诉他人\n\n|cFFFFFFFF其他:|r |cFF00FFFF不考虑失败的情况下 只要知道公式要求，即可转化出对应物品，公式仅为说明且可多次获取并小幅提升成功率|r\n\n|cFFFF6103辨识|r\n\n|cFFFFFFFF方法:|r 将|cFF52D017物品|r和|cFF52D017辨识卷轴|r放入方块点转化\n|cFFFFFFFF消耗:|r 辨识卷轴 x1\n|cFFFFFFFF要求:|r 紫/橙 物品等级>40 的以下装备:\n\n|cFFFFFFFF   项链 戒指 饰品 弓 弩 魔杖 盾 书 衬衣 战袍|r \n\n|cFFFFFFFF说明:|r 辨识间隔 3 秒,相同物品不可同时携带 辨识后物品将会绑定\n\n|cFFFFFFFF举例:|r |cFFC2B280背包内有 北风 x2 辨识时其中一把必须从 背包/身上 去除 比如存入银行|r\n\n|cFFB8860B暗金属性|r\n\n抗/魔/物防强化,魔/物伤强化,魔/物穿透,魔/物强度,HP上限/属性/法/命回 %\n\n|cFFFFD700金色属性|r\n\n按属性 % 提高物/法伤/治疗效果")
----------------------
for i = 1,9 do
	fk_ui[1][i] = CreateFrame("Frame",nil,fk_Fra.fk_01)
		fk_ui[1][i]:SetSize(38,38)
		fk_ui[1][i]:SetPoint("CENTER",fk_ui[2][i],fk_ui[3][i])
		fk_ui[1][i]:SetBackdrop({bgFile = "Interface/UI/Hor-64"})

	fk_ui[0][i] = CreateFrame("Button",nil,fk_ui[1][i])
		fk_ui[0][i]:SetSize(37,37)
		fk_ui[0][i]:EnableMouse(true)
		fk_ui[0][i]:SetPoint("CENTER",0,0)
		fk_ui[0][i]:SetBackdrop({bgFile = "Interface/UI/UI-000"})
		fk_ui[0][i]:SetHighlightTexture("Interface/UI/Hor-72")

	if i > 0 and i <= 3 then
		fk_ui[5][i] = CreateFrame("Frame",nil,fk_Fra.fk_01)
			fk_ui[5][i]:SetSize(38,38)
			fk_ui[5][i]:SetPoint("CENTER",fk_ui[2][i],-50)
			fk_ui[5][i]:SetBackdrop({bgFile = "Interface/UI/Hor-64"})

		fk_ui[4][i] = CreateFrame("Button",nil,fk_ui[5][i])
			fk_ui[4][i]:SetSize(37,37)
			fk_ui[4][i]:EnableMouse(true)
			fk_ui[4][i]:SetPoint("CENTER",0,0)
			fk_ui[4][i]:SetHighlightTexture("Interface/UI/Hor-72")
	end
end

function fk_zh_item_Server(index)
	AIO.Handle("aio_fk","fk_zh_item",index)
end

fk_Fra.fk_05 = CreateFrame("Button",nil,fk_Fra.fk_01)
	fk_Fra.fk_05:SetSize(26,128)
	fk_Fra.fk_05:SetPoint("CENTER",280,8)
	fk_Fra.fk_05:SetNormalTexture("Interface/UI/Hor-01")
	fk_Fra.fk_05:SetScript("OnMouseUp",function(self,button,down)
		if fk_sx:IsShown() then
			fk_sx:Hide()
			fk_Fra.fk_05:SetNormalTexture("Interface/UI/Hor-01")
		else
			fk_sx:Show()
			fk_Fra.fk_05:SetNormalTexture("Interface/UI/Hor-00")
		end
	end)

fk_Fra.fk_03:SetScript("OnClick",function(self)
	local fk_tab = {}
	local fk_toj = 0
	if fk_sd[2][1] > 0 and fk_sd[2][2] > 0 and fk_sd[2][3] > 0 then print("储存已满") return end
	for i = 1,#fk_sd[0] do
		if fk_sd[0][i] > 0 then
			table.insert(fk_tab,fk_sd[0][i])
			fk_toj = fk_toj + fk_sd[0][i]
		end
	end
	if #fk_tab == 2 then
		if fk_toj == 168121 or fk_toj == 168123 or fk_toj == 168124 then print("") return end
		if fk_tab[1] == fk_sd[4] or fk_tab[2] == fk_sd[4] and fk_tab[1] ~= fk_tab[2] then
			local item_sx = fk_toj - fk_sd[4]
			local Name,Link,Rari,iLev = GetItemInfo(item_sx)
			if Rari < 3 or Rari >= 6 then print("") return end
			if iLev < 40 then print("") return end
			local fk_news = {"b",item_sx}
			fk_zh_item_Server(fk_news)
		end

		if fk_tab[1] == fk_sd[5] or fk_tab[2] == fk_sd[5] and fk_tab[1] ~= fk_tab[2] then
			local fk_news = {"g",fk_toj - fk_sd[5]}
			fk_zh_item_Server(fk_news)
		end

		if fk_tab[1] == fk_sd[6] or fk_tab[2] == fk_sd[6] and fk_tab[1] ~= fk_tab[2] then
			local fk_news = {"t",fk_toj - fk_sd[6]}
			fk_zh_item_Server(fk_news)
		end
	elseif #fk_tab > 2 and #fk_tab <= 9 then
		local fk_news = {#fk_tab,fk_toj}
		fk_zh_item_Server(fk_news)
	end
	fk_tab,fk_toj = nil,0
end)

local function fk_icon()
	for i = 1,#fk_sd[0] do
		fk_ui[0][i]:SetBackdrop({bgFile = "Interface/UI/UI-000"})
	end
end

function fk_aio.fk_UI_box1(player,fk_gk)
	fk_sd[0] = {0,0,0,0,0,0,0,0,0}
	fk_sd[2] = fk_gk

	fk_icon()

	if fk_gk[4] and fk_gk[4] == 1 then
		PlaySound("File00000547")
		fk_gk[4] = 0
	end
	fk_UI_GO()
end

function fk_aio.fk_UI_box2(player,fk_gg)
	fk_sd[2] = fk_gg
	fk_UI_GO()
end

function fk_aio.fk_UI_box3(player,fk_qc)
	if fk_qc == 2 then
		PlaySound("File00000550")
		if GetItemCount(fk_sd[4]) < 1 then
			fk_sd[0] = {0,0,0,0,0,0,0,0,0}
			fk_icon()
		end
	else
		fk_sd[0] = {0,0,0,0,0,0,0,0,0}
		fk_icon()
	end
	fk_UI_GO()
end

function fk_UI_GO()
	fk_sx:Hide()
	fk_Fra.fk_05:SetNormalTexture("Interface/UI/Hor-01")
	if (fk_Fra.fk_01:IsShown()) then
		fk_Fra.fk_01:Hide()
	end
	fk_Fra.fk_01:Show()
	for i = 1,9 do
		fk_ui[0][i]:SetScript("OnMouseUp",function(self,button,down)
			if button == "LeftButton" then
				if CursorHasItem() == 1 then
					local fk_it_Ty,fk_it_id,fk_it_na = GetCursorInfo()
					if (fk_it_Ty ~= "item") then print("") return end

					if fk_it_id == 84015 then print("") return end

					local fk_fo = {GetItemCount(fk_it_id),0,}
					if fk_fo[1] <= 0 then return end

					for i = 1,#fk_sd[0] do
						if fk_it_id == fk_sd[0][i] then
							fk_fo[2] = fk_fo[2] + 1
						end
					end

					if fk_fo[2] >= fk_fo[1] then
						for i = 1,#fk_sd[0] do
							if fk_it_id == fk_sd[0][i] then
								fk_sd[0][i] = 0
								fk_ui[0][i]:SetBackdrop({bgFile = "Interface/UI/UI-000"})
								break
							end
						end
					end

					PutItemInBackpack()
					fk_ui[0][i]:SetBackdrop({bgFile = GetItemIcon(fk_it_id)})
					fk_sd[0][i] = fk_it_id
					ClearCursor()
					PlaySound("File00000599")
				end
			elseif button == "RightButton" then
				if fk_sd[0][i] > 0 then
					fk_sd[0][i] = 0
					fk_ui[0][i]:SetBackdrop({bgFile = "Interface/UI/UI-000"})
				end
			end
		end)
		fk_ui[0][i]:SetScript("OnEnter",function(self)
			GameTooltip:SetOwner(self,"ANCHOR_CURSOR",-12,-12)
			GameTooltip:SetHyperlink("item:"..fk_sd[0][i])
			GameTooltip:Show()
		end)
		fk_ui[0][i]:SetScript("OnLeave",function(self)
			GameTooltip:Hide()
		end)
		fk_ui[0][i]:Show()

		if i > 0 and i <= 3 then
			fk_ui[4][i]:SetScript("OnMouseUp",function(self,button,down)
				if button == "RightButton" and fk_sd[2][i] > 0 then
					local fk_news = {"n",i}
					fk_zh_item_Server(fk_news)
				end
			end)

			fk_ui[4][i]:SetBackdrop({bgFile = GetItemIcon(fk_sd[2][i])})
			fk_ui[4][i]:SetScript("OnEnter",function(self)
				GameTooltip:SetOwner(self,"ANCHOR_CURSOR",-12,-12)
				GameTooltip:SetHyperlink("item:"..fk_sd[2][i])
				GameTooltip:Show()
			end)
			fk_ui[4][i]:SetScript("OnLeave",function(self)
				GameTooltip:Hide()
			end)
			fk_ui[4][i]:Show()
		end
	end
end