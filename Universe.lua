-- Universe
-- RJ 20200523

Universe = class()

local MissileSpeed = 2.0

function Universe:init()
    self.processorRatio = 1.0
    self.score = 0
    self.rotationStep = math.rad(1.5) -- degrees
    self.missileVelocity = vec2(MissileSpeed,0)
    self.frame64 = 0
    self:defineSounds()
    self.button = {}
    self.asteroids = {}
    self.missiles = {}
    self.explosions = {}
    self.attractMode = true
    self:newWave()
end

function Universe:defineSounds()
    self.sounds = {}
    self.sounds.bangLarge = asset.bangLarge
    self.sounds.bangMedium = asset.bangMedium
    self.sounds.bangSmall = asset.bangSmall
    self.sounds.beat1 = asset.beat1
    self.sounds.beat2 = asset.beat2
    self.sounds.extraShip = asset.extraShip
    self.sounds.fire = asset.fire
    self.sounds.saucerBig = asset.saucerBig
    self.sounds.saucerSmall = asset.saucerSmall
    self.sounds.thrust = asset.thrust
end

function Universe:startGame()
    self.attractMode = false
    createButtons()
    self.ship = Ship()
    self.asteroids = {}
    self.waveSize = nil
    self.beatDelay = 1 -- second
    self.lastBeatTime = ElapsedTime
    self:newWave()
end

function Universe:draw()
    self.frame64 = (self.frame64+1)%64
    self:checkBeat()
    displayMode(FULLSCREEN_NO_BUTTONS)
    pushStyle()
    background(40, 40, 50)
    self.processorRatio = DeltaTime/0.0083333
    self:drawAsteroids()
    self:drawExplosions()
    checkButtons()
    drawButtons()
    if self.ship then self.ship:draw() end
    if self.ship then self.ship:move() end
    self:drawMissiles()
    drawSplats()
    U:drawScore()
    popStyle()
    U:findCollisions()
end

function Universe:checkBeat()
    if self.attractMode then return end
    self:updateBeatDelay()
    if ElapsedTime - self.lastBeatTime > self.beatDelay then
        self.lastBeatTime = ElapsedTime
        self:playBeat()
    end
end

function Universe:updateBeatDelay()
    if self.frame64 == 63 and self.beatDelay > 0.128 then
        self.beatDelay = self.beatDelay - 0.016
    end
end

function Universe:playBeat()
    if self.lastBeat == self.sounds.beat2 then
        self.lastBeat = self.sounds.beat1
    else
        self.lastBeat = self.sounds.beat2
    end
    sound(self.lastBeat)
end

function Universe:newWave()
    for i = 1, self:newWaveSize() do
        local a = Asteroid()
        self.asteroids[a] = a
    end
end

function Universe:findCollisions()
    for i,a in pairs(self.asteroids) do
        self:checkMissileCollisions(a)
        if self.ship then self:checkShipCollision(a) end
    end
end

function Universe:checkShipCollision(asteroid)
    if self.ship.pos:dist(asteroid.pos) < asteroid:killDist() then
        scoreAsteroid(asteroid)
        splitAsteroid(asteroid, self.asteroids)
        self:killShip()
    end
end

function Universe:checkMissileCollisions(asteroid)
    for k,m in pairs(self.missiles) do
        if m.pos:dist(asteroid.pos) < asteroid:killDist() then
            scoreAsteroid(asteroid)
            splitAsteroid(asteroid, self.asteroids)
            m:die()
        end
    end
end

function Universe:killShip()
    local f = function()
        self.ship = Ship()
    end
    Explosion(U.ship)
    U.ship = nil
    tween(6, self, {}, tween.easing.linear, f)
end

function Universe:moveObject(anObject)
    local pos = anObject.pos + self.processorRatio*anObject.step
    anObject.pos = vec2(self:keepInBounds(pos.x, WIDTH), self:keepInBounds(pos.y, HEIGHT))    
end

function Universe:keepInBounds(value, bound)
    return (value+bound)%bound
end

function Universe:drawExplosions()
    for k,e in pairs(self.explosions) do
        e:draw()
    end
end

function Universe:drawMissiles()
    pushStyle()
    pushMatrix()
    fill(255)
    stroke(255)
    for k, missile in pairs(self.missiles) do
        missile:draw()
    end
    popMatrix()
    popStyle()
    for k, missile in pairs(self.missiles) do
        missile:move()
    end
end

function Universe:drawAsteroids()
    pushStyle()
    stroke(255)
    fill(0,0,0, 0)
    strokeWidth(2)
    rectMode(CENTER)
    for i,asteroid in pairs(self.asteroids) do
        asteroid:draw()
        asteroid:move()
    end
    popStyle()
    killDeadAsteroids(self.asteroids)
end

function Universe:drawScore()
    local s= "000000"..tostring(self.score)
    s = string.sub(s,-5)
    fontSize(100)
    text(s, 200, HEIGHT-60)
end

function Universe:newWaveSize()
    self.waveSize = (self.waveSize or 2) + 2
    if  self.waveSize > 11 then self.waveSize = 11 end
    return self.waveSize
end

function Universe:adjustedRotationStep()
    return self.processorRatio*self.rotationStep
end

function Universe:playStereo(aSound, anObject)
    sound(aSound, 1, 1, 2*anObject.pos.x/WIDTH - 1)
end
