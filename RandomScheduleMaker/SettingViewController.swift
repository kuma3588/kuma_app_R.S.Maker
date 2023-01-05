//
//  SettingViewController.swift
//  RandomScheduleMaker
//

import Foundation
import UIKit

final class SettingViewController: UITableViewController {
    
    private let dataStore = DataStore()
    private var menues: [Menu] = [.when, .who, .where, .what, .how]
    private var whenValues: [String?] = []
    private var whoValues: [String?] = []
    private var whereValues: [String?] = []
    private var whatValues: [String?] = []
    private var howValues: [String?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // データを取り出して、一時データを作成します。
        whenValues = dataStore.menuValues(for: .when)
        whoValues = dataStore.menuValues(for: .who)
        whereValues = dataStore.menuValues(for: .where)
        whatValues = dataStore.menuValues(for: .what)
        howValues = dataStore.menuValues(for: .how)
        
        // CustomCellを登録しています。
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 画面を閉じる都度、画面に表示しているデータを保存します。
        dataStore.update(menuValues: whenValues, for: .when)
        dataStore.update(menuValues: whoValues, for: .who)
        dataStore.update(menuValues: whereValues, for: .where)
        dataStore.update(menuValues: whatValues, for: .what)
        dataStore.update(menuValues: howValues, for: .how)
    }
    
}

extension SettingViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        menues.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let menu = menues[section]
        switch menu {
        case .when:
            return whenValues.count
        case .who:
            return whoValues.count
        case .where:
            return whereValues.count
        case .what:
            return whatValues.count
        case .how:
            return howValues.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["いつ","だれが","どこで","何をしに","どうやって"][section]
//        "\(menues[section]) section"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath)
        guard let textFieldCell = cell as? TextFieldCell else {
            return cell
        }
        
        switch menues[indexPath.section] {
        case .when:
            // 設定されている値をCellに代入します。一緒に表示位置を記録します。
            textFieldCell.set(whenValues[indexPath.row], for: indexPath)
        case .who:
            textFieldCell.set(whoValues[indexPath.row], for: indexPath)
        case .where:
            textFieldCell.set(whereValues[indexPath.row], for: indexPath)
        case .what:
            textFieldCell.set(whatValues[indexPath.row], for: indexPath)
        case .how:
            textFieldCell.set(howValues[indexPath.row], for: indexPath)
        }
        // SettingViewControllerが委譲先となるようにselfを設定します。
        textFieldCell.delegate = self
        return textFieldCell
    }
}

extension SettingViewController: TextFieldCellDelegate {
    // UITextFieldの編集が終わった時に呼び出されます。
    func textFieldCell(_ textFieldCell: TextFieldCell, didEndEditing text: String?, from indexPath: IndexPath) {
        switch menues[indexPath.section] {
        case .when:
            // 一時データを更新します。（画面を閉じる時にデータを更新します。）
            whenValues[indexPath.row] = text
        case .who:
            whoValues[indexPath.row] = text
        case .where:
            whereValues[indexPath.row] = text
        case .what:
            whatValues[indexPath.row] = text
        case .how:
            howValues[indexPath.row] = text
        }
        print("Updated value :\(String(describing: text)) from \(indexPath)")
    }
    
}
