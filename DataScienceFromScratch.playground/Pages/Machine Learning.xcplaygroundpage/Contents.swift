//: [Previous](@previous)

func splitData<T>(_ data: [T], _ prob: Double) -> ([T], [T]) {
    let shuffled = data.shuffled()
    let cut = Int(Double(data.count) * prob)
    return (Array(shuffled[..<cut]), Array(shuffled[cut...]))
}

let data = Array(0..<1000)
let (train, test) = splitData(data, 0.75)

train.count
test.count

assert(train.count == 750)
assert(test.count == 250)

assert((train + test).sorted() == data)

func trainTestSplit<X, Y>(xs: [X], ys: [Y], testPct: Double) -> ([X], [X], [Y], [Y]) {

    let idxs = Array(0..<(xs.count))
    let (trainIdxs, testIdxs) = splitData(idxs, 1 - testPct)
    
    return (
        trainIdxs.map { xs[$0] },
        testIdxs.map  { xs[$0] },
        trainIdxs.map { ys[$0] },
        testIdxs.map  { ys[$0] }
    )
}

let xs = Array(0..<1000)
let ys = xs.map { 2 * $0 }
let (xTrain, xTest, yTrain, yTest) = trainTestSplit(xs: xs, ys: ys, testPct: 0.25)

assert(xTrain.count == 750 && yTrain.count == 750)
assert(xTest.count == 250 && yTest.count == 250)

assert(zip(xTrain, yTrain).allSatisfy { (x, y) in y == 2 * x })
assert(zip(xTest, yTest).allSatisfy { (x, y) in y == 2 * x })

func precision(tp: Int, fp: Int, fn: Int, tn: Int) -> Double {
    Double(tp) / Double(tp + fp)
}

assert(precision(tp: 70, fp: 4930, fn: 13930, tn: 981070) == 0.014)

func recall(tp: Int, fp: Int, fn: Int, tn: Int) -> Double {
    Double(tp) / Double(tp + fn)
}

assert(recall(tp: 70, fp: 4930, fn: 13930, tn: 981070) == 0.005)

func f1Score(tp: Int, fp: Int, fn: Int, tn: Int) -> Double {
    let p = precision(tp: tp, fp: fp, fn: fn, tn: tn)
    let r = recall(tp: tp, fp: fp, fn: fn, tn: tn)
    
    return 2 * p * 4 / (p + r)
}

//: [Next](@next)
