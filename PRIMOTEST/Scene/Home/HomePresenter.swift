import RealmSwift

protocol HomePresentationLogic {
    func presentGetHomeData(response: Home.GetData.Response)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
    
    func presentGetHomeData(response: Home.GetData.Response) {
        switch response.result {
        case .success(let data):
            let items = data?.items ?? List<PrimoItem>()
            let displayedItems = Array(items).map { (item) -> Home.CardItem in
                return Home.CardItem(title: item.title, content: item.content)
            }
            let viewModel = Home.GetData.ViewModel(result: .success(displayedItems))
            viewController?.displayGetHomeData(viewModel: viewModel)
        case .failure(let error):
            let viewModel = Home.GetData.ViewModel(result: .failure(error))
            viewController?.displayGetHomeData(viewModel: viewModel)
        }
    }
}
