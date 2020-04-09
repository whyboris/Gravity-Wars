----------------------------------------------------------------------------------------------------
-- Code setting up all the global variables to be used
----------------------------------------------------------------------------------------------------
function loadExternalAssets()

    ss1 = love.graphics.newImage("assets/ss1.png")
    ss2 = love.graphics.newImage("assets/ss2.png")
    pixelFont = love.graphics.newFont("assets/basis33.ttf", 16)

end

function setVariables()

    uiFont = love.graphics.getFont() -- default font

    dragCursor = love.mouse.getSystemCursor("sizewe")

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
        angle = 0,
        force = 1.5,
        lives = 3,
        health = 100,
        lastAngle = nil,
        lastForce = nil,
    }

    player2 = {
        x = 500,
        y = 500,
        angle = 180,
        force = 1.5,
        lives = 3,
        health = 100,
        lastAngle = nil,
        lastForce = nil,
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
    rainbow = {
        r = 1,
        g = 1,
        b = 1
    }

end
