using HorizonSideRobots

<<<<<<< HEAD
function маркировать_поле_с_маркерами_лесенкой(r::Robot)
    num=0
    путь = перейти_в_левый_нижний_угол_и_вернуть_путь(r)

    putmarker!(r)
    while !isborder(r,Ost)
        move!(r,Ost)
        putmarker!(r)
    end
    длинна_поля=пройти_и_вернуть_шаги(r,West)

    while !isborder(r,Nord) && длинна_поля > 0
        сколько_маркеров_надо_поставить = длинна_поля
        move!(r,Nord)
        while сколько_маркеров_надо_поставить > 0
            putmarker!(r)
            сколько_маркеров_надо_поставить -= пройти_влево_через_преграды_и_вернуть_шаги(r,Ost)
        end
        вернуться_через_препятствия(r,West)
        длинна_поля-=1
    end

    перейти_в_левый_нижний_угол(r)
    пройти_по_пути(r,путь)
end

function пройти_влево_через_преграды_и_вернуть_шаги(r::Robot, side::HorizonSide) ::Int
    num_steps=0
    while isborder(r,side) && !isborder(r,следующее_против_часовой_стрелки_направление(side))
        move!(r,следующее_против_часовой_стрелки_направление(side))
        num_steps+=1
    end
    сделано_шагов =0
    if !isborder(r,side)
        move!(r,side)
        сделано_шагов +=1
    end
    if num_steps != 0
        while isborder(r, инвертировать_направление(следующее_против_часовой_стрелки_направление(side)))
            move!(r,side)
            сделано_шагов +=1
        end
        for _ in 1:num_steps
            move!(r, инвертировать_направление(следующее_против_часовой_стрелки_направление(side)))
        end
    end
    return сделано_шагов 
end

function вернуться_через_препятствия(r::Robot, side::HorizonSide)
    сделано_шагов = 1
    while сделано_шагов !=0
        сделано_шагов = пройти_влево_через_преграды_и_вернуть_шаги(r,side)
    end
end

=======
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
>>>>>>> 989ebe7250709017f27742ae7c540a1e350aa969




<<<<<<< HEAD
function перейти_в_левый_нижний_угол_и_вернуть_путь(r::Robot) ::Array
    путь=[]
    while isborder(r,Sud)==false || isborder(r,West)==false
        if isborder(r,Sud)==false
            move!(r,Sud)
            push!(путь,Nord)
        end
        if isborder(r,West)==false
            move!(r,West)
            push!(путь,Ost)
        end
    end
    return путь
end

function перейти_в_левый_нижний_угол(r::Robot)
    while isborder(r,West)==false || isborder(r,Sud)==false
        if isborder(r,West)==false
            move!(r,West)
        end
        if isborder(r,Sud)==false
            move!(r,Sud)
        end
    end
end

function пройти_и_вернуть_шаги(r::Robot,side::HorizonSide) :: Int # show_path_after_moving
    n=0
    while isborder(r,side)==false
        move!(r,side)
        n=n+1
    end 
    return n
end

следующее_против_часовой_стрелки_направление(side::HorizonSide) = HorizonSide(mod(Int(side)+1,4))

инвертировать_направление(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

function пройти_по_пути(r::Robot,путь::Array)
    n=length(путь)
    while n>0
        move!(r,путь[n])
        n=n-1
    end
=======
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
>>>>>>> 989ebe7250709017f27742ae7c540a1e350aa969
end