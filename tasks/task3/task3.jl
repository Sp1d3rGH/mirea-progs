using HorizonSideRobots

function all_field_marking(r::Robot)
    y=show_path_after_moving(r, Sud)
    x=show_path_after_moving(r, West)

    while isborder(r, Ost) == false
        move!(r, Ost)
    end
    while isborder(r, Nord) == false
        move!(r, Nord)
    end

    mark_field_right_to_left(r, Sud)

    if isborder(r, Sud)
        markside(r, Nord)
    end
    markside(r, Sud)

    move_n(r, Nord, y)
    move_n(r, Ost, x)
end

function mark_field_right_to_left(r::Robot, side::HorizonSide)
    while isborder(r, West) == false

        while isborder(r, side) == false
            putmarker!(r)    
            move!(r, side)
        end
        putmarker!(r)

        side = HorizonSide(mod(Int(side) + 2, 4))
        move!(r, West)
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

function markside(r, side::HorizonSide)
    while isborder(r, side) == false
        putmarker!(r)    
        move!(r, side)
    end
    putmarker!(r)
end

function move_n(r::Robot, side::HorizonSide, n::Int)
    for i in 1:n
        move!(r, side)
    end
end