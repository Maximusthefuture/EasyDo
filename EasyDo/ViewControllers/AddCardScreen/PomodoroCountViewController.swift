//
//  PomodoroCountViewController.swift
//  EasyDo
//
//  Created by Maximus on 01.02.2022.
//

import Foundation
import UIKit

class PomodoroCountViewController: ResizableViewController {
    var viewModel = PomodoroCountViewModel()
    var pomodoroImage = UIImage(named: "pomodoro")
    let padding: CGFloat = 16
    let pomodoroView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    var count = 0
    var pomodoroRefreshed: ((Int) -> Void)?
    var pomodoroStackView: UIStackView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let tintedImage = self.pomodoroImage?.withRenderingMode(.alwaysTemplate)
        pomodoroView.image = tintedImage
        pomodoroView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapPomodoro)))
        pomodoroStackView = UIStackView()
        pomodoroStackView?.axis = .horizontal
        pomodoroStackView?.distribution = .equalSpacing
        pomodoroStackView?.spacing = 10
        for _ in 0...8 {
            let pomodoroView = UIImageView(image: tintedImage)
            pomodoroView.isUserInteractionEnabled = true
            pomodoroView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapPomodoro)))
            pomodoroStackView?.addArrangedSubview(pomodoroView)
        }
        view.backgroundColor = .white
        view.addSubview(pomodoroStackView!)
        pomodoroStackView?.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: padding, left: padding, bottom: 0, right: padding))
    }
    
    @objc func handleTapPomodoro(_ gesture: UITapGestureRecognizer) {
        ((gesture.view) as? UIImageView)?.tintColor = .red
        count += 1
        viewModel.pomodoroCount.value = count
        pomodoroRefreshed?(count)
    }
}
