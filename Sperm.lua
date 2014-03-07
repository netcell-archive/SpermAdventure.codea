Sperm = class()

diameter      = 30 * HEIGHT/1024
radius        = diameter/2
radiusSquare  = math.pow(radius,2)
maxTailLength = 20
accelCoef     = 1
maxX          = WIDTH - radius
minX          = radius
y             = HEIGHT/2
top           = y + radius
bot           = y - radius

function Sperm:init()
    self.top      = top
    self.x        = WIDTH/2
    self.y        = y
    self.radius   = radius
    self.velx     = 0
    self.tail     = {self.x}
    self.orgGravx = 0--Gravity.x
end

function Sperm:left()
    return self.x - radius
end

function Sperm:right()
    return self.x + radius
end

function Sperm:update()
    local tail = self.tail
    local x = self.x
    local velx = self.velx
    table.insert(tail, 1, self.x)
    if #tail == maxTailLength then
        table.remove(tail)
    end

   self.velx = self.velx + (Gravity.x - self.orgGravx) * accelCoef
    self.x   = self.x + self.velx
    
    if self.x > maxX then
        self.velx = 0
        self.x = maxX
    elseif self.x < minX then
        self.velx = 0
        self.x = minX
    end
end

function Sperm:collideBearable(btop, bbot)
    local hSquare = math.pow(math.min(math.abs(bbot - y), math.abs(btop - y) ), 2)
    if radiusSquare > hSquare then
        return math.sqrt(radiusSquare - hSquare)
    else
        return radius
    end
end

function Sperm:collide(block)
    local btop = block.y + blockHeight
    local bbot = block.y
    if btop >= bot and bbot <= top then
        local bearable = self:collideBearable(btop, bbot)
        if self.x - block.w <= bearable or block.wr - self.x <= bearable then
            return true
        end
    end
    return false
end

function Sperm:draw()
    fill(255, 255, 255, 255)
    local tail = self.tail
    for i,v in ipairs(tail) do
        ellipse(v, y + i*speed, (diameter - diameter*i/#tail))
    end
    
    ellipse(self.x, y, diameter)
    fill(0, 0, 0, 255)
    ellipse(self.x - diameter/6 - 1, y-1, diameter/3)
    ellipse(self.x + diameter/6 + 1, y-1, diameter/3)
end