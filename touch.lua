----------------------------------------------------------------------------------------------------
-- Code related to touch interactions (from Codea, not yet updated for Love2D)
----------------------------------------------------------------------------------------------------

--[[

    if CurrentTouch.state == BEGAN then


        -- this if/then ONLY allows you to shoot when there is no shot in progress!!!
        if shotInProgress == 0 then
            -- shoots, but does it too often and thus dimms trails
            if CurrentTouch.x > WIDTH-60 and CurrentTouch.x < WIDTH-60+40 and CurrentTouch.y > 20 and CurrentTouch.y < 60 then
                shootBulletAgain()
                print("shoot button pressed")
            end
        end


        -- let this button explode the current shot if a shot is in progress !!!
        -- needs to be contained so it can be pressed only once !!!
        if shotInProgress == 1 then
            if CurrentTouch.x > WIDTH-60 and CurrentTouch.x < WIDTH-60+40 and CurrentTouch.y > 20 and CurrentTouch.y < 60 then
                for i=1, numOfBullets do
                    -- dangerous to explode - get TOO MANY SHOTS!!! $$$$$$$$$$$$$$$ DANGER
                    --explode(x1a[i],y1a[i])
                    --split(x1a[i],y1a[i])
                end
            end
        end


        -- for FORCE *** can be simplified
        if CurrentTouch.y < 50 and CurrentTouch.x > 110 and CurrentTouch.x < 410  then

            firstTouch = CurrentTouch.x

        -- for ANGLE
        elseif CurrentTouch.y > 50 and CurrentTouch.y < 90  and CurrentTouch.x > 110 and CurrentTouch.x < 410  then

            firstTouch = CurrentTouch.x

        end


    elseif CurrentTouch.state == MOVING then

        -- for FORCE
        if CurrentTouch.y > 50 and CurrentTouch.y < 90  and CurrentTouch.x > 110 and CurrentTouch.x < 410 then

            -- fill(16, 178, 197, 255)
            love.graphics.rectangle('fill',20,60,80,20)
            -- fill(255)

            if turn == 1 then
                -- mess with this for smoother control over ANGLE
                p1a = p1a + math.pow((CurrentTouch.x-firstTouch)/200,3)

                -- 10,000ths place
                p1a = math.floor(p1a*10000)/10000
                text(p1a, 25,61)
            elseif turn == 2 then
                -- mess with this for smoother control over ANGLE
                p2a = p2a + math.pow((CurrentTouch.x-firstTouch)/200,3)

                -- 10,000ths place
                p2a = math.floor(p2a*10000)/10000
                text(p2a, 25,61)
            end

        -- for ANGLE
        elseif CurrentTouch.y < 50  and CurrentTouch.x > 110 and CurrentTouch.x < 410  then

            -- fill(16, 178, 197, 255)
            love.graphics.rectangle('fill',20,20,80,20)
            -- fill(255)

            if turn == 1 then
                -- mess with this for smoother control over FORCE
                p1f = p1f + math.pow((CurrentTouch.x-firstTouch)/1000,3)

                -- 10,000ths place
                p1f = math.floor(p1f*10000)/10000
                text(p1f, 25,21)
            elseif turn == 2 then
                -- mess with this for smoother control over FORCE
                p2f = p2f + math.pow((CurrentTouch.x-firstTouch)/1000,3)

                -- 10,000ths place
                p2f = math.floor(p2f*10000)/10000
                text(p2f, 25,21)
            end

        end


    elseif CurrentTouch.state == ENDED then
        --print("test")
    end

--]]
