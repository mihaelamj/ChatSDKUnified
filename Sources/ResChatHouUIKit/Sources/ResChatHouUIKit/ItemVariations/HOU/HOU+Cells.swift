//
//  HOU+Cells.swift
//
//
//  Created by Mihaela MJ on 15.09.2024..
//

import Foundation
import ResChatUIKit
import ResChatAppearance
import ResChatHouCommon

// MARK: Cells -

public class HOUChatBotMessageCell: ChatBotMessageCell {
    override public class var imageProvider: ImageProviding {
        return HOUImageProvider()
    }
    
    override public class var colorProvider: ColorProviding {
        return HOUColorProvider()
    }
}

public class HOUUserMessageCell: UserMessageCell {
    override public class var imageProvider: ImageProviding {
        return HOUImageProvider()
    }
    
    override public class var colorProvider: ColorProviding {
        return HOUColorProvider()
    }
}

public class HOULoadingCell: LoadingTableViewCell {
    override public class var imageProvider: ImageProviding {
        IAHImageProvider()
    }
    
    override public class var colorProvider: ColorProviding {
        IAHColorProvider()
    }
}
