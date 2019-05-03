import Foundation

class Media {
    static func removeFileExtension(file name: String) -> String{
        let a = name.lastIndex(of: ".") ?? name.endIndex
        return String(name[..<a])
    }
}
