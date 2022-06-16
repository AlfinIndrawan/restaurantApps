//
//  RestaurantListViewController.swift
//  LetsEat
//
//  Created by Alfin on 29/5/22.
//

import UIKit

class RestaurantListViewController: UIViewController {
  @IBOutlet var collectionView: UICollectionView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
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
