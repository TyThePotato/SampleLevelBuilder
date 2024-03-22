extends Label

func _process(delta):
    var history = CommandManager.get_history_string()
    text = history