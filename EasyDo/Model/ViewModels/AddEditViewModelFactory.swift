//
//  AddEditViewModelFactory.swift
//  EasyDo
//
//  Created by Maximus on 01.02.2022.
//

import Foundation


class AddEditViewModelFactory {
  lazy var pomodoroViewModel = PomodoroCountViewModel()
    lazy var attachmentViewModel = AttachmentsViewModel()
    var cardAddTagsViewModel: CardAddTagsViewModel?
}
