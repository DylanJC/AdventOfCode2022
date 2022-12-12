import SwiftUI
import Foundation

// This code is rough lol. A lot of shortcuts. a lot of little type issues

struct Stack<Element> {
    private var items: [Element] = []
        
    mutating func pop() -> Element {
        items.removeLast()
    }
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    var topItem: Element? {
        return items.last
    }
}

func setUpMyStacks(with lines: [String]) -> [Stack<Character>] {
    let regex = /(\d)/
    if let result = lines.last?.matches(of: regex) {
//        print(result.last)
    }
    
    let numStacks = Int(String((lines.last?.last(where: { $0 != " " }))!)) ?? 0
    
    var stacks: [Stack<Character>] = []
    
    for _ in 0..<numStacks {
        var stack = Stack<Character>()
        stacks.append(stack)
    }
    
    var countingIndex = 1
    var curStack = 0
    
    for i in stride(from:lines.count - 2, to: -1, by: -1) {
        let line = lines[i]
        while curStack < numStacks {
            let index = line.index(line.startIndex, offsetBy: countingIndex)
            let char = line[index]
            if char != " " {
                stacks[curStack].push(char)
            }
            
            countingIndex += 4
            curStack += 1
        }
        countingIndex = 1
        curStack = 0
    }
    return stacks
}

// should be able to make the stack here a stack of generics
// Part 1
func make(_ move: String, for stacks: inout [Stack<Character>]) {
    let regex = /move (\d+) from (\d+) to (\d+)/
    if let result = move.firstMatch(of: regex) {
        let num = Int(String(result.1))!
        let fromStack = Int(String(result.2))! - 1
        let toStack = Int(String(result.3))! - 1
        
        for _ in 0..<num {
            stacks[toStack].push(stacks[fromStack].pop())
        }
    }
}

// Part 2
func makeBig(_ move: String, for stacks: inout [Stack<Character>]) {
    let regex = /move (\d+) from (\d+) to (\d+)/
    if let result = move.firstMatch(of: regex) {
        let num = Int(String(result.1))!
        let fromStack = Int(String(result.2))! - 1
        let toStack = Int(String(result.3))! - 1
        
        var tmpStack = Stack<Character>()
        for _ in 0..<num {
            tmpStack.push(stacks[fromStack].pop())
        }
        for _ in 0..<num {
            stacks[toStack].push(tmpStack.pop())
        }
    }
}

if let fileURL = Bundle.main.url(forResource: "day5Input", withExtension: "txt") {
    let contents = try String(contentsOf: fileURL)
    let lines = contents.split(separator: "\n").compactMap( { String($0) } )
    
    var stacks = setUpMyStacks(with: Array(lines[0...8]))
    for move in lines[9...] {
        if move == "" {
            break
        }
        makeBig(move, for: &stacks)
    }
    
    let topLetters = stacks.compactMap({ $0.topItem })

    print("Top letters of the stacks: \(String(topLetters))")
}


