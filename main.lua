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
    math.randomseed(232) -- shot comes close to opponent // with `initialShot()` it hits the opponent

    setVariables() -- globals.lua

    canvas = love.graphics.newCanvas(WIDTH, HEIGHT)

    love.graphics.setCanvas(canvas)
        love.graphics.clear()
        love.graphics.setBlendMode("alpha")
        love.graphics.setColor(1, 0, 0, 0.5)
        love.graphics.rectangle('fill', 0, 0, 100, 100)
    love.graphics.setCanvas()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line',20,20,20,20)

    love.window.setMode(WIDTH,HEIGHT)

    createPlanets()
    drawPlanets()

    -- resets the location of ship1
    shipX = s1x
    shipY = s1y

    s1x = shipX
    s1y = shipY

    drawUI()
    drawShips()

    -- without first shot the prorgram gives an error
    -- choose a shot:
    shotType3()
    -- initialShot()

end


-- This function gets called once every frame

function love.draw()

    -- love.graphics.setBackgroundColor(0,0,50/255)


    if endOfRound == 1 and shotInProgress == 0 then
        endOfRound = 0
        newGame()
    end


    if colorMode == 1 then
        -- this has potential to run over (how many minutes till it crashes?)
        -- might want it to reset to 0 sometimes
        lineColor1 = lineColor1+1
        lineColor2 = lineColor2+2
        lineColor3 = lineColor3+3

        -- this code oscilates the color all the time (mathematically heavy)
        love.graphics.setColor(
            math.floor(200*math.abs(math.sin(lineColor1*0.005))+54)/255,
            math.floor(200*math.abs(math.sin(lineColor2*0.004))+54)/255,
            math.floor(200*math.abs(math.sin(lineColor3*0.003))+54)/255,
            1
        )
    elseif colorMode == 2 then
        love.graphics.setColor(1, 1, 1, 1)
    end


    -- only draw things if shot is in progress
    if shotInProgress == 1 then
        for i=1, numOfBullets do
            drawShot(i)
        end

        for i=1, numOfBullets do
            collisonCheck(i)
        end
    end


    if shotInProgress == 1 then

        -- if the x location of each shot == 0 then end the turn
        progressCheck = 0

        for i=1, numOfBullets do
            progressCheck = x1a[i] + progressCheck
        end

        if progressCheck == 0 then
            print("all shots have finished")
            shotInProgress = 0
            if turn == 1 then
                turn = 2
            elseif turn == 2 then
                turn = 1
            end
        end

    end


    drawPlanets()

    drawShips()

    -- this code here WILL dim the trails continuously when explosion occurs
    -- works too fast so I can slow it down by dimming every 5th frame (temp int)
    if benign < 0 then
        dimTrails()
    end

    drawUI()

    -- starts dimming the playing field more aggressively
    if endOfRound == 1 then
        dimTrails()
        -- love.graphics.setColor(0,0,0,1)
        -- love.graphics.rectangle('fill',-1,-1,WIDTH+5,HEIGHT+5)
    end

    -- RENDER THE CANVAS NOW
    love.graphics.draw(canvas)

end

