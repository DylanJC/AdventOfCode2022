import Foundation

struct Pair: Hashable {
    static func == (lhs: Pair, rhs: Pair) -> Bool {
        lhs.point == rhs.point
    }
    
    let point: (x: Int, y: Int)
    
    // I stole this hash function from the internet
    func hash(into hasher: inout Hasher) {
        let cantorValue = ((point.x + point.y) * (point.x + point.y)  + point.x + 3 * point.y ) / 2
        hasher.combine(Int(cantorValue))
    }
}

var visibleTrees: Set<Pair> = []

func lookThroughGroveVertically(from: Int, to: Int, by: Int, lines: [String]) {
    for j in stride(from: 0, to: lines[0].count, by: 1) {
        var maxSeenSoFar = -1
        for i in stride(from: from, to: to, by: by) {
            let val = lines[i][j]
            if val > maxSeenSoFar {
                visibleTrees.insert(Pair(point: (x: i, y: j)))
                maxSeenSoFar = val
            }
        }
    }
}

func lookThroughGroveHorizontally(from: Int, to: Int, by: Int, lines: [String]) {
    for i in stride(from: 0, to: lines.count, by: 1) {
        var maxSeenSoFar = -1
        for j in stride(from: from, to: to, by: by) {
            let val = lines[i][j]
            if val > maxSeenSoFar {
                visibleTrees.insert(Pair(point: (x: i, y: j)))
                maxSeenSoFar = val
            }
        }
    }
}

func calculateScenicScore(x: Int, y: Int, lines: [String]) -> Int {
    let height = lines[y][x]
    
    var left = 0
    for i in stride(from: y - 1, to: -1, by: -1) {
        left += 1
        if lines[i][x] >= height {
            break
        }
    }
    
    var right = 0
    for i in stride(from: y + 1, to: lines[0].count, by: 1) {
        right += 1
        if lines[i][x] >= height {
            break
        }
    }
    
    var top = 0
    for j in stride(from: x - 1, to: -1, by: -1) {
        top += 1
        if lines[y][j] >= height {
            break
        }
    }
    
    var bottom = 0
    for j in stride(from: x + 1, to: lines.count, by: 1) {
        bottom += 1
        if lines[y][j] >= height {
            break
        }
    }
    
    if left == 0 { left = 1 }
    if right == 0 { right = 1 }
    if top == 0 { top = 1 }
    if bottom == 0 { bottom = 1 }
    
    return left * right * top * bottom
}

if let fileUrl = Bundle.main.url(forResource: "day8Input", withExtension: "txt") {
    do {
        let contents = try String(contentsOf: fileUrl)
        let lines = contents.split(separator: "\n").compactMap({ String($0) })

        // Part A
        // left
        lookThroughGroveHorizontally(from: 0, to: lines[0].count, by: 1, lines: lines)
        // right
        lookThroughGroveHorizontally(from: lines[0].count - 1, to: -1, by: -1, lines: lines)
        // top
        lookThroughGroveVertically(from: 0, to: lines.count, by: 1, lines: lines)
        // bottom
        lookThroughGroveVertically(from: lines.count - 1, to: -1, by: -1, lines: lines)

        print("\(visibleTrees.count) trees are visible from outside the grove.")
                
        // Part B
        var maxScenicScore = 0

        for i in stride(from: 1, to: lines[0].count - 1, by: 1) {
            for j in stride(from: 1, to: lines.count - 1, by: 1) {
                let scenicScore = calculateScenicScore(x: j, y: i, lines: lines)
                if scenicScore > maxScenicScore {
                    maxScenicScore = scenicScore
                }
            }
        }

        print("Highest scenic score: \(maxScenicScore)")
        // guessed 281792 and it was too low
    } catch {
        print("Error occurred")
    }
}

extension String {
    subscript(_ ind: Int) -> Int {
        return Int(String(self[index(startIndex, offsetBy: ind)])) ?? 0
    }
}
