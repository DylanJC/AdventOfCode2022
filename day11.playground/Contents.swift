import Foundation

struct Monkey {
    var items: [Int]
    var numInspections = 0
    var testNum: Int
    var trueMonkey: Int
    var falseMonkey: Int
    
    var op: String
    var val: String
    
    
    func operation(old: Int) -> Int {
        var toAddOrMult = 0
        if val == "old" {
            toAddOrMult = old
        } else {
            toAddOrMult = Int(val) ?? 0
        }
        
        if op == "+" {
            return old + toAddOrMult
        } else if op == "*" {
            return old * toAddOrMult
        }
        
        return 0
    }
}

func initializeMonkeys(lines: [String], monkeys: inout [Monkey]) {
    var startIndex = 0
    var endIndex = 5
    
    while endIndex < lines.count {
        let items = lines[startIndex + 1].matches(of: /\d+/).compactMap({ Int($0.output) })

        let operation = lines[startIndex + 2].firstMatch(of: /Operation: new = old (.) (.+)/)
        let op = String(operation?.output.1 ?? "")
        let val = String(operation?.output.2 ?? "")
        
        let testNum = Int(lines[startIndex + 3].firstMatch(of: /\d+/)?.output ?? "0") ?? 0
        
        let trueNum = Int(lines[startIndex + 4].firstMatch(of: /\d+/)?.output ?? "0") ?? 0
        let falseNum = Int(lines[startIndex + 5].firstMatch(of: /\d+/)?.output ?? "0") ?? 0
        
        monkeys.append(Monkey(items: items, testNum: testNum, trueMonkey: trueNum, falseMonkey: falseNum, op: op, val: val))
        startIndex += 6
        endIndex += 6
    }
}

if let fileUrl = Bundle.main.url(forResource: "day11Input", withExtension: "txt") {
    let contents = try String(contentsOf: fileUrl)
    let lines = contents.split(separator: "\n").compactMap({ String($0) })
    
    var monkeys: [Monkey] = []
    
    initializeMonkeys(lines: lines, monkeys: &monkeys)
    
    // Part 1
//    for _ in 0..<20 {
//        for i in 0..<monkeys.count {
//            while !monkeys[i].items.isEmpty {
//                monkeys[i].numInspections += 1
//
//                let old = monkeys[i].items.first ?? 0
//                let new = Int(floor(Double(monkeys[i].operation(old: old)) / 3))
//                monkeys[i].items.remove(at: 0)
//                if new % monkeys[i].testNum == 0 {
//                    monkeys[monkeys[i].trueMonkey].items.append(new)
//                } else {
//                    monkeys[monkeys[i].falseMonkey].items.append(new)
//                }
//            }
//        }
//    }
    
    
    
    // Part 2
    for _ in 0..<10000 {
        for i in 0..<monkeys.count {
            while !monkeys[i].items.isEmpty {
                monkeys[i].numInspections += 1
                
                let old = monkeys[i].items.first ?? 0
                let new = Int(floor(Double(monkeys[i].operation(old: old) / 10)))
                monkeys[i].items.remove(at: 0)
                if new % monkeys[i].testNum == 0 {
                    monkeys[monkeys[i].trueMonkey].items.append(new)
                } else {
                    monkeys[monkeys[i].falseMonkey].items.append(new)
                }
            }
        }
    }
    
    
    var mostMonkey = 0
    var secondMostMonkey = 0
    
    for monkey in monkeys {
        let curInspections = monkey.numInspections
        if curInspections >= mostMonkey {
            secondMostMonkey = mostMonkey
            mostMonkey = curInspections
        } else if curInspections > secondMostMonkey {
            secondMostMonkey = curInspections
        }
    }
    
    let monkeyBusiness = mostMonkey * secondMostMonkey
    
    print("Level of monkey business: \(monkeyBusiness)")
    
    // part 2 I guessed 31943340525 and it was too high
    // part 2 I guessed 14400719993 and it was too low
}
