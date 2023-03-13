//
//  DetailView.swift
//  timetable.ver5
//
//  Created by Kohshi Yamaguchi on 2022/09/28.
//

import SwiftUI
import RealmSwift

struct DetailView: View {
    @ObservedObject var model = ContentViewModel()
    @EnvironmentObject var m: myModel
    @Environment(\.presentationMode) var presentation
    var hnum: Int
    var vnum: Int
    @AppStorage("idsaved") var idSaved = ""
    @State private var selection = 0
    @State var taskTitle = ""
    @FocusState var focus: Bool
    
    @State var isShowDialog = false
    
    var body: some View {
        VStack {
            VStack {
                VStack(alignment: .leading) {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Course Info").foregroundColor(.blue).bold()
                            Spacer()
                        }
                        Rectangle().frame(height: 1).foregroundColor(.blue)
                    }.padding(.leading)
                    HStack {
                        VStack(alignment: .leading) {
                            HStack(alignment: .firstTextBaseline) {
                                HStack {
                                    Text("Title").font(.subheadline)
                                    Spacer()
                                }.frame(width: 82)
                                Text(":")
                                Text(m.array[hnum][vnum])
                                    .font(.subheadline)
                            }
                            
                            HStack(alignment: .firstTextBaseline) {
                                HStack {
                                    Text("Instructor").font(.subheadline)
                                    Spacer()
                                }.frame(width: 82)
                                Text(":")
                                Text(m.arrayInstructor[hnum][vnum])
                                    .font(.subheadline)
                            }
                            
                            HStack(alignment: .firstTextBaseline) {
                                HStack {
                                    Text("Schedule").font(.subheadline)
                                    Spacer()
                                }.frame(width: 82)
                                Text(":")
                                Text(m.arraySchedule[hnum][vnum])
                                    .font(.subheadline)
                            }
                            
                            HStack(alignment: .firstTextBaseline) {
                                HStack {
                                    Text("Room").font(.subheadline)
                                    Spacer()
                                }.frame(width: 82)
                                Text(":")
                                Text(m.arrayRoom[hnum][vnum])
                                    .font(.subheadline)
                            }
                            
                            HStack(alignment: .firstTextBaseline) {
                                HStack {
                                    Text("Mode").font(.subheadline)
                                    Spacer()
                                }.frame(width: 82)
                                Text(":")
                                Text(m.arrayMode[hnum][vnum])
                                    .font(.subheadline)
                            }
                            
                            HStack(alignment: .firstTextBaseline) {
                                HStack {
                                    Text("Color").font(.subheadline)
                                    Spacer()
                                }.frame(width: 82)
                                Text(":")
                                Text(m.arrayColor[hnum][vnum])
                                    .font(.subheadline)
                            }
                        }
                        Spacer()
                    }.padding(.leading).padding(.vertical).background(RoundedRectangle(cornerRadius: 20).fill(Color.gray).opacity(0.5)).padding(.horizontal)
                }
                
                HStack {
                    
                    Button(role: .destructive, action: {
                        isShowDialog = true
                    }) {
                        Text("Delete").frame(width: 60)
                    }.buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .confirmationDialog("All class data will be deleted.\nAre you sure?", isPresented: $isShowDialog, titleVisibility: .visible) {
                            Button("OK", role: .destructive, action: {
                                
                                // タスク削除
                                let realm = try? Realm()
                                if let myModel = realm?.objects(cellModel.self).filter("id = %@", idSaved).first {
                                    try? realm?.write {
                                        realm?.delete(myModel.tasks.filter("courseTitle = %@", m.array[hnum][vnum]))
                                    }
                                }
                                
                                let scheduleHnumVnumArray: [String] = m.arraySchedule[hnum][vnum].components(separatedBy: ",")
                                
                                let scheduleForDelete = m.arraySchedule[hnum][vnum]
                                
                                m.array[hnum][vnum] = ""
                                m.arrayInstructor[hnum][vnum] = ""
                                m.arraySchedule[hnum][vnum] = ""
                                m.arrayCourseno[hnum][vnum] = ""
                                m.arrayRoom[hnum][vnum] = ""
                                m.arrayMode[hnum][vnum] = ""
                                m.arrayColor[hnum][vnum] = ""
                                
                                for scheduleHnumVnum in scheduleHnumVnumArray {
                                    
                                    let scheduleHnumVnum2 = shapeScheduleString(scheduleHnumVnum: scheduleHnumVnum)
                                    
                                    var forRealmHnum = hnum
                                    var forRealmVnum = vnum
                                    
                                    if !(scheduleForDelete.isEmpty) {
                                        let forRealmCell = convertDayToHVNum(Day: scheduleHnumVnum2)
                                        forRealmHnum = forRealmCell.1
                                        forRealmVnum = forRealmCell.0
                                    }
                                    
                                    let target = cellNameForRealm[forRealmHnum][forRealmVnum]
                                    
                                    m.array[forRealmHnum][forRealmVnum] = ""
                                    
                                    m.arrayInstructor[forRealmHnum][forRealmVnum] = ""
                                    
                                    m.arraySchedule[forRealmHnum][forRealmVnum] = ""
                                    
                                    m.arrayCourseno[forRealmHnum][forRealmVnum] = ""
                                    
                                    m.arrayRoom[forRealmHnum][forRealmVnum] = ""
                                    
                                    m.arrayMode[forRealmHnum][forRealmVnum] = ""
                                    
                                    m.arrayColor[forRealmHnum][forRealmVnum] = ""
                                    
                                    addCellDataToRealm(id: idSaved, m: m, hnum: hnum, vnum: vnum, target: target)
                                }
                                
                                self.presentation.wrappedValue.dismiss()
                                
                            })
                            Button("Cancel", role: .cancel, action: {
                            })
                        }
                    NavigationLink(destination:
                                    EditView(hnum: hnum, vnum: vnum, tmpClassInfo: (courseTitle: m.array[hnum][vnum], instructor: m.arrayInstructor[hnum][vnum], schedule: m.arraySchedule[hnum][vnum].isEmpty ? cellNameWithSat[hnum][vnum] : m.arraySchedule[hnum][vnum], courseno: m.arrayCourseno[hnum][vnum], room: m.arrayRoom[hnum][vnum], mode: m.arrayMode[hnum][vnum], color: m.arrayColor[hnum][vnum]))
                    ) {
                        Text("Edit").frame(width: 60)
                    }
                    .tint(Color.green)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                }
            }.padding(.vertical)
            
            VStack(spacing: 0) {
                HStack {
                    Text("Task").foregroundColor(.blue).bold()
                    Spacer()
                }
                Rectangle().frame(height: 1).foregroundColor(.blue)
            }.padding(.leading)
            
            // deleteの確認ダイアログを表示して消すたびに呼び出されてしまうので一旦こっちに直書き,,,そしたらdeleteがうまくいかなくなったので要調査(エクササイズ２を消したらメタファー２が消えたので参照しているインデックス番号が違う可能性） →解決！！！原因は表示していた科目毎でのインデックス番号と全体のインデックス番号が違ったこと。科目毎のインデックス番号で全体のリストから削除していたので違うものが削除されたりしていた。
            VStack {
                ForEach(model.cellModels.filter {$0.id == idSaved}, id: \.id) { oneModel in
                    List {
                        ForEach(oneModel.tasks.filter {($0.id == idSaved) && ($0.courseTitle == m.array[hnum][vnum])}, id: \.self) { oneTask in
                            VStack(alignment: .leading){
                                Text("Due: \(oneTask.dueDate.formatted(.dateTime.hour().minute().day().month()))").font(.subheadline).padding(.bottom, 0.5)
                                //                                        .italic()
                                Text("・\(oneTask.taskTitle)")
                                HStack {
                                    Text("　")
                                    Text("created at \(oneTask.createdAt.formatted(.dateTime.hour().minute().day().month()))").font(.footnote)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            let realm = try? Realm()
                            if let index = indexSet.first, let myModel = realm?.objects(cellModel.self).filter("id = %@", idSaved).first {
                                let INDEX = myModel.tasks.index(of: myModel.tasks.filter("courseTitle = %@", m.array[hnum][vnum])[index])
                                try? realm?.write {
                                    myModel.tasks.remove(at: INDEX!)
                                }
                            }
                        }
                    }.listStyle(PlainListStyle())
                }
            }
            
            HStack {
                TextField("Tap here to add task :)", text: $taskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused(self.$focus)
                    .padding()
                
                Button(action: {
                    let cellModel = try? Realm().objects(cellModel.self).filter("id = %@", idSaved).first
                    let task = Task(value: ["\(taskTitle)", Date(timeInterval: 60*60*24*7, since: Date()), Date(), "\(m.array[hnum][vnum])", idSaved])
                    try? Realm().write {
                        cellModel?.tasks.append(task)
                    }
                    taskTitle = ""
                    focus = false
                }) {
                    Text("Add")
                }.buttonStyle(.borderedProminent)
                    .controlSize(.regular)
                    .padding(.trailing)
            }
            
            .background {
                RoundedRectangle(cornerRadius: 20).stroke(Color.blue)
            }
            .padding(.bottom)
            .padding(.horizontal)
            
        }
        .navigationTitle("Detail View in \(cellNameWithSat[hnum][vnum])")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Detail View in \(cellNameWithSat[hnum][vnum])")
                    .font(.headline)
                    .foregroundColor(Color("silver"))
            }
        }
    }
}
