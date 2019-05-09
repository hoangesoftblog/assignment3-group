import Foundation

class Media {
    static func removeFileExtension(file name: String) -> String{
        let a = name.lastIndex(of: ".") ?? name.endIndex
        return String(name[..<a])
    }
    
    static func getFileExtension(file name: String) -> String {
        if let a = name.lastIndex(of: ".") {
            print("extension is \(String(name[name.index(after: a)..<name.endIndex]))")
            return String(name[name.index(after: a)..<name.endIndex])
        }
        else {
            print("Empty extension")
            return ""
        }
        
    }
}
