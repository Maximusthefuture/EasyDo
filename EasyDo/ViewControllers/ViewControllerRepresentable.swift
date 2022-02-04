//
//  ViewControllerRepresentable.swift
//  EasyDo
//
//  Created by Maximus on 18.01.2022.
//

import Foundation
import SwiftUI


#if canImport(SwiftUI) && DEBUG

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    let container = DependencyContainer()
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return container.makeDayTasksViewContoller()
    }
    
}

struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            ViewControllerRepresentable()
            ViewControllerRepresentable()
            ViewControllerRepresentable()
        }
    }
}

#endif
