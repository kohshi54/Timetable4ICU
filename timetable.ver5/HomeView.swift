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
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.backgroundColor = UIColor(Color("dark blue"))
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = UIColor(Color("silver"))

        UITabBar.appearance().backgroundColor = UIColor(Color("dark blue"))
        
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color("silver"))
    }
    var body: some View {
        TabView {
            TimeTableView().tabItem {
                Image(systemName: "calendar")
                Text("Timetable")
            }
            TaskListViewVertical().tabItem {
                Image(systemName: "list.bullet")
                Text("Task")
            }
        }
        .addPartialSheet()
    }
}
