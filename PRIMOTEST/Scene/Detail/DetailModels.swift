import Foundation

enum Detail {
    enum LoadContent {
        struct Request {}
        struct Response {
            var result: Result<String, CustomError>
        }
        struct ViewModel {
            var result: Result<String, CustomError>
        }
    }
}
