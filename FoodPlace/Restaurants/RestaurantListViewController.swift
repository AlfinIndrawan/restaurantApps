//
//  RestaurantListViewController.swift
//  LetsEat
//
//  Created by Alfin on 29/5/22.
//

import UIKit

class RestaurantListViewController: UIViewController {
  var selectedRestaurant: RestaurantItem?
  var selectedCity: LocationItem?
  var selectedCuisine: String?
  @IBOutlet var collectionView: UICollectionView!
  
  override func viewDidLoad() {
        super.viewDidLoad()
      
    }
  // viewDidAppear() is called every time a view controller's view appears onscreen, while viewDidLoad() is only called once when a view controller initially loads its view.
  //  viewDidAppear() is used here because the RestaurantListViewController instance will show a different list of restaurants each time its view appears onscreen, depending on the choices made by the user.
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("selected city \(selectedCity as Any)")
    print("selected cuisine \(selectedCuisine as Any)")
  }
  
}

extension RestaurantListViewController: UICollectionViewDelegate {
  
}

extension RestaurantListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    1
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCell", for: indexPath )
  }
  
}

// MARK: Private Extension
private extension RestaurantListViewController {
  
}
