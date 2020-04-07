----------------------------------------------------------------------------------------------------
-- Code related to touch interactions (from Codea, not yet updated for Love2D)
----------------------------------------------------------------------------------------------------
-- toggle booleans if clicked in areas where button / sliders are
function love.mousepressed(x, y, button)

    -- print(x)
    -- print(y)

    --[[ fun times
    if shotInProgress == true then
        explode(x,y)
    end
    ]] --

    if (x > (WIDTH - 100) and y < 100) then
        if shotInProgress == false then playerPressedShootButton() end
    elseif (x > 50 and x < 410 and y > 0 and y < 50) then
        mouseXinitial = x
        draggingType = 'force'
        dragging = true
    elseif (x > 50 and x < 410 and y > 50 and y < 110) then
        mouseXinitial = x
        draggingType = 'angle'
        dragging = true
    end
end

-- short circuit the love.update function with boolean
function love.mousereleased(x, y, button) dragging = false end

-- if the mouse is being dragged after clicking, update the values of force or angle
-- uses distance from initial click for smoothly
function love.update(dt)
    if dragging then

        mouseXcurrent = love.mouse.getX()

        if mousXinitial ~= mouseXcurrent then

            diff = mouseXcurrent - mouseXinitial

            if draggingType == 'angle' then

                if turn == 1 then
                    player1.angle = getAngle(player1, diff)
                elseif turn == 2 then
                    player2.angle = getAngle(player2, diff)
                end

            elseif draggingType == 'force' then

                if turn == 1 then
                    player1.force = getForce(player1, diff)
                elseif turn == 2 then
                    player2.force = getForce(player2, diff)
                end

            end

            love.graphics.setCanvas(canvas)
            drawUI()
            love.graphics.setCanvas()

        end
    end
end

function getForce(playerN, diff)

    return math.max(math.min(playerN.force + math.pow(diff / 1000, 3), 5), 0)

end

function getAngle(playerN, diff)

    angle = playerN.angle + math.pow(diff / 200, 3)
    if angle > 360 then
        angle = angle - 360
    elseif angle < 0 then
        angle = angle + 360
    end

    return angle

end

