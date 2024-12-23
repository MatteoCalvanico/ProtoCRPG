extends Node
## MessageBus that contains all the custom signals that can be used 

## !!! Signals !!!
# Player enter/exit from ATTACK MODE - Use it to prevent clicks from passing through the GUI and block the scene
signal attack_mode_on  ## Activate Attack Mode
signal attack_mode_off ## Deactivate Attack Mode

# Player do something in ATTACK MODE - Use it to remove/restore AP point
signal ap_remove(count: int)  ## Remove [param count] from player's APs
signal ap_restore(count: int) ## Add [param count] to player's APs

## Player health change [br]
## Takes [param value] as new health
signal health_change(value: float)

## Logs for InfoDisplay
signal log(text: String)
