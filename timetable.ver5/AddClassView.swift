//
//  AddClassView.swift
//  timetable.ver5
//
//  Created by Kohshi Yamaguchi on 2022/09/28.
//

import SwiftUI
import RealmSwift

struct AddClassView: View {
    @EnvironmentObject var m: myModel
    var hnum: Int
    var vnum: Int
    @State var showingSheet = false
    @State var showingScheduleSheet = false
    @State var showingModeSheet = false
    @State var showingColorSheet = false
    @State var tmpClassInfo: (courseTitle: String, instructor: String, schedule: String, courseno: String, room: String, mode: String, color: String)
    @AppStorage("idsaved") var idSaved = ""
    @State var showingAlert = false
    @State var judgeOverlapDay = "you picked the same one"
    @State var overlap = false
    @AppStorage("yearsaved") var yearSaved = "2024"
    @AppStorage("termsaved") var termSaved = "Spring"
    
    @State var initialSchedule = ""
    @State var scheduleEditingFlg = false

    var rows: [GridItem] = Array(repeating: .init(.fixed(50)), count: 2)
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    if tmpClassInfo.courseTitle.isEmpty {
                        Text("Course Title (Please Tap!)")
                            .foregroundColor(Color("placeholderTextColor"))
                    } else {
                        Text(tmpClassInfo.courseTitle)
                    }
                }
                .padding(EdgeInsets(top: 6.5, leading: 0, bottom: 6.5, trailing: 0))
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 6.5, bottom: 0, trailing: 6.5))
            .overlay(
                RoundedRectangle(cornerRadius: 4.0)
                    .stroke(Color.blue, lineWidth: 0.5)
            )
            .padding(.horizontal)
            .contentShape(RoundedRectangle(cornerRadius: 4.0))
            .onTapGesture {
                self.showingSheet.toggle()
            }
            .sheet(isPresented: $showingSheet) {
                ModalView(showingSheet: $showingSheet, classData: filterCourses(cellName: cellNameWithSat[hnum][vnum], classData: downloadTextFile(year: yearSaved, term: termSaved)), tmpClassInfo: $tmpClassInfo, showingAlert: $showingAlert, judgeOverlapDay: $judgeOverlapDay)
            }
            Group {
                TextField("Instructor", text: $tmpClassInfo.instructor)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 4.0)
                            .stroke(Color("textfield"), lineWidth: 1)
                    )
                    .padding(.horizontal)
                Group {
                    HStack {
                        VStack {
                            if tmpClassInfo.schedule.isEmpty {
                                Text("Schedule")
                                    .foregroundColor(Color("placeholderTextColor"))
                            } else {
                                Text(tmpClassInfo.schedule)
                            }
                        }
                        .padding(EdgeInsets(top: 6.5, leading: 0, bottom: 6.5, trailing: 0))
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 6.5, bottom: 0, trailing: 6.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4.0)
                            .stroke(Color("textfield"), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .contentShape(RoundedRectangle(cornerRadius: 4.0))
                    .onTapGesture {
                        self.showingScheduleSheet.toggle()
                    }
                    .partialSheet(isPresented: $showingScheduleSheet) {
                        SchedulePartialView(schedule: $tmpClassInfo.schedule, showingAlert: $showingAlert, judgeOverlapDay: $judgeOverlapDay, scheduleEditingFlg: $scheduleEditingFlg).onAppear() {
                            initialSchedule = tmpClassInfo.schedule
                        }
                    }
                }
                TextField("Room", text: $tmpClassInfo.room)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 4.0)
                            .stroke(Color("textfield"), lineWidth: 1)
                    )
                    .padding(.horizontal)
                Group {
                    HStack {
                        VStack {
                            if tmpClassInfo.mode.isEmpty {
                                Text("Mode")
                                    .foregroundColor(Color("placeholderTextColor"))
                            } else {
                                Text(tmpClassInfo.mode)
                            }
                        }
                        .padding(EdgeInsets(top: 6.5, leading: 0, bottom: 6.5, trailing: 0))
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 6.5, bottom: 0, trailing: 6.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4.0)
                            .stroke(Color("textfield"), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .contentShape(RoundedRectangle(cornerRadius: 4.0))
                    .onTapGesture {
                        self.showingModeSheet.toggle()
                    }
                    .partialSheet(isPresented: $showingModeSheet) {
                        ModePartialView(mode: $tmpClassInfo.mode)
                    }
                }
                Group {
                    HStack {
                        VStack {
                            if tmpClassInfo.color.isEmpty {
                                Text("Color")
                                    .foregroundColor(Color("placeholderTextColor"))
                            } else {
                                Text(tmpClassInfo.color)
                            }
                        }
                        .padding(EdgeInsets(top: 6.5, leading: 0, bottom: 6.5, trailing: 0))
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 6.5, bottom: 0, trailing: 6.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4.0)
                            .stroke(Color("textfield"), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .contentShape(RoundedRectangle(cornerRadius: 4.0))
                    .onTapGesture {
                        self.showingColorSheet.toggle()
                    }
                    .partialSheet(isPresented: $showingColorSheet) {
                        ColorPartialView(color: $tmpClassInfo.color)
                    }
                    
                    TabView(selection: $tmpClassInfo.color) {
                        LazyHGrid(rows: rows, spacing: 12) {
                            ForEach(colorArray, id: \.self) { oneColor in
                                Circle()
                                    .fill(Color("\(oneColor)"))
                                    .frame(width: 50, height: 50)
                                    .overlay(Circle()
                                                .stroke(Color.black, lineWidth: oneColor == tmpClassInfo.color ? 2 : 0.5))
                                    .onTapGesture(perform: {
                                        withAnimation(Animation.linear(duration: 0.1)) {
                                            tmpClassInfo.color = oneColor
                                        }
                                    })
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)).frame(height: 110).padding(.bottom)
                }
                
            }
            Button(action: {
                
                presentationMode.wrappedValue.dismiss()
                
                let scheduleHnumVnumArray: [String] = tmpClassInfo.schedule.components(separatedBy: ",")
                
                if !(m.arraySchedule[hnum][vnum].isEmpty) {
                    for i in m.arraySchedule[hnum][vnum].components(separatedBy: ",") {
                        let u = i.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "*", with: "")
                        if !tmpClassInfo.schedule.contains(u) {
                            let uHnum = convertDayToHVNum(Day: u).1
                            let uVnum = convertDayToHVNum(Day: u).0
                            m.array[uHnum][uVnum] = ""
                            m.arrayInstructor[uHnum][uVnum] = ""
                            m.arraySchedule[uHnum][uVnum] = ""
                            m.arrayCourseno[uHnum][uVnum] = ""
                            m.arrayRoom[uHnum][uVnum] = ""
                            m.arrayMode[uHnum][uVnum] = ""
                            m.arrayColor[uHnum][uVnum] = ""
                            
                            let target = cellNameForRealm[uHnum][uVnum]
                            
                            addCellDataToRealm(id: idSaved, m: m, hnum: uHnum, vnum: uVnum, target: target)
                        }
                    }
                }
                
                m.array[hnum][vnum] = tmpClassInfo.courseTitle
                m.arrayInstructor[hnum][vnum] = tmpClassInfo.instructor
                m.arraySchedule[hnum][vnum] = tmpClassInfo.schedule
                m.arrayCourseno[hnum][vnum] = tmpClassInfo.courseno
                m.arrayRoom[hnum][vnum] = tmpClassInfo.room
                m.arrayMode[hnum][vnum] = tmpClassInfo.mode
                m.arrayColor[hnum][vnum] = tmpClassInfo.color
                
                for scheduleHnumVnum in scheduleHnumVnumArray {
                    
                    let scheduleHnumVnum2 = shapeScheduleString(scheduleHnumVnum: scheduleHnumVnum)
                    
                    var forRealmHnum = hnum
                    var forRealmVnum = vnum
                    
                    if !(tmpClassInfo.schedule.isEmpty) {
                        let forRealmCell = convertDayToHVNum(Day: scheduleHnumVnum2)
                        forRealmHnum = forRealmCell.1
                        forRealmVnum = forRealmCell.0
                    }
                    
                    let target = cellNameForRealm[forRealmHnum][forRealmVnum]
                    
                    m.array[forRealmHnum][forRealmVnum] = tmpClassInfo.courseTitle
                    
                    m.arrayInstructor[forRealmHnum][forRealmVnum] = tmpClassInfo.instructor
                    
                    m.arraySchedule[forRealmHnum][forRealmVnum] = tmpClassInfo.schedule
                    
                    m.arrayCourseno[forRealmHnum][forRealmVnum] = tmpClassInfo.courseno
                    
                    m.arrayRoom[forRealmHnum][forRealmVnum] = tmpClassInfo.room
                    
                    m.arrayMode[forRealmHnum][forRealmVnum] = tmpClassInfo.mode
                    
                    m.arrayColor[forRealmHnum][forRealmVnum] = tmpClassInfo.color
                    
                    addCellDataToRealm(id: idSaved, m: m, hnum: hnum, vnum: vnum, target: target)
                    
                    
                }
                
                // 重複したものを消したときに、重複していた授業の重複していなかったセルのスケジュールに重複していたスケジュールが残ってしまっていたので、それを消すためにこれを追加
                if overlap {
                    for i in 0...5 {
                        for j in 0...8 {
                            if tmpClassInfo.schedule == m.arraySchedule[i][j] {
                                continue
                            }
                            for k in judgeOverlapDay.components(separatedBy: ",") {
                                if m.arraySchedule[i][j].contains(k) {
                                    m.arraySchedule[i][j] =  m.arraySchedule[i][j].replacingOccurrences(of:"*\(k),", with:"").replacingOccurrences(of:",*\(k)", with:"").replacingOccurrences(of:"\(k),", with:"").replacingOccurrences(of:",\(k)", with:"")
                                }
                            }
                            try? Realm().write {
                                try? Realm().objects(scheduleModel.self).filter("id = %@", idSaved).first?.setValue(m.arraySchedule[i][j], forKey: "\(cellNameForRealm[i][j])")
                            }
                        }
                    }
                }
                
            }) {
                Text("Save")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
        }
        .confirmationDialog("Already Assigned classes:\n\(judgeOverlapDay)\nDo you want to add?", isPresented: $showingAlert, titleVisibility: .visible) {
            Button("Add", role: .destructive, action: {
                overlap = true
                scheduleEditingFlg = false
            })
            Button("Cancel", role: .cancel, action: {
                //今は重複からのスケジュール追加からのキャンセルで一番最初に戻ってしまって、重複からの変更が消えてしまう。
                if scheduleEditingFlg {
                    tmpClassInfo.schedule = initialSchedule
                    scheduleEditingFlg = false
                } else {
                    tmpClassInfo.courseTitle = m.array[hnum][vnum]
                    tmpClassInfo.instructor = m.arrayInstructor[hnum][vnum]
                    if m.arraySchedule[hnum][vnum].isEmpty {
                        tmpClassInfo.schedule = cellNameWithSat[hnum][vnum]
                    } else {
                        tmpClassInfo.schedule = m.arraySchedule[hnum][vnum]
                    }
                    tmpClassInfo.courseno = m.arrayCourseno[hnum][vnum]
                    tmpClassInfo.room = m.arrayRoom[hnum][vnum]
                    tmpClassInfo.mode = m.arrayMode[hnum][vnum]
                    tmpClassInfo.color = m.arrayColor[hnum][vnum]
                }
            })
        }
        .navigationTitle("Add View in \(cellNameWithSat[hnum][vnum])")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Add View in \(cellNameWithSat[hnum][vnum])")
                    .font(.headline)
                    .foregroundColor(Color("silver"))
            }
        }
        .onDisappear() {
            // スケジュールで自身のセルを削除するときにうまくいかなかったので追加。
            addDataToCellFromRealmData(id: idSaved, m: m)
        }
    }
}
