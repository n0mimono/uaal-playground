//
//  ViewController.swift
//  uaal
//
//  Created by Ryota Yokote on 2020/10/30.
//

import UIKit
import UnityFramework
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backViewBottom: NSLayoutConstraint!
    @IBOutlet weak var unityBaseView: UIView!
    
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let ufw = UnityFramework.getInstance() else { return }
        guard let unityView = ufw.appController()?.rootView else { return }
        guard let unityParentView = unityBaseView else { return }

        unityParentView.addSubview(unityView)
        unityView.translatesAutoresizingMaskIntoConstraints = false
        unityView.centerXAnchor.constraint(equalTo: unityParentView.centerXAnchor).isActive = true
        unityView.centerYAnchor.constraint(equalTo: unityParentView.centerYAnchor).isActive = true
        unityView.widthAnchor.constraint(equalTo: unityParentView.widthAnchor, multiplier: 1.0).isActive = true
        unityView.heightAnchor.constraint(equalTo: unityParentView.heightAnchor, multiplier: 1.0).isActive = true
        
        let originBottom = backViewBottom.constant
        button0.rx.tap
            .bind { [weak self] _ in
                self?.backViewBottom.constant = originBottom
            }
            .disposed(by: disposeBag)
        button1.rx.tap
            .bind { [weak self] _ in
                self?.backViewBottom.constant = 200
            }
            .disposed(by: disposeBag)
        button2.rx.tap
            .bind { [weak self] _ in
                self?.backViewBottom.constant = 400
            }
            .disposed(by: disposeBag)
    }
}
