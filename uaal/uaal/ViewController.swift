//
//  ViewController.swift
//  uaal
//
//  Created by Ryota Yokote on 2020/10/30.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, Unity {
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

        addUnityView(to: unityBaseView)
        
        let originBottom = backViewBottom.constant
        button0.rx.tap
            .bind { [weak self] _ in
                self?.backViewBottom.constant = originBottom
                
                self?.canvasScalerReferenceMatch(match: 0.5)
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
