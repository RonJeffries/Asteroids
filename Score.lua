Score = class()

local Instance = nil

function Score:init(shipCount)
    self.shipCount = shipCount or 1
    self.gameIsOver = false
    self.totalScore = 0
    self.nextFreeShip = U.freeShipPoints
    self.myShip = Ship()
    Instance = self
    self.drawLevel = U.drawLevels.score
    U:addIndestructible(self)
end

function Score:draw()
    local s= "000000"..tostring(self.totalScore)
    s = string.sub(s,-5)
    pushStyle()
    fontSize(100)
    text(s, 200, HEIGHT-60)
    local step = Fancy and 50 or 20
    for i = 1,self.shipCount do
        self.myShip.pos = vec2(330-i*step, HEIGHT-120)
        self.myShip.radians = math.pi/2
        U:drawProperly(self.myShip)
    end
    if self.gameIsOver then
        text("GAME OVER", WIDTH/2, HEIGHT/2)
    end
    popStyle()
end

function Score:drawFancy()
    translate(WIDTH/2,HEIGHT/2)
    scale(WIDTH/137,HEIGHT/91)
    --zLevel(-1)
    sprite(asset.milkyway)
    --zLevel(0)
    popMatrix()
    popStyle()
    pushMatrix()
    pushStyle()
    self:draw()
    popStyle()
    popMatrix()
end


function Score:shouldDrawSmallSaucer()
    return self.totalScore >= 3000
end

function Score:instance()
    return Instance
end

function Score:addScore(aNumber)
    self.totalScore = self.totalScore + aNumber
    if self.totalScore >= self.nextFreeShip then
        self.shipCount = self.shipCount + 1
        self.nextFreeShip = self.nextFreeShip + U.freeShipPoints
        sound(U.sounds.extraShip)
    end
end

function Score:score()
    return self.totalScore
end

function Score:move()
end

function Score:spawnShip()
    if InfiniteShips then self.shipCount = self.shipCount + 1 end
    if self.shipCount <= 0 then
        self:stopGame()
        return false
    else
        self.shipCount = self.shipCount - 1
        Ship:makeRegisteredInstance()
        return true
    end
end

function Score:stopGame()
    self.gameIsOver = true
    if not U.attractMode then 
        tween.delay(5,self.enterAttractMode,self) 
    end
end

function Score:enterAttractMode()
    self.gameIsOver = false
    U.attractMode = true
end
