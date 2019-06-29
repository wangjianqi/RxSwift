//
//  GeolocationViewController.swift
//  RxExample
//
//  Created by Carlos García on 19/01/16.
//  Copyright © 2016 Krunoslav Zaher. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

private extension Reactive where Base: UILabel {
    ///类型
    var coordinates: Binder<CLLocationCoordinate2D> {
        return Binder(base) { label, location in
            label.text = "Lat: \(location.latitude)\nLon: \(location.longitude)"
        }
    }
}

class GeolocationViewController: ViewController {
    
    @IBOutlet weak private var noGeolocationView: UIView!
    @IBOutlet weak private var button: UIButton!
    @IBOutlet weak private var button2: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(noGeolocationView)
        
        let geolocationService = GeolocationService.instance
        
        ///是否有权限
        geolocationService.authorized
            .drive(noGeolocationView.rx.isHidden)
            .disposed(by: disposeBag)
        
        geolocationService.location
            ///显示经纬度
            .drive(label.rx.coordinates)
            .disposed(by: disposeBag)
        
        ///跳转到设置
        button.rx.tap
            .bind { [weak self] _ -> Void in
                self?.openAppPreferences()
            }
            .disposed(by: disposeBag)
        
        button2.rx.tap
            .bind { [weak self] _ -> Void in
                self?.openAppPreferences()
            }
            .disposed(by: disposeBag)
    }
    
    private func openAppPreferences() {
        UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
    }
    
}
