//
//  TextFieldCell.swift
//  RandomScheduleMaker
//

import Foundation
import UIKit

protocol TextFieldCellDelegate: AnyObject {
    func textFieldCell(_ textFieldCell: TextFieldCell, didEndEditing text: String?, from indexPath: IndexPath)
}

final class TextFieldCell: UITableViewCell {
    
    @IBOutlet private weak var textField: UITextField!
    private var position: IndexPath?
    weak var delegate: TextFieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // UITextFieldの委譲を受け取れるようにします。
        textField.delegate = self
    }
    
    func set(_ text: String?, for indexPath: IndexPath) {
        // 表示用に受け取ったテキストを表示します。
        textField.text = text
        // 変更通知する際に、どのTextFieldが変更されたか知るためにindexPathを受け取ります。
        position = indexPath
    }
}

extension TextFieldCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let indexPath = position else { return }
        // テキスト編集が終わったタイミング（確定がされたタイミング）で委譲先にデータを受け渡します。
        delegate?.textFieldCell(self, didEndEditing: textField.text, from: indexPath)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 確定ボタンが押されたら、フォーカスを外すようにしています。
        textField.resignFirstResponder()
        return true
    }
}
