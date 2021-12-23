using HorizonSideRobots

function find_marker(r::Robot)
    side = Ost
    spiral_side = 1
    while ismarker(r) == false
        for i in 1:2 # Каждые два поворота нужно увеличить длину стороны спирали на 1
            move_in_spiral(r, side, spiral_side)
            side = HorizonSide(mod(Int(side) - 1, 4)) # Следующее направление по часовой стрелке
        end
        spiral_side += 1
    end
end

function move_in_spiral(r::Robot, side::HorizonSide, n::Int)
    for i in 1:n
        if ismarker(r)
            return 0
        end
        move!(r, side)
    end
end