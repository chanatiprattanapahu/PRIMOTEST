import RealmSwift

protocol HomeBusinessLogic {
    func getHomeData(request: Home.GetData.Request)
}

protocol HomeDataStore {
    var data: Primo? { get }
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore {
    var presenter: HomePresentationLogic?
    var worker = HomeWorker()
    var data: Primo?
    
    func getHomeData(request: Home.GetData.Request) {
//        print("User Realm User file location: \(RealmWorker.shared.realm.configuration.fileURL!.path)")
        if data?.realm == nil {
          if RealmWorker.shared.realm != nil {
              data = RealmWorker.shared.realm.objects(Primo.self).first
          }
        }
        if data == nil || (data?.items ?? List<PrimoItem>()).isEmpty {
            fetchDataFromServer()
        } else if request.forceReload {
            fetchDataFromServer()
        } else {
            displayData()
            fetchDataFromServer()
        }
    }
    
    private func fetchDataFromServer() {
        worker.loadDataService { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.displayData()
            case .failure(let error):
                let response = Home.GetData.Response(result: .failure(error))
                self.presenter?.presentGetHomeData(response: response)
            }
        }
    }
    
    private func displayData() {
        data = RealmWorker.shared.realm.objects(Primo.self).first
        let response = Home.GetData.Response(result: .success(data))
        presenter?.presentGetHomeData(response: response)
    }
}
