//
//  AddTable&SettingView.swift
//  timetable.ver5
//
//  Created by Kohshi Yamaguchi on 2022/09/28.
//

import SwiftUI
import RealmSwift

struct AddTableAndSettingView: View {
    @ObservedObject var model = ContentViewModel()
    @EnvironmentObject var m: myModel
    @State var tableTitle = ""
    @AppStorage("idsaved") var idSaved = ""
    @AppStorage("titlesaved") var titleSaved = ""
    @State var selectionYear = 0
    @State var selectionTerm = 0
    @AppStorage("yearsaved") var yearSaved = "2024"
    @AppStorage("termsaved") var termSaved = "Spring"
    @FocusState var focusState1: Bool
    @State var isFirst = false
    @State private var selectionValue: String? = nil
    
    @AppStorage("satflg") var satflgSaved = false
    @AppStorage("eigthflg") var eigthflgSaved = false
    @AppStorage("timedetailflg") var timedetailflgSaved = true
    @Binding var SatFlg: Bool
    @Binding var eighthFlg: Bool
    @Binding var timeDetailFlg: Bool
    
    @State var addTableViewActive = false
    
    var body: some View {
        VStack {
            VStack {
                VStack(spacing: 0) {
                    HStack {
                        Text("Appearance").foregroundColor(.blue).bold()
                        Spacer()
                    }
                    Rectangle().frame(height: 1).foregroundColor(.blue)
                }.padding(.leading)
                VStack(spacing: 0) {
                    Text("Sat")
                    Toggle("", isOn: $SatFlg)
                        .labelsHidden()
                        .onChange(of: SatFlg, perform: { _ in
                            satflgSaved = SatFlg
                        })
                }
                VStack(spacing: 0) {
                    Text("8限")
                    Toggle("", isOn: $eighthFlg)
                        .labelsHidden()
                        .onChange(of: eighthFlg, perform: { _ in
                            eigthflgSaved = eighthFlg
                        })
                }
                VStack(spacing: 0) {
                    Text("時間表示")
                    Toggle("", isOn: $timeDetailFlg)
                        .labelsHidden()
                        .onChange(of: timeDetailFlg, perform: { _ in
                            timedetailflgSaved = timeDetailFlg
                        })
                }
            }.padding(.vertical)
            VStack {
                VStack(spacing: 0) {
                    HStack {
                        Text("Timetable List").foregroundColor(.blue).bold()
                        Spacer()
                    }
                    Rectangle().frame(height: 1).foregroundColor(.blue)
                }.padding(.leading)
                TabView(selection: $selectionValue) {
                    List {
                        ForEach(model.cellModels, id: \.id) { cellModel in
                            Button(action: {
                                    addDataToCellFromRealmData(id: cellModel.id, m: m)
        
                                    idSaved = cellModel.id
                                    titleSaved = cellModel.tableTitle
                                    yearSaved = cellModel.year
                                    termSaved = cellModel.term
                                    selectionValue = cellModel.id
                            }) {
                                HStack {
                                    if(idSaved == cellModel.id) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .imageScale(.large)
                                            .foregroundColor(.blue)
                                    } else {
                                        Image(systemName: "circle")
                                            .imageScale(.large)
                                            .foregroundColor(Color.gray)
                                    }

                                    Text(cellModel.tableTitle).bold().foregroundColor(idSaved == cellModel.id ? Color.blue : Color.black)
                                    Spacer()
                                    Text("【\(cellModel.term), \(cellModel.year)】").foregroundColor(idSaved == cellModel.id ? Color.blue : Color.black).padding(.horizontal)
                                    
                                }
                            }
                        }

                        .onDelete { indexSet in
                            let realm = try? Realm()
                            if let index = indexSet.first, let myModel = realm?.objects(cellModel.self).filter("id = %@", self.model.cellModels[index].id).first {
        
                                if model.cellModels.count != 1 {
                                    try? realm?.write {
                                        realm?.delete(myModel)
                                    }
                                    if (self.model.cellModels[index].id == idSaved) {
                                        if ((indexSet.first ?? 0) != 0) {
                                            addDataToCellFromRealmData(id: self.model.cellModels[index-1].id, m: m)
                                            idSaved = self.model.cellModels[index-1].id
                                            titleSaved = self.model.cellModels[index-1].tableTitle
                                        } else {
                                            addDataToCellFromRealmData(id: self.model.cellModels[index+1].id, m: m)
                                            idSaved = self.model.cellModels[index+1].id
                                            titleSaved = self.model.cellModels[index+1].tableTitle
                                        }
                                    }
                                }
        
                            }
                        }
                    }.listStyle(PlainListStyle()).environment(\.editMode, .constant(.inactive))
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                VStack {
                    TextField("時間割名", text: $tableTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused(self.$focusState1)
                        .padding()
                    HStack {
                        Spacer()
                        // ios16になってラベルの表示がおかしくなったので、一旦label: Text("Term")を一旦消す
                        Picker(selection: $selectionTerm, label: Text("")) {
                            Text("Winter").tag(2)
                            Text("Autumn").tag(1)
                            Text("Spring").tag(0)
                        }
                        .padding(.horizontal)
                        
                        .background {
                            RoundedRectangle(cornerRadius: 7).stroke(Color.blue, lineWidth: 0.5)
                        }
                        .padding(.bottom)
                        Spacer()
                        Picker(selection: $selectionYear, label: Text("")) {
                            Text("2020").tag(4)
                            Text("2021").tag(3)
                            Text("2022").tag(2)
                            Text("2023").tag(1)
                            Text("2024").tag(0)
                        }
                        .padding(.horizontal)
                        .background {
                            RoundedRectangle(cornerRadius: 7).stroke(Color.blue, lineWidth: 0.5)
                        }
                        .padding(.bottom)
                        Spacer()
                        Button(action: {
                            let uuid = UUID().uuidString
                            createNewRealmData(tableTitle: tableTitle, uuid: uuid, year: yearArray[selectionYear], term: termArray[selectionTerm])
                            addDataToCellFromRealmData(id: uuid, m: m)
                            idSaved = uuid
                            titleSaved = tableTitle
                            tableTitle = ""
                            yearSaved = yearArray[selectionYear]
                            termSaved = termArray[selectionTerm]
                            focusState1 = false
                            isFirst = false
                        }) {
                            Text("Create")
                        }.buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .padding(.trailing)
                            .padding(.bottom)
                    }
                }.background {
                    RoundedRectangle(cornerRadius: 20).stroke(Color.blue)
                }.padding(.horizontal).padding(.bottom)
            }.onAppear() {
                if idSaved.isEmpty {
                    isFirst = true
                }
            }
            .alert("Welcome!", isPresented: $isFirst) {
                Button("OK") {
                    focusState1 = true
                }
            } message: {
                Text("Please input table name, select term & year to create timetable \n\nまず初めに時間割名を入力、タームと年度を選択して時間割をつくってください！")
            }
            .onDisappear {
                if idSaved.isEmpty {
                    addTableViewActive = true
                }
            }
        }
        .navigationTitle("Settings View")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings View")
                    .font(.headline)
                    .foregroundColor(Color("silver"))
            }
        }
    }
}
