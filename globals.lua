----------------------------------------------------------------------------------------------------
-- Code setting up all the global variables to be used
----------------------------------------------------------------------------------------------------
function setVariables()

    WIDTH = 1000
    HEIGHT = 800

    -- Mouse click interactions
    dragging = false
    draggingType = nil -- `force` or `angle`
    mouseXinitial = 0
    mouseXcurrent = 0

    -- FUN kaleidoscope time!
    -- colorMode = 1

    -- bullet type (should be changeable by player)
    bulType = 1

    -- set number of bullets
    numOfBullets = 10

    -- set number of Planets
    numOfPlanets = 7

    allPlanets = {} -- each planet will have `mass`, `r`, `x`, `y`

    allBullets = {} -- list of bullets, each will have `x`, `y`, and `vx`, `vy` (velocity x & y components)

    player1 = {
        x = 100,
        y = 100,
        angle = 45,
        force = 1.5,
        lives = 3,
        health = 100
    }

    player2 = {
        x = 500,
        y = 500,
        angle = 225,
        force = 1.5,
        lives = 3,
        health = 100
    }

    -- whose turn
    turn = 1

    -- used to end the turn sometime
    shotInProgress = false

    -- integer to provide time-out so your bullet doesn't kill you in the first 50 iterations
    -- benign while it's less than 50 iterations of bullet flight, for example (see collision check)
    benign = 0

    -- if end of round = 1 it restarts the game after all the bullets end their path
    endOfRound = false

    -- kaleidoscope mode colors for shot trails
    lineColor1 = 1
    lineColor2 = 1
    lineColor3 = 1

end
