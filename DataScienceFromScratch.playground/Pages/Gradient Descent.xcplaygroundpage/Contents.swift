//: [Previous](@previous)

import Darwin

// -- previous code
typealias Vector = Array<Double>
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

func scalarMultiply(_ c: Double, _ v: Vector) -> Vector {
    v.map { $0 * c }
}

func vectorMean(_ vectors: [Vector]) -> Vector {
    scalarMultiply(1/Double(vectors.count), vectorSum(vectors))
}

func dot(_ v: Vector, _ w: Vector) -> Double {
    precondition(v.count == w.count, "vectors must be same length")
    return zip(v, w).map(*).reduce(0, +)
}

func add(_ v: Vector, _ w: Vector) -> Vector {
    precondition(v.count == w.count, "vectors must be the same length")
    return zip(v, w).map(+)
}

func subtract(_ v: Vector, _ w: Vector) -> Vector {
    precondition(v.count == w.count, "vectors must be the same length")
    return zip(v, w).map(-)
}

func magnitude(_ v: Vector) -> Double {
    sumOfSquares(v).squareRoot()
}

func distance(_ v: Vector, _ w: Vector) -> Double {
    magnitude(subtract(v, w))
}
// --

func sumOfSquares(_ v: Vector) -> Double {
    dot(v, v)
}

func differenceQuotient(_ f: (Double) -> Double, _ x: Double, _ h: Double) -> Double {
    (f(x + h) - f(x)) / h
}

func square(_ x: Double) -> Double { x * x }
func derivative(_ x: Double) -> Double { 2 * x }

let xs = (-10..<11).map(Double.init)
let actuals = xs.map(derivative)
let estimates = xs.map { differenceQuotient(square, $0, 0.001) }

func partialDifferenceQuotient(_ f: (Vector) -> Double, _ v: Vector, _ i: Int, _ h: Double) -> Double {
    let w = v.enumerated().map { j, vj in
        vj + ((j == i) ? h : 0)
    }
    
    return (f(w) - f(v)) / h
}

func estimateGradient(_ f: (Vector) -> Double, _ v: Vector, _ h: Double = 0.0001) -> Vector {
    (0..<v.count).map { partialDifferenceQuotient(f, v, $0, h) }
}

func gradientStep(_ v: Vector, _ gradient: Vector, _ stepSize: Double) -> Vector {
    precondition(v.count == gradient.count)
    let step = scalarMultiply(stepSize, gradient)
    return add(v, step)
}

func sumOfSquaresGradient(_ v: Vector) -> Vector {
    v.map { 2 * $0 }
}

var v = (0..<3).map { _ in Double((-10...10).randomElement()!) }

for epoch in 0..<1000 {
    let grad = sumOfSquaresGradient(v)
    v = gradientStep(v, grad, -0.01)
}

assert(distance(v, [0, 0, 0]) < 0.001)

let inputs = (-50..<50).map(Double.init).map { ($0, 20 * $0 + 5)  }

func linearGradient(_ x: Double, _ y: Double, _ theta: Vector) -> Vector {
    let slope = theta[0]
    let intercept = theta[1]
    let predicted = slope * x + intercept
    let error = predicted - y
    let squaredError = pow(error, 2) // ?
    let grad = [2 * error * x, 2 * error]
    return grad
}

var theta = [Double.random(in: -1...1), Double.random(in: -1...1)]

let learningRate = 0.001

for epoch in 0..<5000 {
    let grad = vectorMean(inputs.map { (x,y) in linearGradient(x, y, theta) })
    theta = gradientStep(theta, grad, -learningRate)
    print(epoch, theta)
}

let (slope, intercept) = (theta[0], theta[1])

assert(19.9 < slope && slope < 20.1, "slope should be about 20")
assert(4.9 < intercept && intercept < 5.1, "intercept should be about 5")


func minibatches<T>(_ dataset: [T], batchSize: Int, shuffle: Bool = true) -> AnyIterator<ArraySlice<T>> {
    
    var batchStarts = Array(stride(from: 0, to: dataset.count, by: batchSize))
    if shuffle { batchStarts.shuffle() }
    var it = batchStarts.makeIterator()

    return AnyIterator<ArraySlice<T>> {
        guard let start = it.next() else {
            return nil
        }
        
        return dataset[start..<min(start + batchSize, dataset.count)]
    }
}

theta = [Double.random(in: -1...1), Double.random(in: -1...1)]

for epoch in 0..<1000 {
    for batch in minibatches(inputs, batchSize: 20) {
        let grad = vectorMean(batch.map { (x,y) in linearGradient(x, y, theta) })
        theta = gradientStep(theta, grad, -learningRate)
    }
    print(epoch, theta)
}

let (slope2, intercept2) = (theta[0], theta[1])

assert(19.9 < slope2 && slope2 < 20.1, "slope should be about 20")
assert(4.9 < intercept2 && intercept2 < 5.1, "intercept should be about 5")

for epoch in 0..<100 {
    for (x, y) in inputs {
        let grad = linearGradient(x, y, theta)
        theta = gradientStep(theta, grad, -learningRate)
    }
    print(epoch, theta)
}

let (slope3, intercept3) = (theta[0], theta[1])
assert(19.9 < slope3 && slope3 < 20.1, "slope should be about 20")
assert(4.9 < intercept3 && intercept3 < 5.1, "intercept should be about 5")

//: [Next](@next)
