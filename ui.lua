----------------------------------------------------------------------------------------------------
-- Code related to drawing the UI (user interface)
----------------------------------------------------------------------------------------------------

function drawUI()

    love.graphics.setColor(1,1,1,1)

    -- bounding box
    love.graphics.line(10,720,WIDTH-10,720)
    love.graphics.line(WIDTH-10,10,WIDTH-10,720)
    love.graphics.line(10,10,10,720)
    love.graphics.line(10,10,WIDTH-10,10)


    -- region for touch stuff
    love.graphics.line(10,50,410,50)
    love.graphics.line(10,90,410,90)

    love.graphics.line(110,10,110,90)
    love.graphics.line(410,10,410,90)


    -- shoot BUTTON rectangle -- change states while shot in progress
    if shotInProgress == 1 then
        love.graphics.setColor(0.5,0,0,1)
        love.graphics.ellipse('fill',WIDTH-50,50,30,30)
    elseif shotInProgress == 0 then
        love.graphics.setColor(16/255,178/255,197/255,1)
        love.graphics.ellipse('fill',WIDTH-50,50,30,30)
    end


    --draw how many lives each has
    love.graphics.setColor(1,1,0,1)
    for i=1, p1l do
        love.graphics.ellipse('fill',WIDTH/2+35+20*i, HEIGHT-32, 8, 8)
    end

    for i=1, p2l do
        love.graphics.ellipse('fill',WIDTH/2-35-20*i, HEIGHT-32, 8, 8)
    end


    -- right health bar
    love.graphics.setColor((255-proximity*2.55)/255, 1, 0, 1)
    love.graphics.rectangle('fill',WIDTH/2+50,HEIGHT-20,300,10)

    if proximity<100 then
        love.graphics.setColor(223/255, (45+proximity)/255, (45+proximity)/255, 1)
        love.graphics.rectangle('fill',(WIDTH/2+50)+300-300*((100-proximity)/100),HEIGHT-20,300-300*((proximity)/100),10)
    end


    -- left health bar
    love.graphics.setColor((255-proximity2*2.55)/255, 1, 0, 1)
    love.graphics.rectangle('fill',WIDTH/2-350,HEIGHT-20,300,10)

    if proximity2<100 then
        love.graphics.setColor(224/255, (45+proximity2)/255, (45+proximity2)/255, 1)
        love.graphics.rectangle('fill',(WIDTH/2-350),HEIGHT-20,300-300*((proximity2)/100),10)
    end


    -- region for angle & force
    love.graphics.setColor(16/255, 178/255, 197/255, 1)
    love.graphics.rectangle('fill',20,60,80,20)
    love.graphics.rectangle('fill',20,20,80,20)
    love.graphics.setColor(1, 1, 1, 1)

    -- draw the current player's force and angle
    if turn == 1 then
        love.graphics.printf(string.format("%.5f", p1f), 20, 22, 75, 'right')
        love.graphics.printf(string.format("%.5f", p1a), 20, 62, 75, 'right')
    elseif turn == 2 then
        love.graphics.printf(string.format("%.5f", p2f), 20, 22, 75, 'right')
        love.graphics.printf(string.format("%.5f", p2a), 20, 62, 75, 'right')
    end

end


function drawShips()

    love.graphics.setColor(1, 0.6, 0.6, 1)
    love.graphics.ellipse('fill', s1x, s1y, 8, 8)
    love.graphics.ellipse('fill', s2x, s2y, 8, 8)

end


--[[
    Dim all the shot trails on the screen
    meant to run after every shot
    works by applying a black rectangle with low opacity over the whole screen
--]]
function dimTrails()

    -- dims the whole thing - draws black rectangle with low opacity
    -- love.graphics.setColor(0,0,0,1)                           -- need to reset back afterwards :/
    -- need -1 because otherwise has a border that's ugly
    -- love.graphics.rectangle('fill',-1,-1,WIDTH+5,HEIGHT+5)
    -- love.graphics.setColor(1,1,1,1)                           -- need to reset back afterwards :/

    -- print("dimTrails disabled")
    print("dimTrails EXECUTED")

    love.graphics.setCanvas(canvas)
        love.graphics.setColor(0, 0, 0, 0.01)                   -- don't fortget to reset ?
        love.graphics.rectangle('fill', 0, 0, WIDTH, HEIGHT)
        love.graphics.setColor(1, 1, 1, 1)                      -- reset back !?
    love.graphics.setCanvas()


    drawPlanets()
    drawShips()

end


function drawPlanets()

    -- love.graphics.setColor(214/255, 133/255, 83/255, 1)
    love.graphics.setColor(217/255, 160/255, 59/255, 1)

    for i=1, numOfPlanets do
        love.graphics.ellipse('line', px[i], py[i], r[i], r[i])
    end

    drawUI()

end
