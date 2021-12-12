----------------------------------------------------------------------------------------------------
-- Code related to keyboard interactions
----------------------------------------------------------------------------------------------------
function love.keypressed(key)

    print(key)

    if key == 'right' then
        keyRight = true
    end

    if key == 'left' then
        keyLeft = true
    end

    if key == 'up' then
        keyUp = true

        player1.force = player1.force * 1.01

    end

    if key == 'down' then
        keyDown = true
    end

    if key == 'x' then
        explode(400, 300)
    end

    if key == 'n' then
        newGame()
    end

    if key == 'space' then
        playerPressedShootButton()
    end

    if key == 'escape' then
        os.exit()
    end

end

function love.keyreleased(key)

    keyRight = false
    keyLeft = false
    keyUp = false
    keyDown = false

end
