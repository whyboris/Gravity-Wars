----------------------------------------------------------------------------------------------------
-- Code for imports, the initial load, and the `draw` loop
----------------------------------------------------------------------------------------------------
require "globals"
require "ui"
require "shoot"
require "logic"
require "touch"

-- Use this function to perform your initial setup
function love.load()

    -- math.randomseed(42)  -- goes out of bounds
    math.randomseed(232) -- shot comes close to opponent; set `shotType3()` numOfBullets to 15 to hit opponent

    setVariables() -- globals.lua

    love.window.setMode(WIDTH, HEIGHT)

    canvas = love.graphics.newCanvas(WIDTH, HEIGHT)

    -- love.graphics.setCanvas(canvas)
    --     love.graphics.setBlendMode("alpha") -- what does this do ?!??
    -- love.graphics.setCanvas()

    newGame()

    bulType = 3
    playerPressedShootButton() -- disable this to let the player take the first shot

end

-- This function gets called once every frame

function love.draw()

    -- love.graphics.setBackgroundColor(0,0,50/255)

    if endOfRound == true and shotInProgress == false then
        endOfRound = false
        newGame()
    end

    if colorMode == 1 then
        -- this has potential to run over (how many minutes till it crashes?)
        -- might want it to reset to 0 sometimes
        lineColor1 = lineColor1 + 1
        lineColor2 = lineColor2 + 2
        lineColor3 = lineColor3 + 3

        -- this code oscilates the color all the time (mathematically heavy)
        love.graphics.setColor(math.floor(200 * math.abs(math.sin(lineColor1 * 0.005)) + 54) / 255,
                               math.floor(200 * math.abs(math.sin(lineColor2 * 0.004)) + 54) / 255,
                               math.floor(200 * math.abs(math.sin(lineColor3 * 0.003)) + 54) / 255, 1)
    elseif colorMode == 2 then
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- only draw things if shot is in progress
    if shotInProgress == true then
        for i = 1, numOfBullets do drawShot(i) end

        for i = 1, numOfBullets do collisonCheck(i) end

        -- benign makes your own bullet not kill you for the first few moments when you shoot
        benign = benign + 1
    end

    if shotInProgress == true then

        -- if the x location of each shot == 0 then end the turn
        bulletsInFlight = false

        for i = 1, numOfBullets do
            if allBullets[i].x ~= 0 and allBullets[i].y ~= 0 then
                bulletsInFlight = true -- HACK -- assumes position of disabled bullet is = (0, 0)
            end
        end

        if bulletsInFlight == false then
            print("all shots have finished")

            shotInProgress = false
            if turn == 1 then
                turn = 2
            elseif turn == 2 then
                turn = 1
            end

            love.graphics.setCanvas(canvas)
            drawUI()
            love.graphics.setCanvas()
        end

    end

    -- this code here WILL dim the trails continuously when explosion occurs
    -- works too fast so I can slow it down by dimming every 5th frame (temp int)
    if benign < 0 then dimTrails() end

    -- drawUI() -- maybe do not draw continuously ?

    -- starts dimming the playing field more aggressively
    if endOfRound == true then
        dimTrails()
        -- love.graphics.setColor(0,0,0,1)
        -- love.graphics.rectangle('fill',-1,-1,WIDTH+5,HEIGHT+5)
    end

    -- RENDER THE CANVAS NOW
    love.graphics.draw(canvas)

end
