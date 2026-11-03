//
//  function.swift
//  timetable.ver5
//
//  Created by Kohshi Yamaguchi on 2022/09/28.
//

import SwiftUI
import RealmSwift

func convertHVNumToDay(hnum: Int, vnum: Int) -> String {
    let cellNameForRealm = [["1/M", "2/M", "3/M", "L/M", "4/M", "5/M", "6/M", "7/M", "8/M"], ["1/TU", "2/TU", "3/TU", "L/TU", "4/TU", "5/TU", "TU", "7/TU", "8/TU"], ["1/W", "2/W", "3/W", "L/W", "4/W", "5/W", "6/W", "7/W", "8/W"], ["1/TH", "2/TH", "3/TH", "L/TH", "4/TH", "5/TH", "6/TH", "7/TH", "8/TH"], ["1/F", "2/F", "3/F", "L/F", "4/F", "5/F", "6/F", "7/F", "8/F"], ["1/SA", "2/SA", "3/SA", "L/SA", "4/SA", "5/SA", "6/SA", "7/SA", "8/SA"]]
    return cellNameForRealm[hnum][vnum]
}

// 年度ごとの授業データのファイル名（"ALL\(year)" と異なる年度だけ書く）
let syllabusFileNames = ["2022": "ALL2022-2-13"]

func downloadTextFile(year: String, term: String) -> [(courseTitle: String, instructor: String, schedule: String, courseno: String, room: String, mode: String, color: String)] {
    
    var courseALL: ([(courseTitle: String, instructor: String, schedule: String, courseno: String, room: String, mode: String, color: String)]) = [(courseTitle: "ELAのクラス名", instructor: "教授", schedule: "スケジュール", courseno: "コース番号", room: "部屋番号", mode: "授業形態", color: "white")]
    
    // 選択中の年度のファイルだけ読む。ファイルが無い・読めない場合も落とさず手入力用の行だけ返す
    let fileName = syllabusFileNames[year] ?? "ALL\(year)"
    guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "txt"),
          let fileContents = try? String(contentsOf: fileURL) else {
        return courseALL
    }
    
    // 1行目はヘッダー
    for course in fileContents.components(separatedBy: "\n").dropFirst() {
        var oneCourseList = course.components(separatedBy: ";")
        guard oneCourseList.count >= 9, oneCourseList[7] == year, oneCourseList[8] == term else {
            continue
        }
        if oneCourseList[6] == "NO DATA" {
            oneCourseList[6] = ""
        } else if !oneCourseList[6].isEmpty {
            oneCourseList[6] = "（" + oneCourseList[6] + "）"
        }
        
        let convertToTuple: (courseTitle: String, instructor: String, schedule: String, courseno: String, room: String, mode: String, color: String) = (courseTitle: oneCourseList[0]+oneCourseList[6], instructor: oneCourseList[1], schedule: oneCourseList[2], courseno: oneCourseList[3], room: oneCourseList[4], mode: oneCourseList[5], color: "white")
        courseALL.append(convertToTuple)
    }
    
    return courseALL
}

func filterCourses(cellName: String, classData: [(courseTitle: String, instructor: String, schedule: String, courseno: String, room: String, mode: String, color: String)]) -> [(courseTitle: String, instructor: String, schedule: String, courseno: String, room: String, mode: String, color: String)] {
    let filteredArray = classData.filter {$0.schedule.contains(cellName)}
    return filteredArray
}

func convertDayToHVNum(Day: String) -> (Int, Int) {
    let tmpDay = Day
    let timeAndDay = tmpDay.components(separatedBy: "/")
    var time = Int(timeAndDay[0]) ?? 0
    let day = timeAndDay[1]
    var dayInt = 0
    
    if time < 4 {
        time -= 1
    }
    
    switch day {
    case "M":
        dayInt = 0
    case "TU":
        dayInt = 1
    case "W":
        dayInt = 2
    case "TH":
        dayInt = 3
    case "F":
        dayInt = 4
    case "SA":
        dayInt = 5
    default:
        dayInt = 0
    }
    
    return (time, dayInt)
}


func addDataToCellFromRealmData(id: String, m: myModel) {
    for i in 0...5 {
        for j in 0...8 {
            let cellTitle = try? Realm().objects(courseTitleModel.self).filter("id = %@", id).first?.value(forKey: "\(cellNameForRealm[i][j])") ?? ""
            m.array[i][j] = cellTitle as? String ?? ""
            
            let cellInstructor = try? Realm().objects(instructorModel.self).filter("id = %@", id).first?.value(forKey: "\(cellNameForRealm[i][j])") ?? ""
            m.arrayInstructor[i][j] = cellInstructor as? String ?? ""
            
            let cellSchedule = try? Realm().objects(scheduleModel.self).filter("id = %@", id).first?.value(forKey: "\(cellNameForRealm[i][j])") ?? ""
            m.arraySchedule[i][j] = cellSchedule as? String ?? ""
            
            let cellColor = try? Realm().objects(colorModel.self).filter("id = %@", id).first?.value(forKey: "\(cellNameForRealm[i][j])") ?? ""
            m.arrayColor[i][j] = cellColor as? String ?? ""
            
            let cellRoom = try? Realm().objects(roomModel.self).filter("id = %@", id).first?.value(forKey: "\(cellNameForRealm[i][j])") ?? ""
            m.arrayRoom[i][j] = cellRoom as? String ?? ""
            
            let cellMode = try? Realm().objects(modeModel.self).filter("id = %@", id).first?.value(forKey: "\(cellNameForRealm[i][j])") ?? ""
            m.arrayMode[i][j] = cellMode as? String ?? ""
            
            let cellCourseno = try? Realm().objects(coursenoModel.self).filter("id = %@", id).first?.value(forKey: "\(cellNameForRealm[i][j])") ?? ""
            m.arrayCourseno[i][j] = cellCourseno as? String ?? ""
            
        }
    }
}


func createNewRealmData(tableTitle: String, uuid: String, year: String, term: String) {
    let cellModel = cellModel()
    cellModel.tableTitle = tableTitle
    cellModel.id = uuid
    cellModel.year = year
    cellModel.term = term
    let courseTitle = courseTitleModel()
    courseTitle.id = uuid
    cellModel.courseTitle = courseTitle
    let instructor = instructorModel()
    instructor.id = uuid
    cellModel.instructor = instructor
    let schedule = scheduleModel()
    schedule.id = uuid
    cellModel.schedule = schedule
    let courseno = coursenoModel()
    courseno.id = uuid
    cellModel.courseno = courseno
    let room = roomModel()
    room.id = uuid
    cellModel.room = room
    let mode = modeModel()
    mode.id = uuid
    cellModel.mode = mode
    let color = colorModel()
    color.id = uuid
    cellModel.color = color
    //        let tasks = TaskModel()
    //        tasks.id = uuid
    //        cellModel.tasks = tasks
    let realm = try? Realm()
    try? realm?.write {
        realm?.add(cellModel)
    }
}


func addCellDataToRealm(id: String, m: myModel, hnum: Int, vnum: Int, target: String) {
    try? Realm().write {
        try? Realm().objects(courseTitleModel.self).filter("id = %@", id).first?.setValue(m.array[hnum][vnum], forKey: "\(target)")
        
        try? Realm().objects(instructorModel.self).filter("id = %@", id).first?.setValue(m.arrayInstructor[hnum][vnum], forKey: "\(target)")
        
        try? Realm().objects(scheduleModel.self).filter("id = %@", id).first?.setValue(m.arraySchedule[hnum][vnum], forKey: "\(target)")
        
        try? Realm().objects(coursenoModel.self).filter("id = %@", id).first?.setValue(m.arrayCourseno[hnum][vnum], forKey: "\(target)")
        
        try? Realm().objects(roomModel.self).filter("id = %@", id).first?.setValue(m.arrayRoom[hnum][vnum], forKey: "\(target)")
        
        try? Realm().objects(modeModel.self).filter("id = %@", id).first?.setValue(m.arrayMode[hnum][vnum], forKey: "\(target)")
        
        try? Realm().objects(colorModel.self).filter("id = %@", id).first?.setValue(m.arrayColor[hnum][vnum], forKey: "\(target)")
    }
}

func shapeScheduleString(scheduleHnumVnum: String) -> String {
    
    var scheduleHnumVnum2 = scheduleHnumVnum
    
    if scheduleHnumVnum.contains("(") {
        scheduleHnumVnum2 = scheduleHnumVnum.replacingOccurrences(of:"(", with:"")
    } else if scheduleHnumVnum.contains(")") {
        scheduleHnumVnum2 = scheduleHnumVnum.replacingOccurrences(of:")", with:"")
    }
    
    if scheduleHnumVnum2.contains("*") {
        scheduleHnumVnum2 = scheduleHnumVnum2.replacingOccurrences(of:"*", with:"")
    }
    return scheduleHnumVnum2
}

func cellSize(hnum: Int, vnum: Int, eighthFlg: Bool, all: CGSize, m: myModel) -> CGFloat {
    var cellsize: CGFloat = 1
    let height = vnum==3 ? (all.height-0.5) * 0.05 : eighthFlg ? ((all.height*0.95)/8)-0.5 : ((all.height*0.95)/7)-0.5
    let dividerSpace: CGFloat = 0.5
    let lunchHeight = (all.height-0.5) * 0.05
    var lon4: CGFloat = 0
    var lon5: CGFloat = 0
    switch m.array[hnum][vnum].isEmpty {
    case true:
        cellsize = 1
    case false:
        switch vnum {
        case 0:
            if m.array[hnum][vnum] == m.array[hnum][vnum+3] && m.array[hnum][vnum] == m.array[hnum][vnum+2] && m.array[hnum][vnum] == m.array[hnum][vnum+1] {
                cellsize = 4
            } else if m.array[hnum][vnum] == m.array[hnum][vnum+2] && m.array[hnum][vnum] == m.array[hnum][vnum+1] {
                cellsize = 3
            } else if m.array[hnum][vnum] == m.array[hnum][vnum+1] {
                cellsize = 2
            } else {
                cellsize = 1
            }
        case 1...4:
            if m.array[hnum][vnum] == m.array[hnum][vnum-1] {
                cellsize = 0
            } else if m.array[hnum][vnum] == m.array[hnum][vnum+4] && m.array[hnum][vnum] == m.array[hnum][vnum+3] && m.array[hnum][vnum] == m.array[hnum][vnum+2] && m.array[hnum][vnum] == m.array[hnum][vnum+1] {
                cellsize = 5
            } else if m.array[hnum][vnum] == m.array[hnum][vnum+3] && m.array[hnum][vnum] == m.array[hnum][vnum+2] && m.array[hnum][vnum] == m.array[hnum][vnum+1] {
                cellsize = 4
            } else if m.array[hnum][vnum] == m.array[hnum][vnum+2] && m.array[hnum][vnum] == m.array[hnum][vnum+1] {
                cellsize = 3
            } else if m.array[hnum][vnum] == m.array[hnum][vnum+1] {
                cellsize = 2
            } else {
                cellsize = 1
            }
        case 5:
            if m.array[hnum][vnum] == m.array[hnum][vnum-1] {
                cellsize = 0
            } else if m.array[hnum][vnum] == m.array[hnum][vnum+3] && m.array[hnum][vnum] == m.array[hnum][vnum+2] && m.array[hnum][vnum] == m.array[hnum][vnum+1] {
                cellsize = 4
            } else if m.array[hnum][vnum] == m.array[hnum][vnum+2] && m.array[hnum][vnum] == m.array[hnum][vnum+1] {
                cellsize = 3
            } else if m.array[hnum][vnum] == m.array[hnum][vnum+1] {
                cellsize = 2
            } else {
                cellsize = 1
            }
        case 6:
            if m.array[hnum][vnum] == m.array[hnum][vnum-1] {
                cellsize = 0
            } else if m.array[hnum][vnum] == m.array[hnum][vnum+2] && m.array[hnum][vnum] == m.array[hnum][vnum+1] {
                cellsize = 3
            } else if m.array[hnum][vnum] == m.array[hnum][vnum+1] {
                cellsize = 2
            } else {
                cellsize = 1
            }
            
        case 7:
            if m.array[hnum][vnum] == m.array[hnum][vnum-1] {
                cellsize = 0
            } else if m.array[hnum][vnum] == m.array[hnum][vnum+1] {
                cellsize = 2
            } else {
                cellsize = 1
            }
        case 8:
            if m.array[hnum][vnum] == m.array[hnum][vnum-1] {
                cellsize = 0
            } else {
                cellsize = 1
            }
        default:
            cellsize = 1
        }
    }
    
    // *4・*5 の伸び縮みは、連続授業でまとめて描画するセルにも反映する（まとめられて非表示のセルには付けない）
    if vnum == 3 {
        if m.arraySchedule[hnum][vnum+1].contains("*4") {
            lon4 = -lunchHeight/2
        }
    } else if cellsize > 0 {
        let coveredVnums = vnum..<(vnum + Int(cellsize))
        if coveredVnums.contains(4) && m.arraySchedule[hnum][4].contains("*4") {
            lon4 = lunchHeight/2
        }
        if coveredVnums.contains(5) && m.arraySchedule[hnum][5].contains("*5") {
            lon5 += lunchHeight/2
        }
        if coveredVnums.contains(6) && m.arraySchedule[hnum][5].contains("*5") {
            lon5 -= lunchHeight/2
        }
    }

    return (height * cellsize) + (dividerSpace * (cellsize - 1)) + lon4 + lon5
}

func dividerShowBool(hnum: Int, vnum: Int, m: myModel) -> Bool {
    if m.array[hnum][vnum].isEmpty {
        return true
    } else if vnum == 8 {
        return true
    } else if (m.array[hnum][vnum] == m.array[hnum][vnum+1]) {
        return false
    } else {
        return true
    }
}

/* 連続授業の際にios15まではフレームを消せば講義名が表示されなくなっていたからよかったけど、
   ios16になってフレームを消しても講義名が表示されてしまうので
   同じ講義が連続する際は2つ目以降の名前は消すように修正。（講義名が一コマ前と同じなら表示しないっていう処理）
*/
func showNameBool(hnum: Int, vnum: Int, m: myModel) -> Bool {
    if (vnum == 0) {
        return true
    } else if m.array[hnum][vnum].isEmpty {
        return true
    } else if (m.array[hnum][vnum] == m.array[hnum][vnum-1]) {
        return false
    } else {
        return true
    }
}


func judgeOverlap(day: String, m: myModel) -> (Bool, String) {
    var judge: Bool = false
    var array: [String] = []
    var string: String = ""
    let dayArray = day.components(separatedBy: ",")
    
    
    for oneDayRaw in dayArray {
        var oneDay = ""
        
        if oneDayRaw.contains("(") {
            oneDay = oneDayRaw.replacingOccurrences(of:"(", with:"")
        } else if oneDayRaw.contains(")") {
            oneDay = oneDayRaw.replacingOccurrences(of:")", with:"")
        } else {
            oneDay = oneDayRaw
        }
        
        let HAndVNum = oneDay.components(separatedBy: "/")
        
        let HString = HAndVNum[1]
        
        var Hnum = 0
        switch HString {
        case "M":
            Hnum = 0
        case "TU":
            Hnum = 1
        case "W":
            Hnum = 2
        case "TH":
            Hnum = 3
        case "F":
            Hnum = 4
        case "SA":
            Hnum = 5
        default:
            print("conversion error")
        }
        let VStringRaw = HAndVNum[0]
        var VString = ""
        if VStringRaw.contains("*") {
            VString = VStringRaw.replacingOccurrences(of:"*", with:"")
        } else {
            VString = VStringRaw
        }
        
        var Vnum = Int(VString)!
        if Vnum < 4 {
            Vnum -= 1
        }
        
        if !m.array[Hnum][Vnum].isEmpty {
            judge = true
            
            array.append("\(VString)/\(HString)")
        }
    }
    string = array.joined(separator: ",")
    
    return (judge, string)
}

func lunchColor(hnum: Int, m: myModel) -> Color {
    var color: Color = Color.gray
    if m.arrayColor[hnum][3].isEmpty {
        color = Color.gray
    } else {
        color = Color("\(m.arrayColor[hnum][3])")
    }
    return color
}

func renameTasks(from oldTitle: String, to newTitle: String, id: String) {
    guard !oldTitle.isEmpty, oldTitle != newTitle,
          let realm = try? Realm(),
          let table = realm.objects(cellModel.self).filter("id = %@", id).first else { return }
    try? realm.write {
        table.tasks.filter("courseTitle = %@", oldTitle).forEach { $0.courseTitle = newTitle }
    }
}
