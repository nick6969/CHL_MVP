//
//  ShowDataVC.swift
//  CHLMVP_Example
//
//  Created by Nick Lin on 2018/4/23.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import CHLMVP

class ShowDataVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    lazy var presenter: ShowDataPresenter = ShowDataPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.loadDelegate = self
        presenter.loadStateDelegate = self
        presenter.nextState()
    }

}
extension ShowDataVC: PresenterLoadDelegate {

    func loadingDone(_ oldCount: Int, _ newCount: Int) {
        tableView.reloadData()
    }

    func loadingFail(_ error: Error?) {

    }

}

extension ShowDataVC: PresenterLoadStateDelegate {

    func showEmptyView(with: Error?) {

    }

    func removeEmptyView() {

    }

    func showLoading(_ bool: Bool) {

    }
}

extension ShowDataVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.datasCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShowDataTableViewCell
        if let model = presenter.model(at: indexPath.row) {
            cell.setup(with: model)
        }
        return cell
    }
}

extension ShowDataVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if presenter.isLastData(index: indexPath.row) {
            presenter.nextState()
        }
    }

}
