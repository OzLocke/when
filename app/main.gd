extends MarginContainer

var colors = {
	"Teal" : Color(0, 0.329412, 0.372549),
	"Pink" : Color(0.746094, 0.477966, 0.710483),
	"Orange" : Color(0.894118, 0.496048, 0.176471),
	"Blue" : Color(0.095551, 0.301437, 0.789063),
	"Green" : Color(0.304367, 0.714844, 0.330022)
	}


var background_color = colors.Pink

var days = {
	"English" : ["Monday", "Tueday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
	"Norsk" : ["Mandag", "Tirsdag", "Onsdag", "Torsdag", "Fredag", "Lørdag", "Søndag"],
	"Cymraeg" : ["Dydd Llun", "Dydd Mawrth", "Dydd Mercher", "Dydd Iau", "Dydd Gwener", "Dydd Sadwrn", "Dydd Sul"]
	}
var active_language = "English"
var active_theme = "Sunset"
var language_popup
var themes_popup


func _ready():
	VisualServer.set_default_clear_color(background_color)
	
	var style_box = load("res://Assets/Styleboxes/Default/popup_hover.tres")
	style_box.bg_color = background_color
	
	language_popup = $Rows/Cols/LanguageButton/Language
	language_popup.add_item("English")
	language_popup.add_item("Norsk")
	language_popup.add_item("Cymraeg")
	language_popup.connect("id_pressed", self, "_on_language_pressed")
	language_popup.add_color_override("font_color", background_color)
	
	themes_popup = $Rows/Cols/ThemesButton/Themes
	themes_popup.add_item("Dyslexic")
	themes_popup.add_item("Sunset")
	themes_popup.add_item("Contrast")
	themes_popup.add_item("Bubblegum")
	themes_popup.add_item("Forest")
	themes_popup.connect("id_pressed", self, "_on_theme_pressed")
	themes_popup.add_color_override("font_color", background_color)
	
	

func _process(_delta):
	
	$Rows/Date.text = days[active_language][OS.get_datetime()["weekday"]-1] + " " + str("%02d" % OS.get_datetime()["day"])
	
	var hours = OS.get_datetime()["hour"]
	var minutes = OS.get_datetime()["minute"]
	$Rows/Time.text = "%02d" % hours + ":" + "%02d" % minutes
	
func _on_language_pressed(ID):
	active_language = language_popup.get_item_text(ID)

func _on_theme_pressed(ID):
	active_theme = themes_popup.get_item_text(ID)
	print(themes_popup.get_item_text(ID))

func _on_LanguageButton_button_up():
	language_popup.popup()

func _on_ThemesButton_button_up():
	themes_popup.popup()
