class_name BossQuiz
extends BaseMicrogame
@export var transition_rect: TextureRect

@export var game_music: AudioStreamPlayer

@export var game_timer: Timer
@export var p1_time_label: Label
@export var p2_time_label: Label
@export var p1_question_label: RichTextLabel
@export var p2_question_label: RichTextLabel
@export var p1_top_label: RichTextLabel
@export var p1_left_label: RichTextLabel
@export var p1_right_label: RichTextLabel
@export var p1_bottom_label: RichTextLabel
@export var p2_top_label: RichTextLabel
@export var p2_left_label: RichTextLabel
@export var p2_right_label: RichTextLabel
@export var p2_bottom_label: RichTextLabel

@export var sfx_wrong1: AudioStreamPlayer
@export var sfx_wrong2: AudioStreamPlayer
@export var sfx_stupid1: AudioStreamPlayer
@export var sfx_stupid2:AudioStreamPlayer

var questions_to_answer = 3

var questions_answered_p1 = 0
var questions_answered_p2 = 0
var lives_p1 = 3
var lives_p2 = 3
var done_1 = false
var done_2 = false
var p1_time
var p2_time

#var current_question_num_p1
var question_list_easy = [
	["Who is Donkey Kong's best friend?", "Diddy Kong", "Dixie Kong", "", "", "Candy Kong", "Bluster Kong", "Lanky Kong", "Funky Kong", "Chunky Kong", "Lil' Kong", "Stinky Kong", "Mario", "Bowser", "King K. Rool"],
	["What year did the original [i]Super Mario Bros.[/i] release?", "1985", "", "", "", "1999", "1989", "1995", "1990", "1991", "1982", "1984", "19-Aught-7"],
	["What does \"COGS\" stand for?", "Creation of Games Society", "", "", "", "Community of Game Scholars", "Conservation of Games Syndicate", "The acronym is meaningless.", "Cost of Goods Sold", "It's the last name of the club's founder.", "Community of Gamedev Specialists", "Console and Online Gaming Society", "Creative Optimization of Games Squad", "Computer Operations and Gaming Simulations", "Cooperative Online Game Studio", "Collaborative Open Game Studio"],
	["What is the name of COGS' special event held once every semester?", "Scarlet Game Jam", "", "", "", "Scarlet Game Night", "RU Gaming?", "Fireside Open", "Scarlet Classic", "COGS Minecraft Night"],
	["What is the highest grossing arcade game of all time?", "[i]Pac-Man[/i]", "", "", "", "[i]Space Invaders[/i]", "[i]Street Fighter II[/i]", "[i]NBA Jam[/i]", "[i]Asteroids[/i]", "[i]Mortal Kombat II[/i]", "[i]Donkey Kong[/i]", "[i]Galaga[/i]", "[i]Snake[/i]", "[i]Pong[/i]", "[i]Dig Dug[/i]", "[i]Frogger[/i]", "[i]Centipede[/i]"],
	["What does the \"DS\" in \"Nintendo DS\" stand for?", "Developers' System", "", "", "", "Digital System", "Digital Screen", "Double Screen", "Display Sync", "Data Sharing", "Dynamic System"],
	["What does the \"DS\" in \"Nintendo DS\" stand for?", "Dual Screen", "", "", "", "Digital System", "Digital Screen", "Double Screen", "Display Sync", "Data Sharing", "Dynamic System"],
	["What is the name of Kratos' son in [i]God of War Ragnarök[/i]?", "Atreus", "", "", "", "Babitos", "Kratos never cared to name him, and just calls him \"boy\".", "Agamemnon", "Menelaus", "Pallas", "Potestas", "Baldur", "Belial", "Asmodeus", "Atriox", "Artemis", "Apollo"],
	["What is today's date?"],
	["Who is the first Gym Leader fought in the original [i]Pokémon Red[/i] and [i]Pokémon Blue[/i]?", "Brock", "Misty", "", "", "Blaine", "Lt. Surge", "Erika", "Koga", "Giovanni", "Sabrina", "Red", "Blue", "Dawn", "Falkner", "Roxanne", "Norman", "Milo", "Katy", "Nemona", "Tracy", "Bugsy"],
	["What year did the Nintendo Wii release?", "2006", "", "", "", "2007", "2005", "2008", "2004", "2010", "2003", "2002", "2000", "2001", "2009", "2008"],
	["What is Master Chief's given first name?", "John", "", "", "", "Abraham", "David", "Isaiah", "Zion", "Justin", "Zachary", "Elliot", "Joel", "Peter", "Jeremy", "Salem", "Kane", "Jacob", "Alan", "Aiden", "Kyle", "Wayne", "James", "Bruce"],
	["What [i]Minecraft[/i] block found deep underground is unbreakable in Survival mode?", "Bedrock", "", "", "", "Deepslate", "Granite", "Andesite", "Diorite", "Blackstone", "Netherite", "Core Block", "Obsidian", "Barrier", "Void", "End Stone"],
	["Which character from [i]Doki Doki Literature Club![/i] is revealed to be both sentient and evil?", "Monika", "", "", "", "Sayori", "Yuri", "Natsuki", "Dan Salvato"],
	["Mega Man has an older brother named _____.", "Proto Man", "Roll", "", "", "Dr. Light", "Dr. Wily", "Zero", "Mega Man X", "Elec Man", "Rockman", "Bass", "Sigma", "Guts Man", "Cut Man", "Rush"],
	["Mega Man has a younger sister named _____.", "Roll", "", "", "", "Dr. Light", "Dr. Wily", "Mega Woman", "Mega Girl", "Bass", "Sigma", "Rush", "Elec Woman", "Elec Girl", "Roxanne", "Tron Bonne", "Blues"],
	["What is the maximum number of Power Stars a player can collect in the original [i]Super Mario 64[/i]?", "120", "", "", "", "100", "150", "50", "200", "300", "180", "250", "115", "90", "105", "880", "999"],
	["Who is the final boss in [i]Terraria[/i]?", "Moon Lord", "", "", "", "Cthulhu", "Supreme Calamitas", "Devourer of Gods", "Wall of Flesh", "Empress of Light", "Slime God", "Lunatic Cultist", "Exo Mechs", "Ocram", "Hive Mind of Cthulhu", "Ancient Vision", "Phantasm Dragon", "True Eye of Cthulhu", "Terrarian"],
	["What game originated the old meme phrase \"The cake is a lie\"?", "[i]Portal[/i]", "", "", "", "[i]Half-Life[/i]", "[i]Team Fortress 2[/i]", "[i]Minecraft[/i]", "[i]Terraria[/i]", "[i]Goat Simulator[/i]", "[i]Life is Strange[/i]", "[i]YIIK: A Post-Modern RPG[/i]"],
	["What is the name of the kingdom that Princess Zelda rules over in most [i]The Legend of Zelda[/i] games?", "Hyrule", "", "", "", "Termina", "Kakariko", "Outset", "Pallet", "Phantomile", "Lunatea", "Gerudo", "Goron", "Hateno", "Eldin", "Morshu", "Sarasaland"],
	["What is the name of the 2021 visual novel where you can court the Rutgers buses?", "[i]Last Stop: Your Heart![/i]", "", "", "", "[i]Rutgers Bus Dating Simulator[/i]", "[i]Scarlet Routes of Love[/i]", "[i]Road to My Heart[/i]", "[i]RU Mine?[/i]", "[i]Next Stop: Romance[/i]", "[i]Red Bus Rendezvous[/i]"],
	["What iconic item is usually used to save your game progress in [i]Resident Evil[/i] games?", "Typewriter", "", "", "", "Tape Recorder", "Video Camera", "Diary", "Bed", "Toilet", "Mirror", "Cell Phone", "Bathroom Sink"],
	["Who was the final boss in the original [i]Punch-Out!![/i] for the NES?", "Mike Tyson", "", "", "", "Little Mac", "Doc Louis", "Donkey Kong", "Mr. Sandman", "Super Macho Man", "Nick Bruiser"],
	["What is the name of the town the player moves to at the beginning of [i]Stardew Valley[/i]?", "Pelican Town", "Zuzu City", "", "", "Terraria City", "Hyrule City", "River Village", "Willow Town", "Cindersap Town", "Pallet Town", "Backwoods Village"],
	["Who is Crash Bandicoot's sworn nemesis?", "Doctor Neo Cortex", "", "", "", "Doctor N. Tropy", "Doctor N. Gin", "Doctor N. Brio", "Uka Uka", "Aku Aku", "Nitros Oxide", "Doctor Robotnik", "Fake Crash", "Tiny Tiger", "Ripper Roo", "Dingodile", "Pinstripe Potoroo"],
	["As of 2024, what is the best-selling game of all time?", "[i]Minecraft[/i]", "[i]Grand Theft Auto V[/i]", "", "", "Wii Sports", "[i]PUBG: Battlegrounds[/i]", "[i]Mario Kart 8[/i]", "[i]Red Dead Redemption 2[/i]", "[i]Terraria[/i]", "[i]Super Mario Bros.[/i]", "[i]Overwatch[/i]", "[i]Animal Crossing: New Horizons[/i]", "[i]Pokémon Diamond/Pokémon Pearl/Pokémon Platinum[/i]", "[i]Elden Ring[/i]"],
	["Which [i]Super Smash Bros.[/i] game introduced Final Smashes?", "[i]Super Smash Bros. Brawl[/i]", "", "", "", "[i]Super Smash Bros. 64[/i]", "[i]Super Smash Bros. Melee[/i]", "[i]Super Smash Bros. for Nintendo 3DS and Wii U[/i]", "[i]Super Smash Bros. Ultimate[/i]"],
	["What is the name of Kirby's home planet?", "Popstar", "Dream Land", "", "", "Halcandra", "Robobot", "Floralia", "Ripple Star", "Rock Star", "Shiver Star", "Neo Star", "Dark Star", "Hotbeat", "Patch Land", "Aqua Star"],
	["What was the name of the Xbox 360's motion-sensing peripheral?", "Xbox Kinect", "", "", "", "Project Natal", "Xbox Sense", "Xbox Move", "Xbox Go", "Xbox MotionPlus", "X Vision"]
]

var question_list_medium = [
	["What year was COGS founded?", "2014", "", "", "", "2010", "2012", "2017", "2019", "2021", "2009", "1999", "2000", "2009", "2008", "2011"],
	["What was [i]Minecraft[/i]'s original name?", "[i]Cave Game[/i]", "[i]Minecraft: Order of the Stone[/i]", "", "", "[i]Blockscape[/i]", "[i]Mine & Craft[/i]", "[i]Craftverse[/i]", "[i]Voxel World[/i]", "[i]Pixelcraft[/i]", "[i]Blocky Haven[/i]", "[i]My World[/i]", "[i]Pixel Forge[/i]", "[i]Worldbuilder[/i]", "[i]Cubic Horizons[/i]", "[i]Stone Realm[/i]", "[i]Treasure Planet[/i]", "[i]Hunt, Gather, Build[/i]", "[i]Dragonslayer[/i]"],
	["What is the name of Klonoa's home town?", "Breezegale", "", "", "", "Littleroot", "Phantomile", "Lunatea", "Volk City", "Twinleaf", "Zinkenstill", "Gongaga", "Hyrule"],
	["Which is a real Pokémon?", "Brambleghast", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Centiskorch", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Wishiwashi", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Hydrapple", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Volcanion", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Druddigon", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Pyukumuku", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Frosmoth", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Shroodle", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Blacephalon", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Stakataka", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Poipole", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Nihilego", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Barbaracle", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Raging Bolt", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Scream Tail", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Iron Hands", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["Which is a real Pokémon?", "Iron Crown", "", "", "", "Tentaquil", "Slimer", "Crawltipede", "Orbulon", "Bohldohr", "Crabulon", "Spectrafin", "Rockodile", "Voltergeist", "Venomenon", "Skullipede", "Cactyke", "Waykeewaykee", "Frostina", "Plantera", "Glumm", "Dynamax", "Klonoa", "Primadon", "Pompompurin", "Kodra", "Bronzilla", "Cnidrion", "Azathoth", "Lusamine", "Iron Jaw", "Iron Stamp", "Verdant Sail", "Sundering Sun"],
	["What's the name of COGS' mascot?", "COGS-chan", "", "", "", "Jam-tan", "Pascal", "Cogster", "Coglet", "Coggers", "Godot Gal", "Sarah", "Scarlet", "Julie", "Gamer Girl", "Melissa", "Rachel", "Roxie", "Alex", "Alana", "Jam Jar", "Bath Bomb Baby"],
	["Who composed [i]One Winged Angel[/i] as it was first heard in [i]Final Fantasy VII[/i]?", "Nobuo Uematsu", "", "", "", "Koji Kondo", "Danny Elfman", "John Williams", "Yoko Shimamura", "Akira Yamaoka", "Koichi Sugiyama", "Kazumi Totaka", "Masato Nakamura", "Junichi Masuda", "Masahiro Sakurai", "Michiru Yamane", "Yasunori Mitsuda", "Mahito Yokota", "Jake Kaufman", "Garett Coker", "Hirokazu \"Hit\" Tanaka", "Toby Fox", "Grant Kirkhope", "Jun'ya \"ZUN\" Ōta", "Daisuke Ishiwatari", "Naoki \"NAOKI\" Hashimoto", "Christopher Larkin", "Motoi Sakuraba", "Jun Senoue", "Tee \"Tee Lopes\" Lopes", "David Wise", "Hitoshi Sakimoto", "Shigeru Miyamoto", "Noah Wu"],
	["How much does a [i]Fornite[/i] Battle Pass cost?", "$9.99", "", "", "", "$4.99", "$14.99", "$19.99", "$11.99", "100 V-Bucks", "500 V-Bucks", "1,000 V-Bucks", "200 V-Bucks"],
	["Which one of these [i]Undertale[/i] characters is named after a real person?", "Temmie", "", "", "", "Undyne", "Alphys", "Asriel", "Gerson", "Nabstablook", "Chara"],
	["The protagonist from [i]One Shot[/i] is named after which famous inventor?", "Nikola Tesla", "", "", "", "Albert Einstein", "J. Robert Oppenheimer", "Alexander Graham Bell", "Thomas Edison", "Madam C.J. Walker", "Orville Wright", "Wilbur Wright", "Ada Lovelace", "Hedy Lamarr", "Kendrick Lamar"],
	["What is the name of Wario's brother?", "Wario doesn't have a brother.", "Waluigi", "", "", "Mario", "Luigi", "Jimmy T.", "18-Volt", "Wario-Man"],
	["After global launch, [i]Zenless Zone Zero[/i]'s first Exclusive Channel featureed which S-rank character?", "Ellen Joe", "", "", "", "Zhu Yuan", "Hoshimi Miyabi", "Belle", "Wise", "Anby", "Nicole", "Billy Kid", "Nekomiya Mana", "Ben Bigger", "Jane Doe", "Seth", "Qingyi", "Ellen Degeneres", "Klee", "Venti", "Zhongli", "Ganyu", "Hu Tao"],
	["What game originated the old meme phrase \"All your base are belong to us\"?", "[i]Zero Wing[/i]", "", "", "", "[i]Contra[/i]", "[i]Mega Man[/i]", "[i]Half-Life[/i]", "[i]Portal[/i]", "[i]Metal Gear[/i]", "[i]Star Fox[/i]", "[i]Metroid[/i]", "[i]Hogan's Alley[/i]", "[i]Pilotwings[/i]", "[i]Double Dragon[/i]"],
	["Nintendo was originally founded to produce what?", "Playing cards", "", "", "", "Polaroid cameras", "Plush toys", "Electrical cables", "Circuit boards", "Scented candles", "Children's books", "Action figures"],
	["Who is the titular \"guilty Gear\" from the [i]Guilty Gear[/i] franchise?", "Sol Badguy", "", "", "", "Ky Kiske", "Leo Whitefang", "Ragna the Bloodedge", "Ramlethal Valentine", "Jack-O' Valentine", "Baiken", "Bedman", "Dizzy", "Ariels", "Asuka R. Kreutz", "Kliff Undersn", "Testament", "Justice", "Saul Goodman"],
	["During a promotoional Q&A video for the 30th anniversary of [i]Super Mario Bros.[/i], series creator Shigeru Miyamoto reveals that Bowser Jr.'s mother is who?", "Shigeru Miyamoto himself", "Princess Peach", "", "", "Princess Daisy", "Princess Rosalina", "Pauline", "Mario", "Luigi", "Kamek", "An unknown deceased character.", "Not even Shigeru Miyamoto knows.", "Bowser Jr. has no mother, and Bowser is capable of asexual reproduction."],
	["As of 2024, the world record speedrun for the original [i]Super Mario Bros.[/i] takes _____.", "around 5 minutes", "", "", "", "around 1 minute", "around 2 minutes", "around 10 minutes", "around 15 minutes", "around 20 minutes", "around 30 minutes", "around 1 hour", "around 30 seconds"],
	["The Lowain Bros from [i]Granblue Fantasy[/i] are also collectively known as _____.", "The Brofam", "", "", "", "Dandylions Blooming in the Tosh", "The Bromance", "The Katalina Fan Club", "The Yggdrasil Fan Club", "The Freesia von Bismarck Fan Club", "The Swinger Trio", "The Human Pyramid", "The Magnificent Tools of Destruction", "The Dudebros", "The Shadow Triad"],
	["In [i]Pokémon Diamond[/i], [i]Pokémon Pearl[/i], and [i]Pokémon Platinum[/i], the device obtained in Jubilife City that occupies the DS' touch screen is called the _____.", "Pokétch", "", "", "", "Pokétech", "Pokédex", "PokéNav", "Pokégear", "C-Gear", "Cell Phone", "Xtransceiver"],
	["Which one of these is [i]not[/i] a virus from the [i]Resident Evil[/i] series?", "G-Veronica virus", "", "", "", "T-virus", "G-virus", "T-Veronica virus", "NE-T virus", "Progenitor virus"],
	["Which one of these is [i]not[/i] a virus from the [i]Resident Evil[/i] series?", "Z-virus", "", "", "", "T-virus", "G-virus", "T-Veronica virus", "NE-T virus", "Progenitor virus"],
	["Who is the first companion to join Mario on his journey in [i]Paper Mario: The Thousand-Year Door[/i]?", "Goombella", "", "", "", "Vivian", "Goombario", "Luigi", "Princess Peach", "Kooper", "Bombette", "Lady Bow", "Koops", "Madame Flurrie", "Admiral Bobbery", "Olivia", "Kersti", "Geno", "Mallow", "Huey", "Starlow", "Stuffwell", "Toad", "Yoshi", "Prince Dreambert"],
	["What was the first video game played in outer space?", "[i]Tetris[/i]", "", "", "", "[i]Pong[/i]", "[i]Super Mario Bros.[/i]", "[i]Pokémon Red[/i]", "[i]Pokémon Blue[/i]", "[i]Super Mario Kart[/i]", "[i]Pac-Man[/i]", "[i]Dig Dug[/i]"],
	["What animal is Tom Nook from the [i]Animal Crossing[/i] series?", "Tanuki", "Nook", "", "", "Human", "Dog", "Cat", "Rabbit", "Mouse", "Bear", "Raccoon", "Fox"],
	["Who is the titular \"Twilight Princess\" from the [i]The Legend of Zelda: Twilight Princess[/i]?", "Midna", "Princess Zelda", "", "", "Princess Hilda", "Ilia", "Impa", "Epona", "Nayru", "Din", "Farore"]
]

var question_list_hard =  [
	["What's 9 + 10?", "21", "19", "", "", "20", "22", "4", "910", "2", "1", "90", "-1", "0.9"],
	["What's Obama's last name?", "Soda", "Obama", "Care", "", "Obamna", "Barack", "Baracko", "Hussein", "Bush", "Biden", "Clinton"],
	["What is the name of the iconic blue shark plush toy sold at IKEA stores?", "Blåhaj", "", "", "", "Djungelskog", "Blåvingad", "Aftonsparv", "Skogsduva", "Kramig", "Söt Barnslig", "Gosig Golden", "Lilleplutt", "Jättestor", "Famnig Hjärta", "Fabler Björn", "Snuttig", "Jättelik", "Knorrig", "Titta Djur", "Livlig", "Brummig", "Sparka", "Gulligast", "Drömslott", "Utsådd", "Guldvävare"],
	["Ooh-eee!", "Ooh-ah-ah!", "", "", "", "Ting-tang!", "Walla-walla bing-bang!", "Eee-ooh!", "Ah-ooh!", "Eee-ah-ah!", "Eee-ah!", "Ah-eee!", "Ah-ooh-ooh!"],
	["What the dog doin'?", "Taking an Ice Breakers mint.", "", "", "", "Opening the door for the Pizza Hut delivery guy.", "Stealing a Dr. Pepper from the fridge.", "Spraying Febreze around the living room.", "Flirting with female dogs after using Old Spice body spray.", "Riding on top of a Roomba.", "Playing [i]Kirby Super Star Ultra[/i] for Nintendo DS.", "Sitting in the driver's seat of a car at the Wendy's drive-thru."],
	["What is the 7th letter of the alphabet?", "H", "G", "", "", "I", "J", "E", "F", "7"],
	["What is the minimum number of Spongebobs it would take to defeat Goku?", "30,000,000,000", "", "", "", "1,000,000,000,000", "2", "5,000,000", "No amount of Spongebobs could ever defeat Goku.", "400,000", "∞", "8,000,000", "7,000,000,000", "600,000,000,000"],
	["Name something a burglar would not wanna see when he breaks into a house.", "Naked grandma", "", "", "", "An occupant", "A dog", "A police officer", "A completely empty house with no furniture", "Another burglar", "A video camera", "An alarm system", "Perfect Cell"],
	["Did you get those photos printed?", "Bogos binted?", "", "", "", "No.", "Yes.", "Not yet.", "I'll do it tomorrow."],
	["How many holes in a polo?", "4", "", "", "", "1", "2", "3", "5", "0"],
	["What game would you hate for your wife to walk in on you playing?", "[i]Meet 'n' F*** Kingdom[/i]", "", "", "", "[i]Doki Doki Literature Club![/i]", "[i]Genshin Impact[/i]", "[i]Zenless Zone Zero[/i]", "[i]Arknights[/i]", "[i]Phucker in the Gulag[/i]", "[i]Phucker in the Woods[/i]", "[i]Phucker in the Rome[/i]", "[i]Azur Lane[/i]", "[i]Goddess of Victory: Nikke[/i]", "[i]Wuthering Waves[/i]", "[i]Honkai: Star Rail[/i]", "[i]Yandere Simulator[/i]"],
	["Steve Harvey", "Steve Harvet", "Steve Harvey", "", "", "Richard Dawson", "Ray Combs", "Louie Anderson", "Richard Karn", "John O'Hurley"],
	["Can a match box?", "No, but a tin can.", "", "", "", "Yes.", "No.", "I don't know1.", "Yes, one beat Mike Tyson."],
	[".sdrawkcab noitseuq siht rewsnA", "KO", "", "", "", "What?", "I don't understand.", "Tennis elblow.", ".ti teg t'nod I"],
	["What follows December 2nd?", "n", "December 3rd", "A question mark", "142 dwarves"],
	["What's worse than a burga and fries?", "Evil burga, with a side of horror fries.", "", "", "", "Burga with no fries.", "Fries with no burga.", "Funky burga, with a side of disco fries.", "Putrid burga, with a side of fetid fries."],
	["What year is it?", "Aawagga", "After lunch", "1962"],
	["The \"king's hand\" is a dish consisting of an M&M cookie shaped like a hollow hand that is filled with _____.", "greek salad", "", "", "", "Caesar salad", "ambrosia", "yogurt", "icing", "cookie dough", "tuna salad", "egg salad", "lox", "cream cheese", "beans", "Cobb salad", "chicken salad", "corned beef", "sardines", "marmalade"],
	["They put Fanum on a _____.", "horse", "", "", "", "mule", "donkey", "ostritch", "camel", "pig", "buffalo", "llama", "elephant", "cow", "yak", "moose", "lion", "payment plan"],
	["Which day of the week follows Wednesday?", "Logsday", "Thursday", "", "", "Monday", "Tuesday", "Wednesday", "Friday", "Saturday", "Sunday"]
]

var current_correct_answer_p1 = 0
var current_correct_answer_p2 = 0

var current_question_num_p1
var current_question_num_p2
var asked = []
var question_list

var game_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.p1_just_failed = true
	GameManager.p2_just_failed = true
	
	if GameManager.game_level == 1:
		craft_date_question()
		question_list = question_list_easy
	elif GameManager.game_level == 2:
		question_list = question_list_medium
	elif GameManager.game_level == 3:
		append_year_question()
		question_list = question_list_hard
		
	get_tree().paused = true
	
	var transition_tween = get_tree().create_tween()
	transition_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	transition_tween.tween_property(transition_rect, "scale", Vector2(10, 10), (0.5 / GameManager.game_speed))
	await get_tree().create_timer(0.5/GameManager.game_speed).timeout
	get_tree().paused = false
	
	await get_tree().create_timer(2.0/GameManager.game_speed).timeout
	
	game_music.set_pitch_scale(GameManager.game_speed)
	game_music.play()
	
	game_timer.set_wait_time(16/GameManager.game_speed)
	game_timer.start()
	
	asked = []
	
	select_question_number_p1()
	select_question_number_p2()
	
	print(asked)
	
	print(question_list[current_question_num_p1])
	print(question_list[current_question_num_p2])
	generate_question_p1(question_list[current_question_num_p1])
	generate_question_p2(question_list[current_question_num_p2])
	game_started = true
	
	sfx_wrong1.set_pitch_scale(GameManager.game_speed)
	sfx_wrong2.set_pitch_scale(GameManager.game_speed)
	sfx_stupid1.set_pitch_scale(GameManager.game_speed)
	sfx_stupid2.set_pitch_scale(GameManager.game_speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if done_1 == false:
		p1_time = game_timer.get_time_left()
		p1_time_label.text = str("%.2f" % p1_time)
	if done_2 == false:
		p2_time = game_timer.get_time_left()
		p2_time_label.text = str("%.2f" % p2_time)
	
	
	if Input.is_action_just_pressed("top_button_0") && game_started == true:
		if lives_p1 > 0:
			if current_correct_answer_p1 == 1:
				questions_answered_p1 += 1
				if questions_answered_p1 < questions_to_answer:
					select_question_number_p1()
					print(question_list[current_question_num_p1])
					generate_question_p1(question_list[current_question_num_p1])
				else:
					done_1 = true
					GameManager.p1_just_failed = false
					blank_p1()
			else:
				sfx_wrong1.play()
				lives_p1 -= 1
				if lives_p1 <= 0:
					done_1 = true
					blank_p1()
					await get_tree().create_timer(0.5/ GameManager.game_speed).timeout
					sfx_stupid1.play()


	if Input.is_action_just_pressed("left_button_0") && game_started == true:
		if lives_p1 > 0:
			if current_correct_answer_p1 == 2:
				questions_answered_p1 += 1
				if questions_answered_p1 < questions_to_answer:
					select_question_number_p1()
					print(question_list[current_question_num_p1])
					generate_question_p1(question_list[current_question_num_p1])
				else:
					done_1 = true
					GameManager.p1_just_failed = false
					blank_p1()
			else:
				sfx_wrong1.play()
				lives_p1 -= 1
				if lives_p1 <= 0:
					done_1 = true
					blank_p1()
					await get_tree().create_timer(0.5/ GameManager.game_speed).timeout
					sfx_stupid1.play()
					
	if Input.is_action_just_pressed("right_button_0") && game_started == true:
		if lives_p1 > 0:
			if current_correct_answer_p1 == 3:
				questions_answered_p1 += 1
				if questions_answered_p1 < questions_to_answer:
					select_question_number_p1()
					print(question_list[current_question_num_p1])
					generate_question_p1(question_list[current_question_num_p1])
				else:
					done_1 = true
					GameManager.p1_just_failed = false
					blank_p1()
			else:
				sfx_wrong1.play()
				lives_p1 -= 1
				if lives_p1 <= 0:
					done_1 = true
					blank_p1()
					await get_tree().create_timer(0.5/ GameManager.game_speed).timeout
					sfx_stupid1.play()
					
	if Input.is_action_just_pressed("bottom_button_0") && game_started == true:
		if lives_p1 > 0:
			if current_correct_answer_p1 == 4:
				questions_answered_p1 += 1
				if questions_answered_p1 < questions_to_answer:
					select_question_number_p1()
					print(question_list[current_question_num_p1])
					generate_question_p1(question_list[current_question_num_p1])
				else:
					done_1 = true
					GameManager.p1_just_failed = false
					blank_p1()
			else:
				sfx_wrong1.play()
				lives_p1 -= 1
				if lives_p1 <= 0:
					done_1 = true
					blank_p1()
					await get_tree().create_timer(0.5/ GameManager.game_speed).timeout
					sfx_stupid1.play()
					
	if Input.is_action_just_pressed("top_button_1") && game_started == true:
		if lives_p2 > 0:
			if current_correct_answer_p2 == 1:
				questions_answered_p2 += 1
				if questions_answered_p2 < questions_to_answer:
					select_question_number_p2()
					print(question_list[current_question_num_p2])
					generate_question_p2(question_list[current_question_num_p2])
				else:
					done_2 = true
					GameManager.p2_just_failed = false
					blank_p2()
			else:
				sfx_wrong2.play()
				lives_p2 -= 1
				if lives_p2 <= 0:
					done_2 = true
					blank_p2()
					await get_tree().create_timer(0.5/ GameManager.game_speed).timeout
					sfx_stupid2.play()
					
	if Input.is_action_just_pressed("left_button_1") && game_started == true:
		if lives_p2 > 0:
			if current_correct_answer_p2 == 2:
				questions_answered_p2 += 1
				if questions_answered_p2 < questions_to_answer:
					select_question_number_p2()
					print(question_list[current_question_num_p2])
					generate_question_p2(question_list[current_question_num_p2])
				else:
					done_2 = true
					GameManager.p2_just_failed = false
					blank_p2()
			else:
				sfx_wrong2.play()
				lives_p2 -= 1
				if lives_p2 <= 0:
					done_2 = true
					blank_p2()
					await get_tree().create_timer(0.5/ GameManager.game_speed).timeout
					sfx_stupid2.play()
		
	if Input.is_action_just_pressed("right_button_1") && game_started == true:
		if lives_p2 > 0:
			if current_correct_answer_p2 == 3:
				questions_answered_p2 += 1
				if questions_answered_p2 < questions_to_answer:
					select_question_number_p2()
					print(question_list[current_question_num_p2])
					generate_question_p2(question_list[current_question_num_p2])
				else:
					done_2 = true
					GameManager.p2_just_failed = false
					blank_p2()
			else:
				sfx_wrong2.play()
				lives_p2 -= 1
				if lives_p2 <= 0:
					done_2 = true
					blank_p2()
					await get_tree().create_timer(0.5/ GameManager.game_speed).timeout
					sfx_stupid2.play()
		
	if Input.is_action_just_pressed("bottom_button_1") && game_started == true:
		if lives_p2 > 0:
			if current_correct_answer_p2 == 4:
				questions_answered_p2 += 1
				if questions_answered_p2 < questions_to_answer:
					select_question_number_p2()
					print(question_list[current_question_num_p2])
					generate_question_p2(question_list[current_question_num_p2])
				else:
					done_2 = true
					GameManager.p2_just_failed = false
					blank_p2()
			else:
				sfx_wrong2.play()
				lives_p2 -= 1
				if lives_p2 <= 0:
					done_2 = true
					blank_p2()
					await get_tree().create_timer(0.5/ GameManager.game_speed).timeout
					sfx_stupid2.play()

func select_question_number_p1():
	current_question_num_p1 = randi_range(0, question_list.size() - 1)
	while current_question_num_p1 in asked:
		current_question_num_p1 = randi_range(0, question_list.size() - 1)
	asked.append(current_question_num_p1)
	if question_list == question_list_easy && (current_question_num_p1 == 5 || current_question_num_p1 == 6):
		asked.append(5)
		asked.append(6)
	if question_list == question_list_easy && (current_question_num_p1 == 14 || current_question_num_p1 == 15):
		asked.append(14)
		asked.append(15)
	if question_list == question_list_medium && (current_question_num_p1 >= 3 && current_question_num_p1 <= 20):
		asked.append(3)
		asked.append(4)
		asked.append(5)
		asked.append(6)
		asked.append(7)
		asked.append(8)
		asked.append(9)
		asked.append(10)
		asked.append(11)
		asked.append(12)
		asked.append(13)
		asked.append(14)
		asked.append(15)
		asked.append(16)
		asked.append(17)
		asked.append(18)
		asked.append(19)
		asked.append(20)
	if question_list == question_list_medium && (current_question_num_p1 == 35 || current_question_num_p1 == 36):
		asked.append(35)
		asked.append(36)

func select_question_number_p2():
	current_question_num_p2 = randi_range(0, question_list.size() - 1)
	while current_question_num_p2 in asked:
		current_question_num_p2 = randi_range(0, question_list.size() - 1)
	asked.append(current_question_num_p2)
	if question_list == question_list_easy && (current_question_num_p2 == 5 || current_question_num_p2 == 6):
		asked.append(5)
		asked.append(6)
	if question_list == question_list_easy && (current_question_num_p2 == 14 || current_question_num_p2 == 15):
		asked.append(14)
		asked.append(15)
	if question_list == question_list_medium && (current_question_num_p2 >= 3 && current_question_num_p2 <= 20):
		asked.append(3)
		asked.append(4)
		asked.append(5)
		asked.append(6)
		asked.append(7)
		asked.append(8)
		asked.append(9)
		asked.append(10)
		asked.append(11)
		asked.append(12)
		asked.append(13)
		asked.append(14)
		asked.append(15)
		asked.append(16)
		asked.append(17)
		asked.append(18)
		asked.append(19)
		asked.append(20)
	if question_list == question_list_medium && (current_question_num_p2 == 35 || current_question_num_p2 == 36):
		asked.append(35)
		asked.append(36)

func generate_question_p1(question):
	#Pop the question and display
	p1_question_label.text = "[center]" + question.pop_front() + "[/center]"
	
	#Generate a number for the location of the answer and place it somewhere random, appending that random spot to already used
	current_correct_answer_p1 = randi_range(1, 4)
	var already_used = []
	var answers_placed = 0
	already_used.append(current_correct_answer_p1)
	if current_correct_answer_p1 == 1:
		p1_top_label.text = "[center]" + question.pop_front() + "[/center]"
	elif current_correct_answer_p1 == 2:
		p1_left_label.text = "[center]" + question.pop_front() + "[/center]"
	elif current_correct_answer_p1 == 3:
		p1_right_label.text = "[center]" + question.pop_front() + "[/center]"
	else:
		p1_bottom_label.text = "[center]" + question.pop_front() + "[/center]"
	answers_placed += 1
	
	#Next, put in the guaranteed fake answers, if there are any
	var next_spot_to_put_in
	var next_answer_to_put_in
	for i in range(0, 3):
		next_answer_to_put_in = question.pop_front()
		if next_answer_to_put_in != "":
			next_spot_to_put_in = randi_range(1, 4)
			while already_used.has(next_spot_to_put_in):
				next_spot_to_put_in = randi_range(1, 4)
			already_used.append(next_spot_to_put_in)
			if next_spot_to_put_in == 1:
				p1_top_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			elif next_spot_to_put_in == 2:
				p1_left_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			elif next_spot_to_put_in == 3:
				p1_right_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			else:
				p1_bottom_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			answers_placed += 1
			
	#fill in remainder with randy options
	while answers_placed < 4:
		next_answer_to_put_in = question.pop_at(randi_range(0, question.size() - 1))
		next_spot_to_put_in = randi_range(1, 4)
		while already_used.has(next_spot_to_put_in):
			next_spot_to_put_in = randi_range(1, 4)
		already_used.append(next_spot_to_put_in)
		if next_spot_to_put_in == 1:
			p1_top_label.text = "[center]" + next_answer_to_put_in + "[/center]"
		elif next_spot_to_put_in == 2:
			p1_left_label.text = "[center]" + next_answer_to_put_in + "[/center]"
		elif next_spot_to_put_in == 3:
			p1_right_label.text = "[center]" + next_answer_to_put_in + "[/center]"
		else:
			p1_bottom_label.text = "[center]" + next_answer_to_put_in + "[/center]"
		answers_placed += 1
		
func generate_question_p2(question):
	#Pop the question and display
	p2_question_label.text = "[center]" + question.pop_front() + "[/center]"
	
	#Generate a number for the location of the answer and place it somewhere random, appending that random spot to already used
	current_correct_answer_p2 = randi_range(1, 4)
	var already_used = []
	var answers_placed = 0
	already_used.append(current_correct_answer_p2)
	if current_correct_answer_p2 == 1:
		p2_top_label.text = "[center]" + question.pop_front() + "[/center]"
	elif current_correct_answer_p2 == 2:
		p2_left_label.text = "[center]" + question.pop_front() + "[/center]"
	elif current_correct_answer_p2 == 3:
		p2_right_label.text = "[center]" + question.pop_front() + "[/center]"
	else:
		p2_bottom_label.text = "[center]" + question.pop_front() + "[/center]"
	answers_placed += 1
	
	#Next, put in the guaranteed fake answers, if there are any
	var next_spot_to_put_in
	var next_answer_to_put_in
	for i in range(0, 3):
		next_answer_to_put_in = question.pop_front()
		if next_answer_to_put_in != "":
			next_spot_to_put_in = randi_range(1, 4)
			while already_used.has(next_spot_to_put_in):
				next_spot_to_put_in = randi_range(1, 4)
			already_used.append(next_spot_to_put_in)
			if next_spot_to_put_in == 1:
				p2_top_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			elif next_spot_to_put_in == 2:
				p2_left_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			elif next_spot_to_put_in == 3:
				p2_right_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			else:
				p2_bottom_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			answers_placed += 1
			
	#fill in remainder with randy options
	while answers_placed < 4:
		next_answer_to_put_in = question.pop_at(randi_range(0, question.size() - 1))
		next_spot_to_put_in = randi_range(1, 4)
		while already_used.has(next_spot_to_put_in):
			next_spot_to_put_in = randi_range(1, 4)
		already_used.append(next_spot_to_put_in)
		if next_spot_to_put_in == 1:
			p2_top_label.text = "[center]" + next_answer_to_put_in + "[/center]"
		elif next_spot_to_put_in == 2:
			p2_left_label.text = "[center]" + next_answer_to_put_in + "[/center]"
		elif next_spot_to_put_in == 3:
			p2_right_label.text = "[center]" + next_answer_to_put_in + "[/center]"
		else:
			p2_bottom_label.text = "[center]" + next_answer_to_put_in + "[/center]"
		answers_placed += 1

func blank_p1():
	p1_question_label.text = ""
	p1_top_label.text = ""
	p1_left_label.text = ""
	p1_right_label.text = ""
	p1_bottom_label.text = ""
	
func blank_p2():
	p2_question_label.text = ""
	p2_top_label.text = ""
	p2_left_label.text = ""
	p2_right_label.text = ""
	p2_bottom_label.text = ""

func _on_game_timer_timeout():
	get_tree().paused = true
	var transition_tween = get_tree().create_tween()
	transition_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	transition_tween.tween_property(transition_rect, "scale", Vector2(1, 1), (0.5 / GameManager.game_speed) )

	await get_tree().create_timer(0.5/ GameManager.game_speed).timeout
	get_tree().paused = false
	game_music.stop()
	sfx_wrong1.stop()
	sfx_wrong2.stop()
	sfx_stupid1.stop()
	sfx_stupid2.stop()
	
	all_done.emit()
	
























func craft_date_question():
	var date = Time.get_date_dict_from_system(false)
	var year = int(date.year)
	var month = int(date.month)
	var day = int(date.day)
	question_list_easy[8].append(str(month) + "/" + str(day) + "/" + str(year))
	for i in range(0, 3):
		question_list_easy[8].append("")
	
	question_list_easy[8].append(str(day) + "/" + str(month) + "/" + str(year))
	question_list_easy[8].append(str(month + 1) + "/" + str(day) + "/" + str(year))
	question_list_easy[8].append(str(month - 1) + "/" + str(day) + "/" + str(year))
	question_list_easy[8].append(str(month) + "/" + str(day + 1) + "/" + str(year))
	question_list_easy[8].append(str(month) + "/" + str(day + 2) + "/" + str(year))
	question_list_easy[8].append(str(month) + "/" + str(day + 3) + "/" + str(year))
	question_list_easy[8].append(str(month) + "/" + str(day - 1) + "/" + str(year))
	question_list_easy[8].append(str(month) + "/" + str(day - 2) + "/" + str(year))
	question_list_easy[8].append(str(month) + "/" + str(day - 3) + "/" + str(year))
	question_list_easy[8].append(str(month) + "/" + str(day) + "/" + str(year + 1))
	question_list_easy[8].append(str(month) + "/" + str(day) + "/" + str(year - 1))
	question_list_easy[8].append(str(month) + "/" + str(day + 1) + "/" + str(year + 1))
	question_list_easy[8].append(str(month) + "/" + str(day + 1) + "/" + str(year - 1))
	question_list_easy[8].append(str(month) + "/" + str(day - 1) + "/" + str(year + 1))
	question_list_easy[8].append(str(month) + "/" + str(day - 1) + "/" + str(year - 1))
	question_list_easy[8].append(str(month + 1) + "/" + str(day + 1) + "/" + str(year))
	question_list_easy[8].append(str(month - 1) + "/" + str(day + 1) + "/" + str(year))
	question_list_easy[8].append(str(month + 1) + "/" + str(day - 1) + "/" + str(year))
	question_list_easy[8].append(str(month - 1) + "/" + str(day - 1) + "/" + str(year))
	
func append_year_question():
	var date = Time.get_date_dict_from_system(false)
	var year = int(date.year)
	question_list_hard[16].append(str(year))
