//: [Previous](@previous)

//: # Statistics

let numFriends = [100.0,49,41,40,25,21,21,19,19,18,18,16,15,15,15,15,14,14,13,13,13,13,12,12,11,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,8,8,8,8,8,8,8,8,8,8,8,8,8,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]

let numPoints = numFriends.count

assert(numPoints == 204)

let largestValue = numFriends.max()!
let smallestValue = numFriends.min()!

assert(largestValue == 100)
assert(smallestValue == 1)

let sortedValues = numFriends.sorted()

let smallestValue2 = sortedValues[0]
let secondSmallestValue = sortedValues[1]
let secondLargestValue = sortedValues[sortedValues.count - 2]

assert(smallestValue2 == 1)
assert(secondSmallestValue == 1)
assert(secondLargestValue == 49)


func mean(_ xs: Array<Double>) -> Double {
    xs.reduce(0, +) / Double(xs.count)
}

mean(numFriends)

assert(7.3333 < mean(numFriends) && mean(numFriends) < 7.3334)

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

assert(median([1, 10, 2, 9, 5]) == 5)
assert(median([1, 9, 2, 10]) == (2 + 9) / 2)

assert(median(numFriends) == 6)

func quantile(_ xs: Array<Double>, _ p: Double) -> Double {
    let pIndex = Int(p * Double(xs.count))
    return xs.sorted()[pIndex]
}

assert(quantile(numFriends, 0.10) == 1)
assert(quantile(numFriends, 0.25) == 3)
assert(quantile(numFriends, 0.75) == 9)
assert(quantile(numFriends, 0.90) == 13)


func mode(_ x: Array<Double>) -> Array<Double> {
    let counters = Dictionary(x.map { ($0, 1) }, uniquingKeysWith: +)
    let maxCount = counters.values.max()
    return counters
        .filter { $0.value == maxCount }
        .map { $0.key }
}

assert(Set(mode(numFriends)) == [1, 6])

func dataRange(_ xs: Array<Double>) -> Double {
    xs.max()! - xs.min()!
}

assert(dataRange(numFriends) == 99)

func dot(_ v: Array<Double>, _ w: Array<Double>) -> Double {
    precondition(v.count == w.count, "vectors must be same length")
    return zip(v, w).map(*).reduce(0, +)
}

func sumOfSquares(_ v: Array<Double>) -> Double {
    dot(v, v)
}

func deMean(_ xs: Array<Double>) -> Array<Double> {
    let xBar = mean(xs)
    return xs.map { $0 - xBar }
}

func variance(_ xs: Array<Double>) -> Double {
    precondition(xs.count >= 2, "variance requires at least two elements")
    
    let n = xs.count
    let deviations = deMean(xs)
    return sumOfSquares(deviations) / Double(n - 1)
}

let x = variance(numFriends)

assert(81.54 < variance(numFriends) && variance(numFriends) < 81.55)

func standardDeviation(_ xs: Array<Double>) -> Double {
    variance(xs).squareRoot()
}

assert(9.02 < standardDeviation(numFriends) && standardDeviation(numFriends) < 9.04)

func interquartileRange(_ xs: Array<Double>) -> Double {
    quantile(xs, 0.75) - quantile(xs, 0.25)
}

assert(interquartileRange(numFriends) == 6)

let dailyMinutes = [1,68.77,51.25,52.08,38.36,44.54,57.13,51.4,41.42,31.22,34.76,54.01,38.79,47.59,49.1,27.66,41.03,36.73,48.65,28.12,46.62,35.57,32.98,35,26.07,23.77,39.73,40.57,31.65,31.21,36.32,20.45,21.93,26.02,27.34,23.49,46.94,30.5,33.8,24.23,21.4,27.94,32.24,40.57,25.07,19.42,22.39,18.42,46.96,23.72,26.41,26.97,36.76,40.32,35.02,29.47,30.2,31,38.11,38.18,36.31,21.03,30.86,36.07,28.66,29.08,37.28,15.28,24.17,22.31,30.17,25.53,19.85,35.37,44.6,17.23,13.47,26.33,35.02,32.09,24.81,19.33,28.77,24.26,31.98,25.73,24.86,16.28,34.51,15.23,39.72,40.8,26.06,35.76,34.76,16.13,44.04,18.03,19.65,32.62,35.59,39.43,14.18,35.24,40.13,41.82,35.45,36.07,43.67,24.61,20.9,21.9,18.79,27.61,27.21,26.61,29.77,20.59,27.53,13.82,33.2,25,33.1,36.65,18.63,14.87,22.2,36.81,25.53,24.62,26.25,18.21,28.08,19.42,29.79,32.8,35.99,28.32,27.79,35.88,29.06,36.28,14.1,36.63,37.49,26.9,18.58,38.48,24.48,18.95,33.55,14.24,29.04,32.51,25.63,22.22,19,32.73,15.16,13.9,27.2,32.01,29.27,33,13.74,20.42,27.32,18.23,35.35,28.48,9.08,24.62,20.12,35.26,19.92,31.02,16.49,12.16,30.7,31.22,34.65,13.13,27.51,33.2,31.57,14.1,33.42,17.44,10.12,24.42,9.82,23.39,30.93,15.03,21.67,31.09,33.29,22.61,26.89,23.48,8.38,27.81,32.35,23.84]

let dailyHours = dailyMinutes.map { $0 / 60 }

func covariance(_ xs: Array<Double>, _ ys: Array<Double>) -> Double {
    precondition(xs.count == ys.count, "xs and ys must have the same number of elements")
    return dot(deMean(xs), deMean(ys)) / Double(xs.count - 1)
}

assert(22.42 < covariance(numFriends, dailyMinutes) && covariance(numFriends, dailyMinutes) < 22.43)
assert((22.42 / 60) < covariance(numFriends, dailyHours) && covariance(numFriends, dailyHours) < (22.43 / 60))

func correlation(_ xs: Array<Double>, _ ys: Array<Double>) -> Double {
    let stdDevX = standardDeviation(xs)
    let stdDevY = standardDeviation(ys)
    if stdDevX > 0 && stdDevY > 0 {
        return covariance(xs, ys) / stdDevX / stdDevY
    } else {
        return 0
    }
}

assert(0.24 < correlation(numFriends, dailyMinutes) && correlation(numFriends, dailyMinutes) < 0.25)
assert(0.24 < correlation(numFriends, dailyHours) && correlation(numFriends, dailyHours) < 0.25)

let outlier = numFriends.firstIndex { $0 == 100 }
let numFriendsGood = numFriends
    .enumerated()
    .filter { $0.offset != outlier }
    .map(\.element)
let dailyMinutesGood = dailyMinutes
    .enumerated()
    .filter { $0.offset != outlier }
    .map(\.element)
let dailyHoursGood = dailyMinutesGood.map { $0 / 60 }

assert(0.57 < correlation(numFriendsGood, dailyMinutesGood) && correlation(numFriendsGood, dailyMinutesGood) < 0.58)
assert(0.57 < correlation(numFriendsGood, dailyHoursGood) && correlation(numFriendsGood, dailyHoursGood) < 0.58)

//: [Next](@next)
