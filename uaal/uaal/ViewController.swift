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
    
    @IBOutlet weak var virtualViewHeight: NSLayoutConstraint!
    @IBOutlet weak var virtualViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var unityBaseView: UIView!
    
    @IBOutlet weak var heightScalerSlider: UISlider!
    @IBOutlet weak var widthScalerSlider: UISlider!
    @IBOutlet weak var controlInfoLabel: UILabel!
    
    struct State {
        var virtualViewHeight: CGFloat
        var virtualViewWidth: CGFloat
    }
    var current = BehaviorRelay<State>(
        value: State(
            virtualViewHeight: 812,
            virtualViewWidth: 375
        )
    )
    
    enum Action {
        case updateVirtualViewHeight(height: CGFloat)
        case updateVirtualViewWidth(width: CGFloat)
    }
    
    func updateState(_ action: Action)
    {
        var state = current.value
        switch action {
        case .updateVirtualViewHeight(let height):
            state.virtualViewHeight = height
        case .updateVirtualViewWidth(let width):
            state.virtualViewWidth = width
        }
        current.accept(state)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        addUnityView(to: unityBaseView)
                
        let fullBounds = view.bounds
        virtualViewHeight.constant = fullBounds.height
        virtualViewWidth.constant = fullBounds.width
        
        heightScalerSlider.rx.value
            .map { CGFloat($0) * fullBounds.height }
            .bind { [weak self] v in self?.updateState(.updateVirtualViewHeight(height: v)) }
            .disposed(by: disposeBag)
        widthScalerSlider.rx.value
            .map { CGFloat($0) * fullBounds.width }
            .bind { [weak self] v in self?.updateState(.updateVirtualViewWidth(width: v)) }
            .disposed(by: disposeBag)
        
        current.map { $0.virtualViewHeight }
            .bind(to: virtualViewHeight.rx.constant)
            .disposed(by: disposeBag)
        current.map { $0.virtualViewWidth }
            .bind(to: virtualViewWidth.rx.constant)
            .disposed(by: disposeBag)
        current.map {
            let ratio = $0.virtualViewWidth / $0.virtualViewHeight
            return "\($0.virtualViewHeight.r10())\n\($0.virtualViewWidth.r10())\n\(ratio.r10())"
        }
        .bind(to: controlInfoLabel.rx.text)
        .disposed(by: disposeBag)
    }
}

extension CGFloat {
    func r10() -> CGFloat {
        return (self * 10).rounded() / 10
    }
}
