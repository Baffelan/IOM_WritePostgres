function fast_svd(A::Array{R, 2}, d::Int) where R<:AbstractFloat
    dim = size(A)

    V = Array{R, 2}(undef, dim[2], d)
    U = Array{R, 2}(undef, dim[1], d)
    S = Array{R, 1}(undef, d)

    V = BLAS.syrk('U', 'T', 1.0, A)
    (S, V) = LAPACK.syevr!('V', 'I', 'U', V, 0., 0., dim[2]-d+1, dim[2], 0.)

    reverse!(S)
    @inbounds for i = 1:d
        @turbo S[i] = sqrt(S[i])
    end

    V = reverse(V; dims = 2)
    U = BLAS.gemm('N', 'N', A, V)

    # TODO check if the loop order is optimal
    @inbounds for i = 1:d
      @inbounds for j = 1:dim[1]
        U[j, i] /= S[i]
      end
    end

    return LinearAlgebra.SVD(U, S, V')
end