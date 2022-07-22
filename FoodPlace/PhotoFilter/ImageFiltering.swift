import Foundation
import CoreImage
import UIKit

protocol imageFiltering {
  // takes a filter name and an image as parameters.
  // any class that adopts the ImageFiltering protocol will be able to execute this method.
  func apply(filter: String, originalImage: UIImage) -> UIImage
}

extension imageFiltering {
  func apply(filter: String, originalImage: UIImage) -> UIImage {
    // This statement converts the original image to a CIImage instance so that you can apply filters to it
    let initialCIImage = CIImage(image: originalImage, options: nil)
    let originalOrientation = originalImage.imageOrientation
    // returns the original image if the filter is not found.
    guard let ciFilter = CIFilter(name: filter) else {
      print("filter not found")
      return originalImage
    }
    // These statements apply the selected filter to initialCIImage and store the result in filteredCIImage.
    ciFilter.setValue(initialCIImage, forKey: kCIInputImageKey)
    let context = CIContext()
    let filteredCIImage = (ciFilter.outputImage)!
    let filteredCGImage = context.createCGImage(filteredCIImage, from: filteredCIImage.extent)
    return UIImage(cgImage: filteredCGImage!, scale: 1.0, orientation: originalOrientation)
  }
}
