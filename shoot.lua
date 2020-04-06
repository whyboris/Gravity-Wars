----------------------------------------------------------------------------------------------------
-- Code related to shooting bullets
----------------------------------------------------------------------------------------------------

-- this function sets the initial velocities for each bullet
-- it doesn't shoot - it relies on the "drawShot" function to continue
--
-- f - force            additional to player's chosen force,
-- t - theta (angle)    additional to player's chosen angle,
-- bulletIndex - index of the bullet
function setBulletsInitialVelocities(f, t, bulletIndex)

    if turn == 1 then
        -- preturb it by a bit for jitter so it's not the same
        f = player1.force + f + math.random() *  2
        t = player1.angle + t + math.random() * 10
    elseif turn == 2 then
        f = player2.force + f + math.random() *  2
        t = player2.angle + t + math.random() * 10
    end

    -- *** REDUCE THE FORCE BY some amount and reduce weight of planets by some amount
    -- *** this will make the resolution of the shot higher!!?! ***
    f = f/2

    -- calculate the x and y components of shot for initial force
    vix[bulletIndex] = f * math.cos(0.0174533 * t)
    viy[bulletIndex] = f * math.sin(0.0174533 * t)

    -- to test what's going on
    -- print("force = ", f)
    -- print("angle = ", t)

end

-- to split a bullet (special bullet type allows for splitting while in air)
function split(x,y)

    love.graphics.ellipse('line',x,y,10,10)

    --print("SPLIT @ ", x, y)

    temp = 0

    for i=1, 3 do
        temp = numOfBullets + i
        x1a[temp] = x
        y1a[temp] = y
    end

    numOfBullets = numOfBullets + 3
    temp = 0

    for i=1, 3 do
        temp = numOfBullets - 3 + i
        setBulletsInitialVelocities(0.01,math.random(0,360),temp)
    end

end



function initialShot()

    -- start all the bullets somewhere - not yet sure if code needed
    for i=1, numOfBullets do
        x1a[i] = shipX
        y1a[i] = shipY
        setBulletsInitialVelocities(1,1,i)
    end

end


function shotType1()

    -- shoot only one bullet
    numOfBullets = 1

    for i=1, numOfBullets do
        x1a[i] = shipX
        y1a[i] = shipY
        setBulletsInitialVelocities(1,1,i)
    end

end


function shotType2()

    -- shoot three bullets
    numOfBullets = 3

    for i=1, numOfBullets do
        x1a[i] = shipX
        y1a[i] = shipY
        setBulletsInitialVelocities(1,1,i)
    end

end


function shotType3()

    -- shoot five bullets
    numOfBullets = 5

    for i=1, numOfBullets do
        x1a[i] = shipX
        y1a[i] = shipY
        setBulletsInitialVelocities(1,1,i)
    end

end


function shotType4()

    -- shoot only one bullet
    numOfBullets = 1

    for i=1, numOfBullets do
        x1a[i] = shipX
        y1a[i] = shipY
        setBulletsInitialVelocities(1,1,i)
    end

end


function playerPressedShootButton()

    dimTrails()

    print("Whose is shooting? Player ", turn)

    -- origin of the shot set to player's location
    if turn == 1 then
        shipX = player1.x
        shipY = player1.y
    elseif turn == 2 then
        shipX = player2.x
        shipY = player2.y
    end

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
        for i=1, numOfBullets do
            x1a[i] = shipX
            y1a[i] = shipY
            setBulletsInitialVelocities(2,2,i)
        end
    end

    love.graphics.setCanvas(canvas)
        drawUI()
    love.graphics.setCanvas()

    shotInProgress = true

end



-- should write a better function: one that explodes a SHIP not a location!

-- function takes x,y location and blows up that spot
function explode(x,y)

    love.graphics.ellipse('line',x,y,10,10)

    benign = -100

    love.graphics.setColor(200/255,20/255,20/255,1)

    --print("EXPLOSION @ ", x, y)

    -- add the bullets, don't use existing ones!!!
    -- might keep re-using the 10 bullets I create if hits again - not sure ***

    temp = 0

    for i=1, 10 do
        temp = numOfBullets + i
        x1a[temp] = x
        y1a[temp] = y
    end

    numOfBullets = numOfBullets + 10
    temp = 0

    for i=1, 10 do
        temp = numOfBullets - 10 + i
        setBulletsInitialVelocities(0.01,math.random(0,360),temp)
    end

end
