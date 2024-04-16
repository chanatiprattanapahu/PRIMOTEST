import Foundation

@objc protocol HomeRoutingLogic {
    func routeToDetails(index: Int)
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing {
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
    
    func routeToDetails(index: Int) {
        guard let items = dataStore?.data?.items, index < items.count else { return }
        let destVC = DetailViewController.initFromStoryboard()
        var dataStore = destVC.router?.dataStore
        dataStore?.item = items[index]
        viewController?.navigationController?.pushViewController(destVC, animated: true)
    }
}
