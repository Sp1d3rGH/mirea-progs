using HorizonSideRobots

function all_field_with_obstacles_marking(r::Robot)
    back_track = go_to_bottom_left_corner_return_path(r)

    while isborder(r, Ost) == false
        n = direction_marking_return_steps_count(r, Nord) # Записывает пройденный путь, маркируя при этом клетки
        for i in 1:n # Вернуться по n шагов через препятствия
            move_through_obstacle(r, HorizonSide(mod(Int(Nord) + 2, 4)))
        end
        putmarker!(r)
        move!(r, Ost)
    end
    while isborder(r, Nord) == false
        putmarker!(r)    
        move!(r, Nord)
    end
    putmarker!(r)

    go_to_bottom_left_corner_return_path(r)
    back_by_path_o_sides(r, back_track)
end





function go_to_bottom_left_corner_return_path(r::Robot)::Array
    path = []
    while (isborder(r, Sud) == false) || (isborder(r, West) == false)
        if isborder(r, Sud) == false
            move!(r, Sud)
            push!(path, Nord)
        end
        if isborder(r, West) == false
            move!(r, West)
            push!(path, Ost)
        end
    end
    return path
end

function back_by_path_o_sides(r, path::Array)
    n = length(path)
    while n > 0
        move!(r, path[n])
        n = n - 1
    end
end

function direction_marking_return_steps_count(r::Robot, side::HorizonSide)
    n = 0 
    while move_through_obstacle(r, side) == true
        putmarker!(r)
        n += 1
    end 
    return n
end

function mark_n_back(r::Robot, side::HorizonSide)
    while isborder(r, side) == false
        move!(r, side)
        putmarker!(r)
    end
    while ismarker(r)==true 
        move!(r, HorizonSide(mod(Int(side) + 2, 4))) # В противоположную сторону
    end
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