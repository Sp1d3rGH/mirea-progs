using HorizonSideRobots

function stair_marking(r::Robot)
    level = 0
    x = show_path_after_moving(r, West)
    y = show_path_after_moving(r, Sud)
    
    width = show_path_after_moving(r, Ost)
    while isborder(r, West)
        move!(r, West)
    end

    while isborder(r, Nord) == false
        n = level
        while isborder(r, Ost) == false
            move!(r, Ost)
        end
        while isborder(r, West) == false
            if n <= 0
                putmarker!(r)
            end
            move!(r, West)
            n -= 1
        end
        if level - width <= 0
            putmarker!(r)
        end
        move!(r, Nord)
        level += 1
    end

    while isborder(r, Sud) == false
        move!(r, Sud)
    end
    move_n(r, Nord, y)
    move_n(r, Ost, x)
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