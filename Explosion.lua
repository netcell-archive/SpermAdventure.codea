Explosion = class()

function Explosion:init(px, py)
    self.position = vec2(px, py)
    self.opacity = 255
    self.time = 1
    self.lines = {}

    --sound(SOUND_EXPLODE, 967)

    for i = 1,50 do
        dir = vec2(0,1)
        dir = dir:rotate( math.rad(math.random(360)) )
        table.insert( self.lines, dir*math.random(0,70 * HEIGHT/1024) )
    end
end

function Explosion:isDone()
    return self.opacity <= 0
end

function Explosion:draw()
    fill(255, 255, 255, math.random(0, 250))
    rect(0,0,WIDTH,HEIGHT)
    self.time = self.time + 5 * 1024 / (self.time * HEIGHT)
    
    pushStyle()

    lineCapMode(ROUND)
    strokeWidth(math.random(5, 30 * HEIGHT/1024))
    smooth()
    stroke(255,255,255,math.max(self.opacity,0))

    p = self.position
    for i,v in ipairs(self.lines) do
        vt = p + v * self.time
        line(p.x, p.y, vt.x, vt.y) 
    end

    self.opacity = 255 * (1 - (self.time/30));

    popStyle()
end
