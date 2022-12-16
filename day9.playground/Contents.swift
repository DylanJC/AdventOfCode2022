import Foundation

func moveHead(curPosition: inout (Int, Int), _ move: String) {
    if move == "U" {
        curPosition.1 += 1
    } else if move == "D" {
        curPosition.1 -= 1
    } else if move == "L" {
        curPosition.0 -= 1
    } else if move == "R" {
        curPosition.0 += 1
    }
}

func moveTail(tail: inout (Int, Int), head: (Int, Int)) {
    if tail == head {
        return
    }
    
    if tail.0 == head.0 {
        if head.1 == tail.1 + 2 {
            tail.1 += 1
        } else if head.1 == tail.1 - 2 {
            tail.1 -= 1
        }
    } else if tail.1 == head.1 {
        if head.0 == tail.0 + 2 {
            tail.0 += 1
        } else if head.0 == tail.0 - 2 {
            tail.0 -= 1
        }
    } else if tail.0 < head.0 {
        if head.1 == tail.1 + 2 || (head.1 > tail.1 && head.0 == tail.0 + 2) {
            tail.0 += 1
            tail.1 += 1
        } else if head.1 == tail.1 - 2 || (head.1 < tail.1 && head.0 == tail.0 + 2) {
            tail.0 += 1
            tail.1 -= 1
        }
    } else if tail.0 > head.0 {
        if head.1 == tail.1 + 2 || (head.1 > tail.1 && head.0 == tail.0 - 2) {
            tail.0 -= 1
            tail.1 += 1
        } else if head.1 == tail.1 - 2 || (head.1 < tail.1 && head.0 == tail.0 - 2) {
            tail.0 -= 1
            tail.1 -= 1
        }
    }
}

if let fileUrl = Bundle.main.url(forResource: "day9Input", withExtension: "txt") {
    do {
        let contents = try String(contentsOf: fileUrl)
        let lines = contents.split(separator: "\n").compactMap({ String($0) })
        
        // Part A
        var visitedCoords: Set<Pair> = [Pair(point: (0, 0))]

        var headPosition = (0, 0)
        var tailPosition = (0, 0)

        for line in lines {
            let moveRegex = /([A-Z]) (\d+)/
            if let match = line.firstMatch(of: moveRegex) {
                let move = String(match.output.1)
                let num = Int(match.output.2) ?? 0

                for _ in 0..<num {
                    moveHead(curPosition: &headPosition, move)
                    moveTail(tail: &tailPosition, head: headPosition)

                    if !visitedCoords.contains(Pair(point: tailPosition)) {
                        visitedCoords.insert(Pair(point: tailPosition))
                    }
                }
            }
        }

        print("Number of visitied coordinates: \(visitedCoords.count)")
        
        // Part B
        var visitedKnot9: Set<Pair> = [Pair(point: (0, 0))]
        var positions: [(Int, Int)] = (0...9).map({ _ in (0, 0) })
        for line in lines {
            let moveRegex = /([A-Z]) (\d+)/
            if let match = line.firstMatch(of: moveRegex) {
                let move = String(match.output.1)
                let num = Int(match.output.2) ?? 0

                for _ in 0..<num {
                    moveHead(curPosition: &positions[0], move)
                    for i in 1...9 {
                        moveTail(tail: &positions[i], head: positions[i - 1])
                    }
                    
                    let tail = positions.last ?? (0, 0)
                    
                    if !visitedKnot9.contains(Pair(point: tail)) {
                        visitedKnot9.insert(Pair(point: tail))
                    }
                }
            }
        }

        print("Number of visitied coordinates long rope: \(visitedKnot9.count)")
    } catch {
        print("Could not read file")
    }
}


struct Pair: Hashable {
    let point: (Int, Int)
    
    func hash(into hasher: inout Hasher) {
        // Using Signed Cantor pairing function
        let a = (point.0 >= 0 ? 2 * point.0 : (-2 * point.0) - 1)
        let b = (point.1 >= 0 ? 2 * point.1 : (-2 * point.1) - 1)
        let cantorValue = ((a + b)*(a + b + 1))/2 + b
        hasher.combine(cantorValue)
    }
    
    static func == (lhs: Pair, rhs: Pair) -> Bool {
        lhs.point == rhs.point
    }
}
