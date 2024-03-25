# TODO: implement history cap

extends Node

var editor_main: EditorMain

var _command_history: Array = []
var _last_command_index: int = -1

# inserts a command into the current point in history, and optionally executes it
# any commands currently ahead in history are cleared
func insert_command(command: BaseCommand, execute: bool) -> void:
    _clear_future_history() # if there is future history, it gets removed    
    
    command.editor_main = editor_main
    _command_history.append(command)

    if execute:
        execute_next_command()

# Reverts the last command in history
func revert_last_command() -> void:
    if _last_command_index == -1:
        # no past commands
        return
        
    _command_history[_last_command_index].execute_command_revert()

    _last_command_index -= 1
    
# Executes the next command in history
func execute_next_command() -> void:
    if _last_command_index >= _command_history.size() - 1:
        # no future commands
        return

    _last_command_index += 1

    _command_history[_last_command_index].execute_command()

func clear_all_history() -> void:
    _command_history.clear()
    _last_command_index = -1    

func _clear_future_history() -> void:
    if _last_command_index >= _command_history.size() - 1:
        # at the end of history
        return
        
    _command_history = _command_history.slice(0, _last_command_index + 1)

# DEBUG #
    
func get_history_string() -> String:
    var ret_str: String = ''
    if _last_command_index == -1:
        ret_str += '> '
    ret_str += 'START\n'
    
    var idx: int = 0
    for cmd: BaseCommand in _command_history:
        if idx == _last_command_index:
            ret_str += '> '
        ret_str += str(idx) + ': ' + cmd.human_readable_name + '\n'
        idx += 1
    return ret_str
