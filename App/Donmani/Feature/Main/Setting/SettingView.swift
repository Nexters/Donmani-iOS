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
        case decoration
        case sound
        case notification
        case notice
        case recordGuide
        case feedback
        case privacyPolicy
        
        var title: String {
            switch self {
            case .decoration:
                "꾸미기"
            case .sound:
                "별통이 효과음"
            case .notification:
                "앱 푸시 알림"
            case .notice:
                "공지사항"
            case .recordGuide:
                "별별소 기록 규칙"
            case .feedback:
                "별별소에게 부탁하기"
            case .privacyPolicy:
                "개인정보 처리방침"
            }
        }
    }
    
    @EnvironmentObject var toastManager: ToastManager
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @StateObject var keyboard = KeyboardResponder()
    @Bindable var store: StoreOf<SettingStore>
    
    let width = UIScreen.main.bounds.width
    @State var isPresentingRecordGuideView = false
    @State var isPresentingFeedbackView = false
    @State var isPresentingPrivacyPolicyView = false
    @State var isPresentingNoticeView = false
    @State var isPresentingEditNameView = false
    @State var isSaveEnabled = true
    @State var editUserName: String = ""
    @State var isNotificationEnabled = false
    @State var isNoticeNotRead = false
    @State var isDecorationNotRead = false
    
    @FocusState var isFocusToTextField: Bool
    
    @Dependency(\.rewardRepository) var rewardRepository
    @Dependency(\.userUseCase) var userUseCase
    
    let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\s]+$"
    var isSaveEnable: Bool {
        let isValidCount = (2 <= editUserName.count && editUserName.count <= 12)
        let isValidCharacter = (editUserName.range(of: pattern, options: .regularExpression) != nil)
        return isValidCount && isValidCharacter
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                ZStack {
                    VStack(alignment: .center, spacing: .defaultLayoutPadding) {
                        DNavigationBar(
                            leading: {
                                DNavigationBarButton(.arrowLeft) {
                                    dismiss()
                                }
                            },
                            title: {
                                DText("설정")
                                    .style(.b1, .semibold, .white)
                            }
                        )
                        
                        VStack(alignment: .center, spacing: 12) {
                            DImage(.profile).image
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: 100, height: 100)
                            HStack(spacing: 6) {
                                Button {
                                    GA.Click(event: .settingNickname).send()
                                    editUserName = store.userName
                                    isFocusToTextField = true
                                    isPresentingEditNameView = true
                                    UINavigationController.isBlockSwipe = true
                                } label: {
                                    DText(store.userName)
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
                            MenuButton(type: .decoration) {
                                store.send(.touchDecorationButton)
                            }
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
                                    try await userUseCase.updateNoticeReadStatus()
                                    isNoticeNotRead = false
                                    isPresentingNoticeView.toggle()
                                }
                            }
                            MenuButton(type: .recordGuide) {
                                GA.Click(event: .settingRules).send()
                                UINavigationController.isBlockSwipe = true
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
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
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
                        isNoticeNotRead = !(try await userUseCase.getNoticeReadStatus())
                        isDecorationNotRead = (try await userUseCase.getRewardReadStatus())
                    }
                    GA.View(event: .setting).send()
                }
                .navigationBarBackButtonHidden()
            }
            .scrollBounceBehavior(.basedOnSize)
            .background {
                BackgroundView()
            }
            if isPresentingEditNameView {
                EditNameView()
                    .padding(.bottom, keyboard.currentHeight)
                    .animation(.easeOut(duration: 0.3), value: keyboard.currentHeight)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .ignoresSafeArea(.all, edges: .bottom)
                    .onDisappear {
                        UINavigationController.isBlockSwipe = false
                    }
            }
            if isPresentingRecordGuideView {
                RecordGuideView()
                    .onDisappear {
                        UINavigationController.isBlockSwipe = false
                    }
            }
        }
        .ignoresSafeArea(.keyboard)
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
                                .fill(DColor.notice)
                                .frame(width: 6, height: 6)
                                .padding(.bottom, 18)
                        }
                        .opacity(isNoticeNotRead ? 1 : 0)
                    }
                    
                    if type == .decoration {
                        HStack(alignment: .top) {
                            Circle()
                                .fill(DColor.notice)
                                .frame(width: 6, height: 6)
                                .padding(.bottom, 18)
                        }
                        .opacity(isDecorationNotRead ? 1 : 0)
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
    SettingView(
        store: MainStoreFactory().makeSettingStore(
            state: MainStateFactory().makeSettingState(
                context: SettingStore.Context(userName: "닉네임")
            )
        )
    )
}
