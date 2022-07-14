import UIKit

class NoDataView: UIView {
  var view: UIView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var descLabel: UILabel!
  
  // The NoDataView class is a subclass of UIView. A UIView object has two init methods: the first handles view creation programmatically, and the second handles the loading of XIB files from the app bundle stored on the device. Here, both methods will call setupView().
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
    
  // This method finds and loads the NoDataView XIB file from the app bundle and returns a UIView instance stored inside it.
  func loadViewFromNib() -> UIView {
    let nib = UINib(nibName: "NoDataView", bundle: Bundle.main)
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    return view
  }
  func setupView() {
    view = loadViewFromNib()
    //  makes the width and height of the view flexible to adapt to size and orientation changes, and adds it to the device view hierarchy so it is visible onscreen.
    view.frame = bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(view)
  }
  func set (title: String, desc: String) {
    titleLabel.text = title
    descLabel.text = desc
  }
}
