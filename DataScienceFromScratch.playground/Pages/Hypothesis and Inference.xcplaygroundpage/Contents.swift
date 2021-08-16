//: [Previous](@previous)

//: # Hypothesis and Inference

// -- previous code
func normalCdf(_ x: Double, mu: Double = 0, sigma: Double = 1) -> Double {
    (1 + erf((x - mu) / sqrt(2.0) / sigma)) / 2
}

func inverseNormalCdf(_ p: Double, mu: Double = 0, sigma: Double = 1, tolerance: Double = 0.00001) -> Double {
    guard mu == 0 && sigma == 1 else {
        return mu + sigma * inverseNormalCdf(p, tolerance: tolerance)
    }
    
    var lowZ = -10.0
    var hiZ = 10.0
    var midZ = 0.0
    
    while hiZ - lowZ > tolerance {
        midZ = (lowZ + hiZ) / 2
        let midP = normalCdf(midZ)
        if midP < p {
            lowZ = midZ
        } else {
            hiZ = midZ
        }
    }
    return midZ
}
// --

import Darwin

func normalApproximationToBinomia(_ n: Int, _ p: Double) -> (Double, Double) {
    let mu = p * Double(n)
    let sigma = (p * (1 - p) * Double(n)).squareRoot()
    return (mu, sigma)
}

func normalProbabilityBelow(_ x: Double, mu: Double = 0, sigma: Double = 1) -> Double {
    normalCdf(x, mu: mu, sigma: sigma)
}

func normalProbabilityAbove(_ lo: Double, mu: Double = 0, sigma: Double = 1) -> Double {
    1 - normalCdf(lo, mu: mu, sigma: sigma)
}

func normalProbabilityBetween(_ lo: Double, _ hi: Double, mu: Double = 0, sigma: Double = 1) -> Double {
    normalCdf(hi, mu: mu, sigma: sigma) - normalCdf(lo, mu: mu, sigma: sigma)
}

func normalProbabilityOutside(_ lo: Double, _ hi: Double, mu: Double = 0, sigma: Double = 1) -> Double {
    1 - normalProbabilityBetween(lo, hi, mu: mu, sigma: sigma)
}

func normalUpperBound(_ probability: Double, mu: Double = 0, sigma: Double = 1) -> Double {
    inverseNormalCdf(probability, mu: mu, sigma: sigma)
}

func normalLowerBound(_ probability: Double, mu: Double = 0, sigma: Double = 1) -> Double {
    inverseNormalCdf(1 - probability, mu: mu, sigma: sigma)
}

func normalTwoSidedBounds(_ probability: Double, mu: Double = 0, sigma: Double = 1) -> (Double, Double) {
    let tailProbability = (1 - probability) / 2
    let upperBound = normalLowerBound(tailProbability, mu: mu, sigma: sigma)
    let lowerBound = normalUpperBound(tailProbability, mu: mu, sigma: sigma)
    
    return (lowerBound, upperBound)
}

let (mu0, sigma0) = normalApproximationToBinomia(1000, 0.5)

let (lo, hi) = normalTwoSidedBounds(0.95, mu: mu0, sigma: sigma0)
let (mu1, sigma1) = normalApproximationToBinomia(1000, 0.55)

let type2Probability = normalProbabilityBetween(lo, hi, mu: mu1, sigma: sigma1)
let power = 1 - type2Probability

let hi2 = normalUpperBound(0.95, mu: mu0, sigma: sigma0)

let type2Probability2 = normalProbabilityBelow(hi2, mu: mu1, sigma: sigma1)
let power2 = 1 - type2Probability2


func twoSidedPValue(_ x: Double, mu: Double = 0, sigma: Double = 1) -> Double {
    if x >= mu {
        return 2 * normalProbabilityAbove(x, mu: mu, sigma: sigma)
    } else {
        return 2 * normalProbabilityBelow(x, mu: mu, sigma: sigma)
    }
}

twoSidedPValue(529.5, mu: mu0, sigma: sigma0)

var extremeValueCount = (0..<1000).map { _ in
    let numHeads = (0..<1000)
        .map { _ in Double.random(in: 0..<1) < 0.5 ? 0 : 1 }
        .reduce(0, +)
    return (numHeads >= 530 || numHeads <= 470) ? 1 : 0
}.reduce(0, +)

assert(59 < extremeValueCount && extremeValueCount < 65, "\(extremeValueCount)")

twoSidedPValue(531.5, mu: mu0, sigma: sigma0)

let pHat = 540.0 / 1000.0
let mu = pHat
let sigma = sqrt(pHat * (1 - pHat) / 1000.0)

normalTwoSidedBounds(0.95, mu: mu, sigma: sigma)

func runExperiment() -> Array<Bool> {
    (0..<1000).map { _ in Bool.random() }
}

func rejectFairness(_ experiment: Array<Bool>) -> Bool {
    let numHeads = experiment.filter { $0 }.count
    return numHeads < 469 || numHeads > 531
}

let experiments = (0..<1000).map { _ in runExperiment() }
let numRejections = experiments.filter { rejectFairness($0) }.count

assert(numRejections == 46)

func estimatedParameters(N: Int, n: Int) -> (Double, Double) {
    let p = Double(n) / Double(N)
    let sigma = sqrt(p * (1 - p) / Double(N))
    return (p, sigma)
}

func aBTestStatistic(NA: Int, nA: Int, NB: Int, nB: Int) -> Double {
    let (pA, sigmaA) = estimatedParameters(N: NA, n: nA)
    let (pB, sigmaB) = estimatedParameters(N: NB, n: nB)
    return (pB - pA) / sqrt(pow(sigmaA, 2) + pow(sigmaB, 2))
}


let z1 = aBTestStatistic(NA: 1000, nA: 200, NB: 1000, nB: 180)
twoSidedPValue(z1)

let z2 = aBTestStatistic(NA: 1000, nA: 200, NB: 1000, nB: 150)
twoSidedPValue(z2)

func B(alpha: Double, beta: Double) -> Double {
    tgamma(alpha) * tgamma(beta) / tgamma(alpha + beta)
}

func betaPdf(_ x: Double, alpha: Double, beta: Double) -> Double {
    if x <= 0 || x >= 1 {
        return 0
    }
    return pow(x, (alpha - 1)) * pow((1 - x), (beta - 1)) / B(alpha: alpha, beta: beta)
}

//: [Next](@next)
