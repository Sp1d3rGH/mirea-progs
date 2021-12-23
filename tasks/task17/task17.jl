using HorizonSideRobots

function stairs_marking_with_obstacles(r::Robot)
    back_track = go_to_bottom_left_corner_return_path(r)

    putmarker!(r)
    while isborder(r, Ost) == false
        move!(r, Ost)
        putmarker!(r)
    end
    width = show_path_after_moving(r, West)

    while isborder(r, Nord) == false
        width_temp = width
        move!(r, Nord)
        while width_temp > 0
            putmarker!(r)
            width_temp -= move_through_obstacle_and_return_step_count(r, Ost)
        end
        
        step_count = 1
        while step_count !=0
            step_count = move_through_obstacle_and_return_step_count(r, West)
        end

        width -= 1
    end

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

function move_through_obstacle_and_return_step_count(r::Robot, side::HorizonSide)
    n = 0
    side_side = HorizonSide(mod(Int(side)+1,4)) # Следующее направление против часовой стрелки
    while isborder(r, side) && (isborder(r, side_side) == false) # Следующее против часовой стрелки
        move!(r, side_side)
        n += 1
    end
    step_count = 0
    if isborder(r, side) == false
        move!(r, side)
        step_count += 1
    end
    if n != 0
        while isborder(r, HorizonSide(mod(Int(side_side) + 2, 4)))
            move!(r,side)
            step_count +=1
        end
        for i in 1:n
            move!(r, HorizonSide(mod(Int(side_side) + 2, 4)))
        end
    end
    return step_count
end

function show_path_after_moving(r::Robot, side::HorizonSide)
    n = 0
    while isborder(r, side)==false
        move!(r, side)
        n = n + 1
    end 
    return n
end