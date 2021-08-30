//: [Previous](@previous)

import Darwin

// -- prev code
typealias Vector = Array<Double>
func dot(_ v: Vector, _ w: Vector) -> Double {
    precondition(v.count == w.count, "vectors must be same length")
    return zip(v, w).map(*).reduce(0, +)
}

func scalarMultiply(_ c: Double, _ v: Vector) -> Vector {
    v.map { $0 * c }
}

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

func vectorMean(_ vectors: [Vector]) -> Vector {
    scalarMultiply(1/Double(vectors.count), vectorSum(vectors))
}

func add(_ v: Vector, _ w: Vector) -> Vector {
    precondition(v.count == w.count, "vectors must be the same length")
    return zip(v, w).map(+)
}

func gradientStep(_ v: Vector, _ gradient: Vector, _ stepSize: Double) -> Vector {
    precondition(v.count == gradient.count)
    let step = scalarMultiply(stepSize, gradient)
    return add(v, step)
}

let numFriends = [100.0,49,41,40,25,21,21,19,19,18,18,16,15,15,15,15,14,14,13,13,13,13,12,12,11,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,8,8,8,8,8,8,8,8,8,8,8,8,8,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]

let dailyMinutes = [1,68.77,51.25,52.08,38.36,44.54,57.13,51.4,41.42,31.22,34.76,54.01,38.79,47.59,49.1,27.66,41.03,36.73,48.65,28.12,46.62,35.57,32.98,35,26.07,23.77,39.73,40.57,31.65,31.21,36.32,20.45,21.93,26.02,27.34,23.49,46.94,30.5,33.8,24.23,21.4,27.94,32.24,40.57,25.07,19.42,22.39,18.42,46.96,23.72,26.41,26.97,36.76,40.32,35.02,29.47,30.2,31,38.11,38.18,36.31,21.03,30.86,36.07,28.66,29.08,37.28,15.28,24.17,22.31,30.17,25.53,19.85,35.37,44.6,17.23,13.47,26.33,35.02,32.09,24.81,19.33,28.77,24.26,31.98,25.73,24.86,16.28,34.51,15.23,39.72,40.8,26.06,35.76,34.76,16.13,44.04,18.03,19.65,32.62,35.59,39.43,14.18,35.24,40.13,41.82,35.45,36.07,43.67,24.61,20.9,21.9,18.79,27.61,27.21,26.61,29.77,20.59,27.53,13.82,33.2,25,33.1,36.65,18.63,14.87,22.2,36.81,25.53,24.62,26.25,18.21,28.08,19.42,29.79,32.8,35.99,28.32,27.79,35.88,29.06,36.28,14.1,36.63,37.49,26.9,18.58,38.48,24.48,18.95,33.55,14.24,29.04,32.51,25.63,22.22,19,32.73,15.16,13.9,27.2,32.01,29.27,33,13.74,20.42,27.32,18.23,35.35,28.48,9.08,24.62,20.12,35.26,19.92,31.02,16.49,12.16,30.7,31.22,34.65,13.13,27.51,33.2,31.57,14.1,33.42,17.44,10.12,24.42,9.82,23.39,30.93,15.03,21.67,31.09,33.29,22.61,26.89,23.48,8.38,27.81,32.35,23.84]

let outlier = numFriends.firstIndex { $0 == 100 }
let numFriendsGood = numFriends
    .enumerated()
    .filter { $0.offset != outlier }
    .map(\.element)
let dailyMinutesGood = dailyMinutes
    .enumerated()
    .filter { $0.offset != outlier }
    .map(\.element)

func mean(_ xs: Array<Double>) -> Double {
    xs.reduce(0, +) / Double(xs.count)
}

func deMean(_ xs: Array<Double>) -> Array<Double> {
    let xBar = mean(xs)
    return xs.map { $0 - xBar }
}

func totalSumOfSquares(y: Vector) -> Double {
    deMean(y)
        .map { pow($0, 2.0) }
        .reduce(0, +)
}

func sumOfSquares(_ v: Array<Double>) -> Double {
    dot(v, v)
}

func median(_ v: Array<Double>) -> Double {
    func odd() -> Double {
        v.sorted()[v.count / 2]
    }
    
    func even() -> Double {
        let sortedXs = v.sorted()
        let hiMidpoint = v.count / 2
        return (sortedXs[hiMidpoint - 1] + sortedXs[hiMidpoint]) / 2
    }
    
    return v.count % 2 == 0 ? even() : odd()
}

func variance(_ xs: Array<Double>) -> Double {
    precondition(xs.count >= 2, "variance requires at least two elements")
    
    let n = xs.count
    let deviations = deMean(xs)
    return sumOfSquares(deviations) / Double(n - 1)
}

func standardDeviation(_ xs: Array<Double>) -> Double {
    variance(xs).squareRoot()
}

func normalCdf(_ x: Double, mu: Double = 0, sigma: Double = 1) -> Double {
    (1 + erf((x - mu) / sqrt(2.0) / sigma)) / 2
}
// --

let inputs: [[Double]] = [[1,49,4,0],[1,41,9,0],[1,40,8,0],[1,25,6,0],[1,21,1,0],[1,21,0,0],[1,19,3,0],[1,19,0,0],[1,18,9,0],[1,18,8,0],[1,16,4,0],[1,15,3,0],[1,15,0,0],[1,15,2,0],[1,15,7,0],[1,14,0,0],[1,14,1,0],[1,13,1,0],[1,13,7,0],[1,13,4,0],[1,13,2,0],[1,12,5,0],[1,12,0,0],[1,11,9,0],[1,10,9,0],[1,10,1,0],[1,10,1,0],[1,10,7,0],[1,10,9,0],[1,10,1,0],[1,10,6,0],[1,10,6,0],[1,10,8,0],[1,10,10,0],[1,10,6,0],[1,10,0,0],[1,10,5,0],[1,10,3,0],[1,10,4,0],[1,9,9,0],[1,9,9,0],[1,9,0,0],[1,9,0,0],[1,9,6,0],[1,9,10,0],[1,9,8,0],[1,9,5,0],[1,9,2,0],[1,9,9,0],[1,9,10,0],[1,9,7,0],[1,9,2,0],[1,9,0,0],[1,9,4,0],[1,9,6,0],[1,9,4,0],[1,9,7,0],[1,8,3,0],[1,8,2,0],[1,8,4,0],[1,8,9,0],[1,8,2,0],[1,8,3,0],[1,8,5,0],[1,8,8,0],[1,8,0,0],[1,8,9,0],[1,8,10,0],[1,8,5,0],[1,8,5,0],[1,7,5,0],[1,7,5,0],[1,7,0,0],[1,7,2,0],[1,7,8,0],[1,7,10,0],[1,7,5,0],[1,7,3,0],[1,7,3,0],[1,7,6,0],[1,7,7,0],[1,7,7,0],[1,7,9,0],[1,7,3,0],[1,7,8,0],[1,6,4,0],[1,6,6,0],[1,6,4,0],[1,6,9,0],[1,6,0,0],[1,6,1,0],[1,6,4,0],[1,6,1,0],[1,6,0,0],[1,6,7,0],[1,6,0,0],[1,6,8,0],[1,6,4,0],[1,6,2,1],[1,6,1,1],[1,6,3,1],[1,6,6,1],[1,6,4,1],[1,6,4,1],[1,6,1,1],[1,6,3,1],[1,6,4,1],[1,5,1,1],[1,5,9,1],[1,5,4,1],[1,5,6,1],[1,5,4,1],[1,5,4,1],[1,5,10,1],[1,5,5,1],[1,5,2,1],[1,5,4,1],[1,5,4,1],[1,5,9,1],[1,5,3,1],[1,5,10,1],[1,5,2,1],[1,5,2,1],[1,5,9,1],[1,4,8,1],[1,4,6,1],[1,4,0,1],[1,4,10,1],[1,4,5,1],[1,4,10,1],[1,4,9,1],[1,4,1,1],[1,4,4,1],[1,4,4,1],[1,4,0,1],[1,4,3,1],[1,4,1,1],[1,4,3,1],[1,4,2,1],[1,4,4,1],[1,4,4,1],[1,4,8,1],[1,4,2,1],[1,4,4,1],[1,3,2,1],[1,3,6,1],[1,3,4,1],[1,3,7,1],[1,3,4,1],[1,3,1,1],[1,3,10,1],[1,3,3,1],[1,3,4,1],[1,3,7,1],[1,3,5,1],[1,3,6,1],[1,3,1,1],[1,3,6,1],[1,3,10,1],[1,3,2,1],[1,3,4,1],[1,3,2,1],[1,3,1,1],[1,3,5,1],[1,2,4,1],[1,2,2,1],[1,2,8,1],[1,2,3,1],[1,2,1,1],[1,2,9,1],[1,2,10,1],[1,2,9,1],[1,2,4,1],[1,2,5,1],[1,2,0,1],[1,2,9,1],[1,2,9,1],[1,2,0,1],[1,2,1,1],[1,2,1,1],[1,2,4,1],[1,1,0,1],[1,1,2,1],[1,1,2,1],[1,1,5,1],[1,1,3,1],[1,1,10,1],[1,1,6,1],[1,1,0,1],[1,1,8,1],[1,1,6,1],[1,1,4,1],[1,1,9,1],[1,1,9,1],[1,1,4,1],[1,1,2,1],[1,1,9,1],[1,1,0,1],[1,1,8,1],[1,1,6,1],[1,1,1,1],[1,1,1,1],[1,1,5,1]]

func predict(x: Vector, beta: Vector) -> Double {
    dot(x, beta)
}

func error(x: Vector, y: Double, beta: Vector) -> Double {
    predict(x: x, beta: beta) - y
}

func squaredError(x: Vector, y: Double, beta: Vector) -> Double {
    pow(error(x: x, y: y, beta: beta), 2)
}

let x = [1.0, 2, 3]
let y = 30.0
let beta = [4.0, 4, 4]

assert(error(x: x, y: y, beta: beta) == -6)
assert(squaredError(x: x, y: y, beta: beta) == 36)

func SqErrorGradient(x: Vector, y: Double, beta: Vector) -> Vector {
    let err = error(x: x, y: y, beta: beta)
    return x.map { 2 * err * $0 }
}

assert(SqErrorGradient(x: x, y: y, beta: beta) == [-12.0, -24, -36])

func leastSquaresFit(xs: [Vector], ys: [Double], learningRate: Double = 0.001, numSteps: Int = 1000, batchSize: Int = 1) -> Vector {
    var guess = (0..<xs[0].count).map { _ in Double.random(in: 0..<1) }
    
    for _ in 0..<numSteps {
        for start in stride(from: 0, to: xs.count, by: batchSize) {
            let batchXs = xs[start..<min(start+batchSize, xs.count)]
            let batchYs = ys[start..<min(start+batchSize, xs.count)]
            
            let gradient = vectorMean(
                zip(batchXs, batchYs)
                    .map { (x, y) in
                        SqErrorGradient(x: x, y: y, beta: guess)
                    }
            )
            
            guess = gradientStep(guess, gradient, -learningRate)
        }
    }

    return guess
}

//let beta2 = leastSquaresFit(xs: inputs, ys: dailyMinutesGood, learningRate: 0.001, numSteps: 5000, batchSize: 25)

let beta2 = [30.51478108864945, 0.9748282216498867, -1.8506907490134552, 0.914089379346843]

assert(30.50 < beta2[0] && beta2[0] < 30.70)
assert(0.96 < beta2[1] && beta2[1] < 1.00)
assert(-1.89 < beta2[2] && beta2[2] < -1.85)
assert(0.91 < beta2[3] && beta2[3] < 0.94)

func multipleRSquared(xs: [Vector], ys: Vector, beta: Vector) -> Double {
    let sumOfSquaredErrors = zip(xs, ys)
        .map { (x, y) in
            pow(error(x: x, y: y, beta: beta), 2.0)
        }.reduce(0, +)
    return 1.0 - sumOfSquaredErrors / totalSumOfSquares(y: ys)
}

let mrs = multipleRSquared(xs: inputs, ys: dailyMinutesGood, beta: beta2)
assert(0.67 < mrs && mrs < 0.68)

func bootstrapSample<X>(data: [X]) -> [X] {
    (0..<data.count).map { _ in data.randomElement()! }
}

func bootstrapStatistic<X, Stat>(
    data: [X],
    statsFn: ([X]) -> Stat,
    numSamples: Int) -> [Stat] {
    (0..<numSamples).map { _ in statsFn(bootstrapSample(data: data)) }
}

let closeTo100 = (0..<101).map { _ in 99.5 + .random(in: 0..<1.0) }

let farFrom100 =
    [99.5 + Double.random(in: 0..<1.0)]
    + (0..<50).map { _ in Double.random(in: 0..<1.0) }
    + (0..<50).map { _ in 200 + Double.random(in: 0..<1.0)}

let mediansClose = bootstrapStatistic(data: closeTo100, statsFn: median, numSamples: 100)
let mediansFar = bootstrapStatistic(data: farFrom100, statsFn: median, numSamples: 100)

assert(standardDeviation(mediansClose) < 1)
assert(standardDeviation(mediansFar) > 90)

let learningRate = 0.001

func estimateSampleBeta(_ pairs: [(Vector, Double)]) -> Vector {
    let xSample = pairs.map { $0.0 }
    let ySample = pairs.map { $0.1 }
    
    let beta = leastSquaresFit(xs: xSample, ys: ySample, learningRate: learningRate,
                               numSteps: 5000, batchSize: 25)
    
    return beta
}

let bootstrapBetas = bootstrapStatistic(
    data: Array(zip(inputs, dailyMinutesGood)),
    statsFn: estimateSampleBeta, numSamples: 100)

let bootstrapStandardErrors = (0..<4).map { i in
    standardDeviation(bootstrapBetas.map { $0[i] })
}

print(bootstrapStandardErrors)

func pValue(_ betaHatJ: Double, _ sigmaHatJ: Double) -> Double {
    if betaHatJ > 0 {
        return 2 * (1 - normalCdf(betaHatJ / sigmaHatJ))
    } else {
        return 2 * normalCdf(betaHatJ / sigmaHatJ)
    }
}

assert(pValue(30.58, 1.27) < 0.001)
assert(pValue(0.972, 0.103) < 0.001)
assert(pValue(-1.865, 0.155) < 0.001)
assert(pValue(0.923, 1.249) > 0.4)

func ridgePenalty(beta: Vector, alpha: Double) -> Double {
    alpha * dot(Array(beta.dropFirst()), Array(beta.dropFirst()))
}

func squaredErrorRidge(x: Vector, y: Double, beta: Vector, alpha: Double) -> Double {
    pow(error(x: x, y: y, beta: beta), 2.0) + ridgePenalty(beta: beta, alpha: alpha)
}

func ridgePenaltyGradient(beta: Vector, alpha: Double) -> Vector {
    [0.0] + beta.dropFirst().map { 2 * alpha * $0 }
}

func sqErrorRidgeGradient(x: Vector, y: Double, beta: Vector, alpha: Double) -> Vector {
    add(SqErrorGradient(x: x, y: y, beta: beta), ridgePenaltyGradient(beta: beta, alpha: alpha))
}

func leastSquaresFitRidge(xs: [Vector], ys: [Double], alpha: Double,
                          learningRate: Double, numSteps: Int, batchSize: Int = 1) -> Vector {
    var guess = (0..<xs[0].count).map { _ in Double.random(in: 0..<1.0)}
    
    for _ in 0..<numSteps {
        for start in stride(from: 0, to: xs.count, by: batchSize) {
            let batchXs = xs[start..<min(start + batchSize, xs.count)]
            let batchYs = ys[start..<min(start + batchSize, ys.count)]
            
            let gradient = vectorMean(zip(batchXs, batchYs).map { (x, y) in
                sqErrorRidgeGradient(x: x, y: y, beta: guess, alpha: alpha)
            })
            
            guess = gradientStep(guess, gradient, -learningRate)
        }
    }
    
    return guess
}

let beta0 = leastSquaresFitRidge(xs: inputs, ys: dailyMinutesGood, alpha: 0.0,
                                 learningRate: learningRate, numSteps: 5000, batchSize: 25)

let dotBeta0 = dot(Array(beta0.dropFirst()), Array(beta0.dropFirst()))
let mrs0 = multipleRSquared(xs: inputs, ys: dailyMinutesGood, beta: beta0)
assert(5 < dotBeta0 && dotBeta0 < 6)
assert(0.67 < mrs0 && mrs0 < 0.69)

let beta01 = leastSquaresFitRidge(xs: inputs, ys: dailyMinutesGood, alpha: 0.1,
                                 learningRate: learningRate, numSteps: 5000, batchSize: 25)

let dotBeta01 = dot(Array(beta01.dropFirst()), Array(beta01.dropFirst()))
let mrs01 = multipleRSquared(xs: inputs, ys: dailyMinutesGood, beta: beta01)
assert(4 < dotBeta01 && dotBeta01 < 5)
assert(0.67 < mrs01 && mrs01 < 0.69)

let beta1 = leastSquaresFitRidge(xs: inputs, ys: dailyMinutesGood, alpha: 1.0,
                                 learningRate: learningRate, numSteps: 5000, batchSize: 25)

let dotBeta1 = dot(Array(beta1.dropFirst()), Array(beta1.dropFirst()))
let mrs1 = multipleRSquared(xs: inputs, ys: dailyMinutesGood, beta: beta1)
assert(3 < dotBeta1 && dotBeta1 < 4)
assert(0.67 < mrs1 && mrs1 < 0.69)

let beta10 = leastSquaresFitRidge(xs: inputs, ys: dailyMinutesGood, alpha: 10.0,
                                 learningRate: learningRate, numSteps: 5000, batchSize: 25)

let dotBeta10 = dot(Array(beta10.dropFirst()), Array(beta10.dropFirst()))
let mrs10 = multipleRSquared(xs: inputs, ys: dailyMinutesGood, beta: beta10)
assert(1 < dotBeta10 && dotBeta10 < 2)
assert(0.67 < mrs10 && mrs10 < 0.69)

//: [Next](@next)
