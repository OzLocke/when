extends Control

var verbose = true
# Create theme data
var themes = {
	"Candy" : {
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
var themes_list = ["Candy", "Contrast"]
# Theme for use on start
var active_theme = "Candy"

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


#Populate variables from active theme dictionary entry
var bg_color = themes[active_theme]["bg_color"]
var color = themes[active_theme]["color"]
var font = themes[active_theme]["font"]

func _ready():
	
	#Connect location variables
	loc_language_button = $Container/Rows/Cols/LanguageButton
	loc_date = $Container/Rows/Cols/Date
	loc_themes_button = $Container/Rows/Cols/ThemesButton
	loc_time = $Container/Rows/Time
	loc_about = $Container/Rows/About
	
	build_language_popup()
	build_themes_popup()

	update_theme()

func _process(_delta):
	# Update date and time
	loc_date.text = days[active_language][OS.get_datetime()["weekday"]-1] + " " + str("%02d" % OS.get_datetime()["day"])
	
	var hours = OS.get_datetime()["hour"]
	var minutes = OS.get_datetime()["minute"]
	loc_time.text = "%02d" % hours + ":" + "%02d" % minutes

func build_language_popup():
	loc_language = VBoxContainer.new()
	add_child(loc_language)
	loc_language.visible = false
	loc_language.rect_size.x = loc_language_button.get_size()[1]
	
	for item in language_list:
		var button = Button.new()
		loc_language.add_child(button)
		button.text = item
		button.align = HALIGN_LEFT
#		button.flat = true
		button.add_color_override("font_color", Color(color.r, color.g, color.b, .5))
		button.connect("button_up", self, "_on_language_item_clicked", [button.text])
		
func build_themes_popup():

	loc_themes = VBoxContainer.new()
	add_child(loc_themes)
	loc_themes.visible = false
	loc_themes.rect_size.x = loc_themes_button.get_size()[1]
	
	for item in themes_list:
		var button = Button.new()
		loc_themes.add_child(button)
		button.text = item
		button.align = HALIGN_RIGHT
#		button.flat = true
		button.add_color_override("font_color", Color(color.r, color.g, color.b, .5))
		button.connect("button_up", self, "_on_themes_item_clicked", [button.text])


func update_theme():
	# Update colors and fonts based on active theme
	
	#Populate variables from active theme dictionary entry
	bg_color = themes[active_theme]["bg_color"]
	color = themes[active_theme]["color"]
	font = themes[active_theme]["font"]
	
	#Set background color
	VisualServer.set_default_clear_color(bg_color)
	
	#Set fonts and colors
	for button in loc_language.get_children():
		button.add_font_override("font",load(font + "_small.tres"))
		button.add_color_override("font_color", Color(color.r, color.g, color.b, .5))
		button.add_color_override("font_color_hover", color)
	loc_language_button.modulate = color
#
	for button in loc_themes.get_children():
		button.add_font_override("font",load(font + "_small.tres"))
		button.add_color_override("font_color", Color(color.r, color.g, color.b, .5))
		button.add_color_override("font_color_hover", color)
	loc_themes_button.modulate = color
	
	loc_date.add_font_override("font",load(font + ".tres"))
	loc_date.add_color_override("font_color", color)
	
	loc_time.add_font_override("font",load(font + "_large.tres"))
	loc_time.add_color_override("font_color", color)
	
	loc_about.add_font_override("font",load(font + "_small.tres"))
	loc_about.add_color_override("font_color", color)

func position_popup(popup, parent):
	popup.set_position(
		Vector2(
			parent.rect_global_position.x,
			parent.rect_global_position.y + 80
			),
		false
		)

func _on_language_pressed(ID):
	#Set active_language to clicked language
	active_language = loc_language.get_item_text(ID)

func _on_theme_pressed(ID):
	#Set active_theme to clicked theme
	active_theme = loc_themes.get_item_text(ID)
	#This needs triggering as theme isn't in _process()
	update_theme()

func _on_LanguageButton_button_up():
	#Show popup on click (moving popup to under it's buttons)
	position_popup(loc_language, loc_language_button)
	loc_language.visible = true

func _on_ThemesButton_button_up():
	#Show popup on click (moving popup to under it's buttons)
	position_popup(loc_themes, loc_themes_button)
	loc_themes.visible = true
	


func _on_LanguageButton_mouse_entered():
	loc_language_button.modulate = Color(color.r, color.g, color.b, .5)


func _on_LanguageButton_mouse_exited():
	loc_language_button.modulate = color


func _on_ThemesButton_mouse_entered():
	loc_themes_button.modulate = Color(color.r, color.g, color.b, .5)


func _on_ThemesButton_mouse_exited():
	loc_themes_button.modulate = color
	
func _on_language_item_clicked(item):
	loc_language.visible = false
	active_language = item

func _on_themes_item_clicked(item):
	loc_themes.visible = false
	active_theme = item
	update_theme()
