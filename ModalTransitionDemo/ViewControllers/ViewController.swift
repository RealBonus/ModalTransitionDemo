//
//  ViewController.swift
//  TabBarPlayground
//
//  Created by Павел Анохов on 18.11.2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Push as modal", for: .normal)
        button.addTarget(self, action: #selector(goPressed), for: .touchUpInside)
        return button
    }()

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .systemBackground

        view.addSubview(button)

        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func goPressed() {
        let viewController = ModalViewController()

        navigationController?.delegate = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
}
