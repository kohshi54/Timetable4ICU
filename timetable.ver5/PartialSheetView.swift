//
//  PartialSheetView.swift
//  timetable.ver5
//
//  Created by Kohshi Yamaguchi on 2022/09/28.
//

import SwiftUI
import PartialSheet

struct SchedulePartialView: View {
    // EnvironmentObjectとしてPartialSheetManagerを定義
    // PartialSheetのバージョンを3に上げると動かなくなります、、、
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    @EnvironmentObject var m: myModel
    
    @Binding var schedule: String
    
    @State var selectionDay = "M"
    @State var selectionTime = "1"
    let day = ["SA", "F", "TH", "W", "TU", "M"]
    let time = ["8", "7", "6", "5", "*4", "4", "3", "2", "1"]
    
    @State var scheduleConflict = false
    @State var scheduleMissing = false
    
    @Binding var showingAlert: Bool
    @State var tmpAlertBool = false
    @Binding var judgeOverlapDay: String
    @Binding var scheduleEditingFlg: Bool
    
    var body: some View {
        
        VStack {
            HStack() {
                Spacer()
                Picker(selection: $selectionTime, label: Text("")) {
                    ForEach(time, id: \.self) { time in
                        Text("\(time)")
                    }
                }
                Text("/").clipped()
                Picker(selection: $selectionDay, label: Text("")) {
                    ForEach(day, id: \.self) { day in
                        Text(day)
                    }
                }
                Spacer()
                Button(action: {
                    // 下がるAnimationにする
                    withAnimation() {
                        
                        let addSchedule = selectionTime + "/" + selectionDay
                        let addScheduleShaped = addSchedule.replacingOccurrences(of: "*", with: "")
                        if schedule.contains(addScheduleShaped) {
                            scheduleConflict = true
                        } else {
                            for i in 0...5 {
                                for j in 0...8 {
                                    if m.arraySchedule[i][j].contains(addSchedule) {
                                        tmpAlertBool = true
                                        judgeOverlapDay = addSchedule
                                    }
                                }
                            }
                            schedule += "," + addSchedule
                            
                            scheduleEditingFlg = true
                            
                            // 4. partialSheetを閉じる関数
                            partialSheetManager.closePartialSheet()
                        }
                        
                    }
                }) {
                    Text("Add")
                }.buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .alert(isPresented: $scheduleConflict) {
                        Alert(title: Text("already exists"))
                    }
                Button(role: .destructive, action: {
                    // 下がるAnimationにする
                    withAnimation() {
                        
                        
                        let deleteSchedule = selectionTime + "/" + selectionDay
                        if schedule.contains(deleteSchedule) {
                            schedule = schedule.replacingOccurrences(of: deleteSchedule + ",", with: "").replacingOccurrences(of: "," + deleteSchedule, with: "")
                            // 4. partialSheetを閉じる関数
                            partialSheetManager.closePartialSheet()
                        } else {
                            scheduleMissing = true
                        }
                    }
                }) {
                    Text("Delete")
                }.buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .alert(isPresented: $scheduleMissing) {
                        Alert(title: Text("does not exist"))
                    }
                
            }
            .frame(width: 300)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20).stroke(Color.blue)
            }.padding()
        }
        // 5. モーダルビューの高さを指定
        //        .frame(height: 200)
        .onDisappear() {
            showingAlert = tmpAlertBool
        }
    }
}


struct ModePartialView: View {
    // EnvironmentObjectとしてPartialSheetManagerを定義
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    @Binding var mode: String
    
    @State var selectionMode = ""
    
    let modeArray = ["ONLINE", "MIXED MODE", "FACE TO FACE", "NO DATA"]
    
    var body: some View {
        
        
        HStack() {
            Spacer()
            Picker(selection: $selectionMode, label: Text("")) {
                ForEach(modeArray, id: \.self) { mode in
                    Text(mode)
                }
            }
            Spacer()
            Button(action: {
                // 下がるAnimationにする
                withAnimation() {
                    // 4. partialSheetを閉じる関数
                    partialSheetManager.closePartialSheet()
                    mode = selectionMode
                    
                }
            }) {
                Text("Add")
            }.buttonStyle(.borderedProminent)
                .controlSize(.small)
            //                    .padding(.trailing)
        }
        .frame(width: 200)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20).stroke(Color.blue)
        }            .frame(width: 200)
            .padding()
        // 5. モーダルビューの高さを指定
        //        .frame(height: 200)
    }
}


struct ColorPartialView: View {
    // EnvironmentObjectとしてPartialSheetManagerを定義
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    @Binding var color: String
    
    @State var selectionColor = ""
    
    var body: some View {
        
        HStack() {
            Spacer()
            Picker(selection: $selectionColor, label: Text("")) {
                ForEach(colorArray, id: \.self) { mode in
                    Text(mode)
                }
            }
            Spacer()
            Button(action: {
                // 下がるAnimationにする
                withAnimation() {
                    // 4. partialSheetを閉じる関数
                    partialSheetManager.closePartialSheet()
                    color = selectionColor
                    
                }
            }) {
                Text("Add")
            }.buttonStyle(.borderedProminent)
                .controlSize(.small)
        }
        .frame(width: 200)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20).stroke(Color.blue)
        }.padding()
        
        // 5. モーダルビューの高さを指定
        //        .frame(height: 200)
    }
}

