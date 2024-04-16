protocol DetailPresentationLogic {
    func presentLoadContent(response: Detail.LoadContent.Response)
}

class DetailPresenter: DetailPresentationLogic {
    weak var viewController: DetailDisplayLogic?
    
    func presentLoadContent(response: Detail.LoadContent.Response) {
        switch response.result {
        case .success(let content):
            let viewModel = Detail.LoadContent.ViewModel(result: .success(content))
            viewController?.displayLoadContent(viewModel: viewModel)
        case .failure(let error):
            let viewModel = Detail.LoadContent.ViewModel(result: .failure(error))
            viewController?.displayLoadContent(viewModel: viewModel)
        }
    }
}
