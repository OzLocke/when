extends MarginContainer

var days = {
	"English" : ["Monday", "Tueday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
	"Norwegian" : ["Mandag", "Tirsdag", "Onsdag", "Torsdag", "Fredag", "Lørdag", "Søndag"],
	"Welsh" : ["Dydd Llun", "Dydd Mawrth", "Dydd Mercher", "Dydd Iau", "Dydd Gwener", "Dydd Sadwrn", "Dydd Sul"]
	}
var language = "Welsh"

func ready():
	$Rows/HBoxContainer/Language.get_popup().add_item("English")
	$Rows/HBoxContainer/Language.get_popup().add_item("Norwegian")
	$Rows/HBoxContainer/Language.get_popup().add_item("Welsh")

func _process(delta):
	
	$Rows/Date.text = days[language][OS.get_datetime()["weekday"]-1] + " " + str(OS.get_datetime()["day"])
	
	var hours = OS.get_datetime()["hour"]
	var minutes = OS.get_datetime()["minute"]
	$Rows/Time.text = "%02d" % hours + ":" + "%02d" % minutes
