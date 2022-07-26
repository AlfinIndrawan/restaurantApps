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
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
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

// MARK: Extension
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
    cell.exploreImageView.tintColor = .red
    return cell
  }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    // The columns variable determines how many columns appear on screen, and is initially set to 2.
    var columns: CGFloat = 2
    // whether the app is running on an iPad or the horizontalSizeClass property is not .compact.
    if Device.isPad || (traitCollection.horizontalSizeClass != .compact) {
      columns = 3
    }
    // Gets the width of the screen and assigns it to viewWidth.
    let viewWidth = collectionView.frame.size.width
    let inset = 7.0
    // Subtracts the space used for the edge insets so the cell size can be determined.
    // assume width of the iPhone 13 pro max screen, which is 414 points. contentWidth is set to 414 - (7 x 3) = 393. cellWidth is set to contentWidth / columns = 196.5, and cellHeight is set to cellWidth, so the CGSize returned would be (196.5, 196.5), enabling two cells to fit in a row.
    // When you rotate the same iPhone to landscape mode, columns is set to 3. viewWidth would be assigned the height of the iPhone screen, which is 896 points. contentWidth is set to 896 - (7 x 4) = 868. cellWidth is set to contentWidth / columns = 289.3, and cellHeight is set to cellWidth, so the CGSize returned would be (289.3, 289.3) so it will be 3 columns
    let contentWidth = viewWidth - inset * (columns + 1)
    let cellWidth = contentWidth / columns
    // height = width
    let cellHeight = cellWidth
    return CGSize(width: cellWidth, height: cellHeight)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 100)
  }
}

// MARK: Private Extension
private extension ExploreViewController {
  func initialize() {
    manager.fetch()
    setupCollectionView()
  }
  func setupCollectionView() {
    let flow = UICollectionViewFlowLayout()
    flow.sectionInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    flow.minimumInteritemSpacing = 0
    flow.minimumLineSpacing = 7
    collectionView.collectionViewLayout = flow
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
