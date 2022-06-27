import Foundation

class RestaurantDataManager {
  private var restaurantItems: [RestaurantItem] = []
  
  func fetch(location: String, selectedCuisine: String = "All", completionHandler: (_ restaurantItems: [RestaurantItem]) -> Void) {
    // The first statement attempts to assign the contents of file to data. The next statement attempts to use a JSONDecoder instance to parse data and store it as an array of RestaurantItem instances, which is assigned to restaurants
    if let file = Bundle.main.url(forResource: location, withExtension: "json") {
      do {
        let data = try Data(contentsOf: file)
        let restaurants = try JSONDecoder().decode(
          [RestaurantItem].self, from: data)
        if selectedCuisine != "All" {
          restaurantItems = restaurants.filter {
            // the filter method is applied to the restaurants array using the {($0.cuisines. contains(selectedCuisine))} closure. This results in an array of RestaurantItem instances where the cuisines property contains the user-selected cuisine. Otherwise, the entire restaurants array is assigned to restaurantItems
            ($0.cuisines.contains(selectedCuisine))
          }
        } else {
          restaurantItems = restaurants
        }
      } catch {
        print("There was an error \(error)")
      }
    }
    // This prints an error message to the Debug area if the do code block fails.
    completionHandler(restaurantItems)
  }
  
  func numberOfRestaurantItems() -> Int {
    restaurantItems.count
  }
  
  func restaurantItem(at index:Int) -> RestaurantItem {
    restaurantItems[index]
  }
}
