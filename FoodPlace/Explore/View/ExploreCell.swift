import UIKit

class ExploreCell: UICollectionViewCell {
  @IBOutlet var exploreNameLabel: UILabel!
  @IBOutlet var exploreImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    exploreImageView.layer.cornerRadius = 10
    exploreImageView.layer.masksToBounds = true
  }
}
