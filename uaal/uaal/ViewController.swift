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
    @IBOutlet weak var adjustControl: UISegmentedControl!

    enum Adjust: Int {
        case none = 0
        case scaler = 1
        case resol = 2
    }

    struct State {
        var virtualViewHeight: CGFloat
        var virtualViewWidth: CGFloat
        var adjust: Adjust
    }
    var current = BehaviorRelay<State>(
        value: State(
            virtualViewHeight: 812,
            virtualViewWidth: 375,
            adjust: .none
        )
    )

    enum Action {
        case updateVirtualViewHeight(height: CGFloat)
        case updateVirtualViewWidth(width: CGFloat)
        case updateAdjust(adjust: Adjust)
    }

    func updateState(_ action: Action) {
        var state = current.value
        switch action {
        case .updateVirtualViewHeight(let height):
            state.virtualViewHeight = height
        case .updateVirtualViewWidth(let width):
            state.virtualViewWidth = width
        case .updateAdjust(let adjust):
            state.adjust = adjust
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
        adjustControl.rx.value
            .bind { [weak self] v in
                self?.updateState(.updateAdjust(adjust: Adjust(rawValue: v) ?? .none))
            }
            .disposed(by: disposeBag)

        current.map { $0.virtualViewHeight }
            .bind(to: virtualViewHeight.rx.constant)
            .disposed(by: disposeBag)
        current.map { $0.virtualViewWidth }
            .bind(to: virtualViewWidth.rx.constant)
            .disposed(by: disposeBag)
        current
            .map {
                let ratio = $0.virtualViewWidth / $0.virtualViewHeight
                return "\($0.virtualViewHeight.r3())\n\($0.virtualViewWidth.r3())\n\(ratio.r3())"
            }
            .bind(to: controlInfoLabel.rx.text)
            .disposed(by: disposeBag)

        // canvasScalerReferenceMatch (not work)
        current.filter { $0.adjust == .scaler}
            .bind { [weak self] state in
                guard let self = self else { return }
                let ratio = state.virtualViewWidth / state.virtualViewHeight
                let baseRatio = self.unityCanvasSize.width / self.unityCanvasSize.height
                let m = (1 - ratio) / (1 - baseRatio)
                self.canvasScalerReferenceMatch(match: m)
            }
            .disposed(by: disposeBag)

        // canvasScalerReferenceResolution (work well)
        current.filter { $0.adjust == .resol }
            .bind { [weak self] state in
                guard let self = self else { return }
                let baseRatio = self.unityCanvasSize.width / self.unityCanvasSize.height
                let ratio = state.virtualViewWidth / state.virtualViewHeight
                let scale = baseRatio / max(min(ratio, 1), baseRatio)
                let targetHeight = scale * self.unityCanvasSize.height

                self.canvasScalerReferenceResolution(width: self.unityCanvasSize.width, height: targetHeight)
            }
            .disposed(by: disposeBag)
    }
}

extension CGFloat {
    func r3() -> CGFloat {
        return (self * 1000).rounded() / 1000
    }
}
