using HorizonSideRobots

function маркировать_поле_с_перегородками(r::Robot)
    x=Ost
    y=Nord
    путь = перейти_в_левый_нижний_угол_и_вернуть_путь(r)
    while isborder(r,x)==false
        маркировать_направление(r,y)
        if !isborder(r,x)
            move!(r,x)
        end
        side_vert=инвертировать_направление(y)
    end
    маркировать_направление(r,y)
    перейти_в_левый_нижний_угол(r)
    пройти_по_пути(r,путь)
end

function маркировать_направление(r::Robot,side::HorizonSide)
    putmarker!(r)
    while пройти_в_направлении_если_возможно(r,side) == true
        putmarker!(r)
    end
    while пройти_в_направлении_если_возможно(r,инвертировать_направление(side))
        ;
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

function маркировать_направление(r,side::HorizonSide) # markside
    while isborder(r,side)==false
        putmarker!(r)    
        move!(r,side)
    end
    putmarker!(r)
end

инвертировать_направление(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

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

function пройти_по_пути(r,путь::Array)
    n=length(путь)
    while n>0
        move!(r,путь[n])
        n=n-1
    end
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
            else
                break
            end
        end
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

следующее_по_часовой_стрелке_направление(side::HorizonSide) = HorizonSide(mod(Int(side)-1,4))