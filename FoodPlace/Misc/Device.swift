import UIKit
// an enumeration is used instead of a class or structure because i can't accidentally make an instance of it.
// IDevice class represents the device the app is running on. UIDevice.current.userInterfaceIdiom returns .phone if the app is running on an iPhone, and returns .pad if the app is running on an iPad.
enum Device {
  static var isPhone: Bool {
    UIDevice.current.userInterfaceIdiom == .phone
  }
  static var isPad: Bool {
    UIDevice.current.userInterfaceIdiom == .pad
  }
}
