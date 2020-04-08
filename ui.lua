----------------------------------------------------------------------------------------------------
-- Code related to drawing the UI (user interface)
----------------------------------------------------------------------------------------------------
function drawUI()

    love.graphics.setColor(1, 1, 1, 1)

    -- bounding box
    love.graphics.line(10, 720, WIDTH - 10, 720)
    love.graphics.line(WIDTH - 10, 10, WIDTH - 10, 720)
    love.graphics.line(10, 10, 10, 720)
    love.graphics.line(10, 10, WIDTH - 10, 10)

    -- region for touch stuff
    love.graphics.line(10, 50, 410, 50)
    love.graphics.line(10, 90, 410, 90)

    love.graphics.line(110, 10, 110, 90)
    love.graphics.line(410, 10, 410, 90)

    -- shoot BUTTON rectangle -- change states while shot in progress
    if shotInProgress == true then
        love.graphics.setColor(0.5, 0, 0, 1)
        love.graphics.ellipse('fill', WIDTH - 50, 50, 30, 30)
    else
        love.graphics.setColor(16 / 255, 178 / 255, 197 / 255, 1)
        love.graphics.ellipse('fill', WIDTH - 50, 50, 30, 30)
    end

    -- draw how many lives each has
    love.graphics.setColor(1, 1, 0, 1)
    for i = 1, player1.lives do
        love.graphics
            .ellipse('fill', WIDTH / 2 + 35 + 20 * i, HEIGHT - 32, 8, 8)
    end

    for i = 1, player2.lives do
        love.graphics
            .ellipse('fill', WIDTH / 2 - 35 - 20 * i, HEIGHT - 32, 8, 8)
    end

    -- right health bar
    love.graphics.setColor((255 - player1.health * 2.55) / 255, 1, 0, 1)
    love.graphics.rectangle('fill', WIDTH / 2 + 50, HEIGHT - 20, 300, 10)

    if player1.health < 100 then
        love.graphics.setColor(223 / 255, (45 + player1.health) / 255,
                               (45 + player1.health) / 255, 1)
        love.graphics.rectangle('fill', (WIDTH / 2 + 50) + 300 - 300 *
                                    ((100 - player1.health) / 100), HEIGHT - 20,
                                300 - 300 * ((player1.health) / 100), 10)
    end

    -- left health bar
    love.graphics.setColor((255 - player2.health * 2.55) / 255, 1, 0, 1)
    love.graphics.rectangle('fill', WIDTH / 2 - 350, HEIGHT - 20, 300, 10)

    if player2.health < 100 then
        love.graphics.setColor(224 / 255, (45 + player2.health) / 255,
                               (45 + player2.health) / 255, 1)
        love.graphics.rectangle('fill', (WIDTH / 2 - 350), HEIGHT - 20,
                                300 - 300 * ((player2.health) / 100), 10)
    end

    love.graphics.setColor(1, 1, 1, 1)

end

function drawForceAndAngle()

    angleX = player1.x - 140
    forceX = player1.x - 140

    angleY = player1.y + 78
    forceY = player1.y + 90

    -- region for angle & force
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle('fill', angleX + 12, angleY + 2, 70, 13, 4, 4)
    love.graphics.rectangle('fill', forceX + 24, forceY + 3, 66, 12, 4, 4)
    love.graphics.setColor(1, 1, 1, 1)

    -- draw the current player's force and angle
    if turn == 1 then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.setFont(pixelFont, 20)
        love.graphics.print('GJ', forceX + 76, forceY + 2) -- GigaJoules

        -- love.graphics.setFont(uiFont)
        love.graphics.printf(string.format("%.5f", player1.force), forceX, forceY + 2, 75,
                             'right')

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(string.format("%.5f", 360 - player1.angle), forceX, angleY + 2, 75,
                            'right')
        love.graphics.ellipse('line', angleX + 78, angleY + 5, 2, 2)


    elseif turn == 2 then
        love.graphics.setFont(uiFont)
        love.graphics.printf(string.format("%.5f", player2.force), 20, 22, 75,
                             'right')
        love.graphics.printf(string.format("%.5f", 360 - player2.angle), 20, 62, 75,
                             'right')
    end


end


function drawShips()

    -- love.graphics.setColor(1, 0.6, 0.6, 1)
    -- love.graphics.ellipse('fill', player1.x, player1.y, 8, 8)
    -- love.graphics.ellipse('fill', player2.x, player2.y, 8, 8)

    love.graphics.draw(ss1, player1.x - 4, player1.y - 4)
    love.graphics.draw(ss2, player2.x - 4, player2.y - 4)

    -- love.graphics.draw(ss1, player1.x, player1.y, player1.angle, 1, 1, 4, 4)

end

--[[
    Dim all the shot trails on the screen
    meant to run after every shot
    works by drawing a black rectangle with low opacity over the whole screen
    then redraws all other elements on top
--]]
function dimTrails()

    print("dimTrails EXECUTED")

    love.graphics.setCanvas(canvas)
    love.graphics.setColor(0, 0, 0, 0.15) -- don't fortget to reset ?
    love.graphics.rectangle('fill', 0, 0, WIDTH, HEIGHT)
    love.graphics.setColor(1, 1, 1, 1) -- reset back !?
    drawPlanets() -- execute inside `canvas` ?!
    drawShips()
    drawUI()
    love.graphics.setCanvas() -- reset canvas ?!

end

function drawPlanets()

    for i = 1, numOfPlanets do
        love.graphics.setColor(0.1, 0.1, 0.1, 1)
        love.graphics.ellipse('fill', allPlanets[i].x, allPlanets[i].y,
                              allPlanets[i].r, allPlanets[i].r)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.ellipse('line', allPlanets[i].x, allPlanets[i].y,
                              allPlanets[i].r, allPlanets[i].r)
    end

end
