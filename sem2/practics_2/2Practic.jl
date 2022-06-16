#Алгоритмы из лекции 1
#Рекурентный бинарный поиск
function bin_search(a, A, l, r)
    if l > r
        return false
    end
    mid = (l + r + 1) ÷ 2 

    if A[mid] == a 
        return true
    end
    if a > A[mid]
        return binary_search(a, A, i + 1, r)
    else
        return binary_search(a, A, l, i - 1)
    end
end

#Функция len, для массива
function len(A)
    res = 0
    for i in A
        len += 1
    end
    return res    
end

#Функция для подсчета суммы элементов в массиве
function sum_(A::AbstractVector{T}) where T
    res = T(0)
    for a in A
        res += a
    end
    return res
end

#Функция для подсчета произведения элементов в массиве
function prod_(A)
    res = eltype(A)(1)
    for a in A
        res *= a
    end
    return res
end

#Функция поиска максимума
function max_(A)
    M = typemin(eltype(A)) # m = -Inf
    for a in A
        M = max(M,a)
    end
    return M
end
#Функция поиска минимума
function min_(A)
    m = typemin(eltype(A)) # m = -Inf
    for a in A
        m = min(m,a)
    end
    return m
end

#Функция поиска среднего значения
function Mean(A::AbstractVector{T}) where T
    s = T(0)
    i = 0
    for a in A
        i += 1
        s += a
    end
    return s / i
end

#Реализация функции is_perm
function _isperm(p)
    n = length(p)
    used = falses(n) # возвращает нулевой BitVector длины n
    for i in p
        (i in 1:n) && (used[i] ⊻= true) || return false # значек ⊻ - обозначает "исключающее или" 
    end
    true
end

#Реализация функции permute!
function _permute!(A, p) 
    for i in eachindex(p)
        if p[i] < 0
            continue
        end 
        # i - начало очередной циклической перестановки индексов массива A            
        buff = A[i]
        j_prew, j = i, p[i] # - индекс элемента исходного массива, который требуется переместить на i-ю позицию                  
        p[i] = -p[i]
        while j != i # - пока циклическая перестановка индексов не "замкнулась"               
            A[j_prew] = A[j]
            j_prew, j = j, p[j]            
            p[j_prew] = -p[j_prew]
        end        
        A[j_prew] = buff 
        # перемещения элементов массива A по очередному циклу (по очередной циклической перестановке индексов) полностью завершены
    end
    for i in eachindex(p)
        p[i] = -p[i]
    end        
    return A
end

#Реализация invpermute - выолняющая обратную перестановку
function _invpermute!(A, p)
    for i in p
        if i > 0
            A[i], A[p[i]] = A[p[i]], A[i]
            p[i] = -p[i]
        end
    end
    for i in eachindex(p)
        p[i] = -p[i]
    end
    return A   
end

#Функция reverse
function _reverse!(a)
    for i in 1:length(a) ÷ 2
        a[i], a[end-i+1] = a[end-i+1], a[i] 
    end
end
