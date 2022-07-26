import UIKit

class RestaurantListViewController: UIViewController, UICollectionViewDelegate {
    
  private let manager = RestaurantDataManager()
  var selectedRestaurant: RestaurantItem?
  var selectedCity: LocationItem?
  var selectedCuisine: String?
    
  @IBOutlet var collectionView: UICollectionView!
    
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  // Before the RestaurantListViewController instance transitions to another view controller, the segue identifier is checked. If the segue identifier is showDetail, then the showRestaurantDetail method is executed.
  // Only the segue between the Restaurant List View Controller Scene and the Restaurant Detail View Controller Scene has the showDetail identifier
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identier = segue.identifier {
      switch identier {
      case Segue.showDetail.rawValue:
        showRestaurantDetail(segue: segue)
      default:
        print("segue not added")
      }
    }
  }
    
  override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialize()
    }

}

// MARK: Private Extension
private extension RestaurantListViewController {
  
  func initialize() {
    createData()
    setupTitle()
    setupCollectionView()
  }
  func setupCollectionView() {
    let flow = UICollectionViewFlowLayout()
    flow.sectionInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    flow.minimumInteritemSpacing = 0
    flow.minimumLineSpacing = 7
    collectionView.collectionViewLayout = flow
  }
    // This method first checks if the segue destination is an instance of RestaurantDetailViewController, and gets the index of the collection view cell that was tapped.
    // Then, manager returns the RestaurantItem instance stored at that index, which is assigned to selectedRestaurant.
    func showRestaurantDetail(segue: UIStoryboardSegue) {
      if let viewController = segue.destination as?
          RestaurantDetailViewController, let indexPath = collectionView.indexPathsForSelectedItems?.first {
        selectedRestaurant = manager.restaurantItem(at: indexPath.row)
        viewController.selectedRestaurant = selectedRestaurant
      }
    }
    func createData() {
        guard let city = selectedCity?.city, let cuisine = selectedCuisine else {
            return
        }
        manager.fetch(location: city, selectedCuisine: cuisine) { restaurantItems in
            if !restaurantItems.isEmpty {
                collectionView.backgroundView = nil
            } else {
                let view = NoDataView(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height))
                view.set(title: "Restaurants", desc: "No restaurants found.")
                collectionView.backgroundView = view
            }
            collectionView.reloadData()
        }
    }
    
    func setupTitle() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = selectedCity?.cityAndState.uppercased()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: UICollectionViewDataSource
extension RestaurantListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        manager.numberOfRestaurantItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCell", for: indexPath) as! RestaurantCell
        let restaurantItem = manager.restaurantItem(at: indexPath.row)
        cell.titleLabel.text = restaurantItem.name
        if let cuisine = restaurantItem.subtitle {
            cell.cuisineLabel.text = cuisine
        }
        if let imageURL = restaurantItem.imageURL {
            if let url = URL(string: imageURL) {
                let data = try? Data(contentsOf: url)
                if let imageData = data {
                    DispatchQueue.main.async {
                        cell.restaurantImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        return cell
    }
}

extension RestaurantListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var columns: CGFloat = 0
    if Device.isPad {
      columns = 3
    } else {
      columns = traitCollection.horizontalSizeClass == .compact ? 1 : 2
    }
    let viewWidth = collectionView.frame.size.width
    let inset = 7.0
    let contentWidth = viewWidth - inset * (columns + 1)
    let cellWidth = contentWidth / columns
    let cellHeight = 312.0
    return CGSize(width: cellWidth, height: cellHeight)
  }
}
