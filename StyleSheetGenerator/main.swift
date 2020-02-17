//
//  main.swift
//  StyleSheetGenerator
//
//  Created by Jason Kim on 28/09/2016.
//  Copyright © 2016 Jason Kim. All rights reserved.
//

import Foundation

/*
 RUN THE SCRIPT WITH THE FOLLOWING:
 xcrun swift main.swift styleSheet.json StyleSheet.swift
 */

// MARK: - Helper functions

extension String {
    
    var lowercasedFirstLetter: String {
        let first = String(characters.prefix(1)).lowercased()
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func lowercaseFirstLetter() {
        self = self.lowercasedFirstLetter
    }
}

// MARK: - Error structure

struct ErrorMessage: Error {
    let message: String
}

// MARK: - Colour structure

struct Colour {
    let name: String
    let rgb: [Double]
    
    init(name: String, rgb: [Double]) {
        self.name = name
        self.rgb = rgb
    }
}

// MARK: - TextStyle structure

struct TextStyle {
    
    let name: String
    let fontName: String
    let size: Double
    let colour: Colour
    
    init(name: String, content: AnyObject, colours: [Colour]) throws {
        let error = ErrorMessage(message: "The style '\(name)' is not formatted properly")
        
        guard let dict = content as? [String: AnyObject] else { throw error }
        guard let fontName = dict["font"] as? String else { throw error }
        guard let size = dict["size"] as? Double else { throw error }
        guard let colourName = dict["colour"] as? String else { throw error }
        
        self.name = name
        self.fontName = fontName
        self.size = size
        
        // Find the color
        let colour: Colour? = {
            for colour in colours {
                if colour.name == colourName { return colour }
            }
            return nil
        }()
        
        let colourError = ErrorMessage(message: "Couldn't find the color '\(colourName)' for style '\(name)'")
        guard let validColour = colour else { throw colourError }
        self.colour = validColour
    }
}

// MARK: - Parse JSON and build objects arrays

func parseJSONData(_ data: Data) throws -> (colours: [Colour], textStyles: [TextStyle]) {
    guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
        throw ErrorMessage(message: "Couldn't parse JSON file")
    }
    
    var coloursArray: [Colour] = []
    var textStylesArray: [TextStyle] = []
    
    // Parse colours
    print("\n\tCOLOURS:\n")
    if let colours = json["colours"] as? [String: [Double]] {
        for (name, rgb) in colours {
            let colour = Colour(name: name, rgb: rgb)
            print("\t🎨  \(colour.name)")
            coloursArray.append(colour)
        }
    } else { throw ErrorMessage(message: "Couldn't parse colours") }
    guard coloursArray.count > 0 else { throw ErrorMessage(message: "Colours array is empty") }
    
    // Parse styles
    print("\n\tTEXT STYLES:\n")
    if let textStyles = json["textStyles"] as? [String: AnyObject] {
        for (name, content) in textStyles {
            let textStyle = try TextStyle(name: name, content: content, colours: coloursArray)
            print("\t🖌  \u{001B}[0;30m\(textStyle.name)\n\t\u{001B}[0;33m\"\(textStyle.fontName)\" \(textStyle.size) \u{001B}[0;30m🎨  \(textStyle.colour.name)\n")
            textStylesArray.append(textStyle)
        }
        print("\u{001B}[0;30m")
    } else { throw ErrorMessage(message: "\u{001B}[0;30mCouldn't parse text styles") }
    return (coloursArray, textStylesArray)
}

// MARK: - Write objects into a Swift file

func buildFileContent(withColours colours: [Colour], andTextStyles textStyles: [TextStyle]) -> String {
    
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    let stringDate = dateFormatter.string(from: Date())
    
    // File header
    
    var contentString: String = "//\n//  StyleSheet.swift\n//\n//  Generated by StyleSheetParser on \(stringDate).\n//  Copyright © 2016 Jason Kim. All rights reserved.\n//\n"
    contentString += "\nimport UIKit\n"
    
    // CommonColor enum
    
    contentString += "\n// MARK: - CommonColor enum\n"
    contentString += "\npublic enum CommonColor {\n\n"
    for colour in colours {
        contentString += "\tcase \(colour.name.lowercasedFirstLetter)\n"
    }
    contentString += "\n\tvar rgba: [CGFloat] {\n"
    contentString += "\t\tswitch self {\n"
    for colour in colours {
        contentString += "\t\tcase .\(colour.name.lowercasedFirstLetter): return ["
        contentString += "\(colour.rgb[0]) / 255.0, \(colour.rgb[1]) / 255.0, \(colour.rgb[2]) / 255.0,"
        contentString += " 1.0]\n"
    }
    contentString += "\t\t}\n"
    contentString += "\t}\n"
    contentString += "\n\tvar r: CGFloat { return self.rgba[0] }\n"
    contentString += "\tvar g: CGFloat { return self.rgba[1] }\n"
    contentString += "\tvar b: CGFloat { return self.rgba[2] }\n"
    contentString += "\tvar a: CGFloat { return self.rgba[3] }\n"
    contentString += "\n}\n"
    
    // UIColor extension
    
    contentString += "\n// MARK: - UIColor extension\n"
    contentString += "\nextension UIColor {\n"
    contentString += "\n\tconvenience init(commonColor: CommonColor) {\n"
    contentString += "\t\tself.init(red: commonColor.r, green: commonColor.g, blue: commonColor.b, alpha: commonColor.a)\n"
    contentString += "\t}\n"
    contentString += "}\n"
    
    // TextStyle enum
    
    contentString += "\n// MARK: - TextStyle enum\n"
    contentString += "\npublic enum TextStyle {\n\n"
    for textStyle in textStyles {
        contentString += "\tcase \(textStyle.name.lowercasedFirstLetter)\n"
    }
    contentString += "\n\tpublic var font: UIFont {\n"
    contentString += "\n\t\tswitch self {\n"
    for textStyle in textStyles {
        contentString += "\t\tcase .\(textStyle.name.lowercasedFirstLetter): return UIFont(name: \"\(textStyle.fontName)\", size: \(textStyle.size))!\n"
    }
    contentString += "\t\t}\n"
    contentString += "\t}\n"
    contentString += "\n\tpublic var color: UIColor {\n"
    contentString += "\n\t\tswitch self {\n"
    for textStyle in textStyles {
        contentString += "\t\tcase .\(textStyle.name.lowercasedFirstLetter): return UIColor(commonColor: .\(textStyle.colour.name.lowercasedFirstLetter))\n"
    }
    contentString += "\t\t}\n"
    contentString += "\t}\n"
    contentString += "}\n"
    
    return contentString
}

// MARK: - Main

let arguments = ProcessInfo.processInfo.arguments
if arguments.count > 1 {
    
    let filename = arguments[arguments.count - 2]
    
    let currentDirectory = FileManager.default.currentDirectoryPath
    let filePath = currentDirectory.appending("/\(filename)")
    let destinationPath: String = {
        var destinationFilename: String = "StyleSheet.swift"
        if arguments.count > 2 { destinationFilename = arguments.last! }
        return currentDirectory.appending("/\(destinationFilename)")
    }()
    let destinationURL: URL = URL(fileURLWithPath: destinationPath)
    
    let fileUrl = URL(fileURLWithPath: filePath)
    do {
        print(fileUrl)
        let data = try Data(contentsOf: fileUrl)
        do {
            print("\nParsing file at:\n\(filePath)")
            let objectsTuple = try parseJSONData(data)
            let content = buildFileContent(withColours: objectsTuple.colours, andTextStyles: objectsTuple.textStyles)
            print("\nWriting file at:\n\(destinationPath)\n")
            try content.write(to: destinationURL, atomically: true, encoding: .utf8)
        }
        catch let error as ErrorMessage {
            print("An error occured:\n\(error.message)\n")
        } catch {
            print("An error occured:\n\(filePath)Error:\n\(error)\n")
        }
    } catch {
        print("\nCouldn't read contents of '\(filename)'\n")
    }
} else {
    print("\nPlease select a JSON file to parse\n")
}

