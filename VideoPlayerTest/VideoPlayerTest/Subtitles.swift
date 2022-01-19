//
//  Subtitles.swift
//  VideoPlayerTest
//
//  Created by thoonk on 2022/01/19.
//

import Foundation

class Subtitles {
    var lines = [Line]()

    struct Line: CustomStringConvertible {
        var index: Int
        var start: TimeInterval
        var end: TimeInterval
        var text: String

        init(
            _ index: Int,
            _ start: String,
            _ end: String,
            _ text: String
        ) {
            self.index = index
            self.start = Line.parse(from: start)
            self.end = Line.parse(from: end)
            self.text = text
        }

        static func parse(from duration: String) -> TimeInterval {
            let splitted = duration.split(separator: ":")
            let hour: TimeInterval = Double(splitted[0]) ?? 0
            let min: TimeInterval = Double(splitted[1]) ?? 0
            let splittedSec = splitted[2].split(separator: ",")
            let sec: TimeInterval = Double(splittedSec[0]) ?? 0
            let msec: TimeInterval = Double(splittedSec[1]) ?? 0

            return (hour * 3600) + (min * 60) + sec + (msec / 1000)
        }

        var description: String {
            return "Subtitle Line \nindex: \(index), \nstart: \(start)\nend: \(end)\ntext: \(text)"
        }
    }
    // _ url: URL,
    init(encoding: String.Encoding = String.Encoding.utf8) {
//        do {
//            let string = try String(contentsOf: url, encoding: encoding)
            guard let path = Bundle.main.path(forResource: "bigbuckbunny_subtitles", ofType: "srt") else { return }
            
            guard let string = try? String(contentsOfFile: path) else { return }
             self.lines = Subtitles.parseSubRip(string)
//        } catch {
//            debugPrint("자막 로드 실패: \(url.absoluteString),\n\(error.localizedDescription)")
//        }
    }
    
    func search(for time: TimeInterval) -> Line? {
        let result = lines.first(where: { line -> Bool in
            line.start <= time && line.end >= time ? true : false
        })
        return result
    }

    fileprivate static func parseSubRip(_ payload: String) -> [Line] {
        var result = [Line]()
        let scanner = Scanner(string: payload)
        while !scanner.isAtEnd {
            let indexString = scanner.scanUpToCharacters(from: .newlines)
            let startString = scanner.scanUpToString(" --> ")
            let endString = scanner.scanUpToCharacters(from: .newlines)
            var textString = scanner.scanUpToString("\n\n") // \r\n\r\n

            if let text = textString {
                textString = text.trimmingCharacters(in: .whitespaces) as String
                textString = text.replacingOccurrences(of: "\n", with: "") as String // \r
            }

            if let indexString = indexString,
               let index = Int(indexString as String),
               let start = startString,
               let end = endString,
               let text = textString {
                let line = Line(index, start, end, text)
                result.append(line)
            }
        }
        
        return result
    }
}
