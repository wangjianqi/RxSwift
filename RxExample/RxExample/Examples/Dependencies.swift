//
//  Dependencies.swift
//  RxExample
//
//  Created by carlos on 13/5/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import RxSwift

import class Foundation.URLSession
import class Foundation.OperationQueue
import enum Foundation.QualityOfService

class Dependencies {

    // *****************************************************************************************
    // !!! This is defined for simplicity sake, using singletons isn't advised               !!!
    // !!! This is just a simple way to move services to one location so you can see Rx code !!!
    // *****************************************************************************************
    static let sharedDependencies = Dependencies() // Singleton
    
    let URLSession = Foundation.URLSession.shared
    //后台线程
    let backgroundWorkScheduler: ImmediateSchedulerType
    let mainScheduler: SerialDispatchQueueScheduler
    let wireframe: Wireframe
    //网络状态
    let reachabilityService: ReachabilityService
    
    private init() {
        wireframe = DefaultWireframe()
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        //优先级
        operationQueue.qualityOfService = QualityOfService.userInitiated
        backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)
        
        mainScheduler = MainScheduler.instance
        reachabilityService = try! DefaultReachabilityService() // try! is only for simplicity sake
    }
    
}
