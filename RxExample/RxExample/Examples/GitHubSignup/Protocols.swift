//
//  Protocols.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import RxSwift
import RxCocoa

///结果
enum ValidationResult {
    case ok(message: String)
    // 空的
    case empty
    //验证中
    case validating
    ///失败
    case failed(message: String)
}

enum SignupState {
    case signedUp(signedUp: Bool)
}

//Api协议
protocol GitHubAPI {
    func usernameAvailable(_ username: String) -> Observable<Bool>
    func signup(_ username: String, password: String) -> Observable<Bool>
}

//验证协议
protocol GitHubValidationService {
    ///名字验证
    func validateUsername(_ username: String) -> Observable<ValidationResult>
    //密码
    func validatePassword(_ password: String) -> ValidationResult
    ///确认密码验证
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

