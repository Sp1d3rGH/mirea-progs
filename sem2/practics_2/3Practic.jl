function comb_sort!(A)
    g = length(A)
    flag = true
    while g != 1 || flag == true
        g /= 1.2473309
        if g < 1
            g = 1
        end
        flag = false
        for i in 1:length(A)-floor(Int, g)
            if A[i] > A[i+floor(Int, g)]
                A[i], A[i+floor(Int, g)] = A[i+floor(Int, g)], A[i]
                flag = true
            end
        end
    end
end

function bubblesort!(a)
    n = length(a)
    for k in 1:n-1
        is_sorted = true
        for i in 1:n-k
            if a[i]>a[i+1]
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

A = rand(50000)
B = deepcopy(A)

println("bubblesort ", @elapsed bubblesort!(A))
println("comb_sort ", @elapsed comb_sort!(B))
