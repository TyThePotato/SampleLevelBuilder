extends BaseCommand

class_name CommandPing

func execute_command(_editor_main: EditorMain):
    print("Ping!")
    
func execute_command_revert(_editor_main: EditorMain):
    print("Pong!")