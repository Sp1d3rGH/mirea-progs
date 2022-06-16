using HorizonSideRobots

function obstacle_cross_marking(r::Robot)
    for side in (Nord, West, Sud, Ost)
<<<<<<< HEAD
        num_steps = direction_marking_return_steps_count(r,side)
        несколько_шагов_через_препятствия(r,инвертировать_направление(side), num_steps)
=======
        n = direction_marking_return_steps_count(r, side) # Записывает пройденный путь, маркируя при этом клетки
        for i in 1:n # Вернуться по n шагов через препятствия
            move_through_obstacle(r, HorizonSide(mod(Int(side) + 2, 4)))
        end
>>>>>>> 989ebe7250709017f27742ae7c540a1e350aa969
    end
    putmarker!(r)
end


<<<<<<< HEAD
function direction_marking_return_steps_count(r::Robot,side::HorizonSide)
    num_steps=0 
    while пройти_в_направлении_если_возможно(r, side) == true
        putmarker!(r)
        num_steps += 1
    end 
    return num_steps
end


несколько_шагов_через_препятствия(r::Robot, side::HorizonSide, num_steps::Int) =
for _ in 1:num_steps
    пройти_в_направлении_если_возможно(r,side)
end



function пройти_в_направлении_если_возможно(r::Robot, direct_side::HorizonSide)::Bool
    orthogonal_side = следующее_по_часовой_стрелке_направление(direct_side)
    reverse_side = инвертировать_направление(orthogonal_side)
    num_steps=0
    if isborder(r,direct_side)==false
        move!(r,direct_side)
        result=true
    else
        while isborder(r,direct_side) == true
            if isborder(r, orthogonal_side) == false
                move!(r, orthogonal_side)
                num_steps += 1
=======
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
>>>>>>> 989ebe7250709017f27742ae7c540a1e350aa969
            else
                break
            end
        end
<<<<<<< HEAD
        if isborder(r,direct_side) == false
            move!(r,direct_side)
            while isborder(r,reverse_side) == true
                move!(r,direct_side)
            end
            result = true
        else
            result = false
        end
        while num_steps>0
            num_steps=num_steps-1
            move!(r,reverse_side)
        end
    end
    return result
end

инвертировать_направление(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

следующее_по_часовой_стрелке_направление(side::HorizonSide) = HorizonSide(mod(Int(side)-1,4))











"""using HorizonSideRobots

function cross_marking(r::Robot)
    for i = 0:3
        mark_n_back(r, HorizonSide(i))
    end
    putmarker!(r)
end

function mark_n_back(r::Robot, side::HorizonSide)
    while try_bypass_obstacle(r, side) == true
        putmarker!(r)
        move!(r, side)
        putmarker!(r)
    end
    while ismarker(r) == true 
        try_bypass_obstacle(r, HorizonSide(mod(Int(side) + 2, 4)))
        move!(r, HorizonSide(mod(Int(side) + 2, 4)))
    end
end

function try_bypass_obstacle(r::Robot, side::HorizonSide)
    n = 0
    if side == Sud
        obstacle_is_rectangle = true
        while isborder(r, Sud)
            if isborder(r, West)
                obstacle_is_rectangle = false
                break
            end
            n += 1
            move!(r, West)
        end
        if obstacle_is_rectangle == true
            move!(r, Sud)
            while isborder(r, Ost)
                move!(r, Sud)
            end
        end
        for i in 1:n
            move!(r, Ost)
        end
        return obstacle_is_rectangle

    elseif side == Nord
        obstacle_is_rectangle = true
        while isborder(r, Nord)
            if isborder(r, West)
                obstacle_is_rectangle = false
                break
            end
            n += 1
            move!(r, West)
        end
        if obstacle_is_rectangle == true
            move!(r, Nord)
            while isborder(r, Ost)
                move!(r, Nord)
            end
        end
        for i in 1:n
            move!(r, Ost)
        end
        return obstacle_is_rectangle

    elseif side == West
        obstacle_is_rectangle = true
        while isborder(r, West)
            if isborder(r, Nord)
                obstacle_is_rectangle = false
                break
            end
            n += 1
            move!(r, Nord)
        end
        if obstacle_is_rectangle == true
            move!(r, West)
            while isborder(r, Sud)
                move!(r, West)
            end
        end
        for i in 1:n
            move!(r, Sud)
        end
        return obstacle_is_rectangle

    elseif side == Ost
        obstacle_is_rectangle = true
        while isborder(r, Ost)
            if isborder(r, Nord)
                obstacle_is_rectangle = false
                break
            end
            n += 1
            move!(r, Nord)
        end
        if obstacle_is_rectangle == true
            move!(r, Nord)
            while isborder(r, Sud)
                move!(r, Ost)
            end
        end
        for i in 1:n
            move!(r, Sud)
        end
        return obstacle_is_rectangle
    end
end"""
=======
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
>>>>>>> 989ebe7250709017f27742ae7c540a1e350aa969
