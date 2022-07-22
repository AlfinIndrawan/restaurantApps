import Foundation

struct FilterItem {
  let filter: String?
  let name: String?
  init(dict: [String: String]) {
    self.filter = dict["filter"]
    self.name = dict["name"]
  }
}
