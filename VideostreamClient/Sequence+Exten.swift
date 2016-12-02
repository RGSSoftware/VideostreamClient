import Foundation

//[true, false].reduceAnd()
//return false

extension Sequence where Iterator.Element == Bool {
    func reduceAnd() -> Bool {
        return !contains(false)
    }
    
    func reduceOr() -> Bool {
        return contains(true)
    }
}
