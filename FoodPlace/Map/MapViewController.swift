import UIKit
import MapKit

// Displaying MKAnnotationView instances on the map view

class MapViewController: UIViewController {

  @IBOutlet var mapView: MKMapView!
  private let manager = MapDataManager()
  var selectedRestaurant: RestaurantItem?
  override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
  // pass the RestaurantItem instance from the MapViewController instance to the RestaurantDetailViewController instanc
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier! {
    case Segue.showDetail.rawValue:
      showRestaurantDetail(segue: segue)
    default:
      print("Segue not added")
    }
  }
   
}

// MARK: Private Extension

private extension MapViewController {
  //  The fetch(completion:) method loads the MapLocations.plist file and creates and assigns the array of RestaurantItem instances to the items array. The annotations property returns a copy of the items array.
  func initialize() {
    mapView.delegate = self
    manager.fetch {(annotations) in setupMap(annotations)}
  }
  
  // The setupMap(_:) method takes a parameter, annotations, which is an array of RestaurantItem instances. It sets the region of the map to be displayed in the map view using the initialRegion(latDelta:longDelta:) method of the MapDataManager class, then adds each RestaurantItem instance in the annotations array to the map view.
  // The map view's delegate (the MapViewController class in this case) then automatically provides an MKAnnotationView instance for every RestaurantItem instance within the region.
  
  func setupMap(_ annotations: [RestaurantItem]) {
    mapView.setRegion(manager.initialRegion(latDelta: 0.5, longDelta: 0.5), animated: true)
    mapView.addAnnotations(manager.annotations)
  }
  
  func showRestaurantDetail(segue: UIStoryboardSegue) {
    // This checks to make sure the segue destination is a RestaurantDetailViewController instance. If it is, a temporary constant, restaurant, is assigned the selectedRestaurant property in the MapViewController instance
    if let viewController = segue.destination as? RestaurantDetailViewController,
       let restaurant = selectedRestaurant {
    // restaurant is then assigned to the selectedRestaurant property in the RestaurantDetailViewController instance.
      viewController.selectedRestaurant = restaurant
    }
  }
}

// MARK: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
  
  // mapView(_:annotationView:calloutAccessoryControlTapped:) is another method specified in the MKMapViewDelegate protocol. It is triggered when the user taps the callout bubble button.
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
  // This gets the RestaurantItem instance associated with MKAnnotationView instance that was tapped and assigns it to selectedRestaurant.
    guard let annotation = mapView.selectedAnnotations.first else {
      return
    }
    selectedRestaurant = annotation as? RestaurantItem
  // self.performSegue(withIdentifier: Segue.showDetail.rawValue, sender: self) performs the segue with the "showDetail" identifier, which presents the Restaurant Detail screen.
    self.performSegue(withIdentifier: Segue.showDetail.rawValue, sender: self)
  }
  
  //  This is one of the delegate methods specified in the MKMapViewDelegate protocol. It's triggered when an MKAnnotation instance is within the map region, and it returns an MKAnnotationView instance, which the user will see on the screen. i use this method to replace the default pins with custom pins.
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
  //  In addition to the annotations that you specify, an MKMapView instance will also add an annotation for the user location. This guard statement checks to see whether the annotation is the user location. If it is, nil is returned, as the user location is not a restaurant location.
    let identifier = "customPin"
    guard !annotation.isKind(of: MKUserLocation.self)
    else {
      return nil
    }
    
    let annotationView: MKAnnotationView
    
  // The if statement checks to see whether there are any existing annotations that were initially visible but are no longer on the screen.
  // If there are, the MKAnnotationView instance for that annotation can be reused and is assigned to the annotationView variable.
    
    if let customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
      annotationView = customAnnotationView
      annotationView.annotation = annotation
    }
    
  // The else clause is executed if there are no existing MKAnnotationView instances that can be reused. A new MKAnnotationView instance is created with the reuse identifier specified earlier (custompin).
  // The MKAnnotationView instance is configured with a callout. When you tap a pin on the map, a callout bubble will appear showing the title (restaurant name), subtitle (cuisines), and a button.
    else {
      let av = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
      annotationView = av
    }
    
  // This configures the MKAnnotationView instance that you just created to display extra information in a callout bubble and sets the custom image to the custom- annotation image stored in Assets.xcassets.
  // When adding a custom image, the annotation uses the center of the image as the pin point, so the centerOffset property is used to set the correct location of the pin point, at the tip of the pin.
    annotationView.canShowCallout = true
    if let image = UIImage(named: "custom-annotation") {
      annotationView.image = image
      annotationView.centerOffset = CGPoint ( x: -image.size.width/2, y: -image.size.width/2)
    }
    return annotationView
  }
  
 
}

