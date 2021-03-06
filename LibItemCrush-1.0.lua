--[[
	This is merely a collection and combination of the various disenchant, prospecting and milling result and skill data tables out there.
	Mainly inspired by (aka copied from) tekkub's externals/disenchant_probability.lua & Enchantrix' data and also contains ReagentMaker's data

	All data tables are formatted in this manner:
		data = { [raw item] = { {createdItem, countText, chanceText, count, chance}, ... }, ... }

	All parts need to be encased or WoW screams at the many many many locals ;)
--]]

-- GLOBALS: GetItemInfo, GetProfessions, GetProfessionInfo
-- GLOBALS: select, unpack, math, tonumber, wipe, pairs

local MAJOR, MINOR = "LibItemCrush-1.0", 2
local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

local DISENCHANT = GetSpellInfo(13262)
local MILLING = GetSpellInfo(51005)
local PROSPECTING = GetSpellInfo(31252)
function lib:GetCrushType(item)
	return (lib:IsDisenchantable(item) and DISENCHANT)
		or (lib:IsMillable(item) and MILLING)
		or (lib:IsProspectable(item) and PROSPECTING)
		or nil
end

function lib:GetPossibleCrushs(item)
	if lib:IsDisenchantable(item) then
		return lib:GetPossibleDisenchants(item)
	elseif lib:IsMillable(item) then
		return lib:GetPossibleMillings(item)
	elseif lib:IsProspectable(item) then
		return lib:GetPossibleProspects(item)
	end
end

local CRAFTING = select(6, GetAuctionItemClasses())
local ORES, _, HERBS = select(4, GetAuctionItemSubClasses(6))

local sources = {}
function lib:GetCrushSources(item)
	if not item then return end
	local data
	local itemType, itemSubType = select(6, GetItemInfo(item))

	if itemType == CRAFTING and itemSubType == HERBS then
		data = lib.millingData
	elseif itemType == CRAFTING and itemSubType == ORES then
		data = lib.prospectData
	else
		-- TODO: disenchanting, something like 'Rare Weapons, level 30-55'
	end
	if not data then return end

	wipe(sources)
	for source, results in pairs(data) do
		for i=1, #results, 5 do
			if results[i] == item then
				table.insert(sources, { source, results[i+1], results[i+2], results[i+3], results[i+4] })
			end
		end
	end
	return sources
end

--[[ 		MILLING			 ]]--
do
	local PEACEBLOOM, SILVERLEAF, EARTHROOT, MAGEROYAL, BRIARTHORN, SWIFTTHISTLE, BRUISEWEED, STRANGLEKELP, WILDSTEEL, GRAVEMOSS, KINGSBLOOD, LIFEROOT, FADELEAF, GOLDTHORN, KHADGAR, DRAGONSTEETH, FIREBLOOM, PURPLELOTUS, ARTHASTEARS, SUNGRASS, BLINDWEED, GHOSTSHROOM, GROMSBLOOD, GOLDENSANSAM, DREAMFOIL, SILVERSAGE, SORROWMOSS, ICECAP = 2447, 765, 2449, 785, 2450, 2452, 2453, 3820, 3355, 3369, 3356, 3357, 3818, 3821, 3358, 3819, 4625, 8831, 8836, 8838, 8839, 8845, 8846, 13464, 13463, 13465, 13466, 13467
	local FELWEED, DREAMINGGLORY, TEROCONE, RAGVEIL, ANCHIENTLICHEN, NETHERBLOOM, NIGHTMAREVINE, MANATHISTLE = 22785, 22786, 22789, 22787, 22790, 22791, 22792, 22793
	local GOLDCLOVER, TIGERLILY, TALANDRASROSE, DEADNETTLE, FIRELEAF, ADDERSTONGUE, LICHBLOOM, ICETHORN = 36901, 36904, 36907, 37921, 39970, 36903, 36905, 36906
	local CINDERBLOOM, STORMVINE, AZSHARASVEIL, HEARTBLOSSOM, WHIPTAIL, TWLGHTJASMINE = 52983, 52984, 52985, 52986, 52988, 52987
	local GREENTEA, RAINPOPPY, SILKWEED, SNOWLILY, FOOLSCAP = 72234, 72237, 72235, 79010, 79011
	local FIREWEED, FROSTWEED, GFLYTRAP, NARROWBLOOM, STARFLOWER, TORCHID = 109126, 109124, 109126, 109128, 109127, 109129

	local ALABASTER, VERDANT, DUSKY, GOLDEN, BURNT, EMERALD, VIOLET, SILVERY, NETHER, AZURE, ASHEN, SHADOW, INDIGO, RUBY, SAPPHIRE, EBON, ICY, BURNING, MISTY, CERULEAN = 39151, 43103, 39334, 39338, 43104, 39339, 39340, 39341, 39342, 39343, 61979, 79251, 43105, 43106, 43107, 43108, 43109, 61980, 79253, 114931

	local millingData = {
		[PEACEBLOOM] 	= { ALABASTER, 	"2-3x", "100%", 2.5, 1, },
		[SILVERLEAF] 	= { ALABASTER, 	"2-3x", "100%", 2.5, 1, },
		[EARTHROOT] 	= { ALABASTER, 	"2-4x", "100%", 3, 1, },
		[MAGEROYAL] 	= { DUSKY,	 	"2-4x", "100%", 3, 1, 		VERDANT, 	"1-3x", "25%", 2, .25, },
		[BRIARTHORN] 	= { DUSKY, 		"2-4x", "100%", 3, 1, 		VERDANT, 	"1-3x", "25%", 2, .25, },
		[SWIFTTHISTLE] 	= { DUSKY, 		"2-3x", "100%", 2.5, 1, 	VERDANT, 	"1-3x", "25%", 2, .25, },
		[BRUISEWEED] 	= { DUSKY,		"2-4x", "100%", 3, 1, 		VERDANT, 	"1-3x", "50%", 2, .5, },
		[STRANGLEKELP] 	= { DUSKY,		"2-4x", "100%", 3, 1, 		VERDANT, 	"1-3x", "50%", 2, .5, },
		[WILDSTEEL] 	= { GOLDEN,		"2-4x", "100%", 3, 1, 		BURNT, 		"1-3x", "25%", 2, .25, },
		[GRAVEMOSS] 	= { GOLDEN,		"2-3x", "100%", 2.5, 1, 	BURNT, 		"1-3x", "25%", 2, .25, },
		[KINGSBLOOD] 	= { GOLDEN,		"2-4x", "100%", 3, 1, 		BURNT, 		"1-3x", "50%", 2, .5, },
		[LIFEROOT]	 	= { GOLDEN,		"2-4x", "100%", 3, 1, 		BURNT, 		"1-3x", "50%", 2, .5, },
		[FADELEAF]	 	= { EMERALD,	"2-4x", "100%", 3, 1, 		INDIGO, 	"1-3x", "25%", 2, .25, },
		[GOLDTHORN]	 	= { EMERALD,	"2-3x", "100%", 2.5, 1,		INDIGO, 	"1-3x", "25%", 2, .25, },
		[KHADGAR]	 	= { EMERALD,	"2-4x", "100%", 3, 1, 		INDIGO, 	"1-3x", "50%", 2, .5, },
		[DRAGONSTEETH] 	= { EMERALD,	"3-4x", "100%", 3.5, 1, 	INDIGO, 	"1-3x", "50%", 2, .5, },
		[FIREBLOOM]	 	= { VIOLET,		"2-3x", "100%", 2.5, 1,		RUBY, 		"1-3x", "25%", 2, .25, },
		[PURPLELOTUS]	= { VIOLET,		"2-3x", "100%", 2.5, 1,		RUBY, 		"1-3x", "25%", 2, .25, },
		[ARTHASTEARS]	= { VIOLET,		"2-3x", "100%", 2.5, 1,		RUBY, 		"1-3x", "25%", 2, .25, },
		[SUNGRASS]		= { VIOLET,		"2-3x", "100%", 2.5, 1,		RUBY, 		"1-3x", "25%", 2, .25, },
		[BLINDWEED]		= { VIOLET,		"2-4x", "100%", 3, 1,		RUBY, 		"1-3x", "50%", 2, .5, },
		[GHOSTSHROOM]	= { VIOLET,		"2-4x", "100%", 3, 1,		RUBY, 		"1-3x", "50%", 2, .5, },
		[GROMSBLOOD]	= { VIOLET,		"2-4x", "100%", 3, 1,		RUBY, 		"1-3x", "50%", 2, .5, },
		[GOLDENSANSAM]	= { SILVERY,	"2-4x", "100%", 3, 1,		SAPPHIRE,	"1-3x", "25%", 2, .25, },
		[DREAMFOIL]		= { SILVERY,	"2-4x", "100%", 3, 1,		SAPPHIRE,	"1-3x", "25%", 2, .25, },
		[SILVERSAGE]	= { SILVERY,	"2-4x", "100%", 3, 1,		SAPPHIRE,	"1-3x", "50%", 2, .5, },
		[SORROWMOSS]	= { SILVERY,	"2-4x", "100%", 3, 1,		SAPPHIRE,	"1-3x", "50%", 2, .5, },
		[ICECAP]		= { SILVERY,	"2-4x", "100%", 3, 1,		SAPPHIRE,	"1-3x", "50%", 2, .5, },
		[FELWEED]	 	= { NETHER,		"2-3x", "100%", 2.5, 1,		EBON, 		"1-3x", "25%", 2, .25, },
		[DREAMINGGLORY]	= { NETHER,		"2-3x", "100%", 2.5, 1,		EBON, 		"1-3x", "25%", 2, .25, },
		[TEROCONE]		= { NETHER,		"2-3x", "100%", 2.5, 1,		EBON, 		"1-3x", "25%", 2, .25, },
		[RAGVEIL]		= { NETHER,		"2-3x", "100%", 2.5, 1,		EBON, 		"1-3x", "25%", 2, .25, },
		[ANCHIENTLICHEN]= { NETHER,		"2-4x", "100%", 3, 1,		EBON, 		"1-3x", "50%", 2, .5, },
		[NETHERBLOOM]	= { NETHER,		"2-4x", "100%", 3, 1,		EBON, 		"1-3x", "50%", 2, .5, },
		[NIGHTMAREVINE]	= { NETHER,		"2-4x", "100%", 3, 1,		EBON, 		"1-3x", "50%", 2, .5, },
		[MANATHISTLE]	= { NETHER,		"2-4x", "100%", 3, 1,		EBON, 		"1-3x", "50%", 2, .5, },
		[GOLDCLOVER]	= { AZURE,		"2-3x", "100%", 2.5, 1,		ICY, 		"1-3x", "25%", 2, .25, },
		[TIGERLILY]		= { AZURE,		"2-3x", "100%", 2.5, 1,		ICY, 		"1-3x", "25%", 2, .25, },
		[TALANDRASROSE]	= { AZURE,		"2-3x", "100%", 2.5, 1,		ICY, 		"1-3x", "25%", 2, .25, },
		[DEADNETTLE]	= { AZURE,		"2-3x", "100%", 2.5, 1,		ICY, 		"1-3x", "25%", 2, .25, },
		[FIRELEAF]		= { AZURE,		"2-3x", "100%", 2.5, 1,		ICY, 		"1-3x", "25%", 2, .25, },
		[ADDERSTONGUE]	= { AZURE,		"2-4x", "100%", 3, 1,		ICY, 		"1-3x", "50%", 2, .5, },
		[LICHBLOOM]		= { AZURE,		"2-4x", "100%", 3, 1,		ICY, 		"1-3x", "50%", 2, .5, },
		[ICETHORN]		= { AZURE,		"2-4x", "100%", 3, 1,		ICY, 		"1-3x", "50%", 2, .5, },
		[CINDERBLOOM] 	= { ASHEN, 		"2-4x", "100%", 3, 1, 		BURNING,	"1-3x", "25%", 2, .25 },
		[STORMVINE] 	= { ASHEN, 		"2-4x", "100%", 3, 1, 		BURNING,	"1-3x", "25%", 2, .25 },
		[AZSHARASVEIL] 	= { ASHEN, 		"2-3x", "100%", 2.5, 1,		BURNING,	"1-3x", "25%", 2, .25 },
		[HEARTBLOSSOM] 	= { ASHEN, 		"2-4x", "100%", 3, 1,	 	BURNING,	"1-3x", "25%", 2, .25 },
		[WHIPTAIL] 		= { ASHEN, 		"2-4x", "100%", 2.5, 1, 	BURNING,	"1-3x", "50%", 2, .5 },
		[TWLGHTJASMINE]	= { ASHEN, 		"2-4x", "100%", 2.5, 1, 	BURNING,	"1-3x", "50%", 2, .5 },
		[GREENTEA] 		= { SHADOW, 	"2-3x", "100%", 2.5, 1, 	MISTY,		"1-3x", "25%", 2, .25 },
		[RAINPOPPY] 	= { SHADOW, 	"2-3x", "100%", 2.5, 1, 	MISTY,		"1-3x", "25%", 2, .25 },
		[SILKWEED] 		= { SHADOW, 	"2-3x", "100%", 2.5, 1, 	MISTY,		"1-3x", "25%", 2, .25 },
		[SNOWLILY] 		= { SHADOW, 	"2-3x", "100%", 2.5, 1, 	MISTY,		"1-3x", "25%", 2, .25 },
		[FOOLSCAP] 		= { SHADOW, 	"2-4x", "100%", 3, 1,	 	MISTY,		"1-3x", "50%", 2, .5 },
		[FIREWEED] 		= { CERULEAN, 	"2-4x", "100%", 3, 1 }, -- TODO: verify!
		[FROSTWEED] 	= { CERULEAN, 	"2-4x", "100%", 3, 1 },
		[GFLYTRAP] 		= { CERULEAN, 	"2-4x", "100%", 3, 1 },
		[NARROWBLOOM] 	= { CERULEAN, 	"2-4x", "100%", 3, 1 },
		[STARFLOWER] 	= { CERULEAN, 	"2-4x", "100%", 3, 1 },
		[TORCHID] 		= { CERULEAN, 	"2-4x", "100%", 3, 1 },
	}
	lib.millingData = millingData

	function lib:GetPossibleMillings(item)
		local _, link = GetItemInfo(item)
		local itemID = link and select(3, link:find("item:(%d+):"))
			  itemID = itemID and tonumber(itemID)
		if not itemID then return end

		if millingData[itemID] then return unpack(millingData[itemID]) end
	end

	function lib:IsMillable(item)
		local _, itemLink, _, _, _, itemType, itemSubType = GetItemInfo(item)
		if itemType ~= CRAFTING or itemSubType ~= HERBS then return end
		local itemID = itemLink and select(3, itemLink:find("item:(%d+):"))
			  itemID = itemID and tonumber(itemID)
		if not itemID then return end

		if millingData[itemID] then return true end
	end
end

--[[ 		PROSPECTING		 ]]--
do
	-- ores
	local COPPER_ORE, TIN_ORE, IRON_ORE, MITHRIL_ORE, THORIUM_ORE, FEL_IRON_ORE, ADAMANTITE_ORE, COBALT_ORE, SARONITE_ORE, TITANIUM_ORE, OBSIDIUM_ORE, ELEMENTIUM_ORE, PYRITE_ORE, GHOST_IRON_ORE, KYPARITE, BLACK_TRILLIUM_ORE, WHITE_TRILLIUM_ORE = 2770, 2771, 2772, 3858, 10620, 23424, 23425, 36909, 36912, 36910, 53038, 52185, 52183, 72092, 72093, 72094, 72103
	local TIGERSEYE, MALACHITE, SHADOWGEM, LESSERMOONSTONE, MOSSAGATE, CITRINE, JADE, AQUAMARINE, STARRUBY, AZEROTHIANDIAMOND, BLUESAPPHIRE, LARGEOPAL, HUGEEMERALD = 818, 774, 1210, 1705, 1206, 3864, 1529, 7909, 7910, 12800, 12361, 12799, 12364
	local ADAMANTITEPOWDER, TITANIUMPOWDER, VOLATILE_EARTH, SPARKLING_SHARD, BLOODGARNET, FLAMESPESSARITE, GOLDENDRAENITE, DEEPPERIDOT, AZUREMOONSTONE, SHADOWDRAENITE, LIVINGRUBY, NOBLETOPAZ, DAWNSTONE, TALASITE, STAROFELUNE, NIGHTSEYE = 24243, 46849, 52327, 90407, 23077, 21929, 23112, 23079, 23117, 23107, 23436, 23439, 23440, 23437, 23438, 23441
	local CHALCEDONY, SHADOWCRYSTAL, TWILIGHTOPAL, HUGECITRINE, BLOODSTONE, SUNCRYSTAL, DARKJADE, FORESTEMERALD, SCARLETRUBY, MONARCHTOPAZ, SKYSAPPHIRE, AUTMNSGLOW, MAJESTICZIRCON, AMETRINE, KINGSAMBER, DREADSTONE, CARDINALRUBY, EYEOFZUL = 36923, 36926, 36927, 36929, 36917, 36920, 36932, 36933, 36918, 36930, 36924, 36921, 36925, 36931, 36922, 36928, 36919, 36934
	local CARNELIAN, ZEPHYRITE, ALICITE, NIGHTSTONE, HESSONITE, JASPER, INFERNORUBY, OCEANSAPPHIRE, DREAMEMERALD, EMBERTOPAZ, DEMONSEYE, AMBERJEWEL = 52177, 52178, 52179, 52180, 52181, 52182, 52190, 52191, 52192, 52193, 52194, 52195
	local PANDAREN_GARNET, ALEXANDRITE, LAPIS_LAZULI, SUNSTONE, TIGER_OPAL, ROGUESTONE, IMPERIAL_AMETHYST, RIVERS_HEART, SUNS_RADIANCE, VERMILLION_ONYX, WILD_JADE, PRIMORDIAL_RUBY = 76136, 76137, 76133, 76134, 76130, 76135, 76141, 76138, 76142, 76140, 76139, 76131

	local prospectData = {
		[COPPER_ORE] 	= { MALACHITE, 		"1x", "50", 1, .5, 			TIGERSEYE, 	"1x", "50%", 1, .5, 		SHADOWGEM, 	"1x", "10%", 1, .1 },
		[TIN_ORE] 		= { LESSERMOONSTONE,"1-2x", "38%", 1.5, .38, 	MOSSAGATE, 	"1-2x", "38%", 1.5, .38,	SHADOWGEM, 	"1-2x", "38%", 1.5, .38,
							AQUAMARINE, 	"1x", "3%", 1, .03,			CITRINE, 	"1x", "3%", 1, .03,			JADE, 		"1x", "3%", 1, .03, },
		[IRON_ORE] 		= { LESSERMOONSTONE,"1-2x", "36%", 1.5, .36, 	JADE, 		"1-2x", "36%", 1.5, .36, 	CITRINE, 	"1-2x", "36%", 1.5, .36,
							AQUAMARINE, 	"1x", "5%", 1, .05,			STARRUBY, 	"1x", "5%", 1, .05, },
		[MITHRIL_ORE] 	= { STARRUBY, 		"1-2x", "35%", 1.5, .36, 	AQUAMARINE, "1-2x", "35%", 1.5, .36, 	CITRINE, 	"1-2x", "35%", 1.5, .36,
							BLUESAPPHIRE, 	"1x", "3%", 1, .03,			LARGEOPAL, 	"1x", "3%", 1, .03,
							AZEROTHIANDIAMOND, "1x", "2%", 1, .02,		HUGEEMERALD, "1x", "2%", 1, .02, },
		[THORIUM_ORE] 	= { AZEROTHIANDIAMOND, "1-2x", "31%", 1.5, .31, BLUESAPPHIRE, "1-2x", "31%", 1.5, .31,
							HUGEEMERALD, 	"1-2x", "31%", 1.5, .31,	LARGEOPAL, 	"1-2x", "31%", 1.5, .31,
							STARRUBY, 		"1-2x", "16%", 1.5, .16, },
		[FEL_IRON_ORE] 	= {
				GOLDENDRAENITE, "1-2x", "18%", 1.5, .18, 	AZUREMOONSTONE, "1-2x", "18%", 1.5, .18, 	BLOODGARNET, 	"1-2x", "18%", 1.5, .18,
				DEEPPERIDOT, 	"1-2x", "18%", 1.5, .18, 	FLAMESPESSARITE, "1-2x", "18%", 1.5, .18,	SHADOWDRAENITE, "1-2x", "18%", 1.5, .18,
				NOBLETOPAZ, 	"1x", "1.2%", 1, .012,		DAWNSTONE, 		"1x", "1.2%", 1, .012,		LIVINGRUBY, 	"1x", "1.2%", 1, .012,
				NIGHTSEYE, 		"1x", "1.2%", 1, .012,		STAROFELUNE, 	"1x", "1.2%", 1, .012,		TALASITE, 		"1x", "1.2%", 1, .012, },
		[ADAMANTITE_ORE]= { ADAMANTITEPOWDER, "1x", "100%", 1, 1,
				GOLDENDRAENITE, "1-2x", "18%", 1.5, .18, 	AZUREMOONSTONE, "1-2x", "18%", 1.5, .18, 	BLOODGARNET, 	"1-2x", "18%", 1.5, .18,
				DEEPPERIDOT, 	"1-2x", "18%", 1.5, .18, 	FLAMESPESSARITE, "1-2x", "18%", 1.5, .18, 	SHADOWDRAENITE, "1-2x", "18%", 1.5, .18,
				NOBLETOPAZ, 	"1x", "4%", 1, .04,			DAWNSTONE, 		"1x", "4%", 1, .04,			LIVINGRUBY, 	"1x", "4%", 1, .04,
				NIGHTSEYE, 		"1x", "4%", 1, .04,			STAROFELUNE, 	"1x", "4%", 1, .04,			TALASITE, 		"1x", "4%", 1, .04, },
		[COBALT_ORE] 	= {
				CHALCEDONY, 	"1-2x", "24%", 1.5, .24, 	HUGECITRINE, 	"1-2x", "24%", 1.5, .24, 	SHADOWCRYSTAL, 	"1-2x", "24%", 1.5, .24,
				BLOODSTONE, 	"1-2x", "23%", 1.5, .23, 	DARKJADE, 		"1-2x", "23%", 1.5, .23, 	SUNCRYSTAL, 	"1-2x", "23%", 1.5, .23,
				MONARCHTOPAZ, 	"1x", "1.3%", 1, .013,		FORESTEMERALD, 	"1x", "1.3%", 1, .013,		SKYSAPPHIRE, 	"1x", "1.3%", 1, .013,
				AUTMNSGLOW, 	"1x", "1.3%", 1, .013,		SCARLETRUBY, 	"1x", "1.3%", 1, .013,		TWILIGHTOPAL, 	"1x", "1.3%", 1, .013, },
		[SARONITE_ORE] 	= {
				CHALCEDONY, 	"1-2x", "18%", 1.5, .18, 	HUGECITRINE, 	"1-2x", "18%", 1.5, .18, 	SHADOWCRYSTAL, 	"1-2x", "18%", 1.5, .18,
				BLOODSTONE, 	"1-2x", "18%", 1.5, .18, 	DARKJADE, 		"1-2x", "18%", 1.5, .18, 	SUNCRYSTAL, 	"1-2x", "18%", 1.5, .18,
				MONARCHTOPAZ, 	"1-2x", "4%", 1.5, .04,		FORESTEMERALD, 	"1-2x", "4%", 1.5, .04,		SKYSAPPHIRE, 	"1-2x", "4%", 1.5, .04,
				AUTMNSGLOW, 	"1-2x", "4%", 1.5, .04,		SCARLETRUBY, 	"1-2x", "4%", 1.5, .04,		TWILIGHTOPAL, 	"1-2x", "4%", 1.5, .04, },
		[TITANIUM_ORE] 	= {
				CHALCEDONY, 	"1-2x", "24%", 1.5, .24, 	HUGECITRINE, 	"1-2x", "24%", 1.5, .24, 	SHADOWCRYSTAL, 	"1-2x", "24%", 1.5, .24,
				BLOODSTONE, 	"1-2x", "24%", 1.5, .24, 	DARKJADE, 		"1-2x", "24%", 1.5, .24, 	SUNCRYSTAL, 	"1-2x", "24%", 1.5, .24,
				AMETRINE, 		"1-2x", "4%", 1.5, .05,		EYEOFZUL, 		"1-2x", "4%", 1.5, .05,		KINGSAMBER, 	"1-2x", "4%", 1.5, .05,
				MAJESTICZIRCON,	"1-2x", "4%", 1.5, .05,		CARDINALRUBY, 	"1-2x", "4%", 1.5, .05,		DREADSTONE,		"1-2x", "4%", 1.5, .05,
				MONARCHTOPAZ, 	"1-2x", "4%", 1.5, .04,		FORESTEMERALD, 	"1-2x", "4%", 1.5, .04,		SKYSAPPHIRE, 	"1-2x", "4%", 1.5, .04,
				AUTMNSGLOW, 	"1-2x", "4%", 1.5, .04,		SCARLETRUBY, 	"1-2x", "4%", 1.5, .04,		TWILIGHTOPAL, 	"1-2x", "4%", 1.5, .04, },
		[OBSIDIUM_ORE] 	= {
				CARNELIAN, 		"1-2x", "24%", 1.5, .24, 	HESSONITE, 		"1-2x", "24%", 1.5, .24, 	JASPER, 		"1-2x", "24%", 1.5, .24,
				NIGHTSTONE, 	"1-2x", "24%", 1.5, .24, 	ZEPHYRITE, 		"1-2x", "24%", 1.5, .24, 	ALICITE, 		"1-2x", "24%", 1.5, .24,
				DREAMEMERALD, 	"1x", "1.2%", 1, .012,		INFERNORUBY, 	"1x", "1.2%", 1, .012,		AMBERJEWEL, 	"1x", "1.2%", 1, .012,
				DEMONSEYE, 		"1x", "1.2%", 1, .012,		EMBERTOPAZ, 	"1x", "1.2%", 1, .012,		OCEANSAPPHIRE, 	"1x", "1.2%", 1, .012, },
		[ELEMENTIUM_ORE]= {
				CARNELIAN, 		"1-2x", "18%", 1.5, .18, 	HESSONITE, 		"1-2x", "18%", 1.5, .18, 	JASPER, 		"1-2x", "18%", 1.5, .18,
				NIGHTSTONE, 	"1-2x", "18%", 1.5, .18, 	ZEPHYRITE, 		"1-2x", "18%", 1.5, .18, 	ALICITE, 		"1-2x", "18%", 1.5, .18,
				DREAMEMERALD, 	"1-2x", "4%", 1, .04,		INFERNORUBY, 	"1-2x", "4%", 1, .04,		AMBERJEWEL, 	"1-2x", "4%", 1, .04,
				DEMONSEYE, 		"1-2x", "4%", 1, .04,		EMBERTOPAZ, 	"1-2x", "4%", 1, .04,		OCEANSAPPHIRE, 	"1-2x", "4%", 1, .04, },
		[PYRITE_ORE] 	= { VOLATILE_EARTH, "1-3x", "100%", 2, 1,
				CARNELIAN, 		"1x", "17%", 1, .17, 		HESSONITE, 		"1x", "17%", 1, .17, 		JASPER, 		"1x", "17%", 1, .17,
				NIGHTSTONE, 	"1x", "17%", 1, .17, 		ZEPHYRITE, 		"1x", "17%", 1, .17, 		ALICITE, 		"1x", "17%", 1, .17,
				DREAMEMERALD, 	"1-2x", "7%", 1.5, .07,		INFERNORUBY, 	"1-2x", "7%", 1.5, .07,		AMBERJEWEL, 	"1-2x", "7%", 1.5, .07,
				DEMONSEYE, 		"1-2x", "7%", 1.5, .07,		EMBERTOPAZ, 	"1-2x", "7%", 1.5, .07,		OCEANSAPPHIRE, 	"1-2x", "7%", 1.5, .07, },
		[GHOST_IRON_ORE]= { SPARKLING_SHARD, "1-2x", "80%", 1.5, .8,
				ALEXANDRITE, 	"1-2x", "14%", 1.5, .24, 	LAPIS_LAZULI,	"1-2x", "14%", 1.5, .24, 	PANDAREN_GARNET, "1-2x", "14%", 1.5, .24,
				SUNSTONE, 		"1-2x", "14%", 1.5, .24, 	ROGUESTONE,		"1-2x", "14%", 1.5, .24, 	TIGER_OPAL,		"1-2x", "14%", 1.5, .24,
				IMPERIAL_AMETHYST, "1-2x", "5%", 1.5, .05,	RIVERS_HEART, 	"1-2x", "5%", 1.5, .05,		SUNS_RADIANCE, 	"1-2x", "5%", 1.5, .05,
				PRIMORDIAL_RUBY, "1-2x", "4%", 1.5, .04,	VERMILLION_ONYX, "1-2x", "4%", 1.5, .04,	WILD_JADE, 		"1-2x", "4%", 1.5, .04, },
		[KYPARITE] 		= { SPARKLING_SHARD, "1-2x", "100%", 1.5, 1,
				ALEXANDRITE, 	"1-2x", "14%", 1.5, .24, 	LAPIS_LAZULI,	"1-2x", "14%", 1.5, .24, 	PANDAREN_GARNET, "1-2x", "14%", 1.5, .24,
				SUNSTONE, 		"1-2x", "14%", 1.5, .24, 	ROGUESTONE,		"1-2x", "14%", 1.5, .24, 	TIGER_OPAL,		"1-2x", "14%", 1.5, .24,
				IMPERIAL_AMETHYST, "1-2x", "5%", 1.5, .05,	RIVERS_HEART, 	"1-2x", "4%", 1.5, .04,		SUNS_RADIANCE, 	"1-2x", "4%", 1.5, .04,
				PRIMORDIAL_RUBY, "1-2x", "4%", 1.5, .04,	VERMILLION_ONYX, "1-2x", "4%", 1.5, .04,	WILD_JADE, 		"1-2x", "4%", 1.5, .04, },
		[BLACK_TRILLIUM_ORE] = { SPARKLING_SHARD, "1-2x", "100%", 1.5, 1,
				IMPERIAL_AMETHYST, "1-2x", "17%", 1.5, .17,	RIVERS_HEART, 	"1-2x", "17%", 1.5, .17,	SUNS_RADIANCE, 	"1-2x", "17%", 1.5, .17,
				PRIMORDIAL_RUBY, "1-2x", "17%", 1.5, .17,	VERMILLION_ONYX, "1-2x", "17%", 1.5, .17,	WILD_JADE, 		"1-2x", "17%", 1.5, .17,
				ALEXANDRITE, 	"1x", "17%", 1, .17, 		LAPIS_LAZULI,	"1", "17%", 1, .17, 		PANDAREN_GARNET, "1x", "17%", 1, .17,
				SUNSTONE, 		"1x", "17%", 1, .17, 		ROGUESTONE,		"1", "17%", 1, .17, 		TIGER_OPAL,		"1x", "17%", 1, .17, },
		[WHITE_TRILLIUM_ORE] = { SPARKLING_SHARD, "1-2x", "100%", 1.5, 1,
				IMPERIAL_AMETHYST, "1-2x", "17%", 1.5, .17,	RIVERS_HEART, 	"1-2x", "17%", 1.5, .17,	SUNS_RADIANCE, 	"1-2x", "17%", 1.5, .17,
				PRIMORDIAL_RUBY, "1-2x", "17%", 1.5, .17,	VERMILLION_ONYX, "1-2x", "17%", 1.5, .17,	WILD_JADE, 		"1-2x", "17%", 1.5, .17,
				ALEXANDRITE, 	"1x", "17%", 1, .17, 		LAPIS_LAZULI,	"1x", "17%", 1, .17, 		PANDAREN_GARNET, "1x", "17%", 1, .17,
				SUNSTONE, 		"1x", "17%", 1, .17, 		ROGUESTONE,		"1x", "17%", 1, .17, 		TIGER_OPAL,		"1x", "17%", 1, .17, },
	}
	lib.prospectData = prospectData

	function lib:GetPossibleProspects(item)
		local _, link = GetItemInfo(item)
		local itemID = link and select(3, link:find("item:(%d+):"))
			  itemID = itemID and tonumber(itemID)
		if not itemID then return end

		if prospectData[itemID] then return unpack(prospectData[itemID]) end
	end
	function lib:IsProspectable(item)
		local _, itemLink, _, _, _, itemType, itemSubType = GetItemInfo(item)
		if itemType ~= CRAFTING or itemSubType ~= ORES then return end
		local itemID = itemLink and select(3, itemLink:find("item:(%d+):"))
			  itemID = itemID and tonumber(itemID)
		if not itemID then return end

		if prospectData[itemID] then return true end
	end
end

--[[ 		ENCHANTING		 ]]--
do
	local WEAPON, ARMOR = GetAuctionItemClasses() -- returns localized strings

	-- constants taken from tekkub taken from Enchantrix
	local VOID, NEXUS, ABYSS, MAELSTROM = 22450, 20725, 34057, 52722
	local SHEAVENLY, LHEAVENLY = 52720, 52721
	local LRADIANT, SBRILLIANT, LBRILLIANT, SPRISMATIC, LPRISMATIC, LDREAM = 11178, 14343, 14344, 22448, 22449, 34052
	local SGLIMMERING, LGLIMMERING, SGLOWING, LGLOWING, SRADIANT, SDREAM = 10978, 11084, 11138, 11139, 11177, 34053
	local LCELEST, GCELEST = 52718, 52719
	local LNETHER, GNETHER, LETERNAL, GETERNAL, LPLANAR, GPLANAR, LCOSMIC, GCOSMIC = 11174, 11175, 16202, 16203, 22447, 22446, 34056, 34055
	local LMAGIC, GMAGIC, LASTRAL, GASTRAL, LMYSTIC, GMYSTIC = 10938, 10939, 10998, 11082, 11134, 11135
	local STRANGE, SOUL, VISION, DREAM, ILLUSION, ARCANE, INFINITE, HYPNOTIC = 10940, 11083, 11137, 11176, 16204, 22445, 34054, 52555
	local SHA, ETHERAL, SETHERAL, SPIRIT, MYST, SHAFRAGMENT = 74248, 74247, 74252, 74249, 74250, 105718
	local DRAENIC, LUMINOUS, SLUMINOUS, TEMPORAL, TEMPORALFRAGMENT = 109693, 111245, 115502, 113588, 115504

	-- shared between weapons and armor
	local function GetUncommonVals(ilvl)
		if     ilvl <= 15  then return  STRANGE,  "1-2x", "80%", 1.5, .80,   LMAGIC, "1-2x", "20%", 1.5, .20
		elseif ilvl <= 20  then return  STRANGE,  "2-3x", "75%", 2.5, .75,   GMAGIC, "1-2x", "20%", 1.5, .20, SGLIMMERING, "1x", "5%", 1, .05
		elseif ilvl <= 25  then return  STRANGE,  "4-6x", "75%", 5.0, .75,  LASTRAL, "1-2x", "15%", 1.5, .15, SGLIMMERING, "1x", "10%", 1, .1
		elseif ilvl <= 30  then return     SOUL,  "1-2x", "75%", 1.5, .75,  GASTRAL, "1-2x", "20%", 1.5, .20, LGLIMMERING, "1x", "5%", 1, .05
		elseif ilvl <= 35  then return     SOUL,  "2-5x", "75%", 3.5, .75,  LMYSTIC, "1-2x", "20%", 1.5, .20,    SGLOWING, "1x", "5%", 1, .05
		elseif ilvl <= 40  then return   VISION,  "1-2x", "75%", 1.5, .75,  GMYSTIC, "1-2x", "20%", 1.5, .20,    LGLOWING, "1x", "5%", 1, .05
		elseif ilvl <= 45  then return   VISION,  "2-5x", "75%", 3.5, .75,  LNETHER, "1-2x", "20%", 1.5, .20,    SRADIANT, "1x", "5%", 1, .05
		elseif ilvl <= 50  then return    DREAM,  "1-2x", "75%", 1.5, .75,  GNETHER, "1-2x", "20%", 1.5, .20,    LRADIANT, "1x", "5%", 1, .05
		elseif ilvl <= 55  then return    DREAM,  "2-5x", "75%", 3.5, .75, LETERNAL, "1-2x", "20%", 1.5, .20,  SBRILLIANT, "1x", "5%", 1, .05
		elseif ilvl <= 60  then return ILLUSION,  "1-2x", "75%", 1.5, .75, GETERNAL, "1-2x", "20%", 1.5, .20,  LBRILLIANT, "1x", "5%", 1, .05
		elseif ilvl <= 65  then return ILLUSION,  "2-5x", "75%", 3.5, .75, GETERNAL, "2-3x", "20%", 2.5, .20,  LBRILLIANT, "1x", "5%", 1, .05
		elseif ilvl <= 80  then return   ARCANE,  "2-3x", "75%", 2.5, .75,  LPLANAR, "1-2x", "22%", 1.5, .22,  SPRISMATIC, "1x", "3%", 1, .03
		elseif ilvl <= 99  then return   ARCANE,  "2-3x", "75%", 2.5, .75,  LPLANAR, "2-3x", "22%", 2.5, .22,  SPRISMATIC, "1x", "3%", 1, .03
		elseif ilvl <= 120 then return   ARCANE,  "2-5x", "75%", 3.5, .75,  GPLANAR, "1-2x", "22%", 1.5, .22,  LPRISMATIC, "1x", "3%", 1, .03
		elseif ilvl <= 151 then return INFINITE,  "1-2x", "75%", 1.5, .75,  LCOSMIC, "1-2x", "22%", 1.5, .22,      SDREAM, "1x", "3%", 1, .03
		elseif ilvl <= 187 then return INFINITE,  "2-5x", "75%", 3.5, .75,  GCOSMIC, "1-2x", "22%", 1.5, .22,      LDREAM, "1x", "3%", 1, .03
		elseif ilvl <= 272 then return HYPNOTIC,  "1-3x", "75%", 2.0, .75,  LCELEST, "1-3x", "25%", 2.0, .25
		elseif ilvl <= 289 then return HYPNOTIC,  "1-5x", "75%", 3.0, .75,  LCELEST, "1-5x", "25%", 3.0, .25
		elseif ilvl <= 300 then return HYPNOTIC,  "1-7x", "75%", 4.0, .75,  LCELEST, "1-7x", "25%", 4.0, .25
		elseif ilvl <= 312 then return HYPNOTIC,  "1-8x", "75%", 4.5, .75,  GCELEST, "1-2x", "25%", 1.5, .25
		elseif ilvl <= 325 then return HYPNOTIC,  "1-9x", "75%", 5.0, .75,  GCELEST, "2-3x", "25%", 2.5, .25
		elseif ilvl <= 333 then return HYPNOTIC, "1-10x", "75%", 5.5, .75,  GCELEST, "2-3x", "25%", 2.5, .25
		elseif ilvl <= 380 then return   SPIRIT,  "1-3x", "85%", 2.0, .85,     MYST,   "1x", "15%", 1.0, .15
		elseif ilvl <= 390 then return   SPIRIT,  "1-4x", "85%", 2.5, .85,     MYST,   "1x", "15%", 1.0, .15
		elseif ilvl <= 410 then return   SPIRIT,  "1-5x", "85%", 3.0, .85,     MYST, "1-2x", "15%", 1.5, .15
		elseif ilvl <= 490 then return   SPIRIT,  "1-6x", "85%", 3.5, .85,     MYST, "1-3x", "15%", 2.0, .15
		elseif ilvl <= 509 then return   DRAENIC,  "1-4x", "100%", 2.5, 1.0
		else return
			DRAENIC,   "1-4x", "95%", 6.0, .95,
			LUMINOUS,    "1x",  "3%", 1.0, .03,
			SLUMINOUS, "1-6x",  "2%", 3.5, .02
		end
	end

	-- Find all the possible DE results for a given item
	--
	-- item - The item to query, accepts all values GetItemInfo accepts
	--
	-- Returns up to three set of DE results.  Each result set consists of 5 values
	--   itemID   - the ID of the item received
	--   quantity - A String describing the number you may get, like "1-3x"
	--   percent  - A String detailing the probability of this result
	--   num_qty  - A number representing the average qty received
	--   num_perc - A number representing the probability
	function lib:GetPossibleDisenchants(item)
		local _, link, qual, ilvl, _, itemType = GetItemInfo(item)
		if not link or not lib:IsDisenchantable(link) or (itemType ~= ARMOR and itemType ~= WEAPON) then return end

		if qual == 4 then -- Epic
			if ilvl > 75 and ilvl <= 80 and itemType == WEAPON then return NEXUS, "1-2x", "33%/66%", 5/3
			elseif ilvl <= 45  then return   SRADIANT, "2-4x",    "100%", 3.0, 1
			elseif ilvl <= 50  then return   LRADIANT, "2-4x",    "100%", 3.0, 1
			elseif ilvl <= 55  then return SBRILLIANT, "2-4x",    "100%", 3.0, 1
			elseif ilvl <= 60  then return      NEXUS,   "1x",    "100%", 1.0, 1
			elseif ilvl <= 80  then return      NEXUS, "1-2x",    "100%", 1.5, 1
			elseif ilvl <= 100 then return       VOID, "1-2x",    "100%", 1.5, 1
			elseif ilvl <= 164 then return       VOID, "1-2x", "33%/66%", 5/3, 1
			elseif ilvl <= 200 then return      ABYSS,   "1x",    "100%", 1.0, 1
			elseif ilvl <= 284 then return      ABYSS, "1-2x",    "100%", 1.5, 1
			elseif ilvl <= 359 then return  MAELSTROM,   "1x",    "100%", 1.0, 1
			elseif ilvl <= 359 then return  MAELSTROM, "1-2x",    "100%", 1.5, 1
			elseif ilvl <= 416 then return  MAELSTROM, "1-2x",    "100%", 1.5, 1
			elseif ilvl <  486 then return        SHA, "1-2x",    "100%", 1.13, 1
			elseif ilvl <= 496 then return SHAFRAGMENT, "1-2x",    "100%", 1.13, 1
			elseif ilvl <= 600 then return         SHA,   "1x",    "100%", 1.0, 1
			else return
				TEMPORAL, "1x", "100%", 1.0, 1
			end

		elseif qual == 3 then -- Rare
			if     ilvl <=  25 then return SGLIMMERING, "1x",  "100%", 1, 1
			elseif ilvl <=  30 then return LGLIMMERING, "1x",  "100%", 1, 1
			elseif ilvl <=  35 then return    SGLOWING, "1x",  "100%", 1, 1
			elseif ilvl <=  40 then return    LGLOWING, "1x",  "100%", 1, 1
			elseif ilvl <=  45 then return    SRADIANT, "1x",  "100%", 1, 1
			elseif ilvl <=  50 then return    LRADIANT, "1x",  "100%", 1, 1
			elseif ilvl <=  55 then return  SBRILLIANT, "1x",  "100%", 1, 1
			elseif ilvl <=  65 then return  LBRILLIANT, "1x", "99.5%", 1, .995, NEXUS, "1x", "0.5%", 1, 0.005
			elseif ilvl <=  99 then return  SPRISMATIC, "1x", "99.5%", 1, .995, NEXUS, "1x", "0.5%", 1, 0.005
			elseif ilvl <= 120 then return  LPRISMATIC, "1x", "99.5%", 1, .995,  VOID, "1x", "0.5%", 1, 0.005
			elseif ilvl <= 165 then return      SDREAM, "1x", "99.5%", 1, .995, ABYSS, "1x", "0.5%", 1, 0.005
			elseif ilvl <= 200 then return      LDREAM, "1x", "99.5%", 1, .995, ABYSS, "1x", "0.5%", 1, 0.005
			elseif ilvl <= 316 then return   SHEAVENLY, "1x",  "100%", 1, 1
			elseif ilvl <= 380 then return   LHEAVENLY, "1x",  "100%", 1, 1
			elseif ilvl <= 424 then return    SETHERAL, "1x",  "100%", 1, 1
			elseif ilvl <= 529 then return     ETHERAL, "1x",  "100%", 1, 1
			elseif ilvl <= 590 then return
				DRAENIC,  "5-12x", "45%", 8.5, .45,
				LUMINOUS,    "1x", "35%", 1.0, .35,
				SLUMINOUS, "1-6x", "20%", 3.5, .20
			else return
				LUMINOUS,    "1x", "55%", 1.0, .55,
				DRAENIC,  "5-12x", "35%", 8.5, .35,
				SLUMINOUS, "3-6x", "10%", 4.5, .10
			end

		elseif qual == 2 then -- Uncommon
			if itemType == ARMOR then return GetUncommonVals(ilvl)

			-- weapons
			elseif ilvl < 380 then
				local r1i, r1ta, r1tp, r1a, r1p, r2i, r2ta, r2tp, r2a, r2p, r3i, r3ta, r3tp, r3a, r3p = GetUncommonVals(ilvl)
				return r1i, r1ta, r2tp, r1a, r2p, r2i, r2ta, r1tp, r2a, r1p, r3i, r3ta, r3tp, r3a, r3p
			elseif ilvl <= 480 then
				-- Panda green weapons follow different rules form the old pattern
				if     ilvl <= 380 then return SPIRIT, "1-4x", "85%", 2.5, .85, MYST,   "1x", "15%", 1.0, .15
				elseif ilvl <= 390 then return SPIRIT, "1-5x", "85%", 3.0, .85, MYST,   "1x", "15%", 1.0, .15
				elseif ilvl <= 410 then return SPIRIT, "1-6x", "85%", 3.5, .85, MYST, "1-2x", "15%", 1.5, .15
				else return                    SPIRIT, "1-7x", "85%", 4.0, .85, MYST, "1-3x", "15%", 2.0, .15 end
			else
				-- WoD green weapons
				return GetUncommonVals(ilvl)
			end
		end
	end

	function lib:IsDisenchantable(item)
		local _, itemLink, _, _, _, itemType = GetItemInfo(item)
		return itemLink and (itemType == WEAPON or itemType == ARMOR)
	end
end
