using HorizonSideRobots

function obstacle_cross_marking(r::Robot)
    for side in (Nord, West, Sud, Ost)
        n = direction_marking_return_steps_count(r, side) # Записывает пройденный путь, маркируя при этом клетки
        for i in 1:n # Вернуться по n шагов через препятствия
            move_through_obstacle(r, HorizonSide(mod(Int(side) + 2, 4)))
        end
    end
    putmarker!(r)
end


function direction_marking_return_steps_count(r::Robot, side::HorizonSide)
    n = 0 
    while move_through_obstacle(r, side) == true
        putmarker!(r)
        n += 1
    end 
    return n
end

function move_through_obstacle(r::Robot, forward_side::HorizonSide)::Bool
    side_side = HorizonSide(mod(Int(forward_side) - 1, 4)) # Направление в сторону обхода
    otherside_side = HorizonSide(mod(Int(side_side) + 2, 4)) # Обратное направление в сторону
    n = 0
    if isborder(r,forward_side)==false
        move!(r,forward_side)
        not_hit_border=true
    else
        while isborder(r,forward_side) == true
            if isborder(r, side_side) == false
                move!(r, side_side)
                n += 1
            else
                break
            end
        end
        if isborder(r,forward_side) == false
            move!(r,forward_side)
            while isborder(r, otherside_side) == true
                move!(r,forward_side)
            end
            not_hit_border = true
        else
            not_hit_border = false
        end
        while n > 0
            n -= 1
            move!(r, otherside_side)
        end
    end
    return not_hit_border
end