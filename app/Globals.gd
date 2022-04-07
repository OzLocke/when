extends Node

var data = {
	"active_language": "English",
	"active_theme": "1",
	"dict": {
		"Cymraeg": {
			"days": [
				"Dydd Llun",
				"Dydd Mawrth",
				"Dydd Mercher",
				"Dydd Iau",
				"Dydd Gwener",
				"Dydd Sadwrn",
				"Dydd Sul"
			],
			"theme_names": {
				"0": "Candy",
				"1": "Cyferbyniad",
				"2": "Cod",
				"3": "Dyslecsia"
			}
		},
		"English": {
			"days": [
				"Monday",
				"Tueday",
				"Wednesday",
				"Thursday",
				"Friday",
				"Saturday",
				"Sunday"
			],
			"theme_names": {
				"0": "Candy",
				"1": "Contrast",
				"2": "Code",
				"3": "Dyslexia"
			}
		},
		"Norsk": {
			"days": [
				"Mandag",
				"Tirsdag",
				"Onsdag",
				"Torsdag",
				"Fredag",
				"Lørdag",
				"Søndag"
			],
			"theme_names": {
				"0": "Sukkertøy",
				"1": "Kontrast",
				"2": "Kode",
				"3": "Dysleksi"
			}
		}
	},
	"meta": {
		"versions": {
			"Android": {"relase": "0.0.0"},
			"iOS": {"release": "0.0.0"},
			"HTML5": {"release": "0.0.0"},
			"OSX": {"release": "0.0.0"},
			"Server": {"release": "0.0.0"},
			"Windows": {"release": "0.1.0"},
			"UWP": {"release": "0.0.0"},
			"X11": {"release": "0.0.0"}
		}
	},
	"themes": {
		"0": {
			"name": "Candy",
			"bg_color": "efa0e4",
			"color": "63285a",
			"font": "res://Assets/Fonts/BRLNSR"
		},
		"1": {
			"name": "Contrast",
			"bg_color": "1c1c1c",
			"color": "ffffff",
			"font": "res://Assets/Fonts/ARIALBD"
		},
		"2": {
			"name": "Code",
			"bg_color": "17280b",
			"color": "55ff55",
			"font": "res://Assets/Fonts/CONSOLA"
		},
		"3": {
			"name": "Dyslexia",
			"bg_color": "e3dedb",
			"color": "333333",
			"font": "res://Assets/Fonts/OPENDYSLEXIC"
		}
	}
}
