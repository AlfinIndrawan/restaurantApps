import UIKit

class RatingsView: UIControl {
  
  private let filledStarImage = UIImage(named:
  "filled-star")
  private let halfStarImage = UIImage(named:
  "half-star")
  private let emptyStarImage = UIImage(named:
  "empty-star")
  private var totalStars = 5
  var rating = 0.0 {
    //  Here, i defined a property observer to monitor changes in the rating property's value. Every time rating changes, setNeedsDisplay() is called and the ratings view is redrawn for better performance
    didSet {
      setNeedsDisplay()
    }
  }
  
  override func draw(_ rect: CGRect) {
    // where you will compose UI elements together.
    let context = UIGraphicsGetCurrentContext()
    // sets the fill color of context to the default system background color.
    context!.setFillColor(UIColor.systemBackground.cgColor)
    context!.fill(rect)
    // Fills the rectangular area specified by rect with the fill color.
    // gets the width of the ratings view and assigns it to ratingsViewWidth
    let ratingsViewWidth = rect.size.width
    //  gets the width available for each star by dividing the width of the ratings view by the number of stars that need to be drawn.
    let availableWidthForStar = ratingsViewWidth / Double(totalStars)
    // ternary operator
    // imagine that each star is enclosed in a rectangle. This statement calculates how long each side of this rectangle should be in order to fit within the ratings view.
    // For example, let's assume the ratings view is 200 points wide and 50 points high. availableWidthForStar would be 200/5 = 40. Since 40 <= 50 evaluates to true, starSideLength will be set to 40.
    let starSideLength = (availableWidthForStar <= rect.size.height) ? availableWidthForStar: rect.size.height
    // Since totalStars is set to 5, this for loop repeats five times.
    for index in 0..<totalStars {
      // For example, for the first star, starOriginX is (40*0.0) + (40-40)/2 = 0. starOriginY is (50 – 40)/2 = 5. frame would thus be a CGRect where x is 0, y is 5, width is 40, and height is 40.
      let starOriginX = (availableWidthForStar *  Double(index)) + ((availableWidthForStar - starSideLength) / 2)
      let starOriginY = ((rect.size.height - starSideLength) / 2)
      let frame = CGRect(x: starOriginX, y: starOriginY, width: starSideLength, height: starSideLength)
      // For example, let's assume rating is 3.5. The first star has an index of 0. This means Double(0 + 1) <= 3.5 will be 1.0 <= 3.5, which evaluates to true. This means the first star that's drawn will be a filled star. and so on
      var starToDraw: UIImage!
      if Double(index+1) <= self.rating {
        starToDraw = filledStarImage
      } else if Double(index+1) <= self.rating.rounded() {
        starToDraw = halfStarImage
      } else {
        starToDraw = emptyStarImage
      }
      starToDraw.draw(in: frame)
    }
    
  }
  // The ratings view needs to become the first responder to respond to touch events. This method returns false by default, as not all user interface elements need to respond to touches. i override this method to make it return true so the ratings view can become the first responder.
  override var canBecomeFirstResponder: Bool {
    true
  }
  // i override this method so i can define custom behavior when the user touches the ratings view.
  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    // The isEnabled property is checked in this guard statement to see if the ratings view is enabled. If the ratings view is not enabled, the user's touches will not be tracked.
    guard self.isEnabled else {
      return false
    }
    super.beginTracking(touch, with: event)
    handle(with: touch)
    return true
  }
}

private extension RatingsView {
  // value will contain a range of values between 0 and 5. Next, the if statement calculates the rating corresponding to the position of the touch and calls updateRating
  func handle(with touch: UITouch) {
    let starRectWidth = self.bounds.size.width / Double(totalStars)
    let location = touch.location(in: self)
    var value = location.x / starRectWidth
    if (value + 0.5) < value.rounded(.up) {
      value = floor(value) + 0.5
    } else {
      value = value.rounded(.up)
    }
    updateRating(with: value)
  }
  
  func updateRating(with newValue: Double) {
    // updateRating(with:) checks to see if value is not equal to the current rating and between 0 and 5. If it is, value is assigned to rating.
    if (self.rating != newValue && newValue >= 0 && newValue <= Double(totalStars)) {
      self.rating = newValue
    }
  }
  
}
