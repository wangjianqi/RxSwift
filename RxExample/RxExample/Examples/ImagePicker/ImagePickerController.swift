//
//  ImagePickerController.swift
//  RxExample
//
//  Created by Segii Shulga on 1/5/16.
//  Copyright © 2016 Krunoslav Zaher. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ImagePickerController: ViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var galleryButton: UIButton!
    @IBOutlet var cropButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        //模拟器不可用
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        //flatMapLatest:转换序列
        cameraButton.rx.tap
            .flatMapLatest { [weak self] _ in
                //Observable<UIImagePickerController>序列
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .camera
                    picker.allowsEditing = false
                }
                    //转成：Observable<[UIImagePickerController.InfoKey : AnyObject]>序列
                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
                    //发出一个元素
                .take(1)
            }
            //要获取的数据
            .map { info in
                //取出图片
                return info[.originalImage] as? UIImage
            }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        //相册
        galleryButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = false
                }
                .flatMap {
                    $0.rx.didFinishPickingMediaWithInfo
                }
                .take(1)
            }
            .map { info in
                return info[.originalImage] as? UIImage
            }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        //可以编辑
        cropButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    //运行编辑
                    picker.allowsEditing = true
                }
                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { info in
                return info[.editedImage] as? UIImage
            }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }
    
}
