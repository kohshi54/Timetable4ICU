//
//  timetable_ver5App.swift
//  timetable.ver5
//
//  Created by Kohshi Yamaguchi on 2022/09/28.
//

import SwiftUI
import PartialSheet

@main
struct timetable_ver5App: App {
    let sheetManager: PartialSheetManager = PartialSheetManager()
    var body: some Scene {
        WindowGroup {
            HomeView().environmentObject(ContentViewModel()).environmentObject(myModel()).environmentObject(sheetManager)
        }
    }
}
