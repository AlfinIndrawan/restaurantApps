
import UIKit

class ReviewsViewController: UIViewController {
  @IBOutlet var collectionView: UICollectionView!
  var selectedRestaurantID: Int?
  private var reviewItems: [ReviewItem] = []
  private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd, yyyy"
  return formatter
  }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    checkReviews()
  }
  
}

private extension ReviewsViewController {
  func initialize() {
    setupCollectionView()
  }
  func setupCollectionView() {
    let flow = UICollectionViewFlowLayout()
    flow.sectionInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    flow.minimumInteritemSpacing = 0
    flow.minimumLineSpacing = 7
    flow.scrollDirection = .horizontal
    collectionView.collectionViewLayout = flow
  }
  func checkReviews() {
    // This statement assigns RestaurantDetailViewController to a temp constant, viewController.
    let viewController = self.parent as? RestaurantDetailViewController
    // This statement assigns the restaurant identifier of the restaurant shown in the Restaurant Detail screen to restaurantID.
    if let restaurantID = viewController?.selectedRestaurant?.restaurantID {
      // This statement gets an array of reviews matching the given restaurantID from the persistent store and assigns it to reviewItems.
      reviewItems = CoreDataManager.shared.fetchReviews(by: restaurantID)
      // If there are reviews for this restaurant, the collection view's background view is set to nil. otherwise, you create a NoDataView instance, set the title and desc properties to "Reviews" and "There are  no reviews" respectively, and assign it to the collection view's background view.
      if !reviewItems.isEmpty {
        collectionView.backgroundView = nil
      } else {
        let view = NoDataView(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height))
        view.set(title: "Reviews", desc: "There are no Reviews")
        collectionView.backgroundView = view
      }
    }
    collectionView.reloadData()
  }
}

extension ReviewsViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    reviewItems.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ReviewCell
    let reviewItem = reviewItems[indexPath.item]
    cell.nameLabel.text = reviewItem.name
    cell.titleLabel.text = reviewItem.title
    cell.reviewLabel.text = reviewItem.customerReview
    if let reviewItemDate = reviewItem.date {
      cell.dateLabel.text = dateFormatter.string(from: reviewItemDate)
    }
    if let reviewItemRating = reviewItem.rating {
      cell.ratingsView.rating = reviewItemRating
    }
    return cell
  }

}

extension ReviewsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let edgeInset = 7.0
    if reviewItems.count == 1 {
      let cellWidth = collectionView.frame.size.width - (edgeInset * 2)
      return CGSize(width: cellWidth, height: 200)
    } else {
      let cellWidth = collectionView.frame.size.width - (edgeInset * 3)
      return CGSize(width: cellWidth, height: 200)
    }
  }
}
