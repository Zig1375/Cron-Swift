//
//  CronJob.swift
//  Cronexpr
//
//  Created by Safx Developer on 2015/12/06.
//  Copyright © 2015年 Safx Developers. All rights reserved.
//

#if os(OSX)
import Darwin
#elseif os(Linux)
import Glibc
#endif

public struct CronJob {
    public let pattern: DatePattern
    let job: () -> Void

    public init(pattern: String, hash: Int64 = 0, job: @escaping () -> Void) throws {
        self.pattern = try DatePattern(pattern, hash: hash)
        self.job = job

        print(pattern)
        start()
    }


    public func start() {
        guard let _ = pattern.next()?.date else {
            print("No next execution date could be determined")
            return
        }

        zThread() {
            while let next = self.pattern.next()?.date {
                let interval = UInt32(next.timeIntervalSinceNow)
                print(interval)
                sleep(interval);
                self.job()
            };
        }.start();
    }
}
