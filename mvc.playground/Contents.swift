import UIKit
import Foundation

// 更新を複数のオブジェクトに通知する
final class Model {
  let notificationCenter = NotificationCenter()

  private(set) var count = 0 {
    // プロパティの変更後に実行する文
    didSet {
      notificationCenter.post(name: .init(rawValue: "count"), object: nil, userInfo: ["count": count])
    }
  }
  func countDown() { count -= 1 }
  func countUp() { count += 1 }
}

class Controller {
  weak var myModel: Model?
  // View が作成する Controller の型を外か ら指定できるようにするため
  required init() {}
  // View で定義する UIButton のタップ イベントを addTarget(_:action:for:) によって直接受け取るため
  @objc func onMinusTapped() { myModel?.countDown() }
  @objc func onPlusTapped() { myModel?.countUp() }
}

//final class View: UIView {
//  private let label: UILabel
//  private let minusButton: UIButton
//  private let plusButton: UIButton
//
//  var defaultControllerClass: Controller.Type = Controller.self
//  private var myCountoller: Controller?
//
//  var myModel: Model? {
//    didSet {
//      // Controller生成と、Modelの監視を開始する
//      registerModel()
//    }
//  }
//
//  deinit {
//    myModel?.notificationCenter.removeObserver(self)
//  }
//
//  override init(frame: CGRect) {
//    // ... 画面のレイアウト設定 ...
//  }
//
//  private func registerModel() {
//    guard let model = myModel else { return }
//
//    let controller = defaultControllerClass.init()
//    controller.myModel = model
//    myCountoller = controller
//
//    label.text = model.count.description
//    minusButton.addTarget(controller, action: #selector(Controller.onMinusTapped), for: .touchUpInside)
//    model.notificationCenter.addObserver(forName: .init(rawValue: "count"), object: nil, queue: nil, using:
//      { [unowned self] notification in
//        if let count = notification.userInfo?["count"] as? Int {
//          self.label.text = count.description
//    } })
// }
//}

// Cocoa MVC の View は原初 MVC と違い、Model のこと を一切知りません。そのため原初 MVC に比べると再利用性がとても高く、同じような画面構 成の View をさまざまな場面に流用できます。

final class View: UIView {
  let label: UILabel
  let minusButton: UIButton
  let plusButton: UIButton

  override init(frame: CGRect) {
    // ... 画面のレイアウト設定 ...
  }
}

final class ViewController: UIViewController {
  var myModel: Model? {
    didSet {
      // ViewとModelとを結合し、Modelの監視を開始する
      registerModel()
    }
  }
  private(set) lazy var myView: View = View()
  override func loadView() {
    view = myView
  }
  deinit {
    myModel?.notificationCenter.removeObserver(self)
  }
  private func registerModel() {
    guard let model = myModel else { return }
    myView.label.text = model.count.description
    // 3
    myView.minusButton.addTarget(self,
                                 action: #selector(onMinusTapped),
                                 for: .touchUpInside)
    myView.plusButton.addTarget(self,
                                action: #selector(onPlusTapped),
                                for: .touchUpInside)
    // 2
    model.notificationCenter
      .addObserver(forName: .init(rawValue: "count"),
                   object: nil,
                   queue: nil,
                   using:
        { [unowned self] notification in
      }) }
  if let count = notification.userInfo?["count"] as? Int {
    self.myView.label.text = "\(count)"
  }
  // 1
  @objc func onMinusTapped() { myModel?.countDown() }
  @objc func onPlusTapped() { myModel?.countUp() }
}

// オブザーバーパターン 状態変化の別オブジェクトへの通知
// 1対多のイベント通知を可能にする
// NotificationCenterクラスはサブジェクトであり、中央に位置するハブ
// オブザーバはNotificationCenterクラスに登録され、登録の際に、通知を受け取るイベント、利用するメソッドを指定する
// 1 通知を受け取るオブジェクトに Notification型の値を引数に持つメソッドを実装する
// 2 NotificationCenterクラスに通知を受け取るいオブジェクトを登録する
// 3 NotificationCenterクラスに通知を投稿する

class Poster {
  static let notificationName = Notification.Name("SomeNotification")

  func post() {
    NotificationCenter.default.post(
      name: Poster.notificationName, object: nil)
  }
}

class Observer {

  init() {
    // 2 NotificationCenterクラスに通知を受け取るいオブジェクトを登録する、通知を受け取るオブジェクト、通知を受け取るメソッド、受け取りたい通知の名前
    // "SomeNotification" という名前の通知をhandleNotification(_:)で受け取るように登録
    // Slector型 メソッドを参照するための型、メソッドをそれが属する型をは切り離して扱うことができる。
    NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Poster.notificationName, object: nil)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // 1 通知を受け取るオブジェクトに Notification型の値を引数に持つメソッドを実装する
  // セレクタはObjective-Cの概念であるため、Slector型を生成するにはメソッドがObjective-Cから参照可能である必要がある
  @objc func handleNotification(_ notification: Notification) {
    print("通知を受け取りました")
  }

}

var observer = Observer()
let poster = Poster()
poster.post()
