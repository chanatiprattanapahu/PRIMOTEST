//  Created by gusguz on 14/4/2567 BE.
import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayGetHomeData(viewModel: Home.GetData.ViewModel)
}

class HomeViewController: BaseViewController {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    var displayedItems = [Home.CardItem]()
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        refreshControl.addTarget(self, action: #selector(self.reloadData), for: .valueChanged)
        
        return refreshControl
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        fetchData()
    }
    
    private func setupCollection() {
        let width = ((collectionView.bounds.width - 48) / 2.0)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.itemSize = CGSize(width: width, height: width)
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(
            UINib(nibName: "HomeCardCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "HomeCardCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addSubview(refreshControl)
        collectionView.reloadData()
    }
    
    private func fetchData(forceReload: Bool = false) {
        loading.isHidden = false
        loading.startAnimating()
        interactor?.getHomeData(request: Home.GetData.Request(forceReload: forceReload))
    }
    
    @objc private func reloadData() {
        refreshControl.endRefreshing()
        fetchData(forceReload: true)
    }
}

extension HomeViewController: HomeDisplayLogic {
    func displayGetHomeData(viewModel: Home.GetData.ViewModel) {
        loading.isHidden = true
        loading.stopAnimating()
        switch viewModel.result {
        case .success(let items):
            displayedItems = items
            collectionView.reloadData()
        case .failure(let error):
            displayError(error: error)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCardCollectionViewCell", for: indexPath) as? HomeCardCollectionViewCell
        cell?.configureCell(model:  displayedItems[indexPath.item])
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router?.routeToDetails(index: indexPath.item)
    }
}
