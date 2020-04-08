import UIKit
import ReactiveKit
import Bond

class ViewController: UIViewController {

    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    let model = VCModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.loadTasksFromRealm()
        model.bindTableViewToDataSource(tableView: todoTableView)
        model.bindButtonToTF(button: addButton, sender: self)
        todoTableView.reactive.selectedRowIndexPath.observeNext { (index) in
            try! self.model.realm.write({
                self.model.realm.delete(self.model.todoArray[index.row])
            })
            self.model.todoArray.remove(at: index.row)
        }.dispose(in: model.bag)
    }
}

