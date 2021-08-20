//: [Previous](@previous)

// -- previous code
typealias Vector = Array<Double>

func subtract(_ v: Vector, _ w: Vector) -> Vector {
    precondition(v.count == w.count, "vectors must be the same length")
    return zip(v, w).map(-)
}

func dot(_ v: Vector, _ w: Vector) -> Double {
    precondition(v.count == w.count, "vectors must be same length")
    return zip(v, w).map(*).reduce(0, +)
}

func sumOfSquares(_ v: Vector) -> Double {
    dot(v, v)
}

func magnitude(_ v: Vector) -> Double {
    sumOfSquares(v).squareRoot()
}

func distance(_ v: Vector, _ w: Vector) -> Double {
    magnitude(subtract(v, w))
}

func splitData<T>(_ data: [T], _ prob: Double) -> ([T], [T]) {
    let shuffled = data.shuffled()
    let cut = Int(Double(data.count) * prob)
    return (Array(shuffled[..<cut]), Array(shuffled[cut...]))
}
// --

func rawMajorityVote(_ labels: [String]) -> String {
    let votes = Dictionary(labels.map { ($0, 1) }, uniquingKeysWith: +)
    return votes
        .sorted(by: { $0.value > $1.value })
        .first!
        .key
}

assert(rawMajorityVote(["a", "b", "c", "b"]) == "b")

func majorityVote(_ labels: ArraySlice<String>) -> String {
    precondition(labels.count > 0)
    
    let votes = Dictionary(labels.map { ($0, 1) }, uniquingKeysWith: +)

    let sorted = votes.sorted(by: { $0.value > $1.value })

    guard sorted.count > 1 else {
        return sorted[0].key
    }

    if sorted[0].value != sorted[1].value {
        return sorted[0].key
    } else {
        return majorityVote(labels[..<(labels.count - 1)])
    }
}

assert(majorityVote(["a", "b", "c", "b", "a"]) == "b")

struct LabeledPoint {
    let point: Vector
    let label: String
}

func knnClassify(_ k: Int, _ labeledPoints: [LabeledPoint], newPoint: Vector) -> String {
    let byDistance = labeledPoints
        .sorted {
            distance($0.point, newPoint) < distance($1.point, newPoint)
        }
    
    let kNearestLabels = byDistance[..<k].map(\.label)
    
    return majorityVote(kNearestLabels[...])
}

import Foundation

let url = Bundle.main.url(forResource: "iris", withExtension: "data")!
let contents = try String(contentsOf: url)

func parseIrisRow(_ row: [Substring]) -> LabeledPoint {
    let measurements = row[0..<(row.count-1)].map(Double.init).map(\.unsafelyUnwrapped)
    let label = String(row[row.count - 1].split(separator: "-").last!)
    
    return LabeledPoint(point: measurements, label: label)
}

let irisData = contents
    .split(separator: "\n")
    .map { parseIrisRow($0.split(separator: ",")) }

let (irisTrain, irisTest) = splitData(irisData, 0.70)
assert(irisTrain.count == Int(0.7 * 150))
assert(irisTest.count == Int(0.3 * 150))


struct Pair<A, B> {
    let f: A
    let s: B
    init(_ f: A, _ s: B) {
        self.f = f
        self.s = s
    }
}

extension Pair: Equatable, Hashable where A: Hashable, B: Hashable {
    static func ==(left: Pair<A, B>, right: Pair<A, B>) -> Bool {
        left.f == right.f && left.s == right.s
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(f)
        hasher.combine(s)
    }
}

extension Pair: CustomStringConvertible {
    var description: String { "(\(f), \(s))" }
}

var confusionMatrix: [Pair<String, String>: Int] = [:]
var numCorrect = 0

for iris in irisTest {
    let predicted = knnClassify(5, irisTrain, newPoint: iris.point)
    let actual = iris.label
    
    if predicted == actual {
        numCorrect += 1
    }
    
    confusionMatrix[Pair(predicted, actual), default: 0] += 1
}

let pctCorrect = Double(numCorrect) / Double(irisTest.count)

print(pctCorrect)
print(confusionMatrix)

//: [Next](@next)
