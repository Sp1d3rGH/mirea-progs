using HorizonSideRobots

function corner_marking(r::Robot)
    robot_path = []
    while (isborder(r, Sud) == false) | (isborder(r, West) == false)
        push!(robot_path, show_path_after_moving(r, West))
        push!(robot_path, show_path_after_moving(r, Sud))
    end
    for side in (Nord, Ost, Sud, West)
        while isborder(r, side) == false
            move!(r, side)
        end
        putmarker!(r)
    end
    back_by_path(r, robot_path)
end

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

function show_path_after_moving(r::Robot, side::HorizonSide)
    n = 0
    while isborder(r, side)==false
        move!(r, side)
        n = n + 1
    end 
    return n
end

function move_n(r::Robot, side::HorizonSide, n::Int)
    for i in 1:n
        move!(r, side)
    end
end