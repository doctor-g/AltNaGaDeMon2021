all: windows linux html5

clean:
	rm -rf build/linux
	rm -rf build/windows
	rm -rf build/html

windows:
	mkdir -p build/windows
	godot --export "Windows Desktop" project/project.godot

linux:
	mkdir -p build/linux
	godot --export "Linux/X11" project/project.godot

html5:
	mkdir -p build/html
	godot --export "HTML5" project/project.godot
