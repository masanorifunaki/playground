// GCD 非同期処理のための低レベルAPI Graund Central Dispatch
// タスクキューを追加するだけ、追加されたキューは適切なスレッドで実行される
// あらかじめ準備されたスレッドを使いまわす管理の手法をスレッドプールと言う

import Dispatch
import PlaygroundSupport
import Foundation

PlaygroundPage.current.needsIndefiniteExecution = true

let queue = DispatchQueue.main // メインディスパッチキューを取得
let globalQueue = DispatchQueue.global(qos: .userInitiated) // グローバルキューを取得

// メインキューはユーザーインターフェイスへの反映
// それ以外はグローバルキューを使う

let newQueue = DispatchQueue(
    label: "com.my_company.my_app.upload_queue", // デバック時に参照
    qos: .default,
    attributes: [.concurrent]
)

newQueue.async {
    print("非同期")
}

queue.async {
    print("非同期1")
    let queue = DispatchQueue.main
    queue.async {
        print("非同期2")
    }
}

// キャンセルや依存関係を実装する必要がある場合に使う
class SomeOperation: Operation {
    let number: Int
    init(number: Int) {
        self.number = number
    }

    override func main() {
        // 1秒待つ
        Thread.sleep(forTimeInterval: 1)

        guard !isCancelled else { return }

        print(number)
    }
}

let opQueue = OperationQueue()
opQueue.name = "com.example_my_op_q"
opQueue.maxConcurrentOperationCount = 2
opQueue.qualityOfService = .userInitiated

var operations = [SomeOperation]()

for i in 0..<10 {
    operations.append(SomeOperation(number: i))
    if i > 0 {
        operations[i].addDependency(operations[i-1])
    }
}

opQueue.addOperations(operations, waitUntilFinished: false)
//operations[6].cancel()
print("add")

// Thread クラス 手動でのスレッド管理
class SomeThread: Thread {
    override func main() {
        print("executed.")
    }
}

let thread = SomeThread()
thread.start()
