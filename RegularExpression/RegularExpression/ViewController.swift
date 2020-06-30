//
//  ViewController.swift
//  RegularExpression
//
//  Created by 方林威 on 2020/6/30.
//  Copyright © 2020 方林威. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        matches1()
    }
    
    private func matches1() {
        let string = "swift正则使用[em_01][em_02][em_03]"
        // 正则表达式
        let pattern = "\\[em_[0-9][0-9]\\]"
        guard let regular = try? NSRegularExpression(pattern: pattern,
                                                     options: .init(rawValue: 0)) else {
            return
        }
        let results = regular.matches(
            in: string,
            options: .init(rawValue: 0),
            range: NSRange(location: 0, length: string.count)
        )
        
        for result in results {
            print("\(result.range)")
            // NSRange转换Range
            if let range = Range(result.range, in: string) {
                print("matche: \(string[range])")
            }
        }
    }
    
    private func matches2() {
        let string = "swift正则使用[em_01][em_02][em_03]"
        let ranges = string.ranges(of: "\\[em_[0-9][0-9]\\]", options: .regularExpression)
        
        ranges.forEach {
            print(NSRange($0, in: string))  //这里打印NSRange的结果比Range清晰
            print("matche: \(string[$0])")
        }
    }
    
    private func matches3() {
        let string = "swift正则使用swift正则使用swift正则使用swift正则使用swift正则使用swift正则使用"
        let ranges = string.ranges(of: "swift", options: .caseInsensitive)
        
        ranges.forEach {
            print(NSRange($0, in: string))  //这里打印NSRange的结果比Range清晰
            print("matche: \(string[$0])")
        }
    }
}


extension String {
    
    func ranges<T: StringProtocol>(of string: T,
                options: CompareOptions = .regularExpression,
                locale: Locale = .current) -> [Range<String.Index>] {
        guard var searchedRange = range(of: self) else { return [] }
        
        var ranges: [Range<String.Index>] = []
        while let range = self.range(of: string, options: options, range: searchedRange, locale: locale) {
            ranges.append(range)
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
        }
        return ranges
    }
}
