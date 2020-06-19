-- Targeter
-- RJ 20200615

Targeter = class()

function Targeter:init(shooter,target)
    self.saucer = shooter
    self.target = target
    self.deltaPos = target.pos-shooter.pos
    self.deltaVee = target.step-shooter.step
    self.shotSpeed = shooter.shotSpeed
end

function Targeter:timeToTarget()
    local a = self.deltaVee:dot(self.deltaVee) - self.shotSpeed*self.shotSpeed
    local b = 2*self.deltaVee:dot(self.deltaPos)
    local c = self.deltaPos:dot(self.deltaPos)
    local desc = b*b - 4*a*c
    if desc > 0 then
        return 2*c/(math.sqrt(desc) - b)
    else
        return -1
    end
end

function Targeter:fireDirection()
    local dt = self:timeToTarget()
    if dt < 0 then return vec2(1,0):rotate(2*math.pi*math.random()) end
    local trueAimPoint = self.target.pos + self.target.step*dt
    local relativeAimPoint = trueAimPoint - self.saucer.pos
    local offsetAimPoint = relativeAimPoint - dt*self.saucer.step
    local dir = offsetAimPoint:normalize()
    return dir
end