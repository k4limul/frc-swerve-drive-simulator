# FRC Swerve Drive Simulator
## Game Instructions

**Player 1 (Blue):**

* Move: `W`, `A`, `S`, `D`
* Rotate: `E` (clockwise), `Q` (counter-clockwise)
* Shoot: `F`
* Climb: `C`

**Player 2 (Red):**

* Move: `I`, `J`, `K`, `L`
* Rotate: `O` (clockwise), `U` (counter-clockwise)
* Shoot: `H`
* Climb: `N`

> Robots need to face zones to score, align their center with the stage to climb, and movement will be locked after climbing. Each team's source is on the opponent's side of the field and is only accessible by their own alliance.

---

## Description:
Our project is a physics-based swerve drive simulator built in Processing that will model how different drivetrain configurations—such as gear ratios, wheel types, and robot mass—affect movement on an FRC (FIRST Robotics Competition) field. Players can control customizable robots to complete objectives in designated field zones, with performance influencing score outcomes. The goal is to showcase the mechanics and strategy behind swerve drive systems in a fun, interactive two-player game format.

We will recreate the 2024 FRC game, CRESCENDO, and simulate our drivetrain on the game field. The field will consist of different zones where players can drive the robot to perform different tasks in order to score points in the game, including picking up gamepieces from their team’s source zone and scoring it in their team’s amp and subwoofer zones. Our goal is to add functionality for at least the scoring and intaking aspects of the game by the end of the term, and expand on the game in the future.

Moreover, the game will be playable multiplayer (two-player) using a keyboard. To demonstrate both the physics and game mechanics aspects of this project, players will be able to choose and simulate the effects of different wheel treads and masses on their drivetrain. In this way, we can better understand the effects of these attributes on the robot’s efficiency and performance on the field. Because some robot archetypes are mechanically worse than others, we added a point modifying system to balance the game.

Ultimately, we hope to provide a better understanding of robot design relative to game strategy by simulating the physics of a swerve drive and its gameplay in the 2024 FRC game CRESCENDO.

---

## Game Features

* Two-player gameplay using a shared keyboard
* Realistic swerve drive physics and kinematics
* Game field modeled after the 2024 FRC game **CRESCENDO**
* Zones for scoring, intaking, and climbing
* Customizable drivetrain properties like wheel tread and mass
* Field-relative movement with accurate velocity modeling
* Balanced scoring system based on drivetrain choices
* Visual feedback for robot actions and scoring zones

---

## Contributors:
- Kalimul: Implemented Module and SwerveDrive kinematics. Integrated the swerve simulation with the field and game mechanics.
- Naveed: Implemented Zone and Field. Programmed the core functions for playing the game.
- Alvin: Implemented ControlScheme, Timer, and ScoreBoard. Added Climb, Collision, play-tested, and found bugs. 
