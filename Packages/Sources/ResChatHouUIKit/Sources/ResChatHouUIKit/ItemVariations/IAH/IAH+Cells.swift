//
//  File.swift
//  
//
//  Created by Mihaela MJ on 15.09.2024..
//

import Foundation
import UIKit
import ResChatUIKit
import ResChatAppearance
import ResChatHouCommon

// MARK: Cells -

public class IAHChatBotMessageCell: ChatBotMessageCell {
    override public class var imageProvider: ImageProviding {
        IAHImageProvider()
    }
    
    override public class var colorProvider: ColorProviding {
        IAHColorProvider()
    }
}

public class IAHUserMessageCell: UserMessageCell {
    override public class var imageProvider: ImageProviding {
        IAHImageProvider()
    }
    
    override public class var colorProvider: ColorProviding {
        IAHColorProvider()
    }
}

public class IAHLoadingCell: LoadingTableViewCell {
    override public class var imageProvider: ImageProviding {
        IAHImageProvider()
    }
    
    override public class var colorProvider: ColorProviding {
        IAHColorProvider()
    }
}
