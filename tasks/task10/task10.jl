using HorizonSideRobots

function measure_temperature(r::Robot)
    t=0
    n=0
    side = Sud
    while isborder(r, Nord) == false
        if ismarker(r)
            t += temperature(r)
            n += 1
        end
        move!(r, Nord)
    end

    while isborder(r, Ost) == false
        move!(r, Ost)
        while isborder(r, side) == false
            if ismarker(r)
                t += temperature(r)
                n += 1
            end
            move!(r, side)
        end
        side = HorizonSide(mod(Int(side) + 2, 4))
    end
    
    ans = string(t / n)
    print("Среднее значение: " * ans)
end