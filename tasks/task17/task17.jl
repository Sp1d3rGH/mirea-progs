using HorizonSideRobots

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
end