//: [Previous](@previous)

typealias User = (id: Int, name: String)

let users = [
    (id: 0, name: "Hero"),
    (id: 1, name: "Dunn"),
    (id: 2, name: "Sue"),
    (id: 3, name: "Chi"),
    (id: 4, name: "Thor"),
    (id: 5, name: "Clive"),
    (id: 6, name: "Hicks"),
    (id: 7, name: "Devin"),
    (id: 8, name: "Kate"),
    (id: 9, name: "Klein")
]

let friendshipPairs = [(0, 1), (0, 2), (1, 2), (1, 3), (2, 3), (3, 4),
                        (4, 5), (5, 6), (5, 7), (6, 8), (7, 8), (8, 9)]

let friendships = Dictionary<Int, [Int]>(
    friendshipPairs
        .flatMap { [($0.0, [$0.1]), ($0.1, [$0.0])] },
    uniquingKeysWith: +)

let totalConnections = friendships
    .values
    .map(\.count)
    .reduce(0, +)

let numUsers = users.count
let avgConnections = Double(totalConnections) / Double(numUsers)

let sorted = friendships
    .map { ($0.key, $0.value.count) }
    .sorted { $0.1 > $1.1 }

func friendsOfFriends(user: User) -> [Int: Int] {
    Dictionary(
        friendships[user.id]!
            .flatMap { friendships[$0]! }
            .filter { $0 != user.id && !friendships[user.id]!.contains($0) }
            .map { ($0, 1) },
        uniquingKeysWith: { $0 + $1 })
}

friendsOfFriends(user: users[3])

let interests = [
    (0, "Hadoop"), (0, "Big Data"), (0, "HBase"), (0, "Java"),
    (0, "Spark"), (0, "Storm"), (0, "Cassandra"),
    (1, "NoSQL"), (1, "MongoDB"), (1, "Cassandra"), (1, "HBase"),
    (1, "Postgres"), (2, "Python"), (2, "scikit-learn"), (2, "scipy"),
    (2, "numpy"), (2, "statsmodels"), (2, "pandas"), (3, "R"), (3, "Python"),
    (3, "statistics"), (3, "regression"), (3, "probability"),
    (4, "machine learning"), (4, "regression"), (4, "decision trees"),
    (4, "libsvm"), (5, "Python"), (5, "R"), (5, "Java"), (5, "C++"),
    (5, "Haskell"), (5, "programming languages"), (6, "statistics"),
    (6, "probability"), (6, "mathematics"), (6, "theory"),
    (7, "machine learning"), (7, "scikit-learn"), (7, "Mahout"),
    (7, "neural networks"), (8, "neural networks"), (8, "deep learning"),
    (8, "Big Data"), (8, "artificial intelligence"), (9, "Hadoop"),
    (9, "Java"), (9, "MapReduce"), (9, "Big Data")
]

func dataScientistsWhoLike(targetInterest: String) -> [Int] {
    interests
        .filter { $0.1 == targetInterest }
        .map { $0.0 }
}

let userIdsByInterest = Dictionary(interests.map { ($0.1, [$0.0]) }, uniquingKeysWith: +)
let interestsByUserId = Dictionary(interests.map { ($0.0, [$0.1]) }, uniquingKeysWith: +)

userIdsByInterest
interestsByUserId

func mostCommonInterestsWith(user: User) -> [Int: Int] {
    Dictionary(
        interestsByUserId[user.id]!
            .flatMap { userIdsByInterest[$0]! }
            .filter { $0 != user.id }
            .map { ($0, 1) },
        uniquingKeysWith: +)
}

let salariesAndTenures = [
    (83000, 8.7), (88000, 8.1),
    (48000, 0.7), (76000, 6),
    (69000, 6.5), (76000, 7.5),
    (60000, 2.5), (83000, 10),
    (48000, 1.9), (63000, 4.2)
]

func tenureBucket(tenure: Double) -> String {
    tenure < 2 ? "less than two"
        : tenure < 5 ? "between two and five"
        : "more than five"
}

let salaryByTenureBucket = Dictionary(
    salariesAndTenures
        .map { (tenureBucket(tenure: $0.1), [$0.0]) }
    , uniquingKeysWith: +)

let averageSalaryByBucket = salaryByTenureBucket
    .mapValues { Double($0.reduce(0, +)) / Double($0.count) }

averageSalaryByBucket

let wordsAndCounts = Dictionary(
    interests
        .flatMap { $0.1.lowercased().split(separator: " ") }
        .map { ($0, 1) },
    uniquingKeysWith: +)

wordsAndCounts

//: [Next](@next)
