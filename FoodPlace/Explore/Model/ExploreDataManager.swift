import Foundation

//swiftlint:disable force_cast

class ExploreDataManager: DataManager {
  // exploreitems with explore item in struct
  private var exploreItems: [ExploreItem] = []
  
  func fetch() {
    for data in loadPlist(file: "ExploreData") {
      exploreItems.append(ExploreItem(dict: data as! [String: String]))
    }
  }
  private func loadData() -> [[String: String]] {
    let decoder = PropertyListDecoder()
    if let path = Bundle.main.path(forResource: "ExploreData", ofType: "plist"),
       let exploreData = FileManager.default.contents(atPath: path),
       let exploreItems = try? decoder.decode([[String: String]].self, from: exploreData) {
      return exploreItems
    }
    return [[:]]
  }
  func numberOfExploreItems() -> Int {
    exploreItems.count
  }
  func exploreItem(at index: Int) -> ExploreItem {
    exploreItems[index]
  }
}
