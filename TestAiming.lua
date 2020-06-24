-- TestAiming
-- RJ 20200624
    
function testAiming()
    --CodeaUnit.detailed = true
    CodeaUnit.oldU = nil
    
    local gun
    local tgt
    local aim
    local ang

    _:describe("Aiming Tests", function()

        _:before(function()
            CodeaUnit.oldU = U
            U = Universe()
        end)

        _:after(function()
            U = CodeaUnit.oldU
        end)
        
        _:test("Hookup", function()
            _:expect( 2+1 ).is(3)
        end)
        
        _:test("Pure Aiming Angle 45", function()
            gun = vec2(400,400)
            tgt = vec2(600,600)
            aim = Aimer(gun,tgt)
            ang = math.deg(aim:pureAngle())
            _:expect(ang).is(45)
        end)
        
        _:test("Pure Aiming Angle -45", function()
            gun = vec2(400,400)
            tgt = vec2(600,200)
            aim = Aimer(gun,tgt)
            ang = math.deg(aim:pureAngle())
            _:expect(ang).is(-45)
        end)
        
        
    end)
end

Aimer = class()

function Aimer:init(gunPos,tgtPos)
    self.gunPos = gunPos
    self.tgtPos = tgtPos
end

function Aimer:pureAngle()
    local toTarget = self.tgtPos - self.gunPos
    return vec2(0,0):angleBetween(toTarget)
end
