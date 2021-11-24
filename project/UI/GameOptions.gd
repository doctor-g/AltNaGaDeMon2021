extends Control

onready var _music_bus := AudioServer.get_bus_index("Music")
onready var _music_slider := $MusicVolume
onready var _sfx_bus := AudioServer.get_bus_index("SFX")
onready var _sfx_slider := $SFXVolume

func _ready():
	_music_slider.value = db2linear(AudioServer.get_bus_volume_db(_music_bus))
	_sfx_slider.value = db2linear(AudioServer.get_bus_volume_db(_sfx_bus))


func _on_MusicVolume_value_changed(value:float)->void:
	AudioServer.set_bus_volume_db(_music_bus, linear2db(value))


func _on_SFXVolume_value_changed(value:float)->void:
	AudioServer.set_bus_volume_db(_sfx_bus, linear2db(value))
