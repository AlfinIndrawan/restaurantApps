import UIKit
import MapKit

class RestaurantItem: NSObject, MKAnnotation, Decodable {
  let name: String?
  let cuisines: [String]
  let lat: Double?
  let long: Double?
  let address: String?
  let postalCode: String?
  let state: String?
  let imageURL: String?
  let restaurantID: Int?
  
// The CodingKeys enumeration matches the RestaurantItem class properties to the keys in the JSON file.
// if the key name does not match the property name, you can map the key to the property, as shown in the preceding code block for postalCode, imageURL, and restaurantID.
  enum CodingKeys: String, CodingKey {
    case name
    case cuisines
    case lat
    case long
    case address
    case postalCode = "postal_code"
    case state
    case imageURL = "image_url"
    case restaurantID = "id"
  }
  
  var coordinate: CLLocationCoordinate2D {
    guard let lat = lat, let long = long else {
      return CLLocationCoordinate2D()
    }
    return CLLocationCoordinate2D(latitude: lat, longitude: long)
  }
  
  var title: String? {
    name
  }
  
  var subtitle: String? {
    if cuisines.isEmpty {
      return ""
    } else if cuisines.count == 1 {
      return cuisines.first
    } else {
      // For example, if cuisines contained the ["American", "Bistro", "Burgers"] array, the generated string would be "American, Bistro, Burgers".
      return cuisines.joined(separator: ", ")
    }
  }
  
}
