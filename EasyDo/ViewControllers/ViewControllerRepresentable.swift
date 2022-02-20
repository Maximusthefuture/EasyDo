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
        return PickTimeViewController(initialHeight: 0)
    }
    
}

struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            ViewControllerRepresentable().previewLayout(.fixed(width: 300, height: 70))
        }
    }
}

#endif
