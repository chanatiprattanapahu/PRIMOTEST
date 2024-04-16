import Foundation
import SWXMLHash

class HomeWorker {
    
    func loadDataService(completionHandler: @escaping (Result<Home.PrimoModel, CustomError>) -> Void) {
        guard let url = URL(string: "https://medium.com/feed/@primoapp") else {
            completionHandler(.failure(.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else {
                completionHandler(.failure(.cancelled))
                return
            }
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(.generic(error)))
                }
            } else if let data = data {
                guard let feed = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(.errorContent))
                    }
                    return
                }
                let xml = XMLHash.parse(feed)
                var items: [Home.PrimoItemModel] = []
                for element in xml["rss"]["channel"]["item"].all {
                    var item = Home.PrimoItemModel()
                    item.title = element["title"].element?.text
                    item.link = element["link"].element?.text
                    item.guid = element["guid"].element?.text
                    item.category = element["category"].all.compactMap({ data in
                        return Home.Category(title: data.element?.text)
                    })
                    item.creator = element["dc:creator"].element?.text
                    item.pubDate = self.cleanDate(date: element["pubDate"].element?.text)
                    item.atomUpdate = self.cleanDate(date: element["atom:updated"].element?.text, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                    item.content = element["content:encoded"].element?.text
                    items.append(item)
                    
                }
                DispatchQueue.main.async {
                    let model = Home.PrimoModel(items: items)
                    RealmWorker.shared.setupData(model: model)
                    completionHandler(.success(model))
                }
            }
            
        }
        task.resume()
    }
    
    func cleanDate(date: String?, format: String = "E, d MMM yyyy HH:mm:ss z") -> Date?
    {
        guard let date = date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let pubDate = dateFormatter.date(from: date)
        return pubDate
    }
}


enum CustomError: Error {
    case generic(Error)
    case cancelled
    case invalidURL
    case errorContent
}
