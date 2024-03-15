# TODO: should this extend from something specific?

class_name BaseCommand

# Human readable command name (for logging)
var human_readable_name: String

# Attempts to execute command using stored properties
# Pseudo-abstract function - required to be overriden
func execute_command(editor_main: EditorMain):
    printerr('Command did not override function "execute_command()"!')
    
# Reverts execution of command - i.e. undoes command
# Pseudo-abstract function - required to be overriden
func execute_command_revert(editor_main: EditorMain):
    printerr('Command did not override function "execute_command_revert()"!')