import Foundation

// This protocol requires any conforming object to have a method named loadPlist(file:) that takes a string as a parameter and returns an array of dictionaries.
// The string will hold the name of the .plist file to be loaded.
protocol DataManager {
  func loadPlist(file name: String) -> [[String: AnyObject]]
}

// Any class that adopts this protocol will get the loadPlist(file:) method. This method looks for a .plist file specified in the name parameter inside the application bundle.

//swiftlint:disable force_try
extension DataManager {
  func loadPlist(file name: String) -> [[String: AnyObject]] {
    guard let path = Bundle.main.path(forResource: name, ofType: "plist"),
          let itemsData = FileManager.default.contents(atPath: path),
          let items = try! PropertyListSerialization.propertyList(from: itemsData, format: nil) as? [[String: AnyObject]]
    else {
      return [[:]]
    }
    return items
  }
}
