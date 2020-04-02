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

    -- proximity counter
    proximity = 100
    proximity2 = 100

    -- setup mass, radius, planet coordinates, force from each planet to bullet
    m = {}
    r = {}
    px = {}
    py = {}

    -- set ship1 & ship2 locations
    ship1x = 100
    ship1y = 100
    ship2x = 500
    ship2y = 500

    -- player 1 and player 2 angle and force and lives
    player1angle = 45
    player1force = 1.5
    player2angle = 225
    player2force = 1.5
    player1lives = 3
    player2lives = 3

    -- whose turn
    turn = 1

    -- used to end the turn sometime
    shotInProgress = true

    -- temporary variable - add up all the x locations of shots; if == 0, end turn
    progressCheck = 1

    -- integer to provide time-out so your bullet doesn't kill you in the first 10 iterations
    -- benign while it's less than 10, for example (see collision check)
    benign = 0

    -- array to store forces from each planet to each shot (temp use always)
    fpx = {}
    fpy = {}

    -- array used to store location of each shot - x location, y location.
    x1a = {}
    y1a = {}

    -- floats for computing lines to draw (initial and final velocities)
    vix = {} -- initial velocities of shots
    viy = {}
    vfx = 0 -- only used temporarily during shot
    vfy = 0

    -- throwaway variable
    temp = 0

    -- if end of round = 1 it restarts the game after all the bullets end their path
    endOfRound = false

    -- kaleidoscope mode colors for shot trails
    lineColor1 = 1
    lineColor2 = 1
    lineColor3 = 1

end
