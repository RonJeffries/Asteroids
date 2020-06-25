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
        
        _:test("angle between", function()
            _:expect(math.deg(vec2(0,0):angleBetween(vec2(200,200)))).is(45)
            _:expect(math.deg(vec2(1,0):angleBetween(vec2(200,200)))).is(45)
            _:expect(math.deg(vec2(200,0):angleBetween(vec2(200,200)))).is(45)
        end)
        
        _:test("Pure Aiming Angle 45", function()
            gun = {pos=vec2(400,400), shotSpeed=3}
            tgt = {pos=vec2(600,600), step=vec2(0,0)}
            bullet = SaucerMissile:aimedFromSaucer(gun,tgt)
            ang = math.atan2(bullet.step.y, bullet.step.x)
            _:expect(math.deg(ang)).is(45, 0.5)
        end)
        
    end)
end
