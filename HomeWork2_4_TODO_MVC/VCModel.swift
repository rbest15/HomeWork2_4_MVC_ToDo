import Foundation
import ReactiveKit
import Bond
import RealmSwift


class VCModel {
    var todoArray = MutableObservableArray<ToDoTask>()
    
    var bag = DisposeBag()
    let realm = try! Realm()
    
    
    func bindTableViewToDataSource(tableView: UITableView){
        todoArray.bind(to: tableView) { (dataSource, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! ToDoTableViewCell
            cell.todoLabel.text = dataSource[indexPath.row].text
            return cell
        }
    }
    
    func bindButtonToTF(button: UIButton, sender: UIViewController){
        button.reactive.tap.observeNext {
            let alert = UIAlertController(title: "ToDo", message: "Enter a task", preferredStyle: .alert)
            alert.addTextField()
            alert.textFields![0].returnKeyType = .done
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                if alert.textFields![0].text?.count ?? 0 > 0 {
                    let newTask = ToDoTask()
                    newTask.text = alert.textFields![0].text!
                    self.todoArray.append(newTask)
                    try! self.realm.write {
                        self.realm.add(newTask)
                    }
                } else { return }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                return
            }))
            sender.present(alert, animated: true)
        }.dispose(in: bag)
    }
    
    func loadTasksFromRealm(){
        let taskArrayFromRealm = realm.objects(ToDoTask.self)
        for task in taskArrayFromRealm {
            todoArray.append(task)
        }
    }
    
}
class ToDoTask : Object {
    @objc dynamic var text = ""
}
