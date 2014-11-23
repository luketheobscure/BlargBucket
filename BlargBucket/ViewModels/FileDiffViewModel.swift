//
//  FileDiffViewModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 10/12/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

struct Line {
	var prevNumber: String = ""
	var newNumber: String = ""
	var text: String = ""
	var backgroundColor: UIColor = UIColor.whiteColor()
}

class FileDiffViewModel: NSObject {
	var lines: [Line] = []
	var title: String?

	init(diff:String) {
		super.init()

		let tempLines: [String] = diff.componentsSeparatedByString("\n")
		title = findTitle(tempLines)
		lines = parseLines(tempLines)
	}

	func findTitle(tempLines:[String]) -> String? {
		// TODO: Figure out if file moved
		if tempLines.count <= 1 {
			return nil
		}
		let firstLineParts = tempLines[0].componentsSeparatedByString(" ")

		// tempLines[2] will be something like '--- a/file/derp'. We don't want the '--- a/'
		return tempLines[2].substringFromIndex(advance(tempLines[2].startIndex, 6))
	}

	func parseLines(tempLines:[String]) -> [Line] {
		var processedLines:[Line] = []

		var beginProcess: Bool = false
		var prevLine = 0
		var newLine = 0
		for line in tempLines {
			if NSRegularExpression.rx("^@@").isMatch(line) {
				var splitLine = line.componentsSeparatedByString(" ")

				var prevLineRange = splitLine[1] as String // Gives us something like "+66,77"
				var tempPrevLine = prevLineRange.componentsSeparatedByString(",")[0] // Something like "+66"
				prevLine = dropFirst(tempPrevLine).toInt()!

				var nextLineRange = splitLine[2] as String // Gives us something like "+66,77"
				var tempNextLine = nextLineRange.componentsSeparatedByString(",")[0] // Something like "+66"
				newLine = dropFirst(tempNextLine).toInt()!
			}

			if !beginProcess && NSRegularExpression.rx("^@@").isMatch(line) {
				beginProcess = true
				continue
			}
			if !beginProcess {
				continue
			}
			if !NSRegularExpression.rx("^@@").isMatch(line){
				if countElements(line) == 0 {
					processedLines.append(
						Line(prevNumber: String(prevLine++), newNumber: String(newLine++), text: "", backgroundColor: UIColor.whiteColor())
					)
					continue
				}
				var backgroundColor: UIColor = UIColor.whiteColor()
				var cellPrevLine = ""
				var cellNewLine = ""
				let firstCharacter = Array(line)[0]
				switch firstCharacter {
					case "+":
						backgroundColor = UIColor(red: 221/255, green: 1, blue: 221/255, alpha: 1)
						cellNewLine = String(newLine++)
					case "-":
						backgroundColor = UIColor(red: 254/255, green: 232/255, blue: 233/255, alpha: 1)
						cellPrevLine = String(prevLine++)
					default:
						cellNewLine = String(newLine++)
						cellPrevLine = String(prevLine++)
				}
				processedLines.append(
					Line(prevNumber: cellPrevLine, newNumber:cellNewLine, text: line, backgroundColor: backgroundColor)
				)
			}
		}

		return processedLines
	}
   
}
