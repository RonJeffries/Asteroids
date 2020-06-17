Score = class()

local Instance = nil

function Score:init(shipCount)
    self.shipCount = shipCount or 1
    self.gameIsOver = false
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
    if self.gameIsOver then
        text("GAME OVER", WIDTH/2, HEIGHT/2)
    end
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

function Score:spawnShip()
    if self.shipCount <= 0 then
        self:stopGame()
        return false
    else
        self.shipCount = self.shipCount - 1
        Ship()
        return true
    end
end

function Score:stopGame()
    local f = function()
        self.gameIsOver = false
        U.attractMode = true
    end
    self.gameIsOver = true
    if not U.attractMode then tween.delay(10,f) end
end
