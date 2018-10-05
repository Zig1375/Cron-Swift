import Foundation
import Dispatch

public class CronJob {
    public static let TIMEZONE = TimeZone(identifier: "Europe/Moscow")!;
    public let pattern: DatePattern
    let job: () -> Void
    let queue: DispatchQueue
    private var nextTime: Int = 0;

    public init(pattern: String, hash: Int64 = 0, job: @escaping () -> Void) throws {
        self.pattern = try DatePattern(pattern, hash: hash)
        self.job = job
        self.queue = DispatchQueue.main

        start()
    }

    public init(pattern: DatePattern, hash: Int64 = 0, job: @escaping () -> Void) {
        self.pattern = pattern
        self.job = job
        self.queue = DispatchQueue.main

        start()
    }

    public func start() {
        guard let next = pattern.next()?.date else {
            print("No next execution date could be determined")
            return
        }

        self.nextTime = Int(next.timeIntervalSince1970);
        let interval = next.timeIntervalSinceNow
        DispatchQueue.global().asyncAfter(deadline: .now() + interval) { () -> () in
            if (self.nextTime <= Int(Date().timeIntervalSince1970)) {
                self.job()
            }

            self.start()
        }
    }
}