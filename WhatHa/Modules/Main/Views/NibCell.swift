
//
//  NibCell.Swift
//  WhatHa
//
//  Created by kim jason on 07/01/2019.
//  Copyright © 2019 rootone - danielKim. All rights reserved.
//

import UIKit

final class NibCell: UICollectionViewCell {
    static let nibName = "NibCell"
    @IBOutlet private var textLabel: UILabel!
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
}
