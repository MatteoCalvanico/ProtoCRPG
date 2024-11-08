extends Node

## !!! Signals !!!
# Player enter/exit from ATTACK MODE - Use it to prevent clicks from passing through the GUI and block the scene
signal attack_mode_on
signal attack_mode_off

# Player do something in ATTACK MODE - Use it to remove/restore AP point
signal ap_remove(count: int)
signal ap_restore(count: int)
