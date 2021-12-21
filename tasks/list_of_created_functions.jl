using HorizonSideRobots

# Инвертировать side
"""side = HorizonSide(mod(Int(side) + 2, 4))"""

# Идти в сторону side, маркируя до упора
function markside(r, side::HorizonSide)
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

# Идти в сторону side n шагов
function move_n(r::Robot, side::HorizonSide, n::Int)
    for i in 1:n
        move!(r, side)
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