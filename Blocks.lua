Blocks = class()

-- blocks properties 
blockHeight   = 50 * HEIGHT/1024
blockGap      = 120 * HEIGHT/1024
maxLeftWidth  = WIDTH - blockGap
blockDistance = 210 * HEIGHT/1024
maxY          = HEIGHT + blockHeight / 2

function Blocks:init(speed)
    self.blocks  = {}
    self.current = 1
    self.height  = blockHeight
    self.speed   = speed
end

function Blocks:get(i)
    return self.blocks[i]
end

function Blocks:head()
    return self.blocks[1]
end

function Blocks:last()
    local blocks = self.blocks
    return blocks[#blocks]
end

function Blocks:now()
    return self.blocks[self.current]
end

function Blocks:spawn(pos_y)
    if (pos_y == nill) then
        pos_y = 0
    end
    local sy = pos_y - blockHeight
    local sw = math.random(blockGap, maxLeftWidth)
    local swr = sw + blockGap
    return table.insert(self.blocks, {y = sy, w = sw, wr = swr})
end

function Blocks:unshift()
    table.remove(self.blocks, 1)
    self.current = self.current - 1
end

function Blocks:update()

    for i,v in ipairs(self.blocks) do
        v.y = v.y + self.speed
    end

    -- Out of window
    if self:get(1).y >= maxY then
        self:unshift()
    end

    -- Far enough for new block
    local s = self:last().y - blockDistance
    if (s >= 0) then
        self:spawn(s)
    end

end

function Blocks:pass(sperm)
    local condition = (self:now().y > sperm.top)
    if condition then
        self.current = self.current + 1
    end
    return condition
end

function Blocks:draw()
    for i,v in ipairs(self.blocks) do
        --if i == current then
            --fill(255, 0, 0, 255)
        --else
            fill(255, 255, 255, 255)
        --end                       
        rect(0, v.y, v.w, self.height)
        rect(v.wr, v.y, WIDTH - v.wr, self.height)
        local r = math.random(0, 2)
        local k = math.random(5, 10)
        if r < 1 then
            fill(255, 255, 255, math.random(70,140))
            rect(0, v.y-k, v.w, self.height+2*k)
            rect(v.wr, v.y-k, WIDTH - v.wr, self.height+2*k)
        end
    end
end
