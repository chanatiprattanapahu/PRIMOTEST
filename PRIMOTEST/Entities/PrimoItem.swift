//
//  PrimoItem.swift
//  PRIMOTEST
//
//  Created by gusguz on 14/4/2567 BE.
//

import Foundation
import RealmSwift

final class Primo: Object {
    var items = List<PrimoItem>()
}

final class PrimoItem: Object
{
    @objc dynamic var title: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var guid: String = ""
    var category = List<CategoryItem>()
    @objc dynamic var creator: String = ""
    @objc dynamic var pubDate: Double = 0
    @objc dynamic var atomUpdate: Double = 0
    @objc dynamic var content: String?
    
}
