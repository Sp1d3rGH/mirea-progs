using HorizonSideRobots

# Инвертировать side
function reverse_side(side::HorizonSide)
    return HorizonSide(mod(Int(side) + 2, 4))
end

# Идти в сторону side, маркируя до упора
function markside(r::Robot, side::HorizonSide)
    while isborder(r, side) == false
        putmarker!(r)    
        move!(r, side)
    end
    putmarker!(r)
end

# Идти в сторону side, маркируя до упора, и вернуться к начальному положению
function mark_n_back(r::Robot, side::HorizonSide)
    while isborder(r, side) == false
        move!(r, side)
        putmarker!(r)
    end
    while ismarker(r)==true 
        move!(r, HorizonSide(mod(Int(side) + 2, 4))) # В противоположную сторону
    end
end

# Идти в сторону side и вернуть кол-во шагов
function show_path_after_moving(r::Robot, side::HorizonSide)
    n = 0
    while isborder(r, side)==false
        move!(r, side)
        n = n + 1
    end 
    return n
end

# Пройти в левый нижний угол и вернуть путь path робота
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

# Идти в сторону side n шагов
function move_n(r::Robot, side::HorizonSide, n::Int)
    for i in 1:n
        move!(r, side)
    end
end

# Вернуться в начальное положение по пути path из сторон, при условии, что робот находится в конечной точке маршрута path
function back_by_path_o_sides(r, path::Array)
    n = length(path)
    while n > 0
        move!(r, path[n])
        n = n - 1
    end
end

# Вернуться в начальное положение по пути path, при условии, что робот находится в конечной точке маршрута path
function back_by_path(r::Robot, path::Array)
    k = length(path)
    n = 1 + (k % 2)
    for i in 1:k
        n = n + 1
        side = Nord
        if n % 2 == 1
            side = Ost
        end
        move_n(r, side, path[k - i + 1])
    end
end

# Пройти вперёд, учитывая и проходя через перегородки
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