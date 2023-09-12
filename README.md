# GRIDRUN Game iOS Version

GridRun is a strategy based game where two players play against each other. There are two types of players: Runners and Seekers. 

## Runner
Runner's goal is to escape the maze. Maps usually have a couple of exits and reaching one of them is enough to escape the grid. Runner has to be always vigilant as they are always tailed by Seeker, who are trying to find and capture the Runner. If Runner successfully exits the maze, they win.

## Seeker
Seeker's goal is to capture Runner. Chasing down Runner is not easy, but if Seeker manages to open up a tile that Runner has used, then Seeker gets information on Runner's move on that particular tile. Constructing the overall way of Runner allows Seeker to tail and capture Runner before they escape.

### Availability:
- iOS 15.0 and higher

##
<p align="row">
  <img src="https://github.com/windrunner21/gridrunner-iOS/assets/18750749/bf6f37db-e977-44b2-b424-d9bbc1f091e3" width="200" >
  <img src="https://github.com/windrunner21/gridrunner-iOS/assets/18750749/7fbdc00b-0b08-44fe-b1b1-3816d381e27b" width="200" >
</p> 

## Features

- [x] Multiplayer Game
- [x] Unranked and Competitive Plays
- [x] Custom Game Rooms
- [x] Account Management
- [x] Account Creation and Login.
- [ ] Customization (soon)
- [ ] Tutorial (soon)
- [ ] Playing against AI (soon)

## Implementation
Implemented using native iOS development. 

### Architecture
Architecture used for the project is a 4 layered architecture. Layers are: 

- Business Logic Layer 
- UI Layer
- Network Layer
- Storage Layer

SOLID principles were used.

### Multiplayer 
Gaming sessions were implemente using Ably Realtime Service. Subscribing and publishing to channels allows for uninterrupted conversation between two players. 
Standart NSNotifications were used to handle edge case updates from realtime service, for example: sudden resigns, game configuration changes - to name a few.

### Network
Network Layer was implemented using core URLSession and Tasks.

### Design
Completely programmable UI. UIKit was used as a UI framework. Custom UI classes were built for reusability and maintanability. Design itself was prototyped in Figma.

## Screenshots

### Custom Rooms: Create and Join
<p align="row">
  <img src="https://github.com/windrunner21/gridrunner-iOS/assets/18750749/803ef814-bf6c-4c3b-9eef-c68094c69686" width="200" >
  <img src="https://github.com/windrunner21/gridrunner-iOS/assets/18750749/a1c7338b-4b53-471a-ba86-db05cb126919" width="200" >
</p>

### Authorization: Register and Login
<p align="row">
  <img src="https://github.com/windrunner21/gridrunner-iOS/assets/18750749/52dd6f77-0e2d-45f6-a0a0-c379dfc5a153" width="200" >
  <img src="https://github.com/windrunner21/gridrunner-iOS/assets/18750749/3b8fe693-9bb3-49f4-b590-e47d9230f8ab" width="200" >
</p>

### Account Management
<p align="row">
  <img src="https://github.com/windrunner21/gridrunner-iOS/assets/18750749/04fb82b4-1322-45c7-bf18-de0656a5e772" width="200" >
</p>

# Copyright
iOS version created by Imran Hajiyev. All rights reserved 2023 GridRun.

- Official Website: https://gridrun.live
- Privacy Policy: https://gridrun.live/privacy-policy

## Contact
Reach me here or submit offical form at https://gridrun.live/contact-us

# Imran Hajiyev ©
