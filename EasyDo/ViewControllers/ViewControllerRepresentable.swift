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
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return ProjectMainViewController()
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
