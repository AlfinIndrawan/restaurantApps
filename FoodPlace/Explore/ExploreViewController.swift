import UIKit

class ExploreViewController: UIViewController {
  
  @IBOutlet var collectionView: UICollectionView!
  let manager = ExploreDataManager()
  var selectedCity: LocationItem?
  var headerView: ExploreHeaderView!
  override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier! {
    case Segue.locationList.rawValue:
      showLocationList(segue: segue)
    case Segue.restaurantList.rawValue:
      showRestaurantList(segue: segue)
    default:
      print("segue not added")
    }
  
  }
  
  // if a location has not been selected
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if identifier == Segue.restaurantList.rawValue,
       selectedCity == nil {
      showLocationRequiredAlert()
      return false
    }
    return true
  }

}

extension ExploreViewController: UICollectionViewDelegate {

}

extension ExploreViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
      headerView = header as? ExploreHeaderView
      return headerView
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    manager.numberOfExploreItems()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreCell", for: indexPath) as! ExploreCell
    let exploreItem = manager.exploreItem(at: indexPath.row)
    cell.exploreNameLabel.text = exploreItem.name
    cell.exploreImageView.image = UIImage(named: exploreItem.image!)
    return cell
  }
}

// MARK: Private Extension
private extension ExploreViewController {
  func initialize() {
    manager.fetch()
  }
  // The guard statement checks whether the segue destination is
  //  a UINavigationController instance and whether topViewController is the LocationViewController instance. If it is, the selectedCity property of the ExploreViewController instance is checked to see if
  //  it contains a value. If it does, that value is assigned to the selectedCity property of the LocationViewController instance. Remember that the setCheckmark(for:at:) method of the LocationViewController instance will be called for each row in the table view, and this sets a checkmark on the row containing the selected city.
  func showLocationList(segue: UIStoryboardSegue) {
    guard let navController = segue.destination as? UINavigationController,
          let viewController = navController.topViewController as? LocationViewController else {
      return
    }
    viewController.selectedCity = selectedCity
  }
  
  func showRestaurantList(segue: UIStoryboardSegue) {
     //  checks to see whether the destination view controller is the RestaurantListViewController instance
    if let viewController = segue.destination as? RestaurantListViewController,
      let city = selectedCity,
      let index = collectionView.indexPathsForSelectedItems?.first?.row {
      // the RestaurantListViewController instance's selectedCuisine property is set to the name of the instance located at that index in the items array
      viewController.selectedCuisine = manager.exploreItem(at: index).name
      //  the RestaurantListViewController instance's selectedCity property will be assigned the value stored in city.
      viewController.selectedCity = city
    }
  }
  
  func showLocationRequiredAlert() {
    let alertController = UIAlertController(title: "Location Needed", message: "Please select a location.", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  @IBAction func unwindLocationCancel(segue: UIStoryboardSegue) {
    let alertController = UIAlertController(title: "Location Needed", message: "Select Location", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  @IBAction func unwindLocationDone(segue: UIStoryboardSegue) {
    // the value of the LocationViewController instance's selectedCity property is assigned to the ExploreViewController instance's selectedCity property,
    if let viewController = segue.source as? LocationViewController {
      selectedCity = viewController.selectedCity
    // if it exists. If the ExploreViewController instance's selectedCity property has a value, it is assigned to location, and the text of the subtitle label is set to the cityAndState property of location.
      if let location = selectedCity {
        headerView.locationLabel.text = location.cityAndState
      }
    }
  }
}
