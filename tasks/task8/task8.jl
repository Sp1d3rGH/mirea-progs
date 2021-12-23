using HorizonSideRobots

function find_passage(r::Robot)
    side = Ost
    while isborder(r, Nord) == true
        putmarker!(r)
        while ismarker(r) == true
            if isborder(r, side) == true
                side = HorizonSide(mod(Int(side) + 2, 4))
            end
            move!(r, side)
        end
        side = HorizonSide(mod(Int(side)+2, 4))
    end
end