----------------------------------------------------------------------------------------------------
-- Code for imports, the initial load, and the `draw` loop
----------------------------------------------------------------------------------------------------
require "globals"
require "ui"
require "shoot"
require "logic"
require "touch"
require "keyboard"

-- Use this function to perform your initial setup
function love.load()

    -- math.randomseed(42)  -- goes out of bounds
    -- math.randomseed(232) -- shot comes close to opponent; set `shotType3()` numOfBullets to 15 to hit opponent
    math.randomseed(os.time()) -- randomize map every time

    loadExternalAssets() -- globals.lua
    setVariables() -- globals.lua

    love.window.setMode(WIDTH, HEIGHT)

    canvas = love.graphics.newCanvas(WIDTH, HEIGHT,  { msaa = 2 })

    canvas2 = love.graphics.newCanvas(WIDTH, HEIGHT,  { msaa = 2 })

    -- love.graphics.setCanvas(canvas)
    --     love.graphics.setBlendMode("alpha") -- what does this do ?!??
    -- love.graphics.setCanvas()

    newGame()

    bulType = 1
    -- playerPressedShootButton() -- disable this to let the player take the first shot

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
        rainbow.r = rainbow.r + 1
        rainbow.g = rainbow.g + 2
        rainbow.b = rainbow.b + 3

        -- this code oscilates the color all the time (mathematically heavy)
        love.graphics.setColor(math.floor(200 * math.abs(math.sin(rainbow.r * 0.005)) + 54) / 255,
                               math.floor(200 * math.abs(math.sin(rainbow.g * 0.004)) + 54) / 255,
                               math.floor(200 * math.abs(math.sin(rainbow.b * 0.003)) + 54) / 255, 1)
    elseif colorMode == 2 then
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- only draw things if shot is in progress
    if shotInProgress == true then
        for i = 1, numOfBullets do drawShot(i) end

        for i = 1, numOfBullets do collisonCheck(i) end

        benign = benign + 1 -- benign makes your own bullet not kill you for the first few moments when you shoot

        bulletsInFlight = false -- TODO: fix this hacky thing: if the x location of each shot == 0 then end the turn
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
    -- if benign < 0 then dimTrails() end

    -- drawUI() -- maybe do not draw continuously ?

    -- starts dimming the playing field more aggressively
    if endOfRound == true then
        -- dimTrails()
        -- love.graphics.setColor(0,0,0,1)
        -- love.graphics.rectangle('fill',-1,-1,WIDTH+5,HEIGHT+5)
    end

    -- RENDER THE CANVAS NOW
    love.graphics.draw(canvas)

    if shotInProgress == false then

        love.graphics.setCanvas(canvas2)
        love.graphics.clear()

        if turn == 1 then
            drawPlayerAngleAndForce(player1)
            if player1.lastAngle ~= nil then
                drawAngleDiff(player1, 0)
            end
            drawForceAndAngle(player1, 1)
        else
            drawPlayerAngleAndForce(player2)
            if player2.lastAngle ~= nil then
                drawAngleDiff(player2, 1)
            end
            drawForceAndAngle(player2, 2)
        end

        love.graphics.setCanvas()
        love.graphics.draw(canvas2)

    end

    drawShips()

    love.graphics.setColor(1, 1, 1, 1)

end


function drawPlayerAngleAndForce(playerN)

    -- large black circle
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.ellipse('fill', playerN.x, playerN.y, 100, 100)

    -- red arc showing force
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.arc('fill', 'pie', playerN.x, playerN.y, playerN.force * 20, 0.0174533 * playerN.angle - 0.1, 0.0174533 * playerN.angle + 0.1)

    -- smaller red circle showing force
    love.graphics.setColor(1, 0, 0, 0.4)
    love.graphics.ellipse('line', playerN.x, playerN.y, playerN.force * 20, playerN.force * 20)

    -- love.graphics.setColor(1, 0, 0, 1)
    -- love.graphics.line(playerN.x, playerN.y,
    --                     playerN.x + math.cos(0.0174533 * playerN.angle) * 100 * playerN.force / 5,
    --                     playerN.y + math.sin(0.0174533 * playerN.angle) * 100 * playerN.force / 5)

    -- large white circle showing maximum
    love.graphics.setColor(1, 1, 1, 0.6)
    love.graphics.ellipse('line', playerN.x, playerN.y, 100, 100)

    -- long line showing angle
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.ellipse('line', playerN.x, playerN.y, 10, 10)
    love.graphics.line(playerN.x, playerN.y,
                        playerN.x + math.cos(0.0174533 * playerN.angle) * 100,
                        playerN.y + math.sin(0.0174533 * playerN.angle) * 100)

end


function drawAngleDiff(playerN, playerOffsetHack)

    angleDiff = playerN.lastAngle - playerN.angle

    forceDiff = playerN.force - playerN.lastForce

    if angleDiff > 180 then
        angleDiff = angleDiff - 360
    end

    if angleDiff < -180 then
        angleDiff = angleDiff + 360
    end

    if angleDiff < 10 and angleDiff > -10 then

        xOffset = playerN.x - 76 + playerOffsetHack * 90

        fontOpacity = math.pow((10 - math.abs(angleDiff))/10, 0.5)
        love.graphics.setFont(pixelFont)

        if (angleDiff ~= 0) then
            -- rectangle
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.rectangle('fill', xOffset + 5, playerN.y - 6, 56, 12, 4, 4)
            -- text
            love.graphics.setColor(1, 1, 1, fontOpacity)
            love.graphics.printf(string.format("%.5f", angleDiff), xOffset, playerN.y - 7, 60, 'right')
        end

        love.graphics.setColor(1, 0, 0, fontOpacity)

        if (forceDiff ~= 0) then
            -- rectangle
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.rectangle('fill', xOffset + 5, playerN.y + 6, 56, 12, 4, 4)
            -- text
            love.graphics.setColor(1, 0, 0, fontOpacity)
            love.graphics.printf(string.format("%.5f", forceDiff), xOffset, playerN.y + 5, 60, 'right')
        end

        love.graphics.setColor(1, 1, 1, 1)
    end

end
