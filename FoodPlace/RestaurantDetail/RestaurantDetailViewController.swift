import UIKit
import MapKit

class RestaurantDetailViewController: UITableViewController {
    var selectedRestaurant: RestaurantItem?
    
    @IBOutlet var heartButton: UIBarButtonItem!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cuisineLabel: UILabel!
    @IBOutlet var headerAddressLabel: UILabel!
    @IBOutlet var tableDetailsLabel: UILabel!
    @IBOutlet var overallRatingLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var locationMapImageView: UIImageView!
    @IBOutlet var ratingsView: RatingsView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        createRating()
    }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case Segue.showReview.rawValue:
        showReview(segue: segue)
      case Segue.showPhotoFilter.rawValue:
        showPhotoFilter(segue: segue)
      default:
        print("Segue not added")
      }
    }
  }
}

private extension RestaurantDetailViewController {
  
  func initialize() {
    setupLabels()
    createMap()
    createRating()
  }
  @IBAction func unwindReviewCancel(segue: UIStoryboardSegue) {
  }
  func showReview(segue: UIStoryboardSegue) {
    guard let navController = segue.destination as? UINavigationController, let viewController = navController.topViewController as? ReviewFormViewController else {
      return
    }
    viewController.selectedRestaurantID = selectedRestaurant?.restaurantID
  }
  func showPhotoFilter(segue: UIStoryboardSegue) {
    guard let navController = segue.destination as? UINavigationController, let viewController = navController.topViewController as? PhotoFilterViewController else {
      return
    }
    viewController.selectedRestaurantID = selectedRestaurant?.restaurantID
  }
  func createRating() {
    ratingsView.isEnabled = true
    // assigns the selectedRestaurant instance's restaurantID property to restaurantID
    if let restaurantID = selectedRestaurant?.restaurantID {
      // gets all the reviews with restaurantID's restaurant identifier value, and calculates the average rating.
      let ratingValue = CoreDataManager.shared.fetchRestaurantRating(by: restaurantID)
      ratingsView.rating = ratingValue
      if ratingValue.isNaN {
        overallRatingLabel.text = "0.0"
      } else {
        let roundedValue = ((ratingValue * 10).rounded() / 10)
        overallRatingLabel.text = "\(roundedValue)"
      }
    }
  }
  func setupLabels() {
    guard let restaurant = selectedRestaurant else {
      return
    }
    title = restaurant.name
    nameLabel.text = restaurant.name
    cuisineLabel.text = restaurant.subtitle
    headerAddressLabel.text = restaurant.address
    tableDetailsLabel.text = "Table for 7, at 10:00 PM"
    addressLabel.text = restaurant.address
  }
  
  func createMap() {
    guard let annotation = selectedRestaurant,
        let long = annotation.long,
          let lat = annotation.lat else {
      return
    }
    let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
    takeSnapshot(with: location)
  }
  
  // Given a location, it takes a snapshot of the map at that location, adds the custom annotation you used earlier in the Map screen, converts it into an image, and assigns it to the locationMapImageView outlet in the RestaurantDetailViewController instance.
  func takeSnapshot(with location: CLLocationCoordinate2D) {
    let mapSnapshotOptions = MKMapSnapshotter.Options()
    var loc = location
    let polyline = MKPolyline(coordinates: &loc, count: 1)
    let region = MKCoordinateRegion(polyline.boundingMapRect)
    mapSnapshotOptions.region = region
    mapSnapshotOptions.scale = UIScreen.main.scale
    mapSnapshotOptions.size = CGSize(width: 340, height: 208)
    mapSnapshotOptions.showsBuildings = true
    mapSnapshotOptions.pointOfInterestFilter = .includingAll
    let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
    snapShotter.start() { snapshot, error in
      guard let snapshot = snapshot else {
        return
      }
      UIGraphicsBeginImageContextWithOptions(mapSnapshotOptions.size, true, 0)
      snapshot.image.draw(at: .zero)
      let identifier = "custompin"
      let annotation = MKPointAnnotation()
      annotation.coordinate = location
      let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      pinView.image = UIImage(named: "custom-annotation")!
      let pinImage = pinView.image
      var point = snapshot.point(for: location)
      let rect = self.locationMapImageView.bounds
      if rect.contains(point) {
        let pinCenterOffset = pinView.centerOffset
        point.x -= pinView.bounds.size.width / 2
        point.y -= pinView.bounds.size.height / 2
        point.x += pinCenterOffset.x
        point.y += pinCenterOffset.y
        pinImage?.draw(at: point)
      }
      if let image = UIGraphicsGetImageFromCurrentImageContext() {
        UIGraphicsEndImageContext()
        DispatchQueue.main.async {
          self.locationMapImageView.image = image
        }
      }
    }
  }
  
}
