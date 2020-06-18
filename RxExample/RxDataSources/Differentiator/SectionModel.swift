//
//  SectionModel.swift
//  RxDataSources
//
//  Created by Krunoslav Zaher on 6/16/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation

//Section泛型
//ItemType泛型
public struct SectionModel<Section, ItemType> {
    public var model: Section
    public var items: [Item]

    //构造方法
    public init(model: Section, items: [Item]) {
        self.model = model
        self.items = items
    }
}

extension SectionModel
    : SectionModelType {
    public typealias Identity = Section
    //定义Item
    public typealias Item = ItemType

    //增加属性
    public var identity: Section {
        return model
    }
}

extension SectionModel
    : CustomStringConvertible {

    public var description: String {
        return "\(self.model) > \(items)"
    }
}

extension SectionModel {
    public init(original: SectionModel<Section, Item>, items: [Item]) {
        self.model = original.model
        self.items = items
    }
}
