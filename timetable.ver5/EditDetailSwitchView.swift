//
//  EditDetailSwitchView.swift
//  timetable.ver5
//
//  Created by Kohshi Yamaguchi on 2022/09/28.
//

import SwiftUI

// TimeTableView2にて、セルに授業が登録してあったらDetailView、そうでなければEditViewを表示するようにしたいけど、TimeTAbleView2内でこの分岐を書いてしまうと、重すぎて動かなくなっちゃうので新しいviewを作ってそこで分岐さす。これ（EditDetailSwitchView）がそのためのView！
struct EditDetailSwitchView: View {
    @EnvironmentObject var m: myModel
    @State var isAdd: Bool
    let hnum: Int
    let vnum: Int
    
    var body: some View {
        VStack {
            if isAdd {
                AddClassView(hnum: hnum, vnum: vnum, tmpClassInfo: (courseTitle: m.array[hnum][vnum], instructor: m.arrayInstructor[hnum][vnum], schedule: m.arraySchedule[hnum][vnum].isEmpty ? cellNameWithSat[hnum][vnum] : m.arraySchedule[hnum][vnum], courseno: m.arrayCourseno[hnum][vnum], room: m.arrayRoom[hnum][vnum], mode: m.arrayMode[hnum][vnum], color: m.arrayColor[hnum][vnum]))
            } else {
                DetailView(hnum: hnum, vnum: vnum)
            }
        }
    }
}
