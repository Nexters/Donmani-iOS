//
//  GA.swift
//  Donmani
//
//  Created by 문종식 on 4/6/25.
//

import FirebaseAnalytics

class GA {
    private init() {
        
    }
    
    static func debugEventLog() {
        Analytics.logEvent("DebugEvent_mjs", parameters: nil)
    }
}

//| open | 앱 또는 UI 요소가 열린 시점 | 앱 실행, 알림 바텀시트 열림 | 앱 세션 시작, 진입 시점 측정 |
//| click | 유저가 버튼, 카드 등 클릭/탭한 시점 | 기록하기 버튼 클릭, 알림 클릭 | 행동 유도 요소의 반응 측정 |
//| view | 전체 화면 또는 모달 등을 본 시점 | 기록화면 진입, 온보딩 진입 | 화면 진입 분석, 퍼널 시작 지점 |
//| impression | 콘텐츠가 화면에 노출된 시점 | 홈 배너 노출, 인사이트 카드 보임 | 콘텐츠 노출률, 반응률 분석 |
//| submit | 내용을 입력하고 저장/제출한 시점 | 기록 저장 완료 | 최종 행동 완료 측정 |
//| receive | 푸시 알림이 기기에 도달한 시점 | 알림 수신 | 알림 발송 성공률 측정 |
