import UIKit

class RestaurantDetailViewController: UITableViewController {
    var selectedRestaurant: RestaurantItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      // This confirms that the MapViewController instance has successfully passed the RestaurantItem instance to the RestaurantDetailViewController instance
        dump(selectedRestaurant as Any)
    }
}
