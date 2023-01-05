//
//  DataStore.swift
//  RandomScheduleMaker
//

import Foundation

// データの保存、取り出しを行うクラスです。
class DataStore {
    // データの保存先です。
    private let userDefaults: UserDefaults = .standard
    
    // 保存先に名前（Key）をつけて保存するため、Keyをこちらで管理しています。
    private func makeKey(from menu: Menu) -> String {
        switch menu {
        case .when:
            return "when_menu_values"
        case .who:
            return "who_menu_values"
        case .where:
            return "where_menu_values"
        case .what:
            return "what_menu_values"
        case .how:
            return "how_menu_values"
        }
    }
    
    // menuに応じた文字列の一覧を取り出します。
    func menuValues(for menu: Menu) -> [String?] {
        userDefaults.value(forKey: makeKey(from: menu)) as? [String?] ?? []
    }
    
    // menuに応じて文字列の一覧を上書きします。
    func update(menuValues: [String?], for menu: Menu) {
        userDefaults.set(menuValues, forKey: makeKey(from: menu))
    }
}
