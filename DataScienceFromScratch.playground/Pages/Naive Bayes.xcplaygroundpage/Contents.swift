//: [Previous](@previous)

// -- prev code
func splitData<T>(_ data: [T], _ prob: Double) -> ([T], [T]) {
    let shuffled = data.shuffled()
    let cut = Int(Double(data.count) * prob)
    return (Array(shuffled[..<cut]), Array(shuffled[cut...]))
}

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
// --

import Foundation

func tokenize(_ text: String) -> Set<String> {
    let text = text.lowercased()
    var tokens: Set<String> = []
    var curIdx = text.unicodeScalars.startIndex
    var cur: UnicodeScalar { text.unicodeScalars[curIdx] }
    var isAtEnd: Bool { curIdx == text.unicodeScalars.endIndex }
    var validChar: Bool { (cur >= "a" && cur <= "z") || (cur >= "0" && cur <= "9") || cur == "'" }
    func skip(cond: () -> Bool) {
        while !isAtEnd && cond() {
            curIdx = text.index(after: curIdx)
        }
    }
    
    skip { !validChar }
    while !isAtEnd {
        let start = curIdx
        skip { validChar }
        tokens.insert(String(text[start..<curIdx]))

        // skip unwanted characters
        skip { !validChar }
    }
    return tokens
}

assert(tokenize("Data Science is science") == Set(["data", "science", "is"]))

struct Message {
    let text: String
    let isSpam: Bool
}

struct NaiveBayesClassifier {
    let k: Double
    var tokens: Set<String> = []
    var tokenHamCounts: [String: Int] = [:]
    var tokenSpamCounts: [String: Int] = [:]
    var hamMessages = 0
    var spamMessages = 0
    
    init(k: Double = 0.5) {
        self.k = k
    }
    
    mutating func train(_ messages: [Message]) {
        for message in messages {
            if message.isSpam {
                spamMessages += 1
            } else {
                hamMessages += 1
            }
            
            for token in tokenize(message.text) {
                tokens.insert(token)
                if message.isSpam {
                    tokenSpamCounts[token, default: 0] += 1
                } else {
                    tokenHamCounts[token, default: 0] += 1
                }
            }
        }
    }
    
    private func probabilities(_ token: String) -> (Double, Double) {
        let spam = tokenSpamCounts[token, default: 0]
        let ham = tokenHamCounts[token, default: 0]
        
        let pTokenSpam = (Double(spam) + k) / (Double(spamMessages) + 2 * k)
        let pTokenHam = (Double(ham) + k) / (Double(hamMessages) + 2 * k)
        
        return (pTokenSpam, pTokenHam)
    }
    
    func predict(_ text: String) -> Double {
        let textTokens = tokenize(text)
        var logProbIfHam = 0.0
        var logProbIfSpam = 0.0
        
        for token in tokens {
            let (probIfSpam, probIfHam) = probabilities(token)
            
            if textTokens.contains(token) {
                logProbIfSpam += log(probIfSpam)
                logProbIfHam += log(probIfHam)
            } else {
                logProbIfSpam += log(1 - probIfSpam)
                logProbIfHam += log(1 - probIfHam)
            }
        }
        
        let probIfSpam = exp(logProbIfSpam)
        let probIfHam = exp(logProbIfHam)
        
        return probIfSpam / (probIfSpam + probIfHam)
    }
}


let messages = [
    Message(text: "spam rules", isSpam: true),
    Message(text: "ham rules", isSpam: false),
    Message(text: "hello ham", isSpam: false),
]

var model = NaiveBayesClassifier(k: 0.5)
model.train(messages)

assert(model.tokens == ["spam", "ham", "rules", "hello"])
assert(model.spamMessages == 1)
assert(model.hamMessages == 2)
assert(model.tokenSpamCounts == ["spam": 1, "rules": 1])
assert(model.tokenHamCounts == ["ham": 2, "rules": 1, "hello": 1])


let text = "hello spam"
let probsIfSpam = [
    (1 + 0.5) / (1 + 2 * 0.5),      // "spam"  (present)
    1 - (0 + 0.5) / (1 + 2 * 0.5),  // "ham"   (not present)
    1 - (1 + 0.5) / (1 + 2 * 0.5),  // "rules" (not present)
    (0 + 0.5) / (1 + 2 * 0.5)       // "hello" (present)
]

let probsIfHam = [
    (0 + 0.5) / (2 + 2 * 0.5),      // "spam"  (present)
    1 - (2 + 0.5) / (2 + 2 * 0.5),  // "ham"   (not present)
    1 - (1 + 0.5) / (2 + 2 * 0.5),  // "rules" (not present)
    (1 + 0.5) / (2 + 2 * 0.5),      // "hello" (present)
]

let pIfSpam = exp(probsIfSpam.map(log).reduce(0, +))
let pIfHam = exp(probsIfHam.map(log).reduce(0, +))

//assert(model.predict("hello spam") == pIfSpam / (pIfSpam + pIfHam))

let hamUrls = Bundle.main.urls(forResourcesWithExtension: nil, subdirectory: "spam_data/easy_ham")!
    + Bundle.main.urls(forResourcesWithExtension: nil, subdirectory: "spam_data/hard_ham")!
let spamUrls = Bundle.main.urls(forResourcesWithExtension: nil, subdirectory: "spam_data/spam")!

func getSubject(_ url: URL) -> String? {
    guard let sub = try? String(contentsOf: url)
        .split(separator: "\n")
        .first { $0.hasPrefix("Subject: ") }?
        .dropFirst(9)
    else { return nil }
    
    return String(sub)
}

let hamMessages = hamUrls
    .compactMap(getSubject)
    .map { Message(text: $0, isSpam: false) }

let spamMessages = spamUrls
    .compactMap(getSubject)
    .map { Message(text: $0, isSpam: true) }

let (trainMessages, testMessages) = splitData(spamMessages + hamMessages, 0.75)

var model2 = NaiveBayesClassifier()
model2.train(trainMessages)

let predictions = testMessages.map { ($0, model2.predict($0.text)) }

let confusionMatrix = Dictionary(
    predictions
        .map { (message, spamProbability) in
            (Pair(message.isSpam, spamProbability > 0.5), 1)
        },
    uniquingKeysWith: +
)

print(confusionMatrix)

extension NaiveBayesClassifier {
    func pSpamGivenToken(_ token: String) -> Double {
        let (probIfSpam, probIfHam) = self.probabilities(token)
        return probIfSpam / (probIfSpam + probIfHam)
    }
}

let words = Array(model2.tokens)
    .sorted { model2.pSpamGivenToken($0) > model2.pSpamGivenToken($1) }

print("spammiest_words", words[..<10])
print("hammiest_words", words[(words.count - 10)...])

//: [Next](@next)
