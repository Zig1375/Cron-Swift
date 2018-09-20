import Dispatch

public struct CronJob {
    public let pattern: DatePattern
    let job: () -> Void
    let queue: DispatchQueue

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

        let interval = next.timeIntervalSinceNow
        DispatchQueue.global().asyncAfter(deadline: .now() + interval) { () -> () in
            self.job()
            self.start()
        }
    }
}