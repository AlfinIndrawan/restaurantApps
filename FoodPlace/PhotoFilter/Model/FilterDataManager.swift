import Foundation

class FilterDataManager: DataManager {
  func fetch() -> [FilterItem] {
    var filterItems: [FilterItem] = []
    for data in loadPlist(file: "FilterData") {
      filterItems.append(FilterItem(dict: data as! [String: String]))
    }
    return filterItems
  }
}
