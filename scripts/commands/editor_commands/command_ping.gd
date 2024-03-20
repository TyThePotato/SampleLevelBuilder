class_name CommandPing
extends BaseCommand

func _init():
    human_readable_name = 'Ping'

func execute_command():
    print("Ping!")
    
func execute_command_revert():
    print("Pong!")