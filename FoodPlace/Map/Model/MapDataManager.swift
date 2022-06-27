import Foundation
import MapKit

// Setting the map view region to be displayed
// In a map view, the portion of the map that is visible on screen is called a region.
// To specify a region, you need the coordinates for the region's center point and the horizontal and vertical span representing the dimensions of the map to be displayed.

class MapDataManager: DataManager {
  private var items: [RestaurantItem] = []
  var annotations: [RestaurantItem] {
    items
  }
  // swiftlint:disable force_try
  private func loadData() -> [[String: AnyObject]] {
    guard let path = Bundle.main.path(forResource: "MapLocations", ofType: "plist"),
          let itemsData = FileManager.default.contents(atPath: path),
          let items = try! PropertyListSerialization.propertyList(from: itemsData, format: nil) as? [[String: AnyObject]]
    else {
      return [[:]]
    }
    return items
  }
  // This method has a completion method parameter. The completion method will be used to process the result when the method has finished execution.
  func fetch(completion: (_ annotations: [RestaurantItem]) -> ()) {
    let manager = RestaurantDataManager()
    // This calls the manager instance's fetch() method to get a list of restaurants from Boston.json. This is hardcoded for now as the iOS Simulator does not have a functional GPS. To see restaurants at a different location, change the name of the JSON file used to another location.
    manager.fetch(location: "Boston", completionHandler: {(restaurantItems) in self.items = restaurantItems
      completion(items)
    })
  }
  
  //  This method takes two parameters and returns an MKCoordinateRegion instance. latDelta specifies the north-to-south distance (measured in degrees) to display for the map region.
  //  One degree is approximately 69 miles. longDelta specifies the amount of east-to-west distance (measured in degrees) to display for the map region. The MKCoordinateRegion instance that is returned determines the region that will appear onscreen.
  func initialRegion(latDelta: CLLocationDegrees, longDelta: CLLocationDegrees) -> MKCoordinateRegion {
    guard let item = items.first else {
      return MKCoordinateRegion()
    }
    // latDelta and longDelta are used to make an MKCoordinateSpan instance, which is the horizontal and vertical span of the region to be created.
    let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
    return MKCoordinateRegion(center: item.coordinate, span: span)
  }
  
}
