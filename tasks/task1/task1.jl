using HorizonSideRobots

function cross_marking(r::Robot)
    for i = 0:3
        mark_n_back(r, HorizonSide(i))
    end
    putmarker!(r)
end

function mark_n_back(r::Robot, side::HorizonSide)
    while isborder(r, side) == false
        move!(r, side)
        putmarker!(r)
    end
    while ismarker(r) == true 
        move!(r, HorizonSide(mod(Int(side) + 2, 4)))
    end
end