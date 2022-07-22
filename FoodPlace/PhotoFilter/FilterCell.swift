import UIKit

class FilterCell: UICollectionViewCell {
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var thumbnailImageView: UIImageView!
  
  override func awakeFromNib() {
    thumbnailImageView.layer.cornerRadius = 9
    thumbnailImageView.layer.masksToBounds = true
  }
  
}

extension FilterCell: imageFiltering {
  
  func set(filterItem: FilterItem, imageForThumbnail: UIImage) {
    nameLabel.text = filterItem.name
    if let filter = filterItem.filter {
      if filter != "None" {
        let filteredImage = apply(filter: filter, originalImage: imageForThumbnail)
        thumbnailImageView.image = filteredImage
      } else {
        thumbnailImageView.image = imageForThumbnail
      }
    }
  }
  
}
