import Foundation

protocol DetailBusinessLogic {
    func loadContent(request: Detail.LoadContent.Request)
}

protocol DetailDataStore {
    var item: PrimoItem? { get set }
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore {
    var presenter: DetailPresentationLogic?
    var worker: DetailWorker?
    var item: PrimoItem?
    
    func loadContent(request: Detail.LoadContent.Request) {
        guard let item = item, let content = item.content else {
            let response = Detail.LoadContent.Response(result: .failure(.errorContent))
            presenter?.presentLoadContent(response: response)
            return
        }
        let response = Detail.LoadContent.Response(result: .success(content))
        presenter?.presentLoadContent(response: response)
    }
}
