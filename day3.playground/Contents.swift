import Foundation

func findCommonItem(_ first: Substring, _ second: Substring, _ third: Substring? = nil) -> Character? {
    let firstSet = Set(first)
    
    guard let third else {
        for letter in second {
            if firstSet.contains(letter) {
                return letter
            }
        }
        return nil
    }
    
    let secondSet = Set(second)
    for letter in third {
        if firstSet.contains(letter) && secondSet.contains(letter) {
            return letter
        }
    }
    return nil
}

func priority(of commonItem: Character) -> Int {
    let alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    guard let firstIndex = alphabet.firstIndex(of: commonItem) else {
        return 0
    }
    
    return alphabet.distance(from: alphabet.startIndex, to: firstIndex) + 1
}

if let fileURL = Bundle.main.url(forResource: "day3Input", withExtension: "txt") {
    let content = try String(contentsOf: fileURL)
    let lines = content.split(separator: "\n")
    
    var prioritySum = 0
    var threeSum = 0
    
    var numElf = 1
    
    for (i, line) in lines.enumerated() {
        let lineLength = line.count / 2
        let firstPocket = line.prefix(lineLength)
        let secondPocket = line.suffix(lineLength)
        
        /// Part 1
        if let common = findCommonItem(firstPocket, secondPocket) {
            prioritySum += priority(of: common)
        }
        
        /// Part 2
        if numElf == 3 {
            if let common = findCommonItem(lines[i-2], lines[i-1], lines[i]) {
                threeSum += priority(of: common)
            }
            numElf = 1
        } else {
            numElf += 1
        }
    }
    
    print("sum of all the priorities is \(prioritySum)")
    print("sum of all the badge priorities is \(threeSum)")
}
