import UIKit
import AVFoundation
class PhotoFilterViewController: UIViewController {
  @IBOutlet var mainImageView: UIImageView!
  @IBOutlet var collectionView: UICollectionView!
  private let manager = FilterDataManager()
  var selectedRestaurantID: Int?
  private var mainImage: UIImage?
  private var thumbnail: UIImage?
  private var filters: [FilterItem] = []
  
    override func viewDidLoad() {
      super.viewDidLoad()
      initialize()
    }
    
}

// MARK: - Private Extension
private extension PhotoFilterViewController {
  func initialize() {
    // sets up the collection view used to display the list of filters
    setupCollectionView()
    // checks the user authorization status for the use of the camera
    checkSource()
  }
  func saveSelectedPhoto() {
    if let mainImage = self.mainImageView.image {
      var restPhotoItem = RestaurantPhotoItem()
      restPhotoItem.date = Date()
      restPhotoItem.photo = mainImage.preparingThumbnail(of: CGSize(width: 100, height: 100))
      if let selRestID = selectedRestaurantID {
        restPhotoItem.restaurantID = Int64(selRestID)
      }
      CoreDataManager.shared.addPhoto(restPhotoItem)
    }
    dismiss(animated: true, completion: nil)
  }
  func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    // set the scroll direction, section insets, inter-item spacing, and line spacing properties, and assign it to the collection view.
    layout.scrollDirection = .horizontal
    layout.sectionInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 7
    // setting delegate and dataSource programmatically rather than using the storyboard; either approach is acceptable
    collectionView.collectionViewLayout = layout
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  func checkSource() {
    let cameraMediaType = AVMediaType.video
    let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
    switch cameraAuthorizationStatus {
    // If the status is .notDetermined, the app will ask the user for permission
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: cameraMediaType) {granted in
        if granted {
          DispatchQueue.main.async {
            self.showCameraUserInterface()
          }
        }
      }
    case .authorized:
      self.showCameraUserInterface()
    default:
      break
    }
  }
  
  func showApplyUserInterface() {
    // loads FilterData.plist and puts its contents into an array of FilterItem instances.
    filters = manager.fetch()
    // PhotoFilterViewController instance's mainImage property to mainImageView, which is the outlet for the image view above the collection view
    if let mainImage = self.mainImage {
      mainImageView.image = mainImage
      collectionView.reloadData()
    }
  }
  @IBAction func onPhotoTapped (_ sender: Any) {
    checkSource()
  }
  @IBAction func onSaveTapped(_ sender: Any) {
    saveSelectedPhoto()
  }
}

extension PhotoFilterViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    filters.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCell
    let filterItem = filters[indexPath.row]
    if let thumbnail = thumbnail {
      cell.set(filterItem: filterItem, imageForThumbnail: thumbnail)
    }
    return cell
  }
}

extension PhotoFilterViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionViewHeight = collectionView.frame.size.height
    let topInset = 14.0
    let cellHeight = collectionViewHeight - topInset
    return CGSize(width: 150, height: cellHeight)
  }
}

extension PhotoFilterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func showCameraUserInterface() {
    let imagePicker = UIImagePickerController()
    // Sets the imagePicker instance's delegate property to the PhotoFilterViewController instance.
    imagePicker.delegate = self
    // conditional completion block
    // If you're running on the simulator, only the statement setting the imagePicker instance's sourceType property to the photo library is compiled. If you're running on an actual device, the statements setting the imagePicker instance's sourceType property to camera and displaying the camera controls are compiled.
    #if targetEnvironment(simulator)
    imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
    #else
    imagePicker.sourceType = UIImagePickerController.SourceType.camera
    imagePicker.showsCameraControls = true
    #endif
    // Sets the camera interface to capture still images.
    imagePicker.mediaTypes = ["public.image"]
    //  the user is allowed to edit the selected image.
    imagePicker.allowsEditing = true
    // Presents imagePicker on the screen.
    self.present(imagePicker, animated: true, completion: nil)
  }
  // you have the option of selecting a photo or canceling
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  // if you select photo below func will triggered and a photo will be returned and assigned to selectedImage.
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      self.thumbnail = selectedImage.preparingThumbnail(of: CGSize(width: 100, height: 100))
      let mainImageViewSize = mainImageView.frame.size
      self.mainImage = selectedImage.preparingThumbnail(of: mainImageViewSize)
    }
    picker.dismiss(animated: true) {
      self.showApplyUserInterface()
    }
  }
}
// any class that adopts this  protocol gets the apply(filter:originalImage:) method.
// uses this method to apply the selected filter to the photo stored in the PhotoFilterViewController instance's mainImage property, and the result is assigned to the mainImageView outlet so that it is visible on the screen.

extension PhotoFilterViewController: imageFiltering {
  func filterMainImage(filterItem: FilterItem) {
    if let mainImage = mainImage, let filter = filterItem.filter {
      // // If you selected the None filter, then mainImage is assigned to the mainImageView outlet
      if filter != "None" {
        mainImageView.image = self.apply(filter: filter, originalImage: mainImage)
      } else {
        mainImageView.image = mainImage
      }
    }
  }
}

extension PhotoFilterViewController: UICollectionViewDelegate {
  //  method is called whenever the user taps a cell in the collection view.
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let filterItem = self.filters[indexPath.row]
    filterMainImage(filterItem: filterItem)
  }
}
