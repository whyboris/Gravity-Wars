----------------------------------------------------------------------------------------------------
-- Code related to shooting bullets
----------------------------------------------------------------------------------------------------
-- this function sets the initial velocities for each bullet
-- it doesn't shoot - it relies on the "drawShot" function to continue
--
-- f - force            additional to player's chosen force,
-- t - theta (angle)    additional to player's chosen angle,
-- bulletIndex - index of the bullet
function setBulletInitialVelocity(f, t, bulletIndex)

    if turn == 1 then
        -- preturb it by a bit for jitter so it's not the same
        f = player1.force + f -- + math.random() * 2
        t = player1.angle + t -- + math.random() * 10
    elseif turn == 2 then
        f = player2.force + f -- + math.random() * 2
        t = player2.angle + t -- + math.random() * 10
    end

    -- *** REDUCE THE FORCE BY some amount and reduce weight of planets by some amount
    -- *** this will make the resolution of the shot higher!!?! ***
    f = f / 2

    -- calculate the x and y components of shot for initial force
    allBullets[bulletIndex].vx = f * math.cos(0.0174533 * t)
    allBullets[bulletIndex].vy = f * math.sin(0.0174533 * t)

end

-- to split a bullet (special bullet type allows for splitting while in air)
function split(x, y)

    love.graphics.ellipse('line', x, y, 10, 10)

    -- print("SPLIT @ ", x, y)

    temp = 0

    for i = 1, 3 do
        temp = numOfBullets + i
        allBullets[i] = {}
        allBullets[temp].x = x
        allBullets[temp].y = y
    end

    numOfBullets = numOfBullets + 3
    temp = 0

    for i = 1, 3 do
        temp = numOfBullets - 3 + i
        setBulletInitialVelocity(0.01, math.random(0, 360), temp)
    end

end

function shotType1()

    -- shoot only one bullet
    numOfBullets = 1

    for i = 1, numOfBullets do
        allBullets[i] = {}
        allBullets[i].x = shipX
        allBullets[i].y = shipY
        setBulletInitialVelocity(1, 1, i)
    end

end

function shotType2()

    -- shoot three bullets
    numOfBullets = 30

    for i = 1, numOfBullets do
        allBullets[i] = {}
        allBullets[i].x = shipX
        allBullets[i].y = shipY
        setBulletInitialVelocity(1, 1, i)
    end

end

function shotType3()

    -- shoot five bullets
    numOfBullets = 5

    for i = 1, numOfBullets do
        allBullets[i] = {}
        allBullets[i].x = shipX
        allBullets[i].y = shipY
        setBulletInitialVelocity(1, 1, i)
    end

end

function shotType4()

    -- shoot only one bullet
    numOfBullets = 1

    for i = 1, numOfBullets do
        allBullets[i] = {}
        allBullets[i].x = shipX
        allBullets[i].y = shipY
        setBulletInitialVelocity(1, 1, i)
    end

end

function playerPressedShootButton()

    dimTrails()

    print("Whose is shooting? Player ", turn)

    -- origin of the shot set to player's location
    if turn == 1 then
        shipX = player1.x
        shipY = player1.y
        player1.lastAngle = player1.angle
        player1.lastForce = player1.force
    elseif turn == 2 then
        shipX = player2.x
        shipY = player2.y
        player2.lastAngle = player2.angle
        player2.lastForce = player2.force
    end

    allBullets = {} -- reset to empty

    -- make bullet benign
    benign = 0

    if bulType == 1 then
        shotType1()
    elseif bulType == 2 then
        shotType2()
    elseif bulType == 3 then
        shotType3()
    elseif bulType == 4 then
        shotType4()
    else
        for i = 1, numOfBullets do
            allBullets[i] = {}
            allBullets[i].x = shipX
            allBullets[i].y = shipY
            setBulletInitialVelocity(2, 2, i)
        end
    end

    love.graphics.setCanvas(canvas)
    drawUI()
    love.graphics.setCanvas()

    shotInProgress = true

end

-- blow up a location in a pretty way
function explode(x, y)
   
    temp = 0
    
    love.graphics.setCanvas(canvas)
 
    for i = 1, 10 do
        temp = numOfBullets + i
        allBullets[temp] = {}

        randX = math.random(-20, 20)
        randY = math.random(-20, 20)

        radius = math.random(5, 15)
        setExplodyColor()
        love.graphics.ellipse('fill', x + randX, y + randY, radius, radius)

        allBullets[temp].x = x + randX
        allBullets[temp].y = y + randY
    end

    love.graphics.setCanvas()

    numOfBullets = numOfBullets + 10
    temp = 0

    for i = 1, 10 do
        temp = numOfBullets - 10 + i
        setBulletInitialVelocity(1, math.random(0, 360), temp)
    end

end

function setExplodyColor()

    -- red     1    0     0
    -- orange  1    0.5   0
    -- yellow  1    1     0

    love.graphics.setColor(1, math.random(0, 255) / 255, 0, 1)
end