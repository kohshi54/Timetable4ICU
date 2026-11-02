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
    // 一覧を開いたコマ（例: "3/TH"）と年度・学期。見出しに使う
    var cellName: String
    var year: String
    var term: String
    // タップしたコマに今入っている授業。編集時にその授業自身を「重複」と数えないために使う
    var currentTitle: String
    @State var searchText = ""
    @State var showingManualInput = false
    @State var manualTitle = ""
    @FocusState var focusTextField: Bool
    @FocusState var focusManualInput: Bool

    var filteredClassData: [(courseTitle: String, instructor: String, schedule: String, courseno: String, room: String, mode: String, color: String)] {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        if query.isEmpty {
            return classData
        }
        return classData.filter {
            $0.courseTitle.localizedCaseInsensitiveContains(query)
                || $0.courseno.localizedCaseInsensitiveContains(query)
                || $0.instructor.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(scheduleLabel(cellName)) · \(year) \(term)")
                    .font(.headline)
                Spacer()
                Button(action: {
                    showingSheet = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(.systemGray3))
                }
                .accessibilityLabel("Close")
            }.padding()

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search title, number, or instructor", text: $searchText)
                    .focused($focusTextField)
                    .disableAutocorrection(true)
            }
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.secondarySystemBackground)))
            .padding(.horizontal)

            HStack {
                Text(filteredClassData.count == 1 ? "1 course" : "\(filteredClassData.count) courses")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 8)

            List {
                ForEach(Array(filteredClassData.enumerated()), id: \.offset) { _, oneClass in
                    let conflicts = conflictingCourses(schedule: oneClass.schedule)
                    Button(action: {
                        select(oneClass)
                    }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(oneClass.courseTitle)
                            Text(oneClass.instructor)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                            HStack(alignment: .firstTextBaseline, spacing: 6) {
                                if oneClass.courseno != "NO DATA" {
                                    chip(oneClass.courseno, foreground: .secondary, background: Color(.systemGray6))
                                }
                                Text(scheduleLabel(oneClass.schedule))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            if !conflicts.isEmpty {
                                chip(conflictLabel(conflicts), foreground: .red, background: Color.red.opacity(0.12))
                            }
                        }
                        .padding(.vertical, 4)
                        .foregroundColor(.primary)
                    }
                }
            }
            .listStyle(.plain)
            .simultaneousGesture(DragGesture().onChanged({ _ in
                focusTextField = false
            }))

            Divider()
            if showingManualInput {
                HStack {
                    TextField("Course title", text: $manualTitle, onCommit: {
                        decideManualTitle()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusManualInput)
                    Button("Add") {
                        decideManualTitle()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else {
                Button(action: {
                    showingManualInput = true
                    focusManualInput = true
                }) {
                    Label("Add a course not listed", systemImage: "plus")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
        }
        .onDisappear() {
            self.showingAlert = tmpAlertBool
        }
    }

    func select(_ oneClass: (courseTitle: String, instructor: String, schedule: String, courseno: String, room: String, mode: String, color: String)) {
        tmpClassInfo = oneClass
        if judgeOverlap(day: tmpClassInfo.schedule, m: m).0 {
            self.tmpAlertBool = true
            judgeOverlapDay = judgeOverlap(day: tmpClassInfo.schedule, m: m).1
        }
        self.showingSheet = false
    }

    func decideManualTitle() {
        let title = manualTitle.trimmingCharacters(in: .whitespaces)
        guard !title.isEmpty else { return }
        tmpClassInfo.courseTitle = title
        showingSheet = false
    }

    // 登録済みの授業のうち時間が重なるものの名前を、重複なしで時限順に返す（タップしたコマの授業自身は除く）
    func conflictingCourses(schedule: String) -> [String] {
        var titles: [String] = []
        for oneDay in schedule.components(separatedBy: ",") {
            let shaped = shapeScheduleString(scheduleHnumVnum: oneDay)
            guard shaped.contains("/") else { continue }
            let (vnum, hnum) = convertDayToHVNum(Day: shaped)
            guard (0...5).contains(hnum), (0...8).contains(vnum) else { continue }
            let registered = m.array[hnum][vnum]
            if !registered.isEmpty && registered != currentTitle && !titles.contains(registered) {
                titles.append(registered)
            }
        }
        return titles
    }

    // 授業名は長いので、3つ以上重なるときは "Overlaps ジェンダーと国際関係 (E) and 2 more" にまとめる
    func conflictLabel(_ conflicts: [String]) -> String {
        if conflicts.count <= 2 {
            return "Overlaps \(conflicts.joined(separator: ", "))"
        }
        return "Overlaps \(conflicts[0]) and \(conflicts.count - 1) more"
    }

    func chip(_ text: String, foreground: Color, background: Color) -> some View {
        Text(text)
            .font(.caption)
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(foreground)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(RoundedRectangle(cornerRadius: 4).fill(background))
    }
}

// シラバスと同じ "3/TU" の表記のまま、"3/TU,2/TH" を "3/TU, 2/TH" と区切りを空けて読みやすくする
func scheduleLabel(_ schedule: String) -> String {
    return schedule.components(separatedBy: ",").joined(separator: ", ")
}
