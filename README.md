# RegularExpression
## [Swift中的正则使用](https://www.jianshu.com/p/a6aa0b9bbd49)

我们以前使用正则通常是用`Foundation`中`NSRegularExpression`这个类
例如:
字符串`swift正则使用[em_01][em_02][em_03]`里搜索出`[em_01]`,`[em_02]`,`[em_03]`的位置然后替换成表情

#### 我们先用`NSRegularExpression`实现
```swift
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
            print("range: \(result.range)")
            // NSRange转换Range
            if let range = Range(result.range, in: string) {
                print("matche: \(string[range])")
            }
        }
    }
```
print:
```swift
{9, 7}
matche: [em_01]
{16, 7}
matche: [em_02]
{23, 7}
matche: [em_03]
```
#### 现在用标准库方案

```swift
let string = "swift正则使用[em_01][em_02][em_03]"
let range = string.range(of: "\\[em_[0-9][0-9]\\]", options: .regularExpression, locale: .current)
```
会得到第一个符合正则的结果, 也就是`[em_01]`的位置`{9, 7}`

我们对字符串扩展一下, 实现出一个查出所有符合正则的位置:
```swift
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
```
再去试试之前的正则查找
```swift
    private func matches2() {
        let string = "swift正则使用[em_01][em_02][em_03]"
        let ranges = string.ranges(of: "\\[em_[0-9][0-9]\\]", options: .regularExpression)
        
        ranges.forEach {
            print(NSRange($0, in: string))  //这里打印NSRange的结果比Range清晰
            print("matche: \(string[$0])")
        }
    }
```
print:
```swift
{9, 7}
matche: [em_01]
{16, 7}
matche: [em_02]
{23, 7}
matche: [em_03]
```
#### 其实还可以搜索指定字符串
```swift
    private func matches3() {
        let string = "swift正则使用swift正则使用swift正则使用swift正则使用swift正则使用swift正则使用"
        let ranges = string.ranges(of: "swift", options: .caseInsensitive)
        
        ranges.forEach {
            print("range: \(NSRange($0, in: string))")  //这里打印NSRange的结果比Range清晰
            print("matche: \(string[$0])")
        }
    }
```
print:
```swift
{0, 5}
matche: swift
{9, 5}
matche: swift
{18, 5}
matche: swift
{27, 5}
matche: swift
{36, 5}
matche: swift
{45, 5}
matche: swift
```
### 总结
搜索字符串的姿势变动简单了很多.

> 如果你有更好的想法 欢迎issues 交流.
