----------------------------------------------------------------------------------------------------
-- Code related to shooting bullets
----------------------------------------------------------------------------------------------------

-- f is force,
-- t is theta (angle),
-- b is the index of the bullet
function shootBullet(f,t,b)

    -- this function sets the initial velocities for each bullet (index "b")
    -- it doesn't shoot - it relies on the "drawShot" function to continue

    --f = force
    --t = angle

    if turn == 1 then
        -- preturb it by a bit for jitter so it's not the same
        f = player1.force + math.random()*2 + f
        t = player1.angle + math.random()*10 + t
    elseif turn == 2 then
        f = player2.force + math.random()*2 + f
        t = player2.angle + math.random()*10 + t
    end

    -- *** REDUCE THE FORCE BY some amount and reduce weight of planets by some amount
    -- *** this will make the resolution of the shot higher!!?! ***
    f = f/2

    -- calculate the x and y components of shot for initial force
    vix[b]=f*math.cos(0.0174533*t)
    viy[b]=f*math.sin(0.0174533*t)

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
        shootBullet(0.01,math.random(0,360),temp)
    end

end



function initialShot()

    -- start all the bullets somewhere - not yet sure if code needed
    for i=1, numOfBullets do
        x1a[i] = shipX
        y1a[i] = shipY
        shootBullet(1,1,i)
    end

end


function shotType1()

    -- shoot only one bullet
    numOfBullets = 1

    for i=1, numOfBullets do
        x1a[i] = shipX
        y1a[i] = shipY
        shootBullet(1,1,i)
    end

end


function shotType2()

    -- shoot three bullets
    numOfBullets = 3

   for i=1, numOfBullets do
        x1a[i] = shipX
        y1a[i] = shipY
        shootBullet(1,1,i)
    end

end


function shotType3()

    -- shoot five bullets
    numOfBullets = 5

   for i=1, numOfBullets do
        x1a[i] = shipX
        y1a[i] = shipY
        shootBullet(1,1,i)
    end

end


function shotType4()

    -- shoot only one bullet
    numOfBullets = 1

    for i=1, numOfBullets do
        x1a[i] = shipX
        y1a[i] = shipY
        shootBullet(1,1,i)
    end

end


function shootBulletAgain()

    dimTrails()

    print("Whose is shooting? Player ", turn)
    shotInProgress = true

    -- *** insert code to select which player *** ???
    -- or have every shot ask as an argument which player is shooting?
    if turn == 1 then
        shipX = player1.x
        shipY = player1.y
        force = player1.force
        angle = player1.angle
    elseif turn == 2 then
        shipX = player2.x
        shipY = player2.y
    end

    -- make bullet benign
    benign = 0

    numOfBullets = bullets

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
            shootBullet(2,2,i)
        end
    end

    love.graphics.setCanvas(canvas)
        drawUI()
    love.graphics.setCanvas()

    -- this code changed the turn too soon and made the health bar act improperly
    -- if turn == 1 then
    --     --turn = 2
    -- elseif turn == 2 then
    --     --turn = 1
    -- end

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
        shootBullet(0.01,math.random(0,360),temp)
    end

end
