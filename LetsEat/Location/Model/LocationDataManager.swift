import Foundation

class LocationDataManager {
  private var locations: [String] = []
  
  // Loads the contents of Locations.plist and returns an array of dictionaries. Each dictionary stores the city and state of a location.
  private func loadData() -> [[String: String]] {
    let decoder = PropertyListDecoder()
    if let path = Bundle.main.path(forResource: "Locations", ofType: "plist"),
      let locationsData = FileManager.default.contents(atPath: path),
      let locations = try? decoder.decode([[String: String]].self, from: locationsData) {
        return locations
      }
  return [[:]]
  }
  
  //  Takes the array provided by loadData(), concatenates the city and state for each element, and appends the resulting string to the locations array.
  func fetch() {
  for location in loadData() {
    if let city = location["city"],
      let state = location["state"] {
      locations.append("\(city), \(state)")
      }
    }
  }

// Returns the number of elements in the locations array.
  func numberOfLocationItems() -> Int {
    locations.count
  }
// Returns a string stored in the locations array at a given array index.
  func locationItem(at index: Int) -> String {
    locations[index]
  }
  
}
