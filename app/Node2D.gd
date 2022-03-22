extends Node2D


var dict = {
	"English": {
		"days" : ["Monday", "Tueday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
		"themes" : {
			0 : "Candy", 
			1 : "Contrast"
		}
	},
	"Norsk": {
		"days" : ["Mandag", "Tirsdag", "Onsdag", "Torsdag", "Fredag", "Lørdag", "Søndag"],
		"themes" : {
			0 : "Sukkertøy", 
			1 : "Kontrast"
		}
	},
	"Cymraeg": {
		"days" : ["Dydd Llun", "Dydd Mawrth", "Dydd Mercher", "Dydd Iau", "Dydd Gwener", "Dydd Sadwrn", "Dydd Sul"],
		"themes" : {
			0 : "Candy", 
			1 : "Cyferbyniad"
		}
	}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	for x in dict:
		print(x + ":")
		for y in dict[x]["themes"]:
			print(dict[x]["themes"][y])
		print("---------")
