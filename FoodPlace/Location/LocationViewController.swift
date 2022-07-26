import UIKit

class LocationViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  let manager = LocationDataManager()
  var selectedCity: LocationItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
      
    }
  private func setCheckmark(for cell: UITableViewCell, location: LocationItem) {
  if selectedCity == location {
    cell.accessoryType = .checkmark
  } else {
    cell.accessoryType = .none
    }
  }
}

extension LocationViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      manager.numberOfLocationItems()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
    let location = manager.locationItem(at: indexPath.row)
    cell.textLabel?.text = location.cityAndState
    setCheckmark(for: cell, location: location)
    return cell
  }
    
}
// MARK: Private Extension
private extension LocationViewController {
  func initialize() {
    manager.fetch()
    title = "Select a Location"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
}

// MARK: UITableViewDelegate
// The UITableViewDelegate protocol specifies the messages that a table view will send to its delegate when the user interacts with the rows in it
extension LocationViewController: UITableViewDelegate {
  // When the user taps a row in the Locations screen, a checkmark will appear in that row, and the selectedCity property is assigned the corresponding LocationItem instance in the locations array.
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      cell.accessoryType = .checkmark
      selectedCity = manager.locationItem(at: indexPath.row)
      tableView.reloadData()
    }
  }
}
