import Foundation

let fileName = "day1Input"

var mostCalories = [0, 0, 0]

func checkIfInTopThree(currentCalories: Int) {
    if currentCalories > mostCalories[0] {
        if currentCalories > mostCalories[1] {
            if currentCalories > mostCalories[2] {
                mostCalories[0] = mostCalories[1]
                mostCalories[1] = mostCalories[2]
                mostCalories[2] = currentCalories
            } else {
                mostCalories[0] = mostCalories[1]
                mostCalories[1] = currentCalories
            }
        } else {
            mostCalories[0] = currentCalories
        }
    }
}

if let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "txt"){
    do {
        let contents = try String(contentsOf: fileUrl, encoding: .utf8)
        let lines = contents.split(separator: "\n", omittingEmptySubsequences: false)
        
        var currentCalories = 0
        
        for numCalories in lines {
            if numCalories == "" {
                checkIfInTopThree(currentCalories: currentCalories)
                currentCalories = 0
                continue
            } else {
                currentCalories += Int(numCalories) ?? 0
            }
        }
        
        checkIfInTopThree(currentCalories: currentCalories)
        print("Top 3 Elves: \(mostCalories)")
        print("Total: \(mostCalories.reduce(0, +))")
    } catch {
        print("contents could not be loaded")
    }
}


