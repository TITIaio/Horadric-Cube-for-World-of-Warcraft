--赫拉迪克方块(Horadric Cube)
--2025-1-11 / TITIaio
--Github : https://github.com/TITIaio/Horadric-Cube-for-World-of-Warcraft

local AIO = AIO or require("AIO")
local fk_aio = AIO.AddHandlers("aio_fk",{})

local Hradik = {
	[0]={
	},
	[1]={
	},
	[2]={
	},
	[3]={
		[354]={ --次级治疗
			{118},--需要的物品
			{3}, --要求数量
			8000, --成功率 1-10000
			858, --产出物 如果是正 将产生对应id的物品 如果是负将使用 Hradik_rand 表内对应元素 参考 随机喷泉金币
			0, --配方物品
			0, --配方成功率加成 1-10000
		},
	},
	[4]={
		[40302]={ --随机喷泉金币
			{3577,7076,11082,18567},--需要的物品
			{1,1,1,1}, --要求数量
			1000, --成功率 1-10000
			-10000, --产出物
			6948, --配方物品 这里使用炉石作为演示
			10000, --配方成功率加成 1-10000
		},
	},
	[5]={
	},
	[6]={
	},
	[7]={
	},
	[8]={
	},
	[9]={
		[165240]={--诺斯特罗的屠龙技术纲要
			{18361,18362,18357,18360,18358,18364,18356,18359,18363},--需要的物品
			{1,1,1,1,1,1,1,1,1}, --要求数量
			8000, --成功率 1-10000
			18401, --产出物
			0, --配方物品
			0, --配方成功率加成 1-10000
		},
	},
}

local Hradik_rand = { --随机物品表
	[-10000] = {43631,43632,43634,43628,43637,43630,43638,43627,43641,43629,43635,43640,43633,43636,43639}, --喷泉金币
}

local fk_place = {
	["g"] = {
		[17031] = 3561, --个人传送法术 传送：暴风城  17031 代表传送符文
		[20725] = -10000, --个人传送也可以直接使用坐标
	},
	["t"] = { --必须是法术
		[17032] = 11420, --团队传送法术 传送门：雷霆崖 17031 代表传送门符文
	},
}
local fk_ccoor = {
	[-10000] = {1,-7185,-3772,9,0} --map,x,y,z
}

local fk_jg = {[1]={},[2]={},[3]={}}
local fk_it = {}

local fk_data = {
	[1] = 32620, --辨识卷轴id
	[2] = 37118, --传送卷轴id
	[3] = 29571, --传送之书id
}

local function fk_cai_1(event,player,object,sender,intid,code,menuid)
	local fk_gi = player:GetGUIDLow()
	local fk_gk = {0,0,0,code}
	for i = 1,3 do
		if fk_jg[i][fk_gi] then
			fk_gk[i] = fk_jg[i][fk_gi]
		end
	end
	AIO.Handle(player,"aio_fk","fk_UI_box1",fk_gk)
end

local function fk_cai_2(player,fk_qc)
	local fk_gi = player:GetGUIDLow()
	if fk_qc == 1 then
		local fk_gg = {0,0,0}
		for i = 1,3 do
			if fk_jg[i][fk_gi] then
				fk_gg[i] = fk_jg[i][fk_gi]
			end
		end
		AIO.Handle(player,"aio_fk","fk_UI_box2",fk_gg)
	elseif fk_qc == 2 or fk_qc == 3 then
		AIO.Handle(player,"aio_fk","fk_UI_box3",fk_qc)
	end
end

local function fk_item_examine(player,f_code,f_item,f_mete)
	for i = 1,#f_item do
		if player:GetItemCount(f_item[i]) < f_code[i] then
			return false
		end
	end
	return true
end

local function fk_interval(pid,interval)
	local f_time = tonumber(string.format("%s",GetGameTime())) --秒
	if pid and interval then
		if fk_it[pid] and f_time - fk_it[pid] <= interval then
			return false
		end
	end
	fk_it[pid] = f_time
	return true
end

local function fk_zh_item_pf(player,fk_A,fk_B) --2秒间隔 / 2 seconds interval
	local fk_gi = player:GetGUIDLow()

	if (fk_jg[1][fk_gi] and fk_jg[1][fk_gi] > 0) and (fk_jg[2][fk_gi] and fk_jg[2][fk_gi] > 0) and (fk_jg[3][fk_gi] and fk_jg[3][fk_gi] > 0) then return end

	if fk_interval(fk_gi,2) == false then return end --2秒间隔 / 2 seconds interval

	if Hradik[fk_A][fk_B] then
		local formula_item = Hradik[fk_A][fk_B][1]
		local formula_code = Hradik[fk_A][fk_B][2]
		local formula_succ = Hradik[fk_A][fk_B][3]
		local formula_resu = 32728
		local formula_book = Hradik[fk_A][fk_B][5]
		local formula_alte = Hradik[fk_A][fk_B][6]
		local fk_pass = fk_item_examine(player,formula_code,formula_item,fk_A)
		if fk_pass == true then
			for i = 1,#formula_item do
				player:RemoveItem(formula_item[i],formula_code[i])
			end

			local fk_si = formula_succ - math.random(1,10000)

			if formula_book > 0 then
				if player:GetItemCount(formula_book) > 0 then
					fk_si = fk_si + formula_alte
				end
			end

			if fk_si > 0 then
				if Hradik[fk_A][fk_B][4] > 0 then
					formula_resu = Hradik[fk_A][fk_B][4]
				else
					local item_id = Hradik[fk_A][fk_B][4]
					local item_rand = Hradik_rand[item_id]
					if item_rand then
						local item_xx = math.random(1, #item_rand)
						formula_resu = item_rand[item_xx]
					end
				end
				for i = 1,3 do
					if not fk_jg[i][fk_gi] or fk_jg[i][fk_gi] == 0 then
						fk_jg[i][fk_gi] = formula_resu
						break
					end
				end
			end
			fk_cai_1(event,player,object,sender,intid,1,menuid)
		end
	end
end

local function fk_zh_item_lq(player,fk_Iv) --[[拿取 1秒间隔]]
	local fk_gi = player:GetGUIDLow()
	if fk_interval(fk_gi,1) == false then return end --1秒间隔 / 1 seconds interval
	if fk_jg[fk_Iv][fk_gi] > 0 then
		player:AddItem(fk_jg[fk_Iv][fk_gi],1)
		fk_jg[fk_Iv][fk_gi] = 0
		fk_cai_2(player,1)
	end
end

local function fk_item_bs(player,fk_Iv,item) --[[辨识 (玩家,fk_Iv,物品) 2秒间隔]]
	local fk_gi = player:GetGUIDLow()
	if fk_interval(fk_gi,2) == false then return end --2秒间隔 / 2 seconds interval
	if player:GetItemCount(fk_data[1]) <= 0 then return end
	if player:GetItemCount(fk_Iv) ~= 1 then return end
	local itFM = {item:GetItemLevel(),item:GetQuality(),item:GetInventoryType()}
	if itFM[3] ~=2 and itFM[3] ~=4 and itFM[3] ~=11 and itFM[3] ~=12 and itFM[3] ~=19 and itFM[3] ~=23 and itFM[3] ~=25 then return end --类型过滤

	if itFM[2] <=3 or itFM[2] >=6 then return end --过滤蓝装与传家宝
	if item:GetItemLevel() < 40 then return end
	if item:IsInTrade() then return end
	if item:GetOwner() ~= player then return end

	if item:IsSoulBound() == false then item:SetBinding(true) end
	player:RemoveItem(fk_data[1],1)
	if item:GetItemLevel() >= 320 then itFM[1] = 320 end
	local levl = { --设定 需要设置好 SpellItemEnchantment.dbc 的法术 / Spells that need to be set up in SpellItemEnchantment.dbc
		[0]={40,70,100,130,160,190,220,250,285,320,500}, --物品等级标准
		[1]={5133,5266,5399,5532,5665,5798,5931,6064,6197,6197}, --位置1 槽位0 编号对应 SpellItemEnchantment.dbc
		[2]={7088,7165,7242,7319,7396,7649,7473,7550,7627,7704}, --位置2 槽位1 编号对应 SpellItemEnchantment.dbc
		[3]={9029,9058,9087,9116,9145,9174,9203,9232,9261,9261}, --位置3 槽位5 编号对应 SpellItemEnchantment.dbc
		[4]={10065,10130,10195,10260,10325,10390,10455,10520,10585,10650}, --位置4 槽位6 隐藏 编号对应 SpellItemEnchantment.dbc
		[5]={5001,7001,9001,10001,5400,7320,9088,10196,5799,7650,9175,10391}, --编号起点 编号对应 SpellItemEnchantment.dbc
		[6]={5133,7088,9029,10065} --默认1-4属性最大编号 编号对应 SpellItemEnchantment.dbc
	}

	local levX = 1
	local levS = 0 --[[得出最大编号]]
	while itFM[1] >= levl[0][levX] do --按物品等级判断
		levX = levX + 1
		levS = levS + 1
		player:SendBroadcastMessage("等级标准:"..levS)
	end
	for i = 1,4 do
		levl[6][i] = levl[i][levS] --得出1-4最大编号
		player:SendBroadcastMessage("最大编号:"..levl[6][i])
	end

	local fk_F = {
		math.random(5001,levl[6][1]),  --1属性 槽位0
		math.random(7001,levl[6][2]),  --2属性 槽位1
		math.random(9001,levl[6][3]),  --3属性 槽位5
		math.random(10001,levl[6][4]), --4属性 槽位6 隐藏
		math.random(0,10000) --附魔几率设定
	}

	local slotMapping = { --定义槽位对应关系
		[2]  = {primarySlot = 0, secondarySlot = 1, enchantmentIndex = fk_F[1], orangeIndex = fk_F[3]},
		[4]  = {primarySlot = 0, secondarySlot = 1, enchantmentIndex = fk_F[1], orangeIndex = fk_F[3]},
		[11] = {primarySlot = 0, secondarySlot = 1, enchantmentIndex = fk_F[1], orangeIndex = fk_F[4]},
		[12] = {primarySlot = 0, secondarySlot = 1, enchantmentIndex = fk_F[1], orangeIndex = fk_F[4]},
		[19] = {primarySlot = 0, secondarySlot = 1, enchantmentIndex = fk_F[1], orangeIndex = fk_F[3]},
		[23] = {primarySlot = 0, secondarySlot = 1, enchantmentIndex = fk_F[1], orangeIndex = fk_F[2]},
		[25] = {primarySlot = 0, secondarySlot = 1, enchantmentIndex = fk_F[1], orangeIndex = fk_F[2]},
	}
	
	local mapping = slotMapping[itFM[3]] --检查当前槽位是否需要处理
	if mapping then
		--item:SetEnchantment(mapping.enchantmentIndex, mapping.primarySlot) --设置基础附魔 如果相关编号的法术已经制作好那么可以去掉注释
		player:SendBroadcastMessage("附魔1:"..mapping.enchantmentIndex.." | "..mapping.primarySlot)
		if fk_F[5] == 6 and fk_F[5] >= 2000 then --是否设置橙色附魔 几率 20% 橙色
			--item:SetEnchantment(mapping.orangeIndex, mapping.secondarySlot) --如果相关编号的法术已经制作好那么可以去掉注释
			player:SendBroadcastMessage("附魔2:"..mapping.orangeIndex.." | "..mapping.secondarySlot)
		end
	end
	fk_cai_2(player,2)
end

local function fk_pduan(player,content)
	if content > 0 then
		player:CastSpell(player,content,true)
	else
		if not fk_ccoor[content] then return end
		local map,x,y,z,o = unpack(fk_ccoor[content])
		player:Teleport(map,x,y,z,o)
	end
	fk_cai_2(player,3)
end

local function fk_player_go(player,fk_le,fk_Iv)
	if not fk_le or not fk_Iv then return end
	local fk_gi = player:GetGUIDLow()
	if fk_interval(fk_gi,2) == false then return end --2秒间隔 / 2 seconds interval

	if not fk_place[fk_le] or not fk_place[fk_le][fk_Iv] then return end

	if fk_le == "g" and player:GetItemCount(fk_data[2]) >= 1 then
		player:RemoveItem(fk_data[2],1)
		player:RemoveItem(fk_Iv,1)
		fk_pduan(player,fk_place[fk_le][fk_Iv])
	elseif fk_le == "t" and player:GetItemCount(fk_data[3]) >= 1 then
		player:RemoveItem(fk_data[3],1)
		player:RemoveItem(fk_Iv,1)
		fk_pduan(player,fk_place[fk_le][fk_Iv])
	end
end

function fk_aio.fk_zh_item(player,index)
	if not index then return end
	local inDEX = string.gsub(index[1],"[%A]","")
	local fk_Iv_1 = tonumber(index[1])
	local fk_Iv_2 = tonumber(index[2])

	if #inDEX == 1 and fk_Iv_2 then
		if inDEX == "b" then
			local item = player:GetItemByEntry(fk_Iv_2)
			fk_item_bs(player,fk_Iv_2,item)

		elseif inDEX == "n" and (fk_Iv_2 > 0 and fk_Iv_2 <= 3) then
			fk_zh_item_lq(player,fk_Iv_2)

		elseif inDEX == "g" or inDEX == "t" then
			fk_player_go(player,inDEX,fk_Iv_2)
		end
	end

	if fk_Iv_1 and fk_Iv_2 and (fk_Iv_1 > 2 and fk_Iv_1 <= 9)  then
		fk_zh_item_pf(player,fk_Iv_1,fk_Iv_2)
	end
end

RegisterItemGossipEvent(84015,1,fk_cai_1)