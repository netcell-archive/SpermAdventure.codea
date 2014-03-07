supportedOrientations(PORTRAIT)
displayMode(FULLSCREEN_NO_BUTTONS)

-- world velocity
speed = 3 * HEIGHT/1024
highscore = 0

-- Use this function to perform your initial setup
function setup()
    sperm  = Sperm()
    blocks = Blocks(speed)
    blocks:spawn(0)
    
    score = 0
    over  = false
    start = false
    exploding = false
    highscore = readLocalData("highscore", 0)
end

function gameover()
    if highscore < score then
        highscore = score
        saveLocalData("highscore", highscore)
    end
    sound(DATA, "ZgNACgBAK0RBGRII9Y/tPt6vyD6gjBA+KwB4b3pAQylFXB0C")
    over = true
    exploding = true
    explosion = Explosion(sperm.x, sperm.y)
    explosion:draw()
end

-- This function gets called once every frame
function draw()
    
    smooth()
    local c = math.random(0, 30)
    background(c, c, c, 255)

    if over == false and start == true then
        sperm:update()

        blocks:update()
        if blocks:pass(sperm) then
            sound(SOUND_PICKUP, 32947)
            score = score + 1
        end

        if sperm:collide(blocks:now()) then
            gameover()
        end

    end
    
    if start == false and over == false then
        fill(255, 255, 255, 255)
        fontSize(16 * HEIGHT/1024)
        text("Turn your device to control the sperm", sperm.x, sperm.y - 50 * HEIGHT/1024)
        text("Avoid obstacles to score", sperm.x, sperm.y - 80 * HEIGHT/1024)
        if CurrentTouch.state == ENDED then
            start = true
        end
    end
            
    blocks:draw()
    
    if over == false then
        sperm:draw()
    end
    
    if exploding == true then
        explosion:draw()
        if explosion:isDone() then
            exploding = false
        end
    end
    
    if over == true and exploding == false then
        local d = math.random(0, 1)
        local e = math.random(0, 1)
        fill(0, 0, 0, 255)
        rect(WIDTH/2 - 150 * HEIGHT/1024 + d, HEIGHT/2 - 150 * HEIGHT/1024 + e, 300 * HEIGHT/1024, 275 * HEIGHT/1024)
        fill(255-c, 255-c, 255-c, 255)
        fontSize(30 * HEIGHT/1024)
        text("GAME OVER", WIDTH/2+d, HEIGHT/2+80 * HEIGHT/1024+e)
        fontSize(24 * HEIGHT/1024)
        text("SCORE: "..score, WIDTH/2+d, HEIGHT/2+10 * HEIGHT/1024+e)
        text("BEST: "..highscore, WIDTH/2+d, HEIGHT/2 - 50 * HEIGHT/1024+e)
        fontSize(16 * HEIGHT/1024)
        text("TAP TO TRY AGAIN", WIDTH/2+d, HEIGHT/2 - 120 * HEIGHT/1024+e)
        if CurrentTouch.state == BEGAN then
            setup()
        end
    end
    if over == false and start == true then
        fontSize(30 * HEIGHT/1024)
        fill(255, 255, 255, 255)
        textAlign(CENTER)
        local tail = sperm.tail
        text(score, tail[#tail], sperm.y + #tail*speed + 10)
    end
end