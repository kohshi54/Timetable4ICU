//
//  LunchView.swift
//  timetable.ver5
//
//  Created by Kohshi Yamaguchi on 2022/09/28.
//

import SwiftUI

struct LunchView: View {
    @EnvironmentObject var m: myModel
    let hnum: Int
    let vnum: Int
    @AppStorage("idsaved") var idSaved = ""
    @State var tabselection = ""
    let lunchOptions = ["ランチ！", "課題！", "予習！", "面談！", "その他"]
    @State var lunchMemo = ""
    @FocusState var focusMemo:Bool
    @State var lunchColor = ""
    var rows: [GridItem] = Array(repeating: .init(.fixed(50)), count: 2)
    @FocusState var activityInput: Bool
    var body: some View {
        VStack {
            TabView(selection: $tabselection) {
                VStack {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Plan").foregroundColor(.blue).bold()
                            Spacer()
                        }
                        Rectangle().frame(height: 1).foregroundColor(.blue)
                    }.padding(.leading)
                    ForEach(lunchOptions, id: \.self) { lunchoption in
                        HStack {
                            Spacer()
                            if lunchoption == tabselection {
                                ZStack {
                                    Image(systemName: "circle")
                                        .imageScale(.large)
                                        .foregroundColor(.blue)
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(.blue)
                                }
                            } else {
                                Image(systemName: "circle")
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            }
                            HStack {
                                Text("\(lunchoption)")
                                if lunchoption == "その他" {
                                    TextField("", text: $tabselection).textFieldStyle(RoundedBorderTextFieldStyle()).focused(self.$activityInput).toolbar {
                                            ToolbarItemGroup(placement: .keyboard) {
                                                Spacer()
                                                Button("\(Text("Done").bold())") {
                                                    activityInput = false
                                                    focusMemo = false
                                                }
                                            }
                                        }
                                }
                                Spacer()
                            }
//                            .frame(width: 72)
                            
                            Spacer()
                            
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if tabselection == lunchoption {
                                tabselection = ""
                            } else {
                                tabselection = lunchoption
                            }
                        }
                        .frame(height: 30)
                    }
                    .onChange(of: tabselection) { value in
                        print("tabselection changed", tabselection)
                        
                        m.array[hnum][vnum] = tabselection
                        
                        addCellDataToRealm(id: idSaved, m: m, hnum: hnum, vnum: vnum, target: "\(cellNameForRealm[hnum][vnum])")
                    }
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            if !activityInput {
                VStack {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Color").foregroundColor(.blue).bold()
                            Spacer()
                        }
                        Rectangle().frame(height: 1).foregroundColor(.blue)
                    }.padding(.leading)
                    TabView(selection: $lunchColor) {
                        LazyHGrid(rows: rows, spacing: 12) {
                            ForEach(colorArray, id: \.self) { oneColor in
                                Circle()
                                    .fill(Color("\(oneColor)"))
                                    .frame(width: 50, height: 50)
                                    .overlay(Circle()
                                                .stroke(Color.black, lineWidth: oneColor == lunchColor ? 2 : 0.5))
                                    .onTapGesture(perform: {
                                        withAnimation(Animation.linear(duration: 0.1)) {
                                            if lunchColor == oneColor {
                                                lunchColor = ""
                                            } else {
                                                lunchColor = oneColor
                                            }
                                        }
                                    })
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)).frame(height: 110).padding(.bottom)
                    .onChange(of: lunchColor) { lunchCol in
                        m.arrayColor[hnum][vnum] = lunchColor
                        
                        addCellDataToRealm(id: idSaved, m: m, hnum: hnum, vnum: vnum, target: "\(cellNameForRealm[hnum][vnum])")
                    }
                }
            }
            
            if !activityInput {
                Group {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Memo").foregroundColor(.blue).bold()
                            Spacer()
                        }
                        Rectangle().frame(height: 1).foregroundColor(.blue)
                    }.padding(.leading)
                    TextEditor(text: $lunchMemo)
                        .overlay() {
                            RoundedRectangle(cornerRadius: 20).stroke(Color.blue)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                        .focused(self.$focusMemo)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("\(Text("Done").bold())") {
                                    focusMemo = false
                                    activityInput = false
                                }
                            }
                        }
                        .onChange(of: lunchMemo) { value in
                            
                            m.arrayInstructor[hnum][vnum] = lunchMemo
                            
                            addCellDataToRealm(id: idSaved, m: m, hnum: hnum, vnum: vnum, target: "\(cellNameForRealm[hnum][vnum])")
                        }
                }
            }
            
            
            
        }
        .navigationTitle("Lunch View in \(cellNameWithSat[hnum][vnum])")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Lunch View in \(cellNameWithSat[hnum][vnum])")
                    .font(.headline)
                    .foregroundColor(Color("silver"))
            }
        }
        .onAppear() {
            tabselection = m.array[hnum][vnum]
            lunchMemo = m.arrayInstructor[hnum][vnum]
            lunchColor = m.arrayColor[hnum][vnum]
        }
    }
}

