import Foundation

func checkContainment(_ first: [Int], _ second: [Int]) -> Bool {
    if (first[0] <= second[0] && first[1] >= second[1]) ||
        (second[0] <= first[0] && second[1] >= first[1]) {
        return true
    }
    return false
}

func checkOverlap(_ first: [Int], _ second: [Int]) -> Bool {
    if (first[0] <= second[0] && first[1] >= second[0]) ||
        (first[0] <= second[1] && first[1] >= second[1]) {
        return true
    }
    return false
}

if let fileURL = Bundle.main.url(forResource: "day4Input", withExtension: "txt") {
    let contents = try String(contentsOf: fileURL)
    let lines = contents.split(separator: "\n")
    
    var numContainedPairs = 0
    var totalOverlapPairs = 0
    
    let sample = ["2-4,6-8","2-3,4-5","5-7,7-9","2-8,3-7","6-6,4-6","2-6,4-8"]
    
    for line in lines {
        let assignments = line.split(separator: ",")
        let firstElf = assignments[0].split(separator: "-").compactMap({ Int($0) })
        let secondElf = assignments[1].split(separator: "-").compactMap({ Int($0) })
        
        if checkContainment(firstElf, secondElf) {
            numContainedPairs += 1
            totalOverlapPairs += 1
        } else if checkOverlap(firstElf, secondElf) {
            totalOverlapPairs += 1
        }
    }
    print("Num contained pairs: \(numContainedPairs)")
    print("Total overlap pairs: \(totalOverlapPairs)")
}
