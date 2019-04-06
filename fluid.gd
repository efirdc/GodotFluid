tool
extends TextureRect

var viewports = ["velocity", "divergence", "pressure", "density", "testing"]
export(int, "velocity", "divergence", "pressure", "density", "testing") var viewport_index = 0
export(float) var velocity_timestep = 1.0;
export(float) var density_timestep = 1.0;
export(float) var velocity_dissipation = 1.0;
export(float) var density_dissipation = 1.0
export(float) var radius = 1.0;
export(Color) var density_color = Color(1,1,1)

var mouse_pos = Vector2(0,0)
var last_mouse_pos = Vector2(0,0)
var containerToViewportAspectRatio = Vector2(0,0)
var containerToViewportSizeRatio = 0.614203

func _ready():
	containerToViewportAspectRatio = Vector2(640, 360) / rect_size
	last_mouse_pos = get_global_mouse_position() * containerToViewportAspectRatio
	set_process(true)
	
func _process(delta):
	
	containerToViewportAspectRatio = Vector2(640, 360) / rect_size
	mouse_pos = get_global_mouse_position() * containerToViewportAspectRatio
	
	change_viewports()
	advection_params(delta)
	velocity_splat()
	density_splat()
	
	last_mouse_pos = mouse_pos

func change_viewports():
	if Input.is_action_just_pressed("cycle_viewports"):
		viewport_index = (viewport_index + 1) % viewports.size()
	
	texture.viewport_path = viewports[viewport_index]

	
func advection_params(delta):
	var velocity = get_node("velocity/sprite").material
	var density = get_node("density/sprite").material
	
	velocity.set_shader_param("timestep", velocity_timestep * 60 * delta)
	velocity.set_shader_param("dissipation", velocity_dissipation)
	velocity.set_shader_param("blue", 0.5)
	density.set_shader_param("timestep", density_timestep * 60 * delta)
	density.set_shader_param("dissipation", density_dissipation)
	density.set_shader_param("blue", 0.0)
	
	
func velocity_splat():
	
	var splat_mat = get_node("velocity/splat").material
	
	splat_mat.set_shader_param("point", mouse_pos)
	var delta_mouse = mouse_pos - last_mouse_pos
	var mouse_color= (delta_mouse.normalized()*0.5 + Vector2(0.5,0.5))
	
	#mouse_color.x = stepify(mouse_color.x, 1.0)
	#mouse_color.y = stepify(mouse_color.y, 1.0)
	
	if delta_mouse.length() > 0:
		splat_mat.set_shader_param("color", Color(mouse_color.x, mouse_color.y, 0.5))
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		splat_mat.set_shader_param("radius", radius*radius*1.1)
	else:
		splat_mat.set_shader_param("radius", 0.0)
		
func density_splat():
	var splat_mat = get_node("density/splat").material
	
	splat_mat.set_shader_param("point", mouse_pos)
	var delta_mouse = mouse_pos - last_mouse_pos
	
	splat_mat.set_shader_param("color", density_color)
	
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		splat_mat.set_shader_param("radius", radius*radius)
	else:
		splat_mat.set_shader_param("radius", 0.0)