//
//  TabmanBarConfig.swift
//  Tabman
//
//  Created by Merrick Sapsford on 24/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import Foundation

/// Update handler protocol for TabmanBarConfig updates.
internal protocol TabmanBarConfigDelegate {
    
    /// The config had its style updated.
    ///
    /// - Parameters:
    ///   - config: The config.
    ///   - style: The new style.
    func config(_ config: TabmanBarConfig, didUpdateStyle style: TabmanBarConfig.Style)
    
    /// The config had its location updated.
    ///
    /// - Parameters:
    ///   - config: The config.
    ///   - location: The new location.
    func config(_ config: TabmanBarConfig, didUpdateLocation location: TabmanBarConfig.Location)
    
    /// The config had its items updated.
    ///
    /// - Parameters:
    ///   - config: The config.
    ///   - items: The new items.
    func config(_ config: TabmanBarConfig, didUpdateItems items: [TabmanBarItem]?)
    
    /// The config had its appearance config updated.
    ///
    /// - Parameters:
    ///   - config: The config.
    ///   - appearance: The new appearance config.
    func config(_ config: TabmanBarConfig, didUpdateAppearance appearance: TabmanBar.AppearanceConfig)
}

/// Configuration object for adjusting appearance and contents of a TabmanBar.
public class TabmanBarConfig: Any {
    
    //
    // MARK: Types
    //
    
    /// The style of the bar.
    ///
    /// - buttonBar: A scrolling horizontal bar with text buttons for each page index.
    /// - progressiveBar: A horizontal progress bar that increments toward completion with each page transition.
    public enum Style {
        case buttonBar
        case progressiveBar
    }
    
    /// The location of the bar on screen.
    ///
    /// - perferred: Use the preferred location for the current style.
    /// - top: At the top. (Note: this will take account of UINavigationBar etc.)
    /// - bottom: At the bottom. (Note: this will take account of UITabBar etc.)
    public enum Location {
        case preferred
        case top
        case bottom
    }

    //
    // MARK: Properties
    //
    
    internal var delegate: TabmanBarConfigDelegate?
    
    
    /// The style to use for the bar. Default = .buttonBar
    public var style: Style = .buttonBar {
        didSet {
            guard style != oldValue else { return }
            
            self.delegate?.config(self, didUpdateStyle: style)
        }
    }
    
    /// The location of the bar on screen. Default = .preferred
    public var location: Location = .preferred {
        didSet {
            guard location != oldValue else {
                return
            }
            self.delegate?.config(self, didUpdateLocation: location)
        }
    }
    
    /// The items to display in the bar.
    public var items: [TabmanBarItem]? {
        didSet {
            self.delegate?.config(self, didUpdateItems: items)
        }
    }
    
    /// The appearance configuration of the bar.
    public var appearance: TabmanBar.AppearanceConfig? {
        didSet {
            self.delegate?.config(self, didUpdateAppearance: appearance ?? .defaultAppearance)
        }
    }
}

// MARK: - Additional Style properties for internal use
internal extension TabmanBarConfig.Style {
    
    /// Where the bar is preferred to be displayed for the style.
    var preferredLocation: TabmanBarConfig.Location {
        switch self {
            
        case .progressiveBar:
            return .bottom
            
        default:
            return .top
        }
    }
}