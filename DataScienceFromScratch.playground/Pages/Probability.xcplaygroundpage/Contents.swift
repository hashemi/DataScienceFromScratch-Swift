//: [Previous](@previous)

//: # Probability

import Darwin

enum Kid: CaseIterable {
    case boy, girl
}

func randomKid() -> Kid { Kid.allCases.randomElement()! }

var bothGirls = 0
var olderGirl = 0
var eitherGirl = 0

for _ in 0..<1000 {
    switch (randomKid(), randomKid()) {
    case (.girl, .girl):
        olderGirl += 1
        bothGirls += 1
        eitherGirl += 1
    case (.girl, .boy):
        olderGirl += 1
        eitherGirl += 1
    case (.boy, .girl):
        eitherGirl += 1
    case (.boy, .boy): break
    }
}

print("P(both | older):", Double(bothGirls) / Double(olderGirl))
print("P(both | either):", Double(bothGirls) / Double(eitherGirl))

func uniformPdf(_ x: Double) -> Double {
    0 <= x && x < 1 ? 1 : 0
}

func uniformCdf(_ x: Double) -> Double {
    x < 0 ? 0
        : x < 1 ? x
        : 1
}

let SQRT_TWO_PI = (Double.pi * 2).squareRoot()



func normalPdf(_ x: Double, mu: Double = 0, sigma: Double = 1) -> Double {
//    (exp(-(x-mu) ** 2 / 2 / sigma ** 2) / (SQRT_TWO_PI * sigma))
    (exp(-pow((x - mu), 2) / 2 / pow(sigma, 2)) / (SQRT_TWO_PI * sigma))
}

let xs = (-50..<50).map { Double($0) / 10 }

xs.map { normalPdf($0, sigma: 0.5) }

xs.map { normalPdf($0, sigma: 2) }

func normalCdf(_ x: Double, mu: Double = 0, sigma: Double = 1) -> Double {
    (1 + erf((x - mu) / sqrt(2.0) / sigma)) / 2
}

xs.map { normalCdf($0) }

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

func bernoulliTrial(_ p: Double) -> Int {
    Double.random(in: 0..<1) < p ? 1 : 0
}

func binomial(_ n: Int, _ p: Double) -> Int {
    (0..<n)
        .map { _ in bernoulliTrial(p) }
        .reduce(0, +)
}

//: [Next](@next)
