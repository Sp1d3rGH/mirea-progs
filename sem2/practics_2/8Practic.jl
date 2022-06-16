#Вычисление частичной суммы степенного ряда
#Эффективный код a_k = a_(k- 1)/k
function task1(n)
    s = 0.0
    a = 1.0
    for k in 1:n+1 
        s += a
        a /= k
    end
    return s
end

#Суммирование сходящегося ряда с заданной точностью
function Base.sin(x,ε)
    xx=x^2
    a=x
    k=1
    s=typeof(x)(0) # - преобразование к 0 нужного типа, что обеспечит стабильность типа переменной s
    while abs(a)>ε
        s+=a
        a=-a*xx/2k/(2k+1)
        k+=1
    end
    #УТВ: |sin(x)-s|<= ε
    return s
end

#"Вычислим сумму" этого (расходящегося) ряда, воспользовавшись прежним приёмом численного суммирования.
function harmonic_sum()
    s=0.0
    k=1
    a=1.0
    while s+a != s
        a=1/k
        s+=a 
        k+=1
    end
    return s
end