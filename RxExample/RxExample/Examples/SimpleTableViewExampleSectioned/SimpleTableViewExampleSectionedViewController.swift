//
//  SimpleTableViewExampleSectionedViewController.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleTableViewExampleSectionedViewController
    : ViewController
    , UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    //配置
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Double>>(
        //cell
        // element:SectionModel中double
        //配置cell
        configureCell: { (_, tv, indexPath, element) in
            //复用cell
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(indexPath.row)"
            return cell
        },
        //配置Section的标题
        //header
        titleForHeaderInSection: { dataSource, sectionIndex in
            //model:SectionModel中String
            return dataSource[sectionIndex].model
        }
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let dataSource = self.dataSource
        //数据源
        //just:唯一的元素
        let items = Observable.just([
            SectionModel(model: "First section", items: [
                    1.0,
                    2.0,
                    3.0
                ]),
            SectionModel(model: "Second section", items: [
                    1.0,
                    2.0,
                    3.0
                ]),
            SectionModel(model: "Third section", items: [
                    1.0,
                    2.0,
                    3.0
                ])
            ])

        // 绑定
        items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx
            .itemSelected
            //转化
            .map { indexPath in
                //返回类型
                return (indexPath, dataSource[indexPath])
            }
            .subscribe(onNext: { pair in
                DefaultWireframe.presentAlert("Tapped `\(pair.1)` @ \(pair.0)")
            })
            .disposed(by: disposeBag)

        //设置代理
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }

    // to prevent swipe to delete behavior
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
