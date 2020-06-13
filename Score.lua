Score = class()

local Instance = nil

function Score:init()
    self.totalScore = 0
    Instance = self
    U:addIndestructible(self)
end

function Score:draw()
    local s= "000000"..tostring(self.totalScore)
    s = string.sub(s,-5)
    pushStyle()
    fontSize(100)
    text(s, 200, HEIGHT-60)
    popStyle()
end

function Score:instance()
    return Instance
end

function Score:addScore(aNumber)
    self.totalScore = self.totalScore + aNumber
end

function Score:score()
    return self.totalScore
end

function Score:move()
end
