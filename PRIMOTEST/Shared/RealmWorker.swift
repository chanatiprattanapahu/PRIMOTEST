//
//  RealmWorker.swift
//  PRIMOTEST
//
//  Created by gusguz on 14/4/2567 BE.
//

import Foundation
import RealmSwift

class RealmWorker
{
    var realm: Realm!
    
    static let shared = RealmWorker()
    
    private init() {}
    
    func setupRealm()
    {
        configure()
    }
    
    private func configure() {
        realm = try! Realm()
    }
    
    private func clear() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func setupData(model: Home.PrimoModel) {
        clear()
        do {
            try realm.write {
                let primoDataModel = Primo()
                for item in model.items ?? [] {
                    primoDataModel.items.append(setupData(data: item))
                }
                realm.create(Primo.self, value: primoDataModel)
            }
        } catch {
            print("error")
        }
    }
    
    private func setupData(data: Home.PrimoItemModel) -> PrimoItem {
        let primoItem = PrimoItem()
        primoItem.title = data.title ?? ""
        primoItem.link = data.link ?? ""
        primoItem.guid = data.guid ?? ""
        let categoryList = List<CategoryItem>()
        for category in data.category ?? [] {
            let categoryItem = CategoryItem()
            categoryItem.title = category.title ?? ""
            categoryList.append(categoryItem)
        }
        primoItem.category = categoryList
        primoItem.creator = data.creator ?? ""
        primoItem.pubDate = data.pubDate?.timeIntervalSince1970 ?? 0
        primoItem.atomUpdate = data.atomUpdate?.timeIntervalSince1970 ?? 0
        primoItem.content = data.content ?? ""
        return primoItem
    }
    
}
