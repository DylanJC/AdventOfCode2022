import Foundation

let fileName = "day2Input"

enum RPS {
    case Rock
    case Paper
    case Scissors
}

let oppMoveDict = [
    "A": RPS.Rock,
    "B": RPS.Paper,
    "C": RPS.Scissors
]

let myMoveDict = [
    "X": RPS.Rock,
    "Y": RPS.Paper,
    "Z": RPS.Scissors
]

func playValue(of move: RPS) -> Int {
    switch move {
    case .Rock: return 1
    case .Paper: return 2
    case .Scissors: return 3
    }
}

func getRPSScore(_ oppMove: RPS, _ myMove: RPS) -> Int {
    if myMove == oppMove {
        return 3
    } else if (myMove == .Rock && oppMove == .Scissors) ||
                (myMove == .Scissors && oppMove == .Paper) ||
                (myMove == .Paper && oppMove == .Rock) {
        return 6
    }
    return 0
}

func calculateGivenScore(for game: Substring) -> Int {
    var score = 0
    if let oppMove = oppMoveDict[game[0]], let myMove = myMoveDict[game[2]] {
        score += getRPSScore(oppMove, myMove) + playValue(of: myMove)
    }
    
    return score
}

func calculateStrategyScore(for game: Substring) -> Int {
    var score = 0
    if let oppMove = oppMoveDict[game[0]] {
        let myMove = game[2]
        if myMove == "Y" {
            switch oppMove {
            case .Rock: score += playValue(of: RPS.Rock)
            case .Paper: score += playValue(of: RPS.Paper)
            case .Scissors: score += playValue(of: RPS.Scissors)
            }
            score += 3
        } else if myMove == "Z" {
            switch oppMove {
            case .Rock: score += playValue(of: RPS.Paper)
            case .Paper: score += playValue(of: RPS.Scissors)
            case .Scissors: score += playValue(of: RPS.Rock)
            }
            score += 6
        } else {
            switch oppMove {
            case .Rock: score += playValue(of: RPS.Scissors)
            case .Paper: score += playValue(of: RPS.Rock)
            case .Scissors: score += playValue(of: RPS.Paper)
            }
        }
    }
    
    return score
}

if let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "txt"){
    do {
        let contents = try String(contentsOf: fileUrl, encoding: .utf8)
        let lines = contents.split(separator: "\n", omittingEmptySubsequences: false)
        
        /// Part 1
        var givenScore = 0
        
        /// Part 2
        var playStrategyScore = 0
        for line in lines {
            if line != "" {
                givenScore += calculateGivenScore(for: line)
                playStrategyScore += calculateStrategyScore(for: line)
            }
        }
        
        print("Score if XYZ is RPS: \(givenScore)")
        print("Score if XYZ is Loss/Tie/Win: \(playStrategyScore)")
        
        /// Part 2
    } catch {
        print("contents could not be loaded")
    }
}

extension StringProtocol {
    subscript(offset: Int) -> String {
        String(self[index(startIndex, offsetBy: offset)])
    }
}
