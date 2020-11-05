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
end

function love.keyreleased(key)

    keyRight = false
    keyLeft = false
    keyUp = false
    keyDown = false

end
