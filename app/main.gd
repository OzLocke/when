extends MarginContainer

# Create theme data
var themes = {
	"Bubblegum" : {
		"bg_color" : Color(0.937255, 0.627451, 0.894118),
		"color" : Color(0.388235, 0.156863, 0.352941),
		"font" : "res://Assets/Fonts/BRLNSR"
		},
	"Contrast" : {
		"bg_color" : Color(0.101961, 0.101961, 0.101961),
		"color" : Color(1, 1, 1),
		"font" : "res://Assets/Fonts/ARIALBD"
		}
	}
var themes_list = ["Bubblegum", "Contrast"]
# Theme for use on start
var active_theme = "Contrast"

# Create language data
var days = {
	"English" : ["Monday", "Tueday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
	"Norsk" : ["Mandag", "Tirsdag", "Onsdag", "Torsdag", "Fredag", "Lørdag", "Søndag"],
	"Cymraeg" : ["Dydd Llun", "Dydd Mawrth", "Dydd Mercher", "Dydd Iau", "Dydd Gwener", "Dydd Sadwrn", "Dydd Sul"]
	}
var language_list = ["English", "Norsk", "Cymraeg"]
#Language for use on start
var active_language = "English"

#Define location variables
var loc_language_button
var loc_language
var loc_date
var loc_themes_button
var loc_themes
var loc_time
var loc_about

func _ready():
	#Connect location variables
	loc_language_button = $Rows/Cols/LanguageButton
	loc_language = $Rows/Cols/LanguageButton/Language
	loc_date = $Rows/Cols/Date
	loc_themes_button = $Rows/Cols/ThemesButton
	loc_themes = $Rows/Cols/ThemesButton/Themes
	loc_time = $Rows/Time
	loc_about = $Rows/About
	
	#--Populate popups--
	# Generate items from list
	for x in language_list:
		loc_language.add_item(x)
	# Connect to item selection function
	loc_language.connect("id_pressed", self, "_on_language_pressed")
	# Generate items from list
	for x in themes_list:
		loc_themes.add_item(x)
	# Connect to item selection function
	loc_themes.connect("id_pressed", self, "_on_theme_pressed")
	
	set_theme(active_theme)

func _process(_delta):
	# Update date and time
	loc_date.text = days[active_language][OS.get_datetime()["weekday"]-1] + " " + str("%02d" % OS.get_datetime()["day"])
	
	var hours = OS.get_datetime()["hour"]
	var minutes = OS.get_datetime()["minute"]
	loc_time.text = "%02d" % hours + ":" + "%02d" % minutes

func set_theme(active_theme):
	# Update colors and fonts based on active theme
	
	#Populate variables from active theme dictionary entry
	var bg_color = themes[active_theme]["bg_color"]
	var color = themes[active_theme]["color"]
	var font = themes[active_theme]["font"]
	
	#Set background color
	VisualServer.set_default_clear_color(bg_color)
	
	#Set fonts and colors
	loc_date.add_font_override("font",load(font + ".tres"))
	loc_date.add_color_override("font_color", color)
	
	loc_time.add_font_override("font",load(font + "_large.tres"))
	loc_time.add_color_override("font_color", color)
	
	loc_about.add_font_override("font",load(font + "_small.tres"))
	loc_about.add_color_override("font_color", color)
	
func _on_language_pressed(ID):
	#Set active_language to clicked language
	active_language = loc_language.get_item_text(ID)

func _on_theme_pressed(ID):
	#Set active_theme to clicked theme
	active_theme = loc_themes.get_item_text(ID)
	#This needs triggering as theme isn't in _process()
	set_theme(active_theme)

func _on_LanguageButton_button_up():
	#Show popup on click
	loc_language.popup()

func _on_ThemesButton_button_up():
	#Show popup on click
	loc_themes.popup()
