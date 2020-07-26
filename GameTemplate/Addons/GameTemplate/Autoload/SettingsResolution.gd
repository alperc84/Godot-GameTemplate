extends Node

signal Resized

#SCREEN
#var ProjectResolution: = Vector2(ProjectSettings.get_setting('display/window/size/width'), ProjectSettings.get_setting('display/window/size/height'))
var Fullscreen = OS.window_fullscreen setget set_fullscreen
var Borderless = OS.window_borderless setget set_borderless
var View:Viewport
var ViewRect2:Rect2
var GameResolution:Vector2
var WindowResolution:Vector2
var ScreenResolution:Vector2
var ScreenAspectRatio:float
var Scale:int = 3 setget set_scale				#Default scale multiple
var MaxScale:int

#RESOLUTION
func set_fullscreen(value:bool)->void:
	Fullscreen = value
	OS.window_fullscreen = value
	WindowResolution = OS.window_size
	if value:
		Scale = MaxScale

func set_borderless(value:bool)->void:
	Borderless = value
	OS.window_borderless  = value

func get_resolution()->void:
	View = get_viewport()
	ViewRect2 = View.get_visible_rect()
	GameResolution = ViewRect2.size
	WindowResolution = OS.window_size
	ScreenResolution = OS.get_screen_size(OS.current_screen)
	ScreenAspectRatio = ScreenResolution.x/ScreenResolution.y
	MaxScale = ceil(ScreenResolution.y/ GameResolution.y)

func set_scale(value:int)->void:
	Scale = clamp(value, 1, MaxScale)
	if Scale >= MaxScale:
		OS.window_fullscreen = true
		Fullscreen = true
	else:
		OS.window_fullscreen = false
		Fullscreen = false
		OS.window_size = GameResolution * Scale
		OS.center_window()
	get_resolution()
	emit_signal("Resized")
