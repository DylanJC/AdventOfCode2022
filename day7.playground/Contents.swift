import Foundation

var fileSystem = Directory(id: 0, name: "/", parentDirectory: nil)
var currentDir = fileSystem
var id = 1

class Directory: Hashable {
    private var id: Int
    // subDirectories and files should prob be private lol but it's ok
    var subDirectories: Set<Directory> = []
    var files: [File] = []
    var name: String
    var parentDirectory: Directory?
    
    var size: Int {
        var totalSize = 0
        
        for file in files {
            totalSize += file.size
        }
        
        for directory in subDirectories {
            totalSize += directory.size
        }
        
        return totalSize
    }
    
    var sumSizesUnder100k: Int {
        var totalSize = 0
        
        for directory in subDirectories {
            totalSize += directory.sumSizesUnder100k
            
            if directory.size < 100000 {
                totalSize += directory.size
            }
        }
        
        return totalSize
    }
    
    init(id: Int, name: String, parentDirectory: Directory?) {
        self.id = id
        self.name = name
        self.parentDirectory = parentDirectory
    }
    
    func navigateTo(_ chosenDir: String) {
        for dir in currentDir.subDirectories {
            if dir.name == chosenDir {
                currentDir = dir
            }
        }
    }

    struct File {
        var name: String
        var size: Int
    }
    
    static func == (lhs: Directory, rhs: Directory) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

func buildSystem(_ line: String) {
    let lsRegex = /\$ ls/
    if line.firstMatch(of: lsRegex) != nil {
        return
    }
    
    let cdRegex = /\$ cd (.+)/
    if let match = line.firstMatch(of: cdRegex) {
        let chosenDirectory = String(match.output.1)
        
        if chosenDirectory == ".." {
            currentDir = currentDir.parentDirectory ?? fileSystem
            return
        }
        
        fileSystem.navigateTo(chosenDirectory)
    }
    
    let dirRegex = /dir (.+)/
    if let match = line.firstMatch(of: dirRegex) {
        let name = String(match.output.1)
        for dir in currentDir.subDirectories {
            if name == dir.name {
                return
            }
        }
        
        currentDir.subDirectories.insert(Directory(id: id, name: name, parentDirectory: currentDir))
        id += 1
    }
    
    let fileRegex = /(\d+) (.+)/
    if let match = line.firstMatch(of: fileRegex) {
        let name = String(match.output.2)
        let size = Int(String(match.output.1)) ?? 0
        
        for file in currentDir.files {
            if file.name == name {
                return
            }
        }
        
        currentDir.files.append(Directory.File(name: name, size: size))
    }
}

func getSmallestPossibleDir(dir: Directory, spaceNeeded: Int) -> Int {
    var smallest: Int?
    for sub in dir.subDirectories {
        let size = getSmallestPossibleDir(dir: sub, spaceNeeded: spaceNeeded)
        
        if size < spaceNeeded {
            continue
        }
        
        if smallest == nil || size < smallest! {
            smallest = size
        }
    }
    
    if smallest == nil || (dir.size > spaceNeeded && dir.size < smallest!) {
        smallest = dir.size
    }
    
    return smallest ?? 0
}
    
if let fileUrl = Bundle.main.url(forResource: "day7Input", withExtension: "txt") {
    do {
        let contents = try String(contentsOf: fileUrl)
        let lines = contents.split(separator: "\n").compactMap({ String($0) })

        for line in lines {
            buildSystem(line)
        }
        
        // Part A
        print("sum of sizes of dirs under 100k: \(fileSystem.sumSizesUnder100k)")
        
        // Part B
        let smallest = getSmallestPossibleDir(dir: fileSystem, spaceNeeded: 6876531)
        print("space we need to free: 6876531")
        print("for part 2 delete dir with size \(smallest)")
    } catch {
        print("Error reading file")
    }
}
