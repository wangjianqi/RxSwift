//
//  Disposable.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 2/8/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

/// Represents a disposable resource.
public protocol Disposable {
    /// Dispose resource.
    //销毁
    func dispose()
}
