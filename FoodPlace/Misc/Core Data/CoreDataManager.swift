import CoreData

struct CoreDataManager {
  let container: NSPersistentContainer
  init() {
    container = NSPersistentContainer(name:
    "FoodPlaceModel")
      container.loadPersistentStores {(storeDesc, error) in
          error.map {
            print($0)
          }
      }
  }
  // calculate overall score
  func fetchRestaurantRating(by identifier: Int) -> Double {
    let reviewItems = fetchReviews(by: identifier)
    // The reduce() method takes a closure, which is used to add all the review ratings together
    let sum = reviewItems.reduce(0, {$0 + ($1.rating ?? 0)})
    return sum / Double(reviewItems.count)
  }
  
  func addReview(_ reviewItem: ReviewItem) {
    let review = Review(context: container.viewContext)
    review.date = Date()
    if let ReviewItemRating = reviewItem.rating {
      review.rating = ReviewItemRating
    }
    review.title = reviewItem.title
    review.name = reviewItem.name
    review.customerReview = reviewItem.customerReview
    review.uuid = reviewItem.uuid
    if let reviewItemRestID = reviewItem.restaurantID {
      review.restaurantID = reviewItemRestID
    }
    save()
  }
  
  func addPhoto(_ restPhotoItem: RestaurantPhotoItem) {
    let restPhoto = RestaurantPhoto(context: container.viewContext)
    restPhoto.date = Date()
    restPhoto.photo = restPhotoItem.photoData
    if let restPhotoID = restPhotoItem.restaurantID {
      restPhoto.restaurantID = restPhotoID
    }
    restPhoto.uuid = restPhotoItem.uuid
    save()
  }
  // When you want to retrieve reviews and photos from the persistent store, you will use restaurantID as an identifier to get reviews and photos for a particular restaurant. Let's implement the methods required for this now
  func fetchReviews(by identifier: Int) -> [ReviewItem] {
    let moc = container.viewContext
    let request = Review.fetchRequest()
    // This creates a fetch predicate that only gets those Review instances with the specified restaurantID.
    let predicate = NSPredicate(format: "restaurantID = %i", identifier)
    var reviewItems: [ReviewItem] = []
    request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    request.predicate = predicate
    do {
      for review in try moc.fetch(request) {
        reviewItems.append(ReviewItem(review: review))
      }
      return reviewItems
    } catch {
      fatalError("Failed to fetch reviews: \(error)")
    }
  }
  
  func fetchRestPhoto(by identifier: Int) -> [RestaurantPhotoItem] {
    let moc = container.viewContext
    let request = RestaurantPhoto.fetchRequest()
    let predicate = NSPredicate(format: "restaurantID = %i", identifier)
    var restPhotoItems: [RestaurantPhotoItem] = []
    request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    request.predicate = predicate
    // This do-catch block performs the fetch request and places the results in the items array. If unsuccessful, your app will crash and an error message will be printed in the Debug area. fetchPhotos(by:) works the same way as fetchReview(by:), but returns an array of RestaurantPhotoItems instances instead.
    do {
      for restPhoto in try moc.fetch(request) {
        restPhotoItems.append(RestaurantPhotoItem(restaurantPhoto: restPhoto))
    }
      return restPhotoItems
    } catch {
      fatalError("Failed to fetch restaurant photos: \(error)")
      }
    }
  
  private func save() {
    do {
      if container.viewContext.hasChanges {
        try container.viewContext.save()
      }
    } catch let error {
      print(error.localizedDescription)
    }
  }
}
