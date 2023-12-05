import Foundation

func checkSpecial(for specials: [Int], curCycle: Int, totalSignal: inout Int, register: Int) {
    for signal in specials {
        if curCycle == signal {
            totalSignal += curCycle * register
            break
        }
    }
}

func drawOn(screen: inout [String], spritePosition: Int, row: inout Int, cycle: Int) {
    if row > 5 {
        return
    }
    
    if screen[row].count == 40 {
        row += 1
    }
    
    let pos = cycle % 40 - 1
    if pos + 1 == spritePosition || pos == spritePosition || pos - 1 == spritePosition {
        screen[row].append("#")
    } else {
        screen[row].append(".")
    }
}

func addx(num: Int, screen: inout [String], spritePosition: inout Int, row: inout Int, cycle: inout Int) {
    cycle += 1
    drawOn(screen: &screen, spritePosition: spritePosition, row: &row, cycle: cycle)
    cycle += 1
    spritePosition += num
}

if let fileUrl = Bundle.main.url(forResource: "day10Input", withExtension: "txt") {
    let contents = try String(contentsOf: fileUrl)
    let lines = contents.split(separator: "\n")
    
    // Part A
    var totalSignal = 0
    var register = 1
    var curCycle = 1
    let specialSignals = [20, 60, 100, 140, 180, 220]

    for line in lines {
        checkSpecial(for: specialSignals,
                     curCycle: curCycle,
                     totalSignal: &totalSignal,
                     register: register)
        let regex = /addx (.+)/
        if let match = line.firstMatch(of: regex) {
            let numToAdd = Int(match.output.1) ?? 0
            curCycle += 1
            checkSpecial(for: specialSignals,
                         curCycle: curCycle,
                         totalSignal: &totalSignal,
                         register: register)
            curCycle += 1
            register += numToAdd
        } else {
            curCycle += 1
        }
    }

    print("Sum of signals: \(totalSignal)")
    
    // Part B
    var crtScreen: [String] = ["", "", "", "", "", ""]
    var spritePosition = 1
    var cycle = 1
    
    var row = 0
    
    for line in lines {
        drawOn(screen: &crtScreen, spritePosition: spritePosition, row: &row, cycle: cycle)
        
        let regex = /addx (.+)/
        if let match = line.firstMatch(of: regex) {
            addx(num: Int(match.output.1) ?? 0,
                 screen: &crtScreen,
                 spritePosition: &spritePosition,
                 row: &row,
                 cycle: &cycle)
        } else {
            cycle += 1
        }
    }
    
    // Display the answer
    for row in crtScreen {
        print(row)
    }
}
