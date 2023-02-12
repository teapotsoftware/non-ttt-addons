
local cvflags = FCVAR_ARCHIVE + FCVAR_REPLICATED
local enabled = CreateConVar("csa_enabled", 1, cvflags, "Whether to show Comic Sans Announcements.", 0, 1)
local minCooldown = CreateConVar("csa_cooldown_min", 180, cvflags, "Minimum cooldown for Comic Sans Announcements.", 1)
local maxCooldown = CreateConVar("csa_cooldown_max", 240, cvflags, "Maximum cooldown for Comic Sans Announcements.", 1)
local duration = CreateConVar("csa_message_duration", 10, cvflags, "How long to show Comic Sans Announcements on screen.", 1)
local fadetime = CreateConVar("csa_message_fadetime", 1, cvflags, "How long it takes Comic Sans Announcements to fade in/out.", 1)
local sponsorPercent = CreateConVar("csa_sponsor_percent", 25, cvflags, "Percentage of Comic Sans Announcements that are sponsor names.", 0, 100)

local DefaultSponsorList = {
	"Selma Bodhi",
	"Peter Felia",
	"Milo Balsang",
	"Herb Eaversmells",
	"Dixon Sider",
	"Sheiza Freek",
	"Eaton Beaver",
	"Ladiz Wascharum",
	"Fondel Majunk",
	"Oliver Klozoff",
	"Wilma Dickfit",
	"Ima Virgin",
	"Buster Hymen",
	"Gabe Athouse",
	"Wilma Fingerdoo",
	"Amanda Hugginkiss",
	"Phil McCracken & Barry McCaulkiner",
	"Willie Beater & Bettie Will",
	"Waiyu & Huyu Hai-Ding",
	"Anita B.J. & T. Nanel",
	"Arty Emmer",
	"B.J. Smegma",
	"Dicker Downgood",
	"Dang Ling Dong",
	"Ryder Poonwell",
	"Dixon B. Tweenerlegs",
	"Dixie Rector",
	"Dick Fitswell",
	"Don Kedic",
	"Rusty Pecker",
	"Lou Stool",
}

local DefaultAnnouncements = {
	{"I wipe standing up", "It's only right and natural"},
	{"Jesse, you are", "Breaking Bad"},
	{"When the water runs clean", "Bottom text"},
	{"How do you", "Top your sub?"},
	{"Green, green...", "What is your problem?"},
	{"Our f-f-f-father", "Who a-art in h-h-heaven"},
	{"What makes me", "A good demoman?"},
	{"God I love when the crumbs sit at the bottom of my boxers", "It feels weird but mostly good"},
	{"Top text. :)", "bottom text :3 UwU"},
	{"All the emo songs are about the same girl", "Her name is Amanda"},
	{"What the fuck", "Is Ligma???"},
	{"Long story short, I took a 2/4", "When I should have gone 4/4"},
	{"Does your laptop have a", "C.M.I. port?"},
	{"Mining at Y=11 gives you the highest chance of finding diamonds", "With the least danger of running into lava"},
	{"It's Britney", "Bitch"},
	{"Mandate this... Mandate that...", "But when will a Man Date me?"},
	{"SEME: Leo, Scorpio, Capricorn, Aries, Gemini, Sagittarius", "UKE: Pisces, Virgo, Libra, Cancer, Aquarius, Taurus"},
	{"The LEFT wants to take away your", "PENIS"},
	{"Walt, I don't know man, you've been seeming kinda sus lately...", "Looks like there's an imposter among us"},
	{"the 3 steps of trolling: step 1: find a unsuspecting idiot", "step 2: set up the idiot's expectations"},
	{"Looking very submissive and breedable, king", "Keep it up"},
	{"Anybody want coffee? I just made a fresh pot of coffee", "WHO WANTS COFFEE?"},
	{"Three vampires walk into a bar", "Two Bloodweisers, one Blood Light"},
	{"So an Irishman walks past a bar...", "Yeah right!"},
	{"Do you have these in Helicopter flavor?", "No, sorry. Only Plane"},
	{"My world of desserts", "Has gone black"},
	{"What aint no country I ever heard of!", "They speak English in What?"},
	{"Your new secure password:", "asdrtnwyvoltonhqwsliufanhdjlfnhasgv hiiii"},
	{"Baseball's like chess at 90 miles per hour", "The players are the pieces and the pawns"},
	{"So um... Are you... You know... Do you... Are you...", "Do you listen to math rock?"},
	{"These two weird guys wouldn't stop staring at me on the bus", "I don't like gaze"},
	{"Node Graph out of date", "Rebuilding..."},
	{"Y'know, don't, s-say", "Swears"},
	{"Do you have the time", "To listen to me whine?"},
	{"It's impossible to make a pun to a kleptomaniac", "They always take things, literally"},
	{"Sorry, liberals. It's basic biology: Boys have bussies", "And girls have girl-bussies"}
}

local SponsorList = {}
local Announcements = {}

local PossibleColors = {
	Color(255, 100, 100),
	Color(255, 180, 100),
	Color(255, 255, 100),
	Color(180, 255, 70),
	Color(70, 255, 100),
	Color(70, 255, 255),
	Color(70, 255, 255),
	Color(70, 130, 255),
	Color(130, 70, 255),
	Color(255, 70, 255)
}

if SERVER then
	resource.AddFile("resource/fonts/ComicSansMS.ttf")
	util.AddNetworkString("ComicSansAnnouncement")

	local NextAnnouncement = 20

	local function LoadData()
		if not file.Exists("comic_sans_announcements", "DATA") then
			file.CreateDir("comic_sans_announcements")
		end

		if not file.Exists("comic_sans_announcements/sponsors.txt", "DATA") then
			file.Write("comic_sans_announcements/sponsors.txt", table.concat(DefaultSponsorList, "\n"))
		end

		if not file.Exists("comic_sans_announcements/announcements.txt", "DATA") then
			local tab = {}
			for _, v in ipairs(DefaultAnnouncements) do
				table.insert(tab, v[1])
				table.insert(tab, v[2])
			end
			file.Write("comic_sans_announcements/announcements.txt", table.concat(tab, "\n"))
		end

		SponsorList = string.Split(file.Read("comic_sans_announcements/sponsors.txt"), "\n")

		local announcementData = string.Split(file.Read("comic_sans_announcements/announcements.txt"), "\n")
		local announcementAmt = math.floor(#announcementData * 0.5)
		AnnouncementList = {}
		for i = 1, #announcementData, 2 do
			table.insert(AnnouncementList, {announcementData[i], announcementData[i + 1]})
		end
		Announcements = AnnouncementList
	end

	-- load data
	LoadData()

	concommand.Add("csa_reload", function(ply, cmd, args)
		if ply:IsAdmin() then
			LoadData()
		end
	end)

	hook.Add("Tick", "ComicSansAnnouncements.Tick", function()
		if enabled:GetBool() and CurTime() > NextAnnouncement then
			NextAnnouncement = CurTime() + math.random(minCooldown:GetFloat(), maxCooldown:GetFloat())
			net.Start("ComicSansAnnouncement")
			if math.random(100) > (100 - sponsorPercent:GetInt()) then
				net.WriteString("Special thanks to our sponsor(s):")
				net.WriteString(SponsorList[math.random(#SponsorList)])
			else
				local a = Announcements[math.random(#Announcements)]
				net.WriteString(a[1])
				net.WriteString(a[2])
			end
			net.WriteInt(math.random(#PossibleColors), 8)
			net.Broadcast()
		end
	end)
else
	surface.CreateFont("ComicSansAnnouncements.Small", {
		font = "Comic Sans MS",
		size = ScreenScale(16),
	})

	surface.CreateFont("ComicSansAnnouncements.Large", {
		font = "Comic Sans MS",
		size = ScreenScale(24),
	})

	local LastAnnouncementTime = -999
	local Line1 = ""
	local Line2 = ""
	local AnnouncementColor = Color(255, 100, 100)
	local BackgroundColor = Color(0, 0, 0)

	net.Receive("ComicSansAnnouncement", function()
		Line1 = net.ReadString()
		Line2 = net.ReadString()
		AnnouncementColor = PossibleColors[net.ReadInt(8)]
		LastAnnouncementTime = CurTime()
	end)

	local function TextAlpha(dt)
		local dur = duration:GetFloat()
		local fade = fadetime:GetFloat()

		if dt >= fade and dt <= (dur - fade) then
			return 255
		end

		-- fade in
		if dt < fade then
			return (dt / fade) * 255
		end

		-- fade out
		return (1 - ((dt - (dur - fade)) / fade)) * 255
	end

	hook.Add("PostDrawHUD", "ComicSansAnnouncements.PostDrawHUD", function()
		local a = TextAlpha(CurTime() - LastAnnouncementTime)
		BackgroundColor.a = a
		AnnouncementColor.a = a
		draw.SimpleTextOutlined(Line1, "ComicSansAnnouncements.Small", ScrW() * 0.5, ScrH() * 0.149, AnnouncementColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, BackgroundColor)
		a = TextAlpha(CurTime() - (LastAnnouncementTime + 1))
		BackgroundColor.a = a
		AnnouncementColor.a = a
		draw.SimpleTextOutlined(Line2, "ComicSansAnnouncements.Large", ScrW() * 0.5, ScrH() * 0.151, AnnouncementColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, BackgroundColor)
	end)
end
