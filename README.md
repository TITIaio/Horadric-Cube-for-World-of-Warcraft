# 魔兽世界版的赫拉迪克方块 / Horadric-Cube-for-World-of-Warcraft
基于《暗黑破坏神2》的赫拉迪克方块功能制作的基于Eluna的魔兽世界功能扩展 / Horadric Cube for World of Warcraft  

### 视频演示 / Video Demo

https://github.com/user-attachments/assets/5fb3af7b-ffef-46ea-96ec-27120b11cae1


### 中文  
本项目是基于《暗黑破坏神2》的赫拉迪克方块功能制作的基于Eluna的魔兽世界功能扩展。可以在游戏中实现以下功能：  
- 物品合成  
- 物品转换  
- 传送  
- 开启隐藏的传送门

本项目对所使用音频与图像不享有版权

#### 要求:
需要服务端支持 Eluna 功能 和 AIO 功能

#### 界面以及使用说明
![cube_1](images/cube_1.png)

1-9 号槽位用于放入物品 通过拖拽将背包内的物品放入到方块中 1-9号槽位中的任意位置

10-12 号槽位用于输出产物 存放在这里的物品不会因角色离线而消失,这些数据保存在服务端内,当使用者再次打开界面将会显示,如果服务端重新启动或者重新加载Eluna那么这些数据将丢失

## 物品合成 / 转换
```lua
local Hradik = {
		[3] = {     --需要 3个物品 那么索引就是 3
		[354] = {   --这个值由需要的物品id值相加得出 118 x 3 = 354
			{118},  --所需物品 id 相同
			{3},    --需要 3 个 id 118 的物品
			8000,   --合成的基本成功率 1-10000 值越大成功率越高
			858,    --合成成功 将给予的物品id
			0,      --是否有可增加额外成功率的物品 (只需存在于背包内)
			0,      --额外增加的成功率值 0-10000 (这个值会与基本成功率相加)
		},
	},
}

	[4]={            --需要 4个物品 那么索引就是 4
		[40302]={    --3577 + 7076 + 11082 + 18567 = 40302
			{3577,7076,11082,18567}, --所需物品 id 不同
			{1,1,1,1},--如果需要的物品 id 不同 那么必须设置每个物品的数量
			1000,
			-10000,   --如果是负值 合成成功将从 Hradik_rand[-10000] 中对应的索引中产生结果
			6948,     --使用炉石作为示范
			10000,
		},
	},

local Hradik_rand = { --随机物品表
	[-10000] = {43631,43632,43634,43628,43637,43630,43638,43627,43641,43629,43635,43640,43633,43636,43639}, --喷泉金币
}

```

## 传送 / 传送门
```lua
local fk_place = {
	["g"] = { --索引 fk_place.g 为个人传送法术
		[17031] = 3561, -- 3561 代表法术 传送：暴风城  17031 代表传送符文
		[20725] = -10000, --是负值将使用 fk_ccoor[-10000] 的坐标 20725 是连结水晶的物品id
	},
	["t"] = { --索引 fk_place.t 为个传送门法术(相当于团队传送)
		[17032] = 11420, --团队传送法术 传送门：雷霆崖 17031 代表传送门符文
	},
}
local fk_ccoor = {
	[-10000] = {1,-7185,-3772,9,0} --map,x,y,z
}

放入 传送卷轴 + 传送符文 点击转换后 将触发 place.g[17031]的法术

放入 传送卷轴 + 连结水晶 点击转换后 将触发 place.g[20725]的法术

放入 传送之书 + 传送门符文 点击转换后 将触发 place.t[17032]的法术

```

### English  
This project is a World of Warcraft functionality extension based on Eluna, inspired by the Horadric Cube from Diablo II. It allows the following features in the game  
- Item crafting  
- Item transmutation  
- Teleportation  
- Opening hidden portals 

The audio and images used in this project are not copyrighted

#### Requirements:
The server needs to support Eluna functionality and AIO functionality

#### Interface and Usage Instructions
![cube_1](images/cube_1.png)

Slots 1-9 are used for placing items. You can drag items from your inventory into any of the slots (1-9) of the cube. 

Slots 10-12 are used for the output products. Items placed here will not disappear when the character logs out, as these data are stored on the server. When the user reopens the interface, the items will reappear. However, if the server is restarted or Eluna is reloaded, these data will be lost.  

## Item Synthesis
```lua
local Hradik = {
    [3] = {     -- Requires 3 items, so the index is 3
        [354] = {   -- This value is the sum of the required item IDs: 118 x 3 = 354
            {118},  -- Required item ID (all the same)
            {3},    -- Requires 3 items with ID 118
            8000,   -- Base success rate for crafting (1-10000); higher values mean higher success
            858,    -- Item ID awarded upon successful crafting
            0,      -- Whether an additional item exists to boost the success rate (just needs to be in the inventory)
            0,      -- Additional success rate value (0-10000); added to the base success rate
        },
    },
    [4] = {            -- Requires 4 items, so the index is 4
        [40302] = {    -- 3577 + 7076 + 11082 + 18567 = 40302
            {3577, 7076, 11082, 18567}, -- Required item IDs (different items)
            {1, 1, 1, 1}, -- If the required item IDs are different, specify the quantity for each item
            1000,         -- Base success rate for crafting (1-10000)
            -10000,       -- If negative, the result is chosen randomly from Hradik_rand[-10000]
            6948,         -- Using the Hearthstone (an in-game item) as an example
            10000,        -- Additional success rate value
        },
    },
}

local Hradik_rand = { -- Random item table
    [-10000] = {43631, 43632, 43634, 43628, 43637, 43630, 43638, 43627, 43641, 43629, 43635, 43640, 43633, 43636, 43639}, -- Fountain Coins
}

```

## Teleport / Portal
```lua
local fk_place = {
    ["g"] = { -- Index fk_place.g for individual teleport spells
        [17031] = 3561, -- 3561 represents the spell "Teleport: Stormwind", 17031 represents the "Rune of Teleportation"
        [20725] = -10000, -- If negative, the coordinates from fk_ccoor[-10000] will be used. 20725 is the item ID for the Nexus Crystal.
    },
    ["t"] = { -- Index fk_place.t for portal spells (similar to group teleport)
        [17032] = 11420, -- Group teleport spell "Portal: Thunder Bluff", 17032 represents the "Rune of Portals"
    },
}
local fk_ccoor = {
    [-10000] = {1, -7185, -3772, 9, 0} -- map, x, y, z
}

Place a Teleport Scroll + Rune of Teleportation into the cube and click Transmute to trigger the spell in place.g[17031]

Place a Teleport Scroll + Nexus Crystal into the cube and click Transmute to trigger the spell in place.g[20725]

Place a Book of Portals + Rune of Portals into the cube and click Transmute to trigger the spell in place.t[17032]

```

## 名称 / Name
Horadric Cube for World of Warcraft

## 作者 / Author
TITIaio

## 存储库 / Repository
[GitHub Repository](https://github.com/TITIaio/Horadric-Cube-for-World-of-Warcraft)

## 下载 / Download
[Download Source Code as .zip](https://github.com/TITIaio/Horadric-Cube-for-World-of-Warcraft/archive/refs/heads/main.zip)

## License
[GNU General Public License v3.0 (GPL-3.0)](https://opensource.org/licenses/GPL-3.0)
