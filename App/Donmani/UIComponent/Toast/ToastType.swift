//
//  ToastType.swift
//  Donmani
//
//  Created by 문종식 on 9/12/25.
//

import DesignSystem

enum ToastType {
    case maxNicknameLengthExceeded
    case specialCharactersNotAllowed
    case successSaveDecoration
    case emptyRecordMonth
    case none
    
    var title: String {
        switch self {
        case .maxNicknameLengthExceeded:
            "최대로 작성했어요"
        case .specialCharactersNotAllowed:
            "특수문자는 입력할 수 없어요"
        case .successSaveDecoration:
            "꾸미기를 반영했어요"
        case .emptyRecordMonth:
            "앗! 이달은 기록이 없어요"
        case .none:
            ""
        }
    }
    
    var position: ToastPosition? {
        switch self {
        case .maxNicknameLengthExceeded, .specialCharactersNotAllowed, .emptyRecordMonth:
                .bottom
        case .successSaveDecoration:
                .top
        case .none:
                nil
        }
    }
    
    var icon: DImageAsset? {
        switch self {
        case .maxNicknameLengthExceeded, .specialCharactersNotAllowed, .emptyRecordMonth:
                .warning
        case .successSaveDecoration:
                .success
        case .none:
                nil
        }
    }
    
    var opacity: CGFloat {
        switch self {
        case .none: 0
        default: 1
        }
    }
    
    var offset: CGFloat {
        switch self {
        case .none: 0
        default: -4
        }
    }
}
