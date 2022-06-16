#Реализация функции findall
function Findall(A, a)
    res = []
    for i in 1:length(A)
        if A[i] == a
            push!(s, i)
        end
    end
    return res
end

#Реализация функции findfirst
function Findfirst(A, a)
    for i in 1:length(A)
        if A[i] == a
            return i 
        end
    end
    return nothing
end

#Реализация функции findlast
function Findlast(A, a)
    res = nothing
    for i in 1:length(A)
        if A[i] == a
            res = i 
        end
    end
    return res
end

#Реализация функции filter
function Filter(f, A)
    res = []
    for i in 1:length(A)
        if f(A[i]) != false
            push!(s, A[i])
        end
    end
    return res
end

#Реализация функции issorted, проверка на отсортированность массива
function issorted(A)
    for i in 1:length(A)-1
        if A[i] > A[i + 1]
            return false
        end
    end
    return true
end


#Реализация bubblesort, так же реализация 4мя видами функций
function bubblesort!(a)
    n = length(a)
    for k in 1:n-1
        is_sorted = true
        for i in 1:n-k
            if by(a[i])>by(a[i+1])
                a[i], a[i+1] = a[i+1], a[i]
                is_sorted = false
            end
        end
        if is_sorted
            break
        end
    end
    return a
end
bubblesort(a) = bubblesort!(deepcopy(a))

function bubblesortperm!(a)
    n = length(a)
    indexes = collect(1:n)
    for k in 1:n-1
        is_sorted = true
        for i in 1:n-k
            if by(a[i]) > by(a[i+1])
                a[i], a[i+1] = a[i+1], a[i]
                indexes[i], indexes[i+1] = indexes[i+1], indexes[i]
                is_sorted = false
            end
        end
        if is_sorted
            break
        end
    end
    return indexes
end
bubblesortperm(a) = bubblesortperm!(deepcopy(a))
