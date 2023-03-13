//
//  Realm.swift
//  timetable.ver5
//
//  Created by Kohshi Yamaguchi on 2022/09/28.
//

import SwiftUI
import RealmSwift

class cellModel: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var tableTitle: String = ""
    @objc dynamic var year: String = ""
    @objc dynamic var term: String = ""
    @objc dynamic var courseTitle: courseTitleModel?
    @objc dynamic var instructor: instructorModel?
    @objc dynamic var schedule: scheduleModel?
    @objc dynamic var courseno: coursenoModel?
    @objc dynamic var room: roomModel?
    @objc dynamic var mode: modeModel?
    @objc dynamic var color: colorModel?
    
    let tasks = RealmSwift.List<Task>()
    
}

class courseTitleModel: Object {
    
    let cells = LinkingObjects(fromType: cellModel.self, property: "courseTitle")
    
    @objc dynamic var id: String = ""
    
    @objc dynamic var M1: String = ""
    @objc dynamic var M2: String = ""
    @objc dynamic var M3: String = ""
    @objc dynamic var ML: String = ""
    @objc dynamic var M4: String = ""
    @objc dynamic var M5: String = ""
    @objc dynamic var M6: String = ""
    @objc dynamic var M7: String = ""
    @objc dynamic var M8: String = ""
    
    @objc dynamic var TU1: String = ""
    @objc dynamic var TU2: String = ""
    @objc dynamic var TU3: String = ""
    @objc dynamic var TUL: String = ""
    @objc dynamic var TU4: String = ""
    @objc dynamic var TU5: String = ""
    @objc dynamic var TU6: String = ""
    @objc dynamic var TU7: String = ""
    @objc dynamic var TU8: String = ""
    
    @objc dynamic var W1: String = ""
    @objc dynamic var W2: String = ""
    @objc dynamic var W3: String = ""
    @objc dynamic var WL: String = ""
    @objc dynamic var W4: String = ""
    @objc dynamic var W5: String = ""
    @objc dynamic var W6: String = ""
    @objc dynamic var W7: String = ""
    @objc dynamic var W8: String = ""
    
    @objc dynamic var TH1: String = ""
    @objc dynamic var TH2: String = ""
    @objc dynamic var TH3: String = ""
    @objc dynamic var THL: String = ""
    @objc dynamic var TH4: String = ""
    @objc dynamic var TH5: String = ""
    @objc dynamic var TH6: String = ""
    @objc dynamic var TH7: String = ""
    @objc dynamic var TH8: String = ""
    
    @objc dynamic var F1: String = ""
    @objc dynamic var F2: String = ""
    @objc dynamic var F3: String = ""
    @objc dynamic var FL: String = ""
    @objc dynamic var F4: String = ""
    @objc dynamic var F5: String = ""
    @objc dynamic var F6: String = ""
    @objc dynamic var F7: String = ""
    @objc dynamic var F8: String = ""
    
    @objc dynamic var SA1: String = ""
    @objc dynamic var SA2: String = ""
    @objc dynamic var SA3: String = ""
    @objc dynamic var SAL: String = ""
    @objc dynamic var SA4: String = ""
    @objc dynamic var SA5: String = ""
    @objc dynamic var SA6: String = ""
    @objc dynamic var SA7: String = ""
    @objc dynamic var SA8: String = ""

}

class instructorModel: Object {
    
    let cells = LinkingObjects(fromType: cellModel.self, property: "instructor")
    
    @objc dynamic var id: String = ""
    
    @objc dynamic var M1: String = ""
    @objc dynamic var M2: String = ""
    @objc dynamic var M3: String = ""
    @objc dynamic var ML: String = ""
    @objc dynamic var M4: String = ""
    @objc dynamic var M5: String = ""
    @objc dynamic var M6: String = ""
    @objc dynamic var M7: String = ""
    @objc dynamic var M8: String = ""
    
    @objc dynamic var TU1: String = ""
    @objc dynamic var TU2: String = ""
    @objc dynamic var TU3: String = ""
    @objc dynamic var TUL: String = ""
    @objc dynamic var TU4: String = ""
    @objc dynamic var TU5: String = ""
    @objc dynamic var TU6: String = ""
    @objc dynamic var TU7: String = ""
    @objc dynamic var TU8: String = ""
    
    @objc dynamic var W1: String = ""
    @objc dynamic var W2: String = ""
    @objc dynamic var W3: String = ""
    @objc dynamic var WL: String = ""
    @objc dynamic var W4: String = ""
    @objc dynamic var W5: String = ""
    @objc dynamic var W6: String = ""
    @objc dynamic var W7: String = ""
    @objc dynamic var W8: String = ""
    
    @objc dynamic var TH1: String = ""
    @objc dynamic var TH2: String = ""
    @objc dynamic var TH3: String = ""
    @objc dynamic var THL: String = ""
    @objc dynamic var TH4: String = ""
    @objc dynamic var TH5: String = ""
    @objc dynamic var TH6: String = ""
    @objc dynamic var TH7: String = ""
    @objc dynamic var TH8: String = ""
    
    @objc dynamic var F1: String = ""
    @objc dynamic var F2: String = ""
    @objc dynamic var F3: String = ""
    @objc dynamic var FL: String = ""
    @objc dynamic var F4: String = ""
    @objc dynamic var F5: String = ""
    @objc dynamic var F6: String = ""
    @objc dynamic var F7: String = ""
    @objc dynamic var F8: String = ""
    
    @objc dynamic var SA1: String = ""
    @objc dynamic var SA2: String = ""
    @objc dynamic var SA3: String = ""
    @objc dynamic var SAL: String = ""
    @objc dynamic var SA4: String = ""
    @objc dynamic var SA5: String = ""
    @objc dynamic var SA6: String = ""
    @objc dynamic var SA7: String = ""
    @objc dynamic var SA8: String = ""

}

class scheduleModel: Object {
    
    let cells = LinkingObjects(fromType: cellModel.self, property: "schedule")
    
    @objc dynamic var id: String = ""
    
    @objc dynamic var M1: String = ""
    @objc dynamic var M2: String = ""
    @objc dynamic var M3: String = ""
    @objc dynamic var ML: String = ""
    @objc dynamic var M4: String = ""
    @objc dynamic var M5: String = ""
    @objc dynamic var M6: String = ""
    @objc dynamic var M7: String = ""
    @objc dynamic var M8: String = ""
    
    @objc dynamic var TU1: String = ""
    @objc dynamic var TU2: String = ""
    @objc dynamic var TU3: String = ""
    @objc dynamic var TUL: String = ""
    @objc dynamic var TU4: String = ""
    @objc dynamic var TU5: String = ""
    @objc dynamic var TU6: String = ""
    @objc dynamic var TU7: String = ""
    @objc dynamic var TU8: String = ""
    
    @objc dynamic var W1: String = ""
    @objc dynamic var W2: String = ""
    @objc dynamic var W3: String = ""
    @objc dynamic var WL: String = ""
    @objc dynamic var W4: String = ""
    @objc dynamic var W5: String = ""
    @objc dynamic var W6: String = ""
    @objc dynamic var W7: String = ""
    @objc dynamic var W8: String = ""
    
    @objc dynamic var TH1: String = ""
    @objc dynamic var TH2: String = ""
    @objc dynamic var TH3: String = ""
    @objc dynamic var THL: String = ""
    @objc dynamic var TH4: String = ""
    @objc dynamic var TH5: String = ""
    @objc dynamic var TH6: String = ""
    @objc dynamic var TH7: String = ""
    @objc dynamic var TH8: String = ""
    
    @objc dynamic var F1: String = ""
    @objc dynamic var F2: String = ""
    @objc dynamic var F3: String = ""
    @objc dynamic var FL: String = ""
    @objc dynamic var F4: String = ""
    @objc dynamic var F5: String = ""
    @objc dynamic var F6: String = ""
    @objc dynamic var F7: String = ""
    @objc dynamic var F8: String = ""
    
    @objc dynamic var SA1: String = ""
    @objc dynamic var SA2: String = ""
    @objc dynamic var SA3: String = ""
    @objc dynamic var SAL: String = ""
    @objc dynamic var SA4: String = ""
    @objc dynamic var SA5: String = ""
    @objc dynamic var SA6: String = ""
    @objc dynamic var SA7: String = ""
    @objc dynamic var SA8: String = ""

}

class coursenoModel: Object {
    
    let cells = LinkingObjects(fromType: cellModel.self, property: "courseno")
    
    @objc dynamic var id: String = ""
    
    @objc dynamic var M1: String = ""
    @objc dynamic var M2: String = ""
    @objc dynamic var M3: String = ""
    @objc dynamic var ML: String = ""
    @objc dynamic var M4: String = ""
    @objc dynamic var M5: String = ""
    @objc dynamic var M6: String = ""
    @objc dynamic var M7: String = ""
    @objc dynamic var M8: String = ""
    
    @objc dynamic var TU1: String = ""
    @objc dynamic var TU2: String = ""
    @objc dynamic var TU3: String = ""
    @objc dynamic var TUL: String = ""
    @objc dynamic var TU4: String = ""
    @objc dynamic var TU5: String = ""
    @objc dynamic var TU6: String = ""
    @objc dynamic var TU7: String = ""
    @objc dynamic var TU8: String = ""
    
    @objc dynamic var W1: String = ""
    @objc dynamic var W2: String = ""
    @objc dynamic var W3: String = ""
    @objc dynamic var WL: String = ""
    @objc dynamic var W4: String = ""
    @objc dynamic var W5: String = ""
    @objc dynamic var W6: String = ""
    @objc dynamic var W7: String = ""
    @objc dynamic var W8: String = ""
    
    @objc dynamic var TH1: String = ""
    @objc dynamic var TH2: String = ""
    @objc dynamic var TH3: String = ""
    @objc dynamic var THL: String = ""
    @objc dynamic var TH4: String = ""
    @objc dynamic var TH5: String = ""
    @objc dynamic var TH6: String = ""
    @objc dynamic var TH7: String = ""
    @objc dynamic var TH8: String = ""
    
    @objc dynamic var F1: String = ""
    @objc dynamic var F2: String = ""
    @objc dynamic var F3: String = ""
    @objc dynamic var FL: String = ""
    @objc dynamic var F4: String = ""
    @objc dynamic var F5: String = ""
    @objc dynamic var F6: String = ""
    @objc dynamic var F7: String = ""
    @objc dynamic var F8: String = ""
    
    @objc dynamic var SA1: String = ""
    @objc dynamic var SA2: String = ""
    @objc dynamic var SA3: String = ""
    @objc dynamic var SAL: String = ""
    @objc dynamic var SA4: String = ""
    @objc dynamic var SA5: String = ""
    @objc dynamic var SA6: String = ""
    @objc dynamic var SA7: String = ""
    @objc dynamic var SA8: String = ""

}

class roomModel: Object {

    let cells = LinkingObjects(fromType: cellModel.self, property: "room")
    
    @objc dynamic var id: String = ""
    
    @objc dynamic var M1: String = ""
    @objc dynamic var M2: String = ""
    @objc dynamic var M3: String = ""
    @objc dynamic var ML: String = ""
    @objc dynamic var M4: String = ""
    @objc dynamic var M5: String = ""
    @objc dynamic var M6: String = ""
    @objc dynamic var M7: String = ""
    @objc dynamic var M8: String = ""
    
    @objc dynamic var TU1: String = ""
    @objc dynamic var TU2: String = ""
    @objc dynamic var TU3: String = ""
    @objc dynamic var TUL: String = ""
    @objc dynamic var TU4: String = ""
    @objc dynamic var TU5: String = ""
    @objc dynamic var TU6: String = ""
    @objc dynamic var TU7: String = ""
    @objc dynamic var TU8: String = ""
    
    @objc dynamic var W1: String = ""
    @objc dynamic var W2: String = ""
    @objc dynamic var W3: String = ""
    @objc dynamic var WL: String = ""
    @objc dynamic var W4: String = ""
    @objc dynamic var W5: String = ""
    @objc dynamic var W6: String = ""
    @objc dynamic var W7: String = ""
    @objc dynamic var W8: String = ""
    
    @objc dynamic var TH1: String = ""
    @objc dynamic var TH2: String = ""
    @objc dynamic var TH3: String = ""
    @objc dynamic var THL: String = ""
    @objc dynamic var TH4: String = ""
    @objc dynamic var TH5: String = ""
    @objc dynamic var TH6: String = ""
    @objc dynamic var TH7: String = ""
    @objc dynamic var TH8: String = ""
    
    @objc dynamic var F1: String = ""
    @objc dynamic var F2: String = ""
    @objc dynamic var F3: String = ""
    @objc dynamic var FL: String = ""
    @objc dynamic var F4: String = ""
    @objc dynamic var F5: String = ""
    @objc dynamic var F6: String = ""
    @objc dynamic var F7: String = ""
    @objc dynamic var F8: String = ""
    
    @objc dynamic var SA1: String = ""
    @objc dynamic var SA2: String = ""
    @objc dynamic var SA3: String = ""
    @objc dynamic var SAL: String = ""
    @objc dynamic var SA4: String = ""
    @objc dynamic var SA5: String = ""
    @objc dynamic var SA6: String = ""
    @objc dynamic var SA7: String = ""
    @objc dynamic var SA8: String = ""

}

class modeModel: Object {
    
    let cells = LinkingObjects(fromType: cellModel.self, property: "mode")
    
    @objc dynamic var id: String = ""
    
    @objc dynamic var M1: String = ""
    @objc dynamic var M2: String = ""
    @objc dynamic var M3: String = ""
    @objc dynamic var ML: String = ""
    @objc dynamic var M4: String = ""
    @objc dynamic var M5: String = ""
    @objc dynamic var M6: String = ""
    @objc dynamic var M7: String = ""
    @objc dynamic var M8: String = ""
    
    @objc dynamic var TU1: String = ""
    @objc dynamic var TU2: String = ""
    @objc dynamic var TU3: String = ""
    @objc dynamic var TUL: String = ""
    @objc dynamic var TU4: String = ""
    @objc dynamic var TU5: String = ""
    @objc dynamic var TU6: String = ""
    @objc dynamic var TU7: String = ""
    @objc dynamic var TU8: String = ""
    
    @objc dynamic var W1: String = ""
    @objc dynamic var W2: String = ""
    @objc dynamic var W3: String = ""
    @objc dynamic var WL: String = ""
    @objc dynamic var W4: String = ""
    @objc dynamic var W5: String = ""
    @objc dynamic var W6: String = ""
    @objc dynamic var W7: String = ""
    @objc dynamic var W8: String = ""
    
    @objc dynamic var TH1: String = ""
    @objc dynamic var TH2: String = ""
    @objc dynamic var TH3: String = ""
    @objc dynamic var THL: String = ""
    @objc dynamic var TH4: String = ""
    @objc dynamic var TH5: String = ""
    @objc dynamic var TH6: String = ""
    @objc dynamic var TH7: String = ""
    @objc dynamic var TH8: String = ""
    
    @objc dynamic var F1: String = ""
    @objc dynamic var F2: String = ""
    @objc dynamic var F3: String = ""
    @objc dynamic var FL: String = ""
    @objc dynamic var F4: String = ""
    @objc dynamic var F5: String = ""
    @objc dynamic var F6: String = ""
    @objc dynamic var F7: String = ""
    @objc dynamic var F8: String = ""
    
    @objc dynamic var SA1: String = ""
    @objc dynamic var SA2: String = ""
    @objc dynamic var SA3: String = ""
    @objc dynamic var SAL: String = ""
    @objc dynamic var SA4: String = ""
    @objc dynamic var SA5: String = ""
    @objc dynamic var SA6: String = ""
    @objc dynamic var SA7: String = ""
    @objc dynamic var SA8: String = ""

}

class colorModel: Object {

    let cells = LinkingObjects(fromType: cellModel.self, property: "color")
    
    @objc dynamic var id: String = ""
    
    @objc dynamic var M1: String = ""
    @objc dynamic var M2: String = ""
    @objc dynamic var M3: String = ""
    @objc dynamic var ML: String = ""
    @objc dynamic var M4: String = ""
    @objc dynamic var M5: String = ""
    @objc dynamic var M6: String = ""
    @objc dynamic var M7: String = ""
    @objc dynamic var M8: String = ""
    
    @objc dynamic var TU1: String = ""
    @objc dynamic var TU2: String = ""
    @objc dynamic var TU3: String = ""
    @objc dynamic var TUL: String = ""
    @objc dynamic var TU4: String = ""
    @objc dynamic var TU5: String = ""
    @objc dynamic var TU6: String = ""
    @objc dynamic var TU7: String = ""
    @objc dynamic var TU8: String = ""
    
    @objc dynamic var W1: String = ""
    @objc dynamic var W2: String = ""
    @objc dynamic var W3: String = ""
    @objc dynamic var WL: String = ""
    @objc dynamic var W4: String = ""
    @objc dynamic var W5: String = ""
    @objc dynamic var W6: String = ""
    @objc dynamic var W7: String = ""
    @objc dynamic var W8: String = ""
    
    @objc dynamic var TH1: String = ""
    @objc dynamic var TH2: String = ""
    @objc dynamic var TH3: String = ""
    @objc dynamic var THL: String = ""
    @objc dynamic var TH4: String = ""
    @objc dynamic var TH5: String = ""
    @objc dynamic var TH6: String = ""
    @objc dynamic var TH7: String = ""
    @objc dynamic var TH8: String = ""
    
    @objc dynamic var F1: String = ""
    @objc dynamic var F2: String = ""
    @objc dynamic var F3: String = ""
    @objc dynamic var FL: String = ""
    @objc dynamic var F4: String = ""
    @objc dynamic var F5: String = ""
    @objc dynamic var F6: String = ""
    @objc dynamic var F7: String = ""
    @objc dynamic var F8: String = ""
    
    @objc dynamic var SA1: String = ""
    @objc dynamic var SA2: String = ""
    @objc dynamic var SA3: String = ""
    @objc dynamic var SAL: String = ""
    @objc dynamic var SA4: String = ""
    @objc dynamic var SA5: String = ""
    @objc dynamic var SA6: String = ""
    @objc dynamic var SA7: String = ""
    @objc dynamic var SA8: String = ""

}
 
class Task: Object {
    @objc dynamic var taskTitle: String = ""
    @objc dynamic var dueDate: Date = Date(timeInterval: 60*60*24*7, since: Date())
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var courseTitle: String = ""
    @objc dynamic var id: String = ""
}

class ContentViewModel: ObservableObject {
    private var token: NotificationToken?
    private var myModelResults = try? Realm().objects(cellModel.self)
    @Published var cellModels: [ContentViewCellModel] = []
    
    init() {
        token = myModelResults?.observe { [weak self] _ in
            self?.cellModels = self?.myModelResults?.map { ContentViewCellModel(id: $0.id, tableTitle: $0.tableTitle, courseTitle: $0.courseTitle, instructor: $0.instructor, schedule: $0.schedule, color: $0.color, tasks: $0.tasks, year: $0.year, term: $0.term) } ?? []
        }
    }
    
    deinit {
        token?.invalidate()
    }
}

struct ContentViewCellModel {
    let id: String
    let tableTitle: String
    let courseTitle: courseTitleModel?
    let instructor: instructorModel?
    let schedule: scheduleModel?
    let color: colorModel?
    let tasks: RealmSwift.List<Task>
    let year: String
    let term: String
}

