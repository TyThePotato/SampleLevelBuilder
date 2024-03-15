extends Node

var editor_main: EditorMain

var _command_history: Array = []
var _last_command_index: int = 0

# inserts a command into the current point in history, and optionally executes it
# any commands currently ahead in history are cleared
func insert_command(command: BaseCommand):
    _command_history.append(command)

# Reverts the last command in history
func revert_last_command():
    print('Attempted to revert last command')
    
# Executes the next command in history
func execute_next_command():
    pass
    
func _clear_future_history():
    if _last_command_index >= _command_history.size() - 1:
        