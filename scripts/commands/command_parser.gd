extends Node

func parse_command(command_string: String) -> BaseCommand:
    if command_string == '': return null
    
    var sections := command_string.split(';')
    
    var command := sections[0].to_lower()
    var args: PackedStringArray
    if sections.size() > 1:
        args = sections.slice(1, sections.size())

    match command:
        'node_new':
            var props := LevelObjectProperties.new()
            for arg in args:
                var kv := arg.split(':')
                var clean_val := kv[1].strip_edges()
                match kv[0].strip_edges():
                    'name': props.name = clean_val
                    'position': props.position = _parse_vector(clean_val)
                    'rotation': props.rotation = _parse_vector(clean_val)
                    'scale': props.scale = _parse_vector(clean_val)
                    'color': props.color = _parse_color(clean_val)
                    
            return CommandObjectNew.new([props])
            
    return null
            
func parse_and_execute_command(command_string: String):
    var cmd := parse_command(command_string)
    CommandManager.insert_command(cmd, true)
            
func _parse_vector(vector_string: String) -> Vector3:
    var components := vector_string.split(' ')
    
    if components.size() != 3: return Vector3.ZERO
        
    for c in components:
        if not c.is_valid_float(): return Vector3.ZERO

    var x := components[0].to_float()
    var y := components[1].to_float()
    var z := components[2].to_float()
    
    return Vector3(x,y,z)

func _parse_color(color_string: String) -> Color:
    var components := color_string.split(' ')

    if components.size() != 3 and components.size() != 4: return Color.MAGENTA

    for c in components:
        if not c.is_valid_float(): return Color.MAGENTA

    var r := components[0].to_float()
    var g := components[1].to_float()
    var b := components[2].to_float()
    var a := 1.0
    if components.size() == 4: a = components[3].to_float()

    return Color(r,g,b,a)