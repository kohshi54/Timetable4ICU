//
//  TaskListView.swift
//  timetable.ver5
//
//  Created by Kohshi Yamaguchi on 2022/09/28.
//

import SwiftUI
import RealmSwift

struct TaskListViewVertical: View {
    @ObservedObject var model = ContentViewModel()
    @AppStorage("idsaved") var idSaved = ""
    @State var noTask = false
//    @State var taskPics: [String] = ["nanami", "Teruteru5"]
    @State var taskPics: [String] = ["nanami"]
    var body: some View {
        NavigationView {
            ForEach(model.cellModels.filter {$0.id == idSaved}, id: \.id) { oneModel in
                if !noTask {
                    List {
                        ForEach(oneModel.tasks.filter {$0.id == idSaved}, id: \.self) { oneTask in
                            VStack(alignment: .leading) {
                                Text("Due：\(oneTask.dueDate.formatted(.dateTime.hour().minute().day().month()))").font(.subheadline)
                                //                                        .underline(Color.blue)
                                //                                        .bold()
                                //                                        .italic()
                                    .padding(.bottom, 0.5)
                                
                                Text("・\(oneTask.taskTitle)").padding(.vertical, 1)
                                HStack {
                                    Text("　")
                                    Text("created at \(oneTask.createdAt.formatted(.dateTime.hour().minute().day().month())) in \(oneTask.courseTitle)").font(.footnote)
                                }
                            }
                        }
                        .onDelete(perform: { indexSet in
                            let realm = try? Realm()
                            if let index = indexSet.first, let myModel = realm?.objects(cellModel.self).filter("id = %@", idSaved).first {
                                try? realm?.write {
                                    myModel.tasks.remove(at: index)
                                }
                            }
                            
                            // 課題を全て削除した時に画面を再描画しないと、「タスクなし！！！」の表示が出ないので、削除する度に課題があるかどうか判定
                            for i in model.cellModels.filter({$0.id == idSaved}) {
                                if (i.tasks.filter {$0.id == idSaved}.isEmpty) {
                                    noTask = true
                                }
                            }
                        })
                    }
                    .listStyle(PlainListStyle())
                } else {
                    VStack {
                        Text("課題無し！！！").font(.system(.title, design: .monospaced))
                        Text("オレえらい！！！さすが！！！").font(.system(.title, design: .monospaced))
                        Image(taskPics.randomElement() ?? "nanami").resizable().scaledToFit()
                    }
                }
            }
            .onAppear() {
                noTask = false
                for i in model.cellModels.filter({$0.id == idSaved}) {
                    if (i.tasks.filter {$0.id == idSaved}.isEmpty) {
                        noTask = true
                    }
                }
            }
            .navigationBarTitle("Task List", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Task List")
                        .font(.headline)
                        .foregroundColor(Color("silver"))
                }
            }
        }
    }
}

