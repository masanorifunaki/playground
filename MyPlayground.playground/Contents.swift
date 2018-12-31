import UIKit

// オプショナル型 nil を許容
var a: Int?
var b: Int?

a = 1
b = 2

// ! オプショナル型だけど中身は nil ではない
var c = a! + b!

var age = 20
var str = "years"

// \()数字を文字列に変換
let old = "\(age)" + str

// 配列の宣言
var arry: [Int] = [1, 2, 3, 4, 5]
// 配列の要素の追加
arry.append(6)
// 配列の要素の削除
arry.remove(at: 0)

for a in arry {
    print(a)
}

// ディクショナリの宣言
var people: [String: Int] = ["Taro": 1992, "Hanako": 1986]
people["Taro"]
// 要素の追加
people["Jiro"] = 1999
// 要素の削除
people.removeValue(forKey: "Hanako")

// ファンクション
func add(c: Int, d: Int) -> Int {
    let totall = c + d
    print(totall)
    return totall
}

add(c: a!, d: b!)

// クラスとインスタンス
class Dog {
    // インスタンスプロパティ
    var name = ""
    var age = 0
    // イニシャライザ（初期設定）
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    // 型プロパティ。インスタンスを生成しなくともアクセスできる
    static var breed = ""
    // インスタンスメソッド
    func bark() {
        let message = name + ": Bow-wow!"
        print(message)
    }
    // 型メソッド
    static func barkStatic() {
        let message = "Bow-wow!"
        print(message)
    }
}

let pochi = Dog(name: "Pochi", age: 5)
pochi.name = "Pochi"
pochi.bark()

Dog.breed = "Akitaken"
Dog.barkStatic()

// クラスの継承
class Akitaken: Dog {
    var from = "Akita"
    func sayFrom() {
        print(from)
    }
}

let taro = Akitaken(name: "taro", age: 10)
taro.sayFrom()

// 構造体はインスタンス生成時にプロパティの設定もできる
struct Cat {
    var name = ""
    var breed = ""
}

let tama = Cat(name: "Tama", breed: "Russia")

// 列挙型、選択肢が複数ある場合に使う
//enum Signal {
//    case Blue
//    case Yellow
//    case Red
//}
//
//var sig: Signal
//sig = Signal.Blue
//sig = .Blue
//
//switch sig {
//case .Blue:
//    print("go")
//case .Yellow:
//    print("Caution")
//case .Red:
//    print("Stop")
//}

// 参照た渡し - インスタンスを参照すること
var ponta = Dog(name: "ponta", age: 10)
var hachi = ponta
hachi.age = 12
ponta.age
hachi.age

// 値渡し
var neko = Cat(name: "Neko", breed: "Osaka")
// mike は　neko と違うインスタンスになる
var mike = neko // neko をコピーしてインスタンスを生成
mike.breed = "Tokyo"

neko.breed
mike.breed

// クロージャー 関数を変数のように扱う
let getAgeMessage = {(name: String, age: Int) -> String in
    let messeage = name + ": I'm \(age) years old."
    return messeage
}

let result = getAgeMessage("Pochi", 5)
print(result)

func sayAge(name: String, age: Int, getMessage: (String, Int) -> String) {
    let message = getMessage(name, age)
    print(message)
}
sayAge(name: "Hatch", age: 12, getMessage: getAgeMessage)

// クラスや構造体に制約を持たす
protocol Fish {
    // プロパティ、値の取得と設定ができる記述
    var color: String {get set}
    func swim()
}
// プロトコルを導入することで、クラスを継承しなくとも、特定のプロパティ
// メソッドが実装されていることが保証される
// 外部のオブジェクトから利用しやすくなる
class Shark: Fish {
    var color: String = "Blue"
    func swim() {
        print("Hi")
    }
}

// デリゲート - いオブジェクト間の連携をスムーズにする
// クラスや構造体ではなくとも、メソッドの記述ができる
// class weak で循環参照（複数のオブジェクトが参照しあい、メモリを開放しないこと）を防ぐ。
protocol SardineDelegate: class {
    func didEatSardine()
}

class Sardine {
    // Sardineのインスタンスから、Saknaのインスタンスを参照されなくなる
    weak var delegate: SardineDelegate?
    // 2
    func eaten() {
        print("I was eaten ...")
        // delegate が nil ではないときに実行する
        // Skana クラスのdidEatSardineを実行
        // 3
        delegate?.didEatSardine()
    }
}

class Sakana: SardineDelegate {
    func eat() {
        let serdine = Sardine()
        // self Sakana がインスタンス化されたもの
        // Serdine のプロパティに Sakana のインスタンスを設定することができる
        serdine.delegate = self
        // Sardineのetatenメソッドが実行
        // 1
        serdine.eaten()
    }
    // 4
    func didEatSardine() {
        print("Eaten !")
    }
}

let s = Sakana()
s.eat()


enum MyError: Error {
    case InvalidValue
}

func doubleUp(value: Int) throws -> Int {
    if value < 0 {
        throw MyError.InvalidValue
    }
    return value * 2
}

//doubleUp(value: -1)

// key と value を for文で両方使いたいときに使う
for (index, value) in arry.enumerated() {
    print("\(index): \(value)")
}

