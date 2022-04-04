extends Control

#Load styleboxes
var style_inactive = load("res://Assets/Styleboxes/inactive.tres")
var style_active = load("res://Assets/Styleboxes/active.tres")

#Define location variables
var loc_language_button
var loc_language
var loc_date
var loc_themes_button
var loc_themes
var loc_time
var loc_about
var loc_release
var loc_copyright

# Define other full-scope variables
var app_data = Globals.data
var user_data
var save_file = "res://data.json"
var bg_color
var color
var font
var active_theme
var active_language

#Define any other variables
var over_popup

func _ready():	
	load_data()
	
	#Connect location variables
	loc_language_button = $Container/Rows/Cols/LanguageButton
	loc_date = $Container/Rows/Cols/Date
	loc_themes_button = $Container/Rows/Cols/ThemesButton
	loc_time = $Time
	loc_release = $Container/Rows/MetaCols/Release
	loc_copyright = $Container/Rows/MetaCols/Copyright
	#Set initial theme and language
	active_theme = user_data["active_theme"]
	active_language = user_data["active_language"]
	#Build popups and set initial theme
	build_popup("Language", app_data["dict"])
	build_popup("Themes", app_data["dict"][active_language]["theme_names"])
	update_theme()
	#Populate meta
	loc_release.text = "Win " + app_data["meta"]["release"]
	loc_copyright.text = "© Locke Creatives " + str(OS.get_datetime()["year"])

func _process(_delta):
	# Update date and time
	loc_date.text = app_data["dict"][active_language]["days"][OS.get_datetime()["weekday"]-1] + " " + str("%02d" % OS.get_datetime()["day"])

	var hours = OS.get_datetime()["hour"]
	var minutes = OS.get_datetime()["minute"]
	loc_time.text = "%02d" % hours + ":" + "%02d" % minutes
	
	position_popup(loc_language, loc_language_button)
	position_popup(loc_themes, loc_themes_button)

func _input(event):
	#Hide popups when clicking away from them
	if !over_popup:
		if event.is_action_pressed("ui_cancel"):
			for popup in get_tree().get_nodes_in_group("popups"):
				popup.visible = false

func load_data():
	var file = File.new()
	file.open(save_file, file.READ)
	var data_raw = file.get_as_text()
	user_data = parse_json(data_raw)
	file.close()
	print(user_data)

func save_data():
	var file = File.new()
	file.open(save_file, file.WRITE)
	file.store_string(JSON.print(user_data, "	", true))
	file.close()
	print(user_data)

func build_popup(popup_name, popup_list):
	#--Create a popup, and build the buttons
	#Create new popup container
	var temp_storage = VBoxContainer.new()
	add_child(temp_storage)
	#Set popup name and styles
	temp_storage.name = popup_name
	temp_storage.visible = false
	temp_storage.size_flags_horizontal = false
	temp_storage.size_flags_vertical = false
	#Add popup to popups group
	temp_storage.add_to_group("popups", true)
#	#Loop over items in popup list to create buttons
	for item in popup_list:
		#Create a new button
		var button = Button.new()
		temp_storage.add_child(button)
		#Set button name, text and styles
		button.name = item
		if popup_name == "Language":
			button.text = item
			button.align = Button.ALIGN_LEFT
		else:
			button.text = app_data["dict"][active_language]["theme_names"][item]
			button.align = Button.ALIGN_RIGHT
		# set stylebox overrides
		var overrides = ["hover", "pressed", "focus", "disabled", "normal"]
		for override in overrides:
			if override == "pressed":
				button.add_stylebox_override(override, style_active)
			else:
				button.add_stylebox_override(override, style_inactive)
		#Connect button signals and functions
		var function_name = "_on_" + popup_name.to_lower() + "_item_clicked"
		button.connect("button_up", self, function_name, [button.name])
		button.connect("mouse_entered", self, "_on_popup_mouse_entered")
		button.connect("mouse_exited", self, "_on_popup_mouse_exited")
	#Asign popup to relevant holding variable
	if popup_name == "Language": loc_language = temp_storage
	if popup_name == "Themes": loc_themes = temp_storage
	
		
func update_theme():
	#--Update colors and fonts based on active theme
	#Populate variables from active theme dictionary entry
	#BG Color
	bg_color = Color(app_data["themes"][active_theme]["bg_color"])
	color = Color(app_data["themes"][active_theme]["color"])
	font = app_data["themes"][active_theme]["font"]
	#Set background color
	VisualServer.set_default_clear_color(bg_color)
	#Set stylebox colors
	style_active.bg_color = color
	#Set fonts and colors
	for button in loc_language.get_children():
		button.add_font_override("font",load(font + "_small.tres"))
		button.add_color_override("font_color", Color(color.r, color.g, color.b, .33))
		button.add_color_override("font_color_hover", color)
		button.add_color_override("font_color_pressed", bg_color)
	loc_language_button.modulate = color
#
	for button in loc_themes.get_children():
		button.add_font_override("font",load(font + "_small.tres"))
		button.add_color_override("font_color", Color(color.r, color.g, color.b, .33))
		button.add_color_override("font_color_hover", color)
		button.add_color_override("font_color_pressed", bg_color)
	loc_themes_button.modulate = color
	
	loc_date.add_font_override("font",load(font + ".tres"))
	loc_date.add_color_override("font_color", color)
	
	loc_time.add_font_override("font",load(font + "_large.tres"))
	loc_time.add_color_override("font_color", color)
	# for loop here allows for adding multiple labels in the meta row without repeating code
	var meta = [loc_release, loc_copyright]
	for label in meta:
		label.add_font_override("font",load(font + "_small.tres"))
		label.add_color_override("font_color", Color(color.r, color.g, color.b, .33))
		
func update_language():
	#Update the themes dropdown to show the theme names in the right language
	var themes = app_data["dict"][active_language]["theme_names"]
	#Loop over each button to set it's text
	for button in loc_themes.get_children():
		#Use the button name to find the relevant entry in the dict
		button.text = themes[button.name]

func position_popup(popup, parent):
	#Set the positions of the popup, relative to it's parent button
	var parent_x = parent.rect_global_position.x
	var parent_y = parent.rect_global_position.y
	var parent_size_x = parent.rect_size.x
	var popup_size_x = popup.rect_size.x
	
	#Set position x for the popup
	var position_x
	# if it's the Language popup align it to the left of the parent button
	if popup.name == "Language":
		position_x = parent_x
	else:
	# otherwise align it to the right of the parent button
		position_x = parent_x + parent_size_x - popup_size_x
	var position_y = parent_y + 110
	#Set the popup's new position
	popup.set_position(Vector2(position_x, position_y), false)
	
func show_popup(opened_popup_name):
	var verbose = false
	if verbose: print("func show_popup(" + opened_popup_name + ")")
	
	#Define and populate variables based on name passed in
	var popup
	var popup_parent
	var active_button
	var active_button_color = Color(app_data["themes"][active_theme]["color"])
	var non_active_button_color = Color(active_button_color.r, active_button_color.g, active_button_color.b, .5)
	if opened_popup_name == "Language":
		if verbose: print("Setting up Language popup")
		popup = loc_language
		if verbose: print("popup == " + popup.name)
		popup_parent = loc_language_button
		if verbose: print("popup_parent == " + popup_parent.name)
		active_button = active_language
		if verbose: print("active_button == " + active_button)
	if opened_popup_name == "Themes":
		if verbose: print("Setting up Language popup")
		popup = loc_themes
		if verbose: print("popup == " + popup.name)
		popup_parent = loc_themes_button
		if verbose: print("popup_parent == " + popup_parent.name)
		active_button = active_theme
		if verbose: print("active_button == " + active_button)
	
	#Set color of active button
	if verbose: print("Finding active button")
	for button in popup.get_children():
		if verbose: print("Checking " + button.name)
		if button.text == active_button:
			if verbose: print("Button is active")
			if verbose: print("Changing active button color to " + str(active_button_color))
			button.add_color_override("font_color", active_button_color)
		else:
			if verbose: print("Button not active")
			if verbose: print("Changing active button color to non-active style")
			button.add_color_override("font_color", non_active_button_color)
	
	#Position popup (important for if the user has resized the screen)
	if verbose: print("Calling position_popup()")
	position_popup(popup, popup_parent)
	
	#Show popup
	if verbose: print("Setting " + popup.name + " to visible")
	popup.visible = true

func _on_popup_mouse_entered():
	over_popup = true
	
func _on_popup_mouse_exited():
	over_popup = false

func _on_LanguageButton_button_up():
	show_popup("Language")

func _on_ThemesButton_button_up():
	show_popup("Themes")

func _on_LanguageButton_mouse_entered():
	loc_language_button.modulate = Color(color.r, color.g, color.b, .5)


func _on_LanguageButton_mouse_exited():
	loc_language_button.modulate = color


func _on_ThemesButton_mouse_entered():
	loc_themes_button.modulate = Color(color.r, color.g, color.b, .5)


func _on_ThemesButton_mouse_exited():
	loc_themes_button.modulate = color
	
func _on_language_item_clicked(item):
	#Hide popup
	loc_language.visible = false
	#Update language
	active_language = item
	update_language()
	#Save change to file
	user_data["active_language"] = active_language
	save_data()
	

func _on_themes_item_clicked(item):
	#Hide popup
	loc_themes.visible = false
	#Update theme
	active_theme = item
	update_theme()
	#Save change to file
	user_data["active_theme"] = active_theme
	save_data()
