extends Control

onready var _music_bus := AudioServer.get_bus_index("Music")
onready var _music_slider := $MusicVolume
onready var _sfx_bus := AudioServer.get_bus_index("SFX")
onready var _sfx_slider := $SFXVolume
onready var _fullscreen_checkbox := $FullscreenCheckbox

func _ready():
	_music_slider.value = db2linear(AudioServer.get_bus_volume_db(_music_bus))
	_sfx_slider.value = db2linear(AudioServer.get_bus_volume_db(_sfx_bus))
	_fullscreen_checkbox.pressed = OS.window_fullscreen


func _on_MusicVolume_value_changed(value:float)->void:
	AudioServer.set_bus_volume_db(_music_bus, linear2db(value))


func _on_SFXVolume_value_changed(value:float)->void:
	AudioServer.set_bus_volume_db(_sfx_bus, linear2db(value))


func _on_FullscreenCheckbox_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
