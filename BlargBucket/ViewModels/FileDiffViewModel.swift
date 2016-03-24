//
//  FileDiffViewModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 10/12/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

/// Represents a single line in a diff
struct Line {
	var prevNumber: String = ""
	var newNumber: String = ""
	var text: String = ""
	var backgroundColor: UIColor = UIColor.whiteColor()
}

/// The diff for a single file
class FileDiffViewModel: NSObject {

	/// An array of `Line`s
	var lines: [Line] = []

	/// The name of the file
	var title: String?

	/**
		Designated initializer
		
		- parameter diff: A diff string to get parsed
	*/
	init(diff:String) {
		super.init()

		let tempLines: [String] = diff.componentsSeparatedByString("\n")
		title = findTitle(tempLines)
		lines = parseLines(tempLines)
	}

	/// Finds the title
	func findTitle(tempLines:[String]) -> String? {
		// TODO: Figure out if file moved
		if tempLines.count <= 1 {
			return nil
		}
//		let firstLineParts = tempLines[0].componentsSeparatedByString(" ")

		// tempLines[2] will be something like '--- a/file/derp'. We don't want the '--- a/'
		return tempLines[2].substringFromIndex(tempLines[2].startIndex.advancedBy(6))
	}

	/**
		Turns a string into an array of `Line`s
		
		- parameter tempLines: An array of strings to get parsed
	*/
	func parseLines(tempLines:[String]) -> [Line] {
		var processedLines:[Line] = []

		var beginProcess: Bool = false
		var prevLine = 0
		var newLine = 0
		for line in tempLines {
			if NSRegularExpression.rx("^@@").isMatch(line) {
				var splitLine = line.componentsSeparatedByString(" ")

				let prevLineRange = splitLine[1] as String // Gives us something like "+66,77"
				let tempPrevLine = prevLineRange.componentsSeparatedByString(",")[0] // Something like "+66"
				prevLine = Int(String(tempPrevLine.characters.dropFirst()))!

				let nextLineRange = splitLine[2] as String // Gives us something like "+66,77"
				let tempNextLine = nextLineRange.componentsSeparatedByString(",")[0] // Something like "+66"
				newLine = Int(String(tempNextLine.characters.dropFirst()))!
			}

			if !beginProcess && NSRegularExpression.rx("^@@").isMatch(line) {
				beginProcess = true
				continue
			}
			if !beginProcess {
				continue
			}
			if !NSRegularExpression.rx("^@@").isMatch(line){
				if line.characters.count == 0 {
					processedLines.append(
						Line(prevNumber: String(prevLine), newNumber: String(newLine), text: "", backgroundColor: UIColor.whiteColor())
					)
                    prevLine += 1
                    newLine += 1
					continue
				}
				var backgroundColor: UIColor = UIColor.whiteColor()
				var cellPrevLine = ""
				var cellNewLine = ""
				let firstCharacter = Array(line.characters)[0]
				switch firstCharacter {
					case "+":
						backgroundColor = UIColor(red: 221/255, green: 1, blue: 221/255, alpha: 1)
						cellNewLine = String(newLine)
                        newLine += 1
					case "-":
						backgroundColor = UIColor(red: 254/255, green: 232/255, blue: 233/255, alpha: 1)
						cellPrevLine = String(prevLine)
                    prevLine += 1
					default:
						cellNewLine = String(newLine)
						cellPrevLine = String(prevLine)
                    newLine += 1
                    prevLine += 1
				}
				processedLines.append(
					Line(prevNumber: cellPrevLine, newNumber:cellNewLine, text: line, backgroundColor: backgroundColor)
				)
			}
		}

		return processedLines
	}
   
}
