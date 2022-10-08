//
//  PopcornTimetvOS_SwiftUIApp.swift
//  PopcornTimetvOS SwiftUI
//
//  Created by Alexandru Tudose on 19.06.2021.
//  Copyright © 2021 PopcornTime. All rights reserved.
//

import SwiftUI
import PopcornKit
import PopcornTorrent

#if os(macOS)
typealias NavigationView = NavigationStack // workaround to use NavigationStack on macOS as there are some bugs on ios/tvos with SeasonPickerButton - not working
#endif

@main
struct PopcornTime: App {
    @State var tosAccepted = Session.tosAccepted
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if !tosAccepted {
                    TermsOfServiceView(tosAccepted: $tosAccepted)
                } else {
                    TabBarView()
                    #if os(iOS) || os(macOS)
                        .modifier(MagnetTorrentLinkOpener())
                    #elseif os(tvOS)
                        .modifier(TopShelfLinkOpener())
                    #endif
                        .onAppear {
                            // bootstrap torrent session
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                PTTorrentsSession.shared()
                            }
                        }
                }
            }
            .preferredColorScheme(.dark)
            #if os(iOS)
            .accentColor(.white)
            .navigationViewStyle(StackNavigationViewStyle())
            .modifier(SecondaryScreen())
            #endif
//            .onAppear {
//                TraktManager.shared.syncUserData()
//            }
        }
//        #if os(iOS) || os(macOS)
//        .commands(content: {
//            OpenCommand()
//        })
//        #endif
        
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact(showsTitle: false))
//        .windowToolbarStyle(.expanded)
//        Settings {
//            SettingsView()
//        }
        #endif
    }

// in order do exit app on window close
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    
    final class AppDelegate: NSObject, NSApplicationDelegate {
        func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
            true
        }
    }
#endif
}
