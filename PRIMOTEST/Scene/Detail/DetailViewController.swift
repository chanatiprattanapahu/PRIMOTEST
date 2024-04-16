//  Created by gusguz on 14/4/2567 BE.
import UIKit
import WebKit

protocol DetailDisplayLogic: AnyObject {
    func displayLoadContent(viewModel: Detail.LoadContent.ViewModel)
}

class DetailViewController: BaseViewController, DetailDisplayLogic, WKNavigationDelegate {
    var webView = WKWebView()
    var interactor: DetailBusinessLogic?
    var router: (NSObjectProtocol & DetailRoutingLogic & DetailDataPassing)?
    
    static func initFromStoryboard() -> Self {
        return UIStoryboard(name: "Detail", bundle: Bundle(for: Self.self)).instantiateInitialViewController() as? Self ?? Self()
    }
    
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
        let interactor = DetailInteractor()
        let presenter = DetailPresenter()
        let router = DetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWebView()
        loadContent()
    }
    
    private func initWebView() {
        webView = WKWebView(frame: view.frame)
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
    
    private func loadContent() {
        interactor?.loadContent(request: Detail.LoadContent.Request())
    }
    
    func displayLoadContent(viewModel: Detail.LoadContent.ViewModel) {
        switch viewModel.result {
        case .success(let content):
            webView.loadHTMLString(content, baseURL: nil)
        case .failure(let error):
            displayError(error: error)
        }
    }
}
