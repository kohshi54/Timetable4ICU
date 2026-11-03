//
//  HomeView.swift
//  timetable.ver5
//
//  Created by Kohshi Yamaguchi on 2022/09/28.
//

import SwiftUI
import PartialSheet

struct HomeView: View {
    init() {
        let navy = UIColor(Color("dark blue"))
        let silver = UIColor(Color("silver"))

        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = navy
        coloredAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = silver

        // iOS 26 以降のタブバーは紺の帯の上にガラスのボタンが乗るため、選択中・非選択の色を明るくはっきり指定する
        UITabBar.appearance().backgroundColor = navy
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = silver
    }
    var body: some View {
        TabView {
            TimeTableView()
                .tint(.blue)
                .darkTabBar()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Timetable")
                }
            TaskListViewVertical()
                .tint(.blue)
                .darkTabBar()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Task")
                }
        }
        // 選択中のタブを白にする。画面の中のボタン類は各タブで iOS 標準の青に戻している
        .tint(.white)
        .addPartialSheet()
    }
}

// iOS 26 以降の Liquid Glass のバーは、背景色ではなくライト/ダークの扱いで文字やアイコンの色が決まる。
// 紺のバーの上で白く描かせるため、バーだけダーク扱いにする
extension View {
    @ViewBuilder func darkTabBar() -> some View {
        if #available(iOS 16.0, *) {
            self.toolbarColorScheme(.dark, for: .tabBar)
        } else {
            self
        }
    }

    @ViewBuilder func darkNavigationBar() -> some View {
        if #available(iOS 16.0, *) {
            self
                .toolbarBackground(Color("dark blue"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
        } else {
            self
        }
    }
}
