//
//  ChatViewController+Scroll.swift
//
//
//  Created by Mihaela MJ on 10.09.2024..
//

import UIKit

extension ChatViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollThreshold: CGFloat = 100.0 // adjust as needed
        
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height

        // If there's not enough content to scroll, trigger bottom immediately (if applicable)
        if contentHeight <= scrollViewHeight {
            if !hasScrolledToBottom {
                scrollPositionSubject.send(.bottom)
                hasScrolledToBottom = true
            }
            return
        }

        // Detect when scrolled beyond top
        if contentOffsetY <= -scrollThreshold {
            if !hasScrolledToTop {
                scrollPositionSubject.send(.top)
                hasScrolledToTop = true
            }
        } else {
            // Reset flag when scrolled away from the top
            hasScrolledToTop = false
        }

        // Detect when scrolled to or beyond the bottom
        if contentHeight > 0 && contentOffsetY >= (contentHeight - scrollViewHeight - scrollThreshold) {
            if !hasScrolledToBottom {
                scrollPositionSubject.send(.bottom)
                hasScrolledToBottom = true
            }
        } else {
            // Reset flag when scrolled away from the bottom
            hasScrolledToBottom = false
        }
    }
}

internal extension ChatViewController {
    func handleScrolledToTop() { // History messages (older ones, but loaded as load more) are added at the top -
        print("Scrolled to top!")
        requestLoadMoreMessagesIfPossible()

    }
    
    func handleScrolledToBottom() {
        print("Scrolled to bottom!")
    }
}
