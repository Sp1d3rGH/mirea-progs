using HorizonSideRobots

function sides_marking_n_return(r::Robot)
    x = show_path_after_moving(r, West)
    y = show_path_after_moving(r, Sud)
    for side in (Ost, Nord, West, Sud)
        while isborder(r, side) == false
            putmarker!(r)    
            move!(r, side)
        end
        putmarker!(r)
    end
    move_n(r, Ost, x)
    move_n(r, Nord, y)
end


function show_path_after_moving(r::Robot, side::HorizonSide)
    n = 0
    while isborder(r, side) == false
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