//
//  ViewController.swift
//  RandomScheduleMaker
//

import UIKit
import AVFoundation

final class ViewController: UIViewController {
    
    //作るAVAudioPlayerのインスタンスの数だけ音楽再生関数を作る
    var player0: AVAudioPlayer?
    var player1: AVAudioPlayer?
    
    @IBOutlet weak var whenPickerView: UIPickerView!
    @IBOutlet weak var whoPickerView: UIPickerView!
    @IBOutlet weak var wherePickerView: UIPickerView!
    @IBOutlet weak var whatPickerView: UIPickerView!
    @IBOutlet weak var howPickerView: UIPickerView!
    
    //viewDidLayoutSubviews用に宣言
    @IBOutlet weak var startActionButton: UIButton!
    
    var count = 0
    var countIsStop = true
    var timar: Timer?
    
    // テキストデータを管理しているクラスです。
    private let dataStore = DataStore()
    // 表示に使う文字列の配列です。
    private var whenValues: [String?] = []
    private var whoValues: [String?] = []
    private var whereValues: [String?] = []
    private var whatValues: [String?] = []
    private var howValues: [String?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //サウンド追加
        if let soundURL = Bundle.main.url(forResource: "BGM132-110921-koryuunoseninotte-wav-nointro", withExtension: "mp3") {
            do {
                player0 = try AVAudioPlayer(contentsOf: soundURL)
                player0?.numberOfLoops = -1 //ループ再生
                player0?.prepareToPlay() //即時再生させる
                player0?.play() //BGMを鳴らす
            } catch {
                print("error")
            }
        }
        
        // 初期設定を行なう
        if dataStore.menuValues(for: .when).isEmpty {
            // もし、データがない場合には初期値を設定する
            dataStore.update(menuValues: [
                "今日",
                "次の休み",
                "次の月曜",
                "次の火曜",
                "次の水曜",
                "次の木曜",
                "次の金曜",
                "次の土曜",
                "次の日曜"
            ], for: .when)
        }
        whenPickerView.dataSource = self
        whenPickerView.delegate = self
        
        if dataStore.menuValues(for: .who).isEmpty {
            dataStore.update(menuValues: [
                "私が",
                "私と友達が",
                "家族全員と",
                "家族Aグループと",
                "家族Bグループと",
                "友達Aグループと",
                "友達Bグループと",
                "恋人と",
                "友達カップルと"
            ], for: .who)
        }
        whoPickerView.dataSource = self
        whoPickerView.delegate = self
        
        if dataStore.menuValues(for: .where).isEmpty {
            dataStore.update(menuValues: [
                "家へ",
                "学校へ",
                "職場へ",
                "友達の家へ",
                "公園へ",
                "カラオケBOXへ",
                "海岸へ",
                "鎌倉へ",
                "横浜へ"
            ], for: .where)
        }
        wherePickerView.dataSource = self
        wherePickerView.delegate = self
        
        if dataStore.menuValues(for: .what).isEmpty {
            dataStore.update(menuValues: [
                "キャッチボールしに",
                "ランチを食べに",
                "ツーリングしに",
                "温泉入りに",
                "ゲームしに",
                "本を読みに",
                "コーヒーを飲みに",
                "ダンスをしに",
                "観光しに"
            ], for: .what)
        }
        whatPickerView.dataSource = self
        whatPickerView.delegate = self
        
        if dataStore.menuValues(for: .how).isEmpty {
            dataStore.update(menuValues: [
                "徒歩で行く",
                "電車で行く",
                "自転車で行く",
                "バイクで行く",
                "車で行く",
                "バスで行く",
                "タクシーで行く",
                "ヒッチハイクで行く",
                "飛行機で行く"
            ], for: .how)
        }
        howPickerView.dataSource = self
        howPickerView.delegate = self
    }
    //レイアウト用
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.whenPickerView.layer.cornerRadius = 10
        self.whoPickerView.layer.cornerRadius = 10
        self.wherePickerView.layer.cornerRadius = 10
        self.whatPickerView.layer.cornerRadius = 10
        self.howPickerView.layer.cornerRadius = 10
        self.startActionButton.layer.cornerRadius = 10
        self.startActionButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
    }
    
    @IBAction func startActionButton(_ sender: UIButton) {
        if countIsStop {
            timar = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        }else{
            timar?.invalidate()
        }
        sender.setTitle(countIsStop ? "ストップ":"スタート", for: .normal)
        countIsStop = !countIsStop
        
        if let soundURL = Bundle.main.url(forResource: "Button Sound Effect", withExtension: "mp3") {
            do {
                player1 = try AVAudioPlayer(contentsOf: soundURL)
                player1?.play() //効果音を鳴らす
            } catch {
                print("error")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 画面が表示されるたびにデータを再読み込みします。
        whenValues = dataStore.menuValues(for: .when)
        whenPickerView.reloadAllComponents()
        
        whoValues = dataStore.menuValues(for: .who)
        whoPickerView.reloadAllComponents()
        
        whereValues = dataStore.menuValues(for: .where)
        wherePickerView.reloadAllComponents()
        
        whatValues = dataStore.menuValues(for: .what)
        whatPickerView.reloadAllComponents()
        
        howValues = dataStore.menuValues(for: .how)
        howPickerView.reloadAllComponents()
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == whenPickerView {
            return 200
        } else if pickerView == whoPickerView {
            return 200
        } else if pickerView == wherePickerView {
            return 200
        } else if pickerView == whatPickerView {
            return 200
        } else if pickerView == howPickerView {
            return 200
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == whenPickerView {
            return whenValues[row % whenValues.count]
        } else if pickerView == whoPickerView {
            return whoValues[row % whoValues.count]
        } else if pickerView == wherePickerView {
            return whereValues[row % whereValues.count]
        } else if pickerView == whatPickerView {
            return whatValues[row % whatValues.count]
        } else if pickerView == howPickerView {
            return howValues[row % howValues.count]
        } else {
            return nil
        }
    }
    
    @objc func timerUpdate(){
        print("update",count)
        count += 1
        if count == 200 {
            count = 0
        }
        whenPickerView.selectRow(count, inComponent: 0, animated: true)
        whoPickerView.selectRow(count, inComponent: 0, animated: true)
        wherePickerView.selectRow(count, inComponent: 0, animated: true)
        whatPickerView.selectRow(count, inComponent: 0, animated: true)
        howPickerView.selectRow(count, inComponent: 0, animated: true)
    }
}
