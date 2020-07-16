//
//  UIImagePickerController+Rx.swift
//  RxExample
//
//  Created by Segii Shulga on 1/4/16.
//  Copyright © 2016 Krunoslav Zaher. All rights reserved.
//


#if os(iOS)
    
    import RxSwift
    import RxCocoa
    import UIKit

    extension Reactive where Base: UIImagePickerController {

        /**
         Reactive wrapper for `delegate` message.
         */
        //类型
        public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey : AnyObject]> {
            //执行方法
            return delegate
                //methodInvoked返回：Observable<[Any]>
                .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
                .map({ (a) in
                    return try castOrThrow(Dictionary<UIImagePickerController.InfoKey, AnyObject>.self, a[1])
                })
        }

        /**
         Reactive wrapper for `delegate` message.
         */
        //取消：Void
        public var didCancel: Observable<()> {
            //执行方法
            return delegate
                .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
                .map {_ in () }
        }
        
    }
    
#endif
//给object解包
fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        //抛出错误
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}
