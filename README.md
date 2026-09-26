<img width="1895" height="1068" alt="Screenshot 2026-09-14 185244" src="https://github.com/user-attachments/assets/015a217b-711c-441a-9d0e-700dc9f05f2b" />

# Dayne the Dino Hunter

### The Game
Dayne the Dino Hunter is a Roguelike Card-Battler inspired by Slay the Spire. The game features turn-based one-on-one combat against a variety of powerful dinosaur enemies.
To contest these formidable foes, a huge arsenal of unique cards is available to the player, allowing for numerous exciting combos and synergies.
This project was made for my portfolio with the goal to learn, study, and recreate the mechanics of Slay the Spire while also showcasing my proficiency in gameplay systems programming and the Godot Engine.

### Project Features
- 50 unique player cards and 40 enemy exclusive cards, each inheriting from the same abstract class. This makes for a very scalable system where new cards can be added very easily without altering any existing code
- State-driven turn based combat system
- Procedurally generated map layout featuring combat, rest, and treasure rooms, and a challenging boss battle at the very end
- All cards are usable by both the player and the enemies, in accordance with the Liskov Substitution Principle.
- The Service Locator pattern is used to allow all manager scripts (AudioManager, TurnManager, CardManager, etc) to be accessible from any part of the game without any coupling involved
- An Audio Player Pooling System that reuses existing audio stream players if they are available and creates new ones dynamically when needed
- A satisfying card interaction and animation system developed with tweens, interpolation, and curves/graphs
- Resource driven design where all card and character data is stored as reusable resources which can be assigned to or accessed by any part of the game as needed
- Bouncy and bubbly UI animations made using tweens
- Complex and scalable resource-based status effect system where all status effects inherit from the same abstract class, making it exceptionally simple to create new status effects or iterate on existing ones
- Use of lightweight wrapper resources to track the duration of status effects without altering the data in the status effect resource
- Extensive tooltip system which makes sure all gameplay information is easily available to the player
- All numbers for damage, healing, and blocking in tooltips and descriptions are updated in real time based the status effects applied to the player and/or enemy
- A DeckManager Singleton that stores and updates the player's current deck and card reward pools, allowing this data to be globally accessible and persist between scenes
- A MusicManager Singleton that features methods for smooth and easy transitions between different music tracks while also letting active music tracks persist between scenes
- A SceneLoader Singleton that uses multithreading to load scenes in the background and displays a loading screen during the process

### Engine
- This project was made using the Godot Engine
- All code for this project is written in GDScript

### How to Run Project
- If you're interested in playing the full game, it can be played in browser on itch.io: https://zubi-dev.itch.io/dayne-the-dino-hunter
- If you're interested in running the project on the Godot Engine, simply download the project files from this repository and import them into the engine
- The code base for this project is fully commented and uses easy-to-understand variable, method, and class names

### Credits
- All the code for this project was done by me
- Dinosaur sprites: https://michael-jay-rov.itch.io/prehistoric-dinosaurs
- Player sprite: https://ozzbit-games.itch.io/fantasy-character
- Music and UI audio: https://ppeak.itch.io/primeval
- Sound effects: https://leohpaz.itch.io/minifantasy-dungeon-sfx-pack
- Menu music: https://pixabay.com/music/main-title-jungle-documentary-133236/
- Icon art: https://clockworkraven.itch.io/raven-fantasy-icons

### Contact
- Discord: @zubi_dev
- Work email: zubairhittam@gmail.com
