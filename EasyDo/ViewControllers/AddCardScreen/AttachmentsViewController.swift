//
//  AttachmentsViewController.swift
//  EasyDo
//
//  Created by Maximus on 12.01.2022.
//

import Foundation
import UIKit

class AttachmentsViewController: ResizableViewController {
   

    
//    private var currentHeight: CGFloat
    
    var viewModel: AttachmentsViewModelProtocol?
    
    let button: UIButton = {
       let b = UIButton()
        b.backgroundColor = .red
        b.setTitle("Add attachment", for: .normal)
        b.addTarget(self, action: #selector(handleAddAttachment), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AttachmentsViewModel()
        view.backgroundColor = .blue
        view.addSubview(button)
        button.centerInSuperview(size: .init(width: 100, height: 100))   
    }
    
//    override init(initialHeight: CGFloat) {
//        currentHeight = initialHeight
//        super.init(initialHeight: initialHeight)
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    @objc private func handleAddAttachment() {
        //Image picker for start? than pdf? download from url, then store in filesystem
        //video, audio???? avfoundation practies?
        //then share attachment???
//        let picker = UIImagePickerController()
        let picker = UIDocumentPickerViewController(forExporting: [])
        present(picker, animated: true)
        print("HANDLE IT")
    }
    
   
    
}
