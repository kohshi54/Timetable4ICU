//
//  TimetableView.swift
//  timetable.ver5
//
//  Created by Kohshi Yamaguchi on 2022/09/28.
//

import SwiftUI
import RealmSwift

struct TimeTableView: View {
    
    @EnvironmentObject var m: myModel
    
    let daysWithSat = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let days = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    let timeWitheighth = ["1", "2", "3", "L", "4", "5", "6", "7", "8"]
    let time = ["1", "2", "3", "L", "4", "5", "6", "7"]
    let timeDetailWitheighth = ["1": ("8:45", "10:00"), "2": ("10:10", "11:25"), "3": ("11:35", "12:50"), "4": ("14:00", "15:15"), "5": ("15:25", "16:40"), "6": ("16:50", "18:05"), "7": ("18:15", "19:30"), "8": ("19:40", "20:55")]
    
    @State var SatFlg = false
    @State var eighthFlg = false
    @State var timeDetailFlg = false
    @AppStorage("satflg") var satflgSaved = false
    @AppStorage("eigthflg") var eigthflgSaved = false
    @AppStorage("timedetailflg") var timedetailflgSaved = true
    
    @AppStorage("idsaved") var idSaved = ""
    @AppStorage("titlesaved") var titleSaved = ""
    
    @State var addTableViewActive = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometryAll in
                VStack (spacing: 0){
                    GeometryReader { geometryUpper in
                        HStack (spacing: 0){
                            Spacer().frame(width: geometryUpper.size.width * 0.09)
                            Divider().opacity(0)
                            GeometryReader { geometryDayArea in
                                HStack (spacing: 0) {
                                    ForEach(SatFlg ? daysWithSat : days, id: \.self) { day in
                                        Text("\(day)").frame(width: SatFlg ? (geometryDayArea.size.width/6)-0.5 : (geometryDayArea.size.width/5)-0.5)
                                        Divider().opacity(0)
                                    }
                                }
                            }.frame(width: geometryUpper.size.width * 0.91)
                        }
                    }.frame(height: geometryAll.size.height * 0.04)
                    
                    Divider().background(Color("separator"))
                    
                    GeometryReader { geometry in
                        HStack (spacing: 0) {
                            GeometryReader { geometryTimeArea in
                                VStack (spacing: 0) {
                                    ForEach(eighthFlg ? timeWitheighth : time , id: \.self) { timeNum in
                                        if timeNum != time[3] {
                                            VStack {
                                                if timeDetailFlg {
                                                    Text("\(timeDetailWitheighth[timeNum]!.0)")
                                                        .font(.system(size: 10, weight: .thin, design: .default)).padding(.top, 2)
                                                }
                                                Spacer()
                                                Text("\(timeNum)")
                                                Spacer()
                                                if timeDetailFlg {
                                                    Text("\(timeDetailWitheighth[timeNum]!.1)")
                                                        .font(.system(size: 10, weight: .thin, design: .default)).padding(.bottom, 2)
                                                }
                                            }.frame(width: geometryTimeArea.size.width-0.5, height: eighthFlg ? (geometryTimeArea.size.height * 0.95)/8 - 0.5 : (geometryTimeArea.size.height * 0.95)/7 - 0.5)
                                            
                                        } else {
                                            Text("L").frame(width: geometryTimeArea.size.width-0.5, height: ((geometryTimeArea.size.height)*0.05)-0.5).background(Color.gray)
                                        }
                                        Divider().background(Color("separator"))
                                    }
                                }
                                
                            }.frame(width: geometry.size.width * 0.09)
                            Divider().background(Color("separator"))    //ここに高さ追加すれば7限にした時tabbarに線が透ける問題解決できそう？？？
                            GeometryReader { geometryScheduleArea in
                                HStack(alignment: .top, spacing: 0) {
                                    ForEach(SatFlg ? 0...5 : 0...4, id: \.self) { hnum in
                                        VStack (spacing: 0){
                                            ForEach(eighthFlg ? 0...8 : 0...7, id: \.self) { vnum in
                                                if vnum != 3 {
                                                    NavigationLink(destination: EditDetailSwitchView(isAdd: m.array[hnum][vnum].isEmpty, hnum: hnum, vnum: vnum)) {
                                                        VStack {
                                                            if (showNameBool(hnum: hnum, vnum: vnum, m: m)) {
                                                                Text("\(m.array[hnum][vnum])")
                                                                if !((m.arrayRoom[hnum][vnum] == "NO DATA") || (m.arrayRoom[hnum][vnum] == "")) {
                                                                    Text(m.arrayRoom[hnum][vnum]).padding(.top, 5)
                                                                }
                                                            }
                                                        }
                                                        .modifier(cellWidthHeightSize(hnum: hnum, vnum: vnum, SatFlg: SatFlg, eighthFlg: eighthFlg, geometryScheduleAreaSize: geometryScheduleArea.size))
                                                    }
                                                    .background(Color("\(m.arrayColor[hnum][vnum])"))
                                                } else {
                                                    NavigationLink(destination: LunchView(hnum: hnum, vnum: vnum)) {
                                                        Text("\(m.array[hnum][vnum])").frame(width: SatFlg ? (geometryScheduleArea.size.width/6)-0.5 : (geometryScheduleArea.size.width/5)-0.5,
                                                                                             height: cellSize(hnum: hnum, vnum: vnum, eighthFlg: eighthFlg, all: geometryScheduleArea.size, m: m))
                                                            .foregroundColor(Color.black)
                                                            .font(.system(size: 13, weight: .regular, design: .default))
                                                    }.background(lunchColor(hnum: hnum, m: m))
                                                }
                                                
                                                if dividerShowBool(hnum: hnum, vnum: vnum, m: m) {
                                                    Divider()
                                                        .background(Color("separator"))
                                                }
                                                
                                            }
                                        }
                                        
                                        Divider().background(Color("separator"))
                                        
                                    }
                                }
                            }.frame(width: geometry.size.width * 0.91)
                        }
                    }.frame(height: geometryAll.size.height * 0.96)
                    
                }
            }
            .navigationBarTitle(titleSaved, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(titleSaved)
                        .font(.headline)
                        .foregroundColor(Color("silver"))
                }
            }
            .navigationBarItems(
                trailing:
                    NavigationLink(destination: AddTableAndSettingView(SatFlg: $SatFlg, eighthFlg: $eighthFlg, timeDetailFlg: $timeDetailFlg), isActive: $addTableViewActive) {
                        Image(systemName: "gearshape.fill")
                    }
            )
        }
        .onAppear() {
            SatFlg = satflgSaved
            eighthFlg = eigthflgSaved
            timeDetailFlg = timedetailflgSaved
            
            addDataToCellFromRealmData(id: idSaved, m: m)
            
            if idSaved.isEmpty {
                addTableViewActive = true
            }
            
        }
    }
}


struct cellWidthHeightSize: ViewModifier {
    @EnvironmentObject var m: myModel
    let hnum: Int
    let vnum: Int
    let SatFlg: Bool
    let eighthFlg: Bool
    let geometryScheduleAreaSize: CGSize
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.primary)
            .font(.system(size: 12, weight: .regular, design: .default))
            .multilineTextAlignment(.center)
            .frame(width: SatFlg ? (geometryScheduleAreaSize.width/6)-0.5 : (geometryScheduleAreaSize.width/5)-0.5, height: cellSize(hnum: hnum, vnum: vnum, eighthFlg: eighthFlg, all: geometryScheduleAreaSize, m: m)
            )
    }
}
