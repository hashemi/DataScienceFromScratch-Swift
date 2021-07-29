//: [Previous](@previous)

//: # Linear Algebra

//: ## Vectors

typealias Vector = Array<Double>

let heightWeightAge: Vector = [70, 170, 40]

let grades: Vector = [95, 80, 75, 62]

func add(_ v: Vector, _ w: Vector) -> Vector {
    precondition(v.count == w.count, "vectors must be the same length")
    return zip(v, w).map(+)
}

assert(add([1, 2, 3], [4, 5, 6]) == [5, 7, 9])

func subtract(_ v: Vector, _ w: Vector) -> Vector {
    precondition(v.count == w.count, "vectors must be the same length")
    return zip(v, w).map(-)
}

assert(subtract([5, 7, 9], [4, 5, 6]) == [1, 2, 3])

func vectorSum(_ vectors: [Vector]) -> Vector {
    precondition(vectors.count != 0, "no vectors provided!")
    
    let numElements = vectors[0].count
    precondition(vectors
            .map(\.count)
            .allSatisfy { $0 == numElements }, "different sizes!")
    
    return vectors[1...].reduce(into: vectors[0]) { res, vec in
        (0..<numElements).forEach { idx in
            res[idx] += vec[idx]
        }
    }
}

assert(vectorSum([[1, 2], [3, 4], [5, 6], [7, 8]]) == [16, 20])

func scalarMultiply(_ c: Double, _ v: Vector) -> Vector {
    v.map { $0 * c }
}

assert(scalarMultiply(2, [1, 2, 3]) == [2, 4, 6])

func vectorMean(_ vectors: [Vector]) -> Vector {
    scalarMultiply(1/Double(vectors.count), vectorSum(vectors))
}

assert(vectorMean([[1, 2], [3, 4], [5, 6]]) == [3, 4])

func dot(_ v: Vector, _ w: Vector) -> Double {
    precondition(v.count == w.count, "vectors must be same length")
    return zip(v, w).map(*).reduce(0, +)
}

assert(dot([1, 2, 3], [4, 5, 6]) == 32)

func sumOfSquares(_ v: Vector) -> Double {
    dot(v, v)
}

assert(sumOfSquares([1, 2, 3]) == 14)

func magnitude(_ v: Vector) -> Double {
    sumOfSquares(v).squareRoot()
}

assert(magnitude([3, 4]) == 5)

func squaredDistance(_ v: Vector, _ w: Vector) -> Double {
    sumOfSquares(subtract(v, w))
}

func distance(_ v: Vector, _ w: Vector) {
    magnitude(subtract(v, w))
}

//: ## Matrices

typealias Matrix = Array<Array<Double>>

let A: Matrix = [[1, 2, 3],  // A has 2 rows and 3 columns
     [4, 5, 6]]

let B: Matrix = [[1, 2],     // B has 3 rows and 2 columns
     [3, 4],
     [5, 6]]

func shape(_ A: Matrix) -> (Int, Int) {
    let numRows = A.count
    let numCols = A.isEmpty ? 0 : A[0].count
    return (numRows, numCols)
}

assert(shape([[1, 2, 3], [4, 5, 6]]) == (2, 3))

func getRow(_ A: Matrix, _ i: Int) -> Vector {
    A[i]
}

func getColum(_ A: Matrix, _ j: Int) -> Vector {
    A.map { $0[j] }
}

func makeMatrix(_ numRows: Int, _ numCols: Int, _ entryFn: (Int, Int) -> Double) -> Matrix {
    (0..<numRows).map { i in
        (0..<numCols).map { j in
            entryFn(i, j)
        }
    }
}

func identityMatrix(_ n: Int) -> Matrix {
    makeMatrix(n, n) { $0 == $1 ? 1 : 0 }
}

identityMatrix(5)

//: [Next](@next)

