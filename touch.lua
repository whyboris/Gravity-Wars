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
    ]]--

    if (x > (WIDTH - 100) and y < 100) then
        if shotInProgress == false then
            shootBulletAgain()
        end
    elseif (x > 50 and x < 410 and y > 0  and y < 50) then
        mouseXinitial = x
        draggingType = 'force'
        dragging = true
    elseif (x > 50 and x < 410 and y > 50  and y < 110)  then
        mouseXinitial = x
        draggingType = 'angle'
        dragging = true
    end
end

-- short circuit the love.update function with boolean
function love.mousereleased(x, y, button)
    dragging = false
end

-- if the mouse is being dragged after clicking, update the values of force or angle
-- uses distance from initial click for smoothly
function love.update(dt)
    if dragging then

        mouseXcurrent = love.mouse.getX()

        if mousXinitial ~= mouseXcurrent then

            diff = mouseXcurrent - mouseXinitial

            if draggingType == 'angle' then

                if turn == 1 then
                    p1a = p1a + math.pow(diff/200,3)
                elseif turn == 2 then
                    p2a = p2a + math.pow(diff/200,3)
                end

            elseif draggingType == 'force' then

                if turn == 1 then
                    p1f = p1f + math.pow(diff/1000,3)
                elseif turn == 2 then
                    p2f = p2f + math.pow(diff/1000,3)
                end

            end

        end
    end
end

