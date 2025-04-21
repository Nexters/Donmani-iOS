//
//  SettingView.swift
//  Donmani
//
//  Created by 문종식 on 2/3/25.
//

import SwiftUI
import DNetwork
import ComposableArchitecture
import DesignSystem

struct SettingView: View {
    enum Menutype {
        case notification
        case notice
        case recordGuide
        case feedback
        case privacyPolicy
        
        var title: String {
            switch self {
            case .notification:
                return "앱 푸시 알림"
            case .notice:
                return "공지사항"
            case .recordGuide:
                return "별별소 기록 규칙"
            case .feedback:
                return "피드백"
            case .privacyPolicy:
                return "개인정보 처리방침"
            }
        }
    }
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @StateObject var keyboard = KeyboardResponder()
    let width = UIScreen.main.bounds.width
    @State var isPresentingRecordGuideView = false
    @State var isPresentingFeedbackView = false
    @State var isPresentingPrivacyPolicyView = false
    @State var isPresentingNoticeView = false
    @State var isPresentingEditNameView = false
    @State var isSaveEnabled = true
    @State var userName = DataStorage.getUserName()
    @State var editUserName: String = ""
    @State var isPresentingLengthGuideToastView = false
    @State var isPresentingSymbolGuideToastView = false
    @State var isNotificationEnabled = false
    @State var isNoticeNotRead = false
    
    @FocusState var isFocusToTextField: Bool
    
    
    let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\s]+$"
    var isSaveEnable: Bool {
        let isValidCount = (2 <= editUserName.count && editUserName.count <= 12)
        let isValidCharacter = (editUserName.range(of: pattern, options: .regularExpression) != nil)
        return isValidCount && isValidCharacter
    }
    
    // TODO: - Add Store
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .center, spacing: .defaultLayoutPadding) {
                ZStack {
                    HStack {
                        DNavigationBarButton(.leftArrow) {
                            dismiss()
                        }
                        Spacer()
                    }
                    .padding(.horizontal, .defaultLayoutPadding)
                    DText("설정")
                        .style(.b1, .semibold, .white)
                }
                .padding(.vertical, 14)
                
                VStack(alignment: .center, spacing: 12) {
                    DImage(.profile).image
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 100, height: 100)
                    HStack(spacing: 6) {
                        Button {
                            GA.Click(event: .settingNickname).send()
                            editUserName = userName
                            isFocusToTextField = true
                            isPresentingEditNameView = true
                        } label: {
                            DText(userName)
                                .style(.b1, .semibold, .white)
                            DImage(.edit).image
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: .s4, height: .s4)
                        }
                    }
                }
                .padding(.defaultLayoutPadding)
                .padding(.bottom, .defaultLayoutPadding)
                
                VStack(alignment: .leading, spacing: 0) {
                    MenuButton(type: .notification) {
                        GA.Click(event: .settingNotice).send()
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            if UIApplication.shared.canOpenURL(appSettings) {
                                UIApplication.shared.open(appSettings)
                            }
                        }
                    }
                    MenuButton(type: .notice) {
                        GA.Click(event: .settingNotice).send()
                        Task {
                            try await NetworkService.User().updateNoticeStatus()
                            isNoticeNotRead = false
                            isPresentingNoticeView.toggle()
                        }
                    }
                    MenuButton(type: .recordGuide) {
                        GA.Click(event: .settingRules).send()
                        isPresentingRecordGuideView.toggle()
                    }
                    
                    MenuButton(type: .feedback) {
                        isPresentingFeedbackView.toggle()
                    }
                    
                    MenuButton(type: .privacyPolicy) {
                        isPresentingPrivacyPolicyView.toggle()
                    }
                }
                Spacer()
            }
            
            if isPresentingRecordGuideView {
                RecordGuideView()
            }
            
            if isPresentingEditNameView {
                EditNameView()
                    .padding(.bottom, keyboard.currentHeight)
                    .animation(.easeOut(duration: 0.3), value: keyboard.currentHeight)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .ignoresSafeArea(.all, edges: .bottom)
            }
            
            VStack {
                Spacer()
                ToastView(title: "최대로 작성했어요")
                    .padding(40)
            }
            .opacity(isPresentingLengthGuideToastView ? 1 : 0)
            
            VStack {
                Spacer()
                ToastView(title: "특수문자는 입력할 수 없어요")
                    .padding(40)
            }
            .opacity(isPresentingSymbolGuideToastView ? 1 : 0)
        }
        .sheet(isPresented: $isPresentingPrivacyPolicyView) {
            // Privacy Policy WebView
            InnerWebView(urlString: DURL.privacyPolicy.urlString)
        }
        .sheet(isPresented: $isPresentingFeedbackView) {
            // Feeback WebView
            InnerWebView(urlString: DURL.feedback.urlString)
        }
        .sheet(isPresented: $isPresentingNoticeView) {
            // Notice WebView
            InnerWebView(urlString: DURL.notice.urlString)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase  in
//            print("OnAppear")
            if newPhase == .active {
                let notification = NotificationManager()
                notification.getNotificationPermissionStatus { status in
                    if (status == .authorized) {
                        notification.registerForRemoteNotifications()
                    } else {
                        notification.unregisterForRemoteNotifications()
                    }
                    isNotificationEnabled = (status == .authorized)
                }
            }
        }
        .onAppear() {
            NotificationManager().getNotificationPermissionStatus { status in
                isNotificationEnabled = (status == .authorized)
            }
            Task {
                isNoticeNotRead = !(try await NetworkService.User().fetchNoticeStatus())
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func MenuButton(
        type: Menutype,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            ZStack {
                HStack(spacing: 4) {
                    DText(type.title)
                        .style(.b1, .bold, .white)
                    if type == .notice {
                        HStack(alignment: .top) {
                            Circle()
                                .fill(DColor.noticeColor)
                                .frame(width: 6, height: 6)
                                .padding(.bottom, 18)
                        }
                        .opacity(isNoticeNotRead ? 1 : 0)
                    }
                    Spacer()
                }
                .frame(width: width - .defaultLayoutPadding * 2, alignment: .leading)
                .padding(.horizontal, .defaultLayoutPadding)
                .padding(.vertical, 18)
                HStack {
                    Spacer()
                    if type == .notification {
                        DToggle(isOn: $isNotificationEnabled)
                    }
                }
                .padding(.horizontal, .defaultLayoutPadding)
            }
        }
    }
}

#Preview {
    SettingView()
}
