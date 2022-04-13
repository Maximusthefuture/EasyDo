//
//  AddEditViewModelFactory.swift
//  EasyDo
//
//  Created by Maximus on 01.02.2022.
//

import Foundation

protocol AddEditViewModelFactoryProtocol {
    func makePomodoroViewModel() -> PomodoroCountViewModelProtocol
//    func makeAttachmentViewModel() -> AttachmentsViewModel
    func makeCardAddTagsViewModel() -> CardAddTagsViewModelProtocol
    func makePickTimeViewModel() -> PickTimeViewModelProtocol
}


class AddEditViewModelFactory: AddEditViewModelFactoryProtocol {
   
    lazy var pomodoroViewModel = PomodoroCountViewModel()
    lazy var attachmentViewModel = AttachmentsViewModel()
    lazy var cardAddTagsViewModel = CardAddTagsViewModel()
    lazy var pickTimeViewModel = PickTimeViewModel()
    
    func makePomodoroViewModel() -> PomodoroCountViewModelProtocol {
        return pomodoroViewModel
    }
    
//    func makeAttachmentViewModel() -> AttachmentsViewModel{
//        return attachmentViewModel
//    }
    
    func makeCardAddTagsViewModel() -> CardAddTagsViewModelProtocol {
        return cardAddTagsViewModel
    }
    
    func makePickTimeViewModel() -> PickTimeViewModelProtocol {
        return pickTimeViewModel
    }
}
