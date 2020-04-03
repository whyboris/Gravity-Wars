# TODO

Need to implement:

- UI for choosing angle & force for shot as well as the "shoot" button
- Every draw method should start with its own `setColor`
- Create a helper method for `setColor`
- Render all shot trails to one canvas, render ships, planets, and UI to another canvas. Update independently as needed
- better code to prevent planet-planet & planet-ship overlap
- randomize map again if total net force on ship is too high (pick some sensible cutoff)

### Shot types

It may be fun to have a variety of shot types that can be used. Here are some ideas.

- single shot
- tripple (narrow)
- tripple (wide)
- four corners (shoot 4 bullets at 90 degrees to each other)
- octoshot (shoot 8 bullets at 45 degrees to each other)
- planet exploder (makes a planet disappear)

Multi shots

_press the 'fire' button again to trigger the further effect_

- teleport (_fire_: teleport to where the bullet is)
- split 3 x1 (_fire_: split into 3)
- split 2 x2 (_fire_: split into 2, then 4)
- split 3 x2 (_fire_: split into 3; then 9)
- split 2 x3 (_fire_: split into 2, then 4, then 8)

Not shots but would be used instead of firing a shot

- teleport to a random location
- spacequake (moves all planets randomly a bit)
