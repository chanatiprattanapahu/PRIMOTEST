import Foundation
import RealmSwift

enum Home {
    enum GetData {
        struct Request {
            var forceReload: Bool
        }
        struct Response {
            var result: Result<Primo?, CustomError>
        }
        struct ViewModel {
            var result: Result<[CardItem], CustomError>
        }
    }
    
    struct CardItem {
        var title: String?
        var content: String?
    }
    
    struct PrimoModel {
        var items: [PrimoItemModel]?
    }
    
    struct PrimoItemModel {
        var title: String?
        var link: String?
        var guid: String?
        var category: [Category]?
        var creator: String?
        var pubDate: Date?
        var atomUpdate: Date?
        var content: String?
    }

    struct Category {
        var title: String?
    }
}
