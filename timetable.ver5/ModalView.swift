//
//  ModalView.swift
//  timetable.ver5
//
//  Created by Kohshi Yamaguchi on 2022/09/28.
//

import SwiftUI

struct ModalView: View {
    @EnvironmentObject var m: myModel
    @Binding var showingSheet: Bool
    var classData: [(courseTitle: String, instructor: String, schedule: String, courseno: String, room: String, mode: String, color: String)]
    @Binding var tmpClassInfo: (courseTitle: String, instructor: String, schedule: String, courseno: String, room: String, mode: String, color: String)
    @Binding var showingAlert: Bool
    @State var tmpAlertBool = false
    @Binding var judgeOverlapDay: String
    @FocusState var focusTextField:Bool
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showingSheet.toggle()
                }) {
                    Text("Cancel")
                }
            }.padding()
            TextField("", text: $tmpClassInfo.courseTitle, onCommit: {
                self.showingSheet = false
            }).focused(self.$focusTextField)
                .textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal)
            List {
                ForEach(0..<classData.count, id: \.self) { oneClass in
                    Button(action: {
                        tmpClassInfo = classData[oneClass]
                        if judgeOverlap(day: tmpClassInfo.schedule, m: m).0 {
                            self.tmpAlertBool = true
                            judgeOverlapDay = judgeOverlap(day: tmpClassInfo.schedule, m: m).1
                        }
                        
                        self.showingSheet = false
                    }) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(classData[oneClass].courseTitle).padding(.top, 6)
                            Text(classData[oneClass].instructor).padding(.leading, 18)
                            Text(classData[oneClass].schedule).padding(.leading, 18)
                        }.foregroundColor(.primary)
                    }
                }
            }.listStyle(GroupedListStyle())
            Spacer().frame(height: 1)
        }
        .gesture(DragGesture().onChanged({_ in
            focusTextField = false
        }))
        .onDisappear() {
            self.showingAlert = tmpAlertBool
        }
    }
}
