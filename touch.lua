----------------------------------------------------------------------------------------------------
-- Code related to touch interactions (from Codea, not yet updated for Love2D)
----------------------------------------------------------------------------------------------------

function love.mousepressed(x, y, button)

    -- print(x)
    -- print(y)

    --[[ fun times
    if shotInProgress == 1 then
        explode(x,y)
    end
    ]]--

    if (x > (WIDTH - 100) and y < 100) then
        if shotInProgress ~= 1 then
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


function love.mousereleased(x, y, button)
    dragging = false
end


function love.update(dt)
    if dragging then
        mouseXcurrent = love.mouse.getX()

        if (mousXinitial ~= mouseXcurrent) then

            if (draggingType == 'angle') then

                love.graphics.rectangle('fill',20/255,60/255,80/255,1)

                if turn == 1 then
                    -- mess with this for smoother control over ANGLE
                    p1a = p1a + math.pow((mouseXcurrent - mouseXinitial)/200,3)

                    -- 10,000ths place
                    p1a = math.floor(p1a*10000)/10000
                    love.graphics.print(p1a, 25,61)
                elseif turn == 2 then
                    -- mess with this for smoother control over ANGLE
                    p2a = p2a + math.pow((mouseXcurrent-mouseXinitial)/200,3)

                    -- 10,000ths place
                    p2a = math.floor(p2a*10000)/10000
                    love.graphics.print(p2a, 25,61)
                end

            elseif draggingType == 'force' then

                love.graphics.rectangle('fill',20/255,20/255,80/255,1)

                if turn == 1 then
                    -- mess with this for smoother control over FORCE
                    p1f = p1f + math.pow((mouseXcurrent - mouseXinitial)/1000,3)

                    -- 10,000ths place
                    p1f = math.floor(p1f*10000)/10000
                    love.graphics.print(p1f, 25,21)
                elseif turn == 2 then
                    -- mess with this for smoother control over FORCE
                    p2f = p2f + math.pow((mouseXcurrent - mouseXinitial)/1000,3)

                    -- 10,000ths place
                    p2f = math.floor(p2f*10000)/10000
                    love.graphics.print(p2f, 25,21)
                end

            end

        end
    end
end
