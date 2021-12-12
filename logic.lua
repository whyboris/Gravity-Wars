----------------------------------------------------------------------------------------------------
-- Code related to creating new game, planets, collision check, and draw shot
----------------------------------------------------------------------------------------------------
function newGame()

    setInitialPositions()

    player1.angle = 0
    player2.angle = 180

    player1.lastAngle = nil
    player2.lastAngle = nil

    player1.health = 100
    player2.health = 100

    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    drawPlanets()
    drawShips()
    drawUI()
    love.graphics.setCanvas()

    print("New Game Started")

end

-- returns `player1` or `player2` table (object) depending on whose turn it is
function currentPlayer()

    if turn == 1 then
        return player1
    else
        return player2
    end
end

-- Randomize placement of planets & ships
-- check for overlap, retry if check fails
function setInitialPositions()

    print('randomizing planets attempt')

    allPlanets = {} -- reset whatever we had before first

    -- include parameters for max and min planet locations

    -- TODO: experiment with mass
    -- having the mass depend on radius is less fun - small planets stop mattering
    -- mass = (math.pow(allPlanets[i].r,3)/25) -- MASS depends on radius^3 *** this affects speed of drawing

    for i = 1, numOfPlanets do
        allPlanets[i] = {
            x = math.random(100, WIDTH - 100),
            y = math.random(150, HEIGHT - 250),
            r = math.random(15, 50),
            mass = math.random(10, 50) * 10
        }
    end

    -- reposition ships
    player1.x = math.random(200, WIDTH / 2 - 100)
    player1.y = math.random(200, HEIGHT - 200)
    player2.x = math.random(WIDTH / 2 + 100, WIDTH - 200)
    player2.y = math.random(200, HEIGHT - 200)

    -- TODO - compute distance with square roots - not just x & y distance
    -- check for planet overlap
    -- check for ship overlapping with planet too
    -- space them out by 50 px at least
    for i = 1, numOfPlanets do
        for j = 1, numOfPlanets do
            if allPlanets[i].x == allPlanets[j].x and allPlanets[i].y ==
                allPlanets[j].y then
                -- do nothing
            elseif math.abs(allPlanets[i].x - allPlanets[j].x) < 40 and
                math.abs(allPlanets[i].y - allPlanets[j].y) < 40 then
                setInitialPositions()
                goto done
            elseif math.abs(allPlanets[i].x - player1.x) < 90 and
                math.abs(allPlanets[i].y - player1.y) < 90 then
                setInitialPositions()
                goto done
            elseif math.abs(allPlanets[i].x - player2.x) < 90 and
                math.abs(allPlanets[i].y - player2.y) < 90 then
                setInitialPositions()
                goto done
            end
        end
    end

    ::done::

end

-- check collisions with every shot that is drawn
-- dims trails after every collision
function collisonCheck(b)

    -- insert code that will set shotInProgress = false if all bullets are gone and end the turn with it

    -- whenever the bullet hits the planet - remove from drawing & computing
    for i = 1, numOfPlanets do

        if (math.sqrt(math.pow(allPlanets[i].x - allBullets[b].x, 2) +
                          math.pow(allPlanets[i].y - allBullets[b].y, 2))) <
            allPlanets[i].r then

            -- remove the bullet from the playing field
            -- as long as it's placed outside the cutoff set in the drawShot()
            -- it will not compute!!! no wasted CPU cycles!
            allBullets[b].x = 0
            allBullets[b].y = 0
            allBullets[b].vx = 0
            allBullets[b].vy = 0

            -- this dims the trails on every collision -- probably should disable
            -- dimTrails()
            love.graphics.setCanvas(canvas)
            drawPlanets() -- draw planets because a collision overlaps with a planet :(
            love.graphics.setCanvas()
        end
    end

    -- grace period when your bullet can't kill you
    if benign > 50 then
        didYouHitPlayer(player1, b)
        didYouHitPlayer(player2, b)
        if turn == 1 then
            updateHealthBar(player2, player1, b)
        else
            updateHealthBar(player1, player2, b)
        end
    end

end

-- don't forget `b` the bullet index
function didYouHitPlayer(playerN, b)

    if (math.sqrt(math.pow(playerN.x - allBullets[b].x, 2) +
                      math.pow(playerN.y - allBullets[b].y, 2))) < 10 then
        print("you hit someone!")

        -- only decrease 1 life!
        if endOfRound == false then playerN.lives = playerN.lives - 1 end

        endOfRound = true
        
        playerN.health = 0
        
        -- store location where player is
        explodeX = playerN.x
        explodeY = playerN.y
        
        -- hide player from the board
        playerN.x = -100
        playerN.y = -100
        
        -- explode this location !!!
        explode(explodeX, explodeY)

        if playerN.lives == 0 then print("GAME OVER, SOMEONE WON!") end
    end

end

-- don't forget `b` the bullet index
function updateHealthBar(playerN, opponent, b)

    distanceFromShot = math.sqrt(math.pow(playerN.x - allBullets[b].x, 2) +
                                     math.pow(playerN.y - allBullets[b].y, 2))

    if opponent.health > distanceFromShot then
        opponent.health = distanceFromShot
        love.graphics.setCanvas(canvas)
        drawUI()
        love.graphics.setCanvas()
    end

end

-- TODO: figure out a sensible default for resolution of the shot and speed of the shot
-- warning: planets with all the small radii may allow bullets to pass through
--          because the shot rosolution is LOW

-- TODO: allow shot to be outside the border by at least a little bit
-- TODO: include code so it doesn't do the calculation if the shot is too far from border
--       if shot is within bounds of the screen, draw it

--[[

THE MOST IMPORTANT FUNCTION - draws the lines for the shot "b" where b (think "bullet") is the shot name

1) if shot is outside some boundary, discard it
2) if the shot is outside drawing area, compute, but don't draw (TODO: this is not implemented yet)
3) if the shot is within screen:
    a) compute x and y components from each planet on the current bullet (store in fpx & fpy variables)
    b) sum up all the forces into a single vfx & vfy
    c) add final force to bullet's initial force
    d) draw the small segment
    e) update bullet's 'initial' velocity for next iteration

--]]
function drawShot(b)

    -- Variables involved:
    -- b - bulletIndex `[b]`

    -- (1)
    -- set the shot outside if it hits outside the play border
    if allBullets[b].x > WIDTH - 10 or allBullets[b].x < 10 or allBullets[b].y >
        WIDTH - 10 or allBullets[b].y < 10 then
        allBullets[b].x = 0
        allBullets[b].y = 0
    end

    -- (3)
    if allBullets[b].x < WIDTH - 10 and allBullets[b].x > 10 and allBullets[b].y <
        WIDTH - 10 and allBullets[b].y > 10 then

        -- array to store forces from each planet to each shot (temp use always)
        fpx = {}
        fpy = {}

        -- (a)
        -- calculate force of planet on x1 and y1
        for i = 1, numOfPlanets do
            xDiff = allPlanets[i].x - allBullets[b].x
            yDiff = allPlanets[i].y - allBullets[b].y

            fpx[i] = xDiff /
                         (math.pow(math.sqrt((xDiff * xDiff) + (yDiff * yDiff)),
                                   3));
            fpy[i] = yDiff /
                         (math.pow(math.sqrt((xDiff * xDiff) + (yDiff * yDiff)),
                                   3));
        end

        -- reset velocity -- TEMPORARY VARIABLES
        vfx = 0
        vfy = 0

        -- (b)
        -- for each planet add all forces multiplied by gravity of each planet
        for i = 1, numOfPlanets do
            vfx = vfx + fpx[i] * allPlanets[i].mass
        end

        for i = 1, numOfPlanets do
            vfy = vfy + fpy[i] * allPlanets[i].mass
        end

        -- (c)
        -- add initial velocity to the final velocity
        vfx = vfx + allBullets[b].vx
        vfy = vfy + allBullets[b].vy

        -- set velocity of each bullet to its final velocity
        allBullets[b].vx = vfx
        allBullets[b].vy = vfy

        -- (d)
        -- Draw shot to canvas
        love.graphics.setCanvas(canvas)
        love.graphics.line(allBullets[b].x, allBullets[b].y,
                           allBullets[b].x + vfx, allBullets[b].y + vfy)
        love.graphics.setCanvas()

        -- (e)
        allBullets[b].x = allBullets[b].x + vfx
        allBullets[b].y = allBullets[b].y + vfy

    end

end
