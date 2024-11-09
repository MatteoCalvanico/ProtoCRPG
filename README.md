<p align="center">
 <h1 align="center">ProtoCRPG</h2>
 <p align="center">Godot template for building your own CRPG</p>
</p>
<p align="center">
    <a href="https://github.com/MatteoCalvanico/ProtoCRPG?tab=readme-ov-file">
      <img alt="Status" src="https://img.shields.io/badge/Status-WORK_IN_PROGRESS-FFA500 />
    </a>
    <a href="https://godotengine.org/download/archive/4.3-stable/">
      <img alt="Engine Used" src="https://img.shields.io/badge/Made%20with-Godot%204.3-478cbf?logo=godot-engine />
    </a>
    <a href="https://github.com/MatteoCalvanico/ProtoCRPG/blob/prototype/LICENSE">
      <img alt="License" src="https://img.shields.io/badge/License-MIT-blue />
    </a>
    <br />
    <br />
</p>

<!-->
[![Status - WORK IN PROGRESS](https://img.shields.io/badge/Status-WORK_IN_PROGRESS-FFA500)](https://)
![Made with Godot 4.3](https://img.shields.io/badge/Made%20with-Godot%204.3-478cbf?logo=godot-engine)
[![License](https://img.shields.io/badge/License-MIT-blue)](#license "Go to license section")
<-->

## Context
ProtoCRPG is a template for building your own CRPG.
Use the latest Godot Engine components, to create a great starting point for an old-school isometric RPG.

## Features
ProtoCRPG has the following features:
- A fully implemented and working 2D isometric view with multiple layers (**TileMapLayers**) and collisions:
<p align = "center">
    <img src="./src/preview.png"/>
</p> 

- Player movement with mouse click using **NavigationAgent2D**:
<p align = "center">
    <img src="./src/movementPreview.gif"/>
</p> 

- Turn-based combat and movement with *action points* [To finish]:
<p align = "center">
    <img src="todo"/>
</p> 

- Simple interactions with NPCs:
<p align = "center">
    <img src="./src/npcPreview.gif"/>
</p> 

- Log to read/write the results of individual actions:
<p align = "center">
    <img src="./src/logPreview.gif"/>
</p> 

- Attack of enemies, with different distances [To finish]:
<p align = "center">
    <img src="./src/enemyMovement.gif"/>
</p> 

- Division of directories and use of Godot conventions 
<p align = "center">
    <img src="./src/dirTree.png"/>
</p> 

## Controls

| Actions                | Keyboard and Mouse |
| ---------------------- | ------------------ |
| Moving                 | Left mouse click   |
| Moving [DEBUG]         | "WASD"             |
| Interaction            | Right mouse click  |
| Attack (on attack mode)| Left mouse click   |
| Zoom                   | Mouse scroll       |