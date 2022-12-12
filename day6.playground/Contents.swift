import Foundation



func findIfDifferent(letters: String, index: Int, lengthOfMessage: Int) -> Bool {
    var letterSet: Set<Character> = []
    
    for i in 0..<lengthOfMessage {
        letterSet.insert(letters[letters.index(letters.startIndex, offsetBy: index - i)])
    }
    
    return letterSet.count == lengthOfMessage
}

if let fileURL = Bundle.main.url(forResource: "day6Input", withExtension: "txt") {
    do {
        let contents = try String(contentsOf: fileURL)
        
        var startMarker = 0
        var messageMarker = 0
        
        let partA = 4
        let partB = 14
        
        for index in partA-1..<contents.count {
            if findIfDifferent(letters: contents, index: index, lengthOfMessage: partA) {
                startMarker = index + 1
                break
            }
        }
        
        for index in partB-1..<contents.count {
            if findIfDifferent(letters: contents, index: index, lengthOfMessage: partB) {
                messageMarker = index + 1
                break
            }
        }
        
        print("Start marker is at position \(startMarker)")
        print("Message marker is at position \(messageMarker)")
    } catch {
        print("Error reading the contents of the file")
    }
}


extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
