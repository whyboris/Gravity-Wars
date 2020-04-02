----------------------------------------------------------------------------------------------------
-- Code related to creating new game, planets, collision check, and draw shot
----------------------------------------------------------------------------------------------------

function newGame()

    love.graphics.setCanvas(canvas)
        love.graphics.clear()
    love.graphics.setCanvas()

    createPlanets()

    drawUI()
    drawPlanets()
    drawShips()

    proximity = 100
    proximity2 = 100

    print("New Game Started")

end

-- Randomize placement of planets; check for overlap (does not draw them!)
function createPlanets()

    print('randomizing planets attempt')

    -- include parameters for max and min planet locations

   for i=1, numOfPlanets do
       px[i] = math.random(100,WIDTH-100)
       py[i] = math.random(150,HEIGHT-250)
       r[i] = math.random(15,50)

       -- I should play with mass ****
       m[i] = math.random(10,50)*10
       -- having the mass depend on radius is less fun - small planets stop mattering
       --m[i] = (math.pow(r[i],3)/25) -- MASS depends on radius^3 *** this affects speed of drawing
    end

    -- makes a planet dead center
    --px[1] = WIDTH/2
    --py[1] = HEIGHT/2

    -- reposition ships
    ship1x = math.random(200,WIDTH/2-100)
    ship1y = math.random(200,HEIGHT-200)
    ship2x = math.random(WIDTH/2+100,WIDTH-200)
    ship2y = math.random(200,HEIGHT-200)


    -- TODO - compute distance with square roots - not just x & y distance
    -- check for planet overlap
    -- check for ship overlapping with planet too
    -- space them out by 50 px at least
    for i=1, numOfPlanets do
        for j=1, numOfPlanets do
            if px[i] == px[j] and py[i] == py[j] then
                -- do nothing
            elseif math.abs(px[i]-px[j]) < 40 and math.abs(py[i]-py[j]) < 40 then
                createPlanets()
            elseif math.abs(px[i]-ship1x) < 90 and math.abs(py[i]-ship1y) < 90 then
                createPlanets()
            elseif math.abs(px[i]-ship2x) < 90 and math.abs(py[i]-ship2y) < 90 then
                createPlanets()
            end
        end
    end

end


-- check collisions with every shot that is drawn
-- dims trails after every collision
function collisonCheck(b)

    -- insert code that will set shotInProgress = false if all bullets are gone and end the turn with it

    -- whenever the bullet hits the planet - remove from drawing & computing
    for i=1,numOfPlanets do

        if(math.sqrt(math.pow(px[i]-x1a[b],2)+math.pow(py[i]-y1a[b],2))) < r[i] then

            -- remove the bullet from the playing field
            -- as long as it's placed outside the cutoff set in the drawShot()
            -- it will not compute!!! no wasted CPU cycles!
            x1a[b] = 0
            y1a[b] = 0
            vix[b] = 0
            viy[b] = 0

            -- this dims the trails on every collision -- probably should disable
            dimTrails()
        end
    end


    -- benign makes your own bullet not kill you for the first few moments when you shoot
    benign = benign + 1


    -- *** ADD CODE - at the moment hitting yourself can cause your opponent's health bar to change


    -- check if you hit opponent (num of bullets must affect benign,
    -- because with too many bullets it kills itself because benign is too high
    if benign > numOfBullets*50 then
        if(math.sqrt(math.pow(ship2x-x1a[b],2)+math.pow(ship2y-y1a[b],2))) < 10 then
            print("you hit the opponent!")

            if endOfRound == false then
                player1lives = player1lives - 1
            end

            endOfRound = true
            -- explode this location !!!
            love.graphics.ellipse('line',ship2x,ship2y,15,15)
            explode(x1a[b],y1a[b])
            proximity = 0

            if player1lives == 0 then
                print("GAME OVER, player 1 WON")
            end
        end
    end

    -- check if you hit yourself
    if benign > numOfBullets*50 then
        if(math.sqrt(math.pow(ship1x-x1a[b],2)+math.pow(ship1y-y1a[b],2))) < 10 then
            print("you hit yourself!")

            if endOfRound == false then
                player2lives = player2lives - 1
            end

            endOfRound = true
            -- explode this location !!!
            love.graphics.ellipse('line',ship1x,ship1y,15,15)
            explode(x1a[b],y1a[b])
            proximity2 = 0
            if player2lives == 0 then
                print("GAME OVER, player 2 WON")
            end
        end
    end


    -- *** MAYBE EDIT THIS - NEED TO ALTERNATE WHEN TO UPDATE DISTANCES
    -- *** NEED *** to update proximity only for opponent, not for self !!!

    -- check how close you are to the opponent; updates proximity
    if turn == 1 then
        if proximity > math.sqrt(math.pow(ship2x-x1a[b],2)+math.pow(ship2y-y1a[b],2)) then
            proximity = math.sqrt(math.pow(ship2x-x1a[b],2)+math.pow(ship2y-y1a[b],2))
            --print("closest we got to ss2 is ", proximity)
            --print("turn A", turn)
        end
    end

    -- check how close you are to the opponent; updates proximity2
    -- edit this code for later - at the moment needs to use "benign"
    -- so that the health meter doesn't freak out as soon as you shoot your bullet
    -- should be disabled on your turn
    if turn == 2 then
        if proximity2 > math.sqrt(math.pow(ship1x-x1a[b],2)+math.pow(ship1y-y1a[b],2)) then
            proximity2 = math.sqrt(math.pow(ship1x-x1a[b],2)+math.pow(ship1y-y1a[b],2))
            --print("closest we got to ss1 is ", proximity)
            --print("turn B", turn)
        end
    end

end



-- **** MUST MESS WITH THIS - increase resolution of the shot and speed of the shot ***********
-- *** planets with all the small radii allow bullets to pass through - because the rosolution is LOW ***

-- THE MOST IMPORTANT FUNCTION - draws the lines for the shot "b" where b is the shot name
function drawShot(b)


    -- set the shot outside if it hits outside the play border
    if x1a[b]>WIDTH-10 or x1a[b]<10 or y1a[b]>WIDTH-10 or y1a[b]<10 then
        x1a[b] = 0
        y1a[b] = 0
    end


    -- include code so it doesn't do the calculation if the shot is too far
    -- bar is low at the moment
    if x1a[b]<WIDTH-10 and x1a[b]>10 and y1a[b]<WIDTH-10 and y1a[b]>10 then

        -- calculate force of planet on x1 and y1
        for i=1, numOfPlanets do
            fpx[i] = (px[i] - x1a[b]) / (math.pow( math.sqrt(((px[i] - x1a[b]) * (px[i] - x1a[b])) + ((py[i] - y1a[b]) * (py[i] - y1a[b]))), 3));
        end

        for i=1, numOfPlanets do
            fpy[i] = (py[i] - y1a[b]) / (math.pow( math.sqrt(((px[i] - x1a[b]) * (px[i] - x1a[b])) + ((py[i] - y1a[b]) * (py[i] - y1a[b]))), 3));
        end

        -- reset velocity
        vfx = 0
        vfy = 0

        -- for each planet add all forces multiplied by gravity of each planet
        for i=1, numOfPlanets do
            vfx = vfx + fpx[i] * m[i]
        end

        for i=1, numOfPlanets do
            vfy = vfy + fpy[i] * m[i]
        end

        -- add initiav velocity to the final velocity
        vfx = vfx + vix[b]
        vfy = vfy + viy[b]

        -- set velocity of each bullet to its final velocity
        vix[b] = vfx
        viy[b] = vfy

        -- Draw shot to canvas
        love.graphics.setCanvas(canvas)                                       -- direct drawing operations to the canvas
            love.graphics.line(x1a[b],y1a[b],x1a[b]+vfx,y1a[b]+vfy)                                    -- draw to canvas
        love.graphics.setCanvas()                                                -- re-enable drawing to the main screen

        x1a[b] = x1a[b] + vfx
        y1a[b] = y1a[b] + vfy

    end

    -- need some code that checks if all the bullets have been extinguished
    -- and then restart the shot with a different person's turn

end
