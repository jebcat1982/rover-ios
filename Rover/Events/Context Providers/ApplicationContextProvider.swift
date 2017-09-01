//
//  ApplicationContextProvider.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct ApplicationContextProvider {
    let bundle: BundleProtocol
}

extension ApplicationContextProvider: ContextProvider {
    
    var pushEnvironment: String? {
        guard let path = bundle.path(forResource: "embedded", ofType: "mobileprovision") else {
            logger.warn("Could not detect push environment: Provisioning profile not found")
            return nil
        }
        
        guard let embeddedProfile = try? String(contentsOfFile: path, encoding: String.Encoding.ascii) else {
            logger.warn("Could not detect push environment: Failed to read provisioning profile at \(path)")
            return nil
        }
        
        let scanner = Scanner(string: embeddedProfile)
        var string: NSString?
        
        guard scanner.scanUpTo("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", into: nil), scanner.scanUpTo("</plist>", into: &string) else {
            logger.warn("Could not detect push environment: Unrecognized provisioning profile structure")
            return nil
        }
        
        guard let data = string?.appending("</plist>").data(using: String.Encoding.utf8) else {
            logger.warn("Could not detect push environment: Failed to decode provisioning profile")
            return nil
        }
        
        guard let plist = (try? PropertyListSerialization.propertyList(from: data, options: [], format: nil)) as? [String: Any] else {
            logger.warn("Could not detect push environment: Failed to serialize provisioning profile")
            return nil
        }
        
        if let entitlements = plist["Entitlements"] as? [String: Any] {
            return entitlements["aps-environment"] as? String
        }
        
        return nil
    }
    
    func captureContext(_ context: Context) -> Context {
        var info = [String: Any]()
        
        if let infoDictionary = bundle.infoDictionary {
            for (key, value) in infoDictionary {
                info[key] = value
            }
        } else {
            logger.warn("Failed to load infoDictionary from bundle")
        }
        
        if let localizedInfoDictionary = bundle.localizedInfoDictionary {
            for (key, value) in localizedInfoDictionary {
                info[key] = value
            }
        }
        
        var nextContext = context
            
        if let displayName = info["CFBundleDisplayName"] as? String {
            logger.debug("Setting appName to: \(displayName)")
            nextContext.appName = displayName
        } else if let bundleName = info["CFBundleName"] as? String {
            logger.debug("Setting appName to: \(bundleName)")
            nextContext.appName = bundleName
        } else {
            logger.warn("Failed to capture app name")
            nextContext.appName = nil
        }
        
        if let shortVersion = info["CFBundleShortVersionString"] as? String {
            logger.debug("Setting appVersion to: \(shortVersion)")
            nextContext.appVersion = shortVersion
        } else {
            logger.warn("Failed to capture appVersion")
            nextContext.appVersion = nil
        }
        
        if let bundleVersion = info["CFBundleVersion"] as? String {
            logger.debug("Setting appBuild to: \(bundleVersion)")
            nextContext.appBuild = bundleVersion
        } else {
            logger.warn("Failed to capture appBuild")
            nextContext.appBuild = nil
        }
        
        if let bundleIdentifier = bundle.bundleIdentifier {
            logger.debug("Setting appNamespace to: \(bundleIdentifier)")
            nextContext.appNamespace = bundleIdentifier
        } else {
            logger.warn("Failed to capture appNamespace")
            nextContext.appNamespace = nil
        }
        
        if let pushEnvironment = self.pushEnvironment {
            logger.debug("Setting pushEnvironment to: \(pushEnvironment)")
            nextContext.pushEnvironment = pushEnvironment
        } else {
            logger.warn("Failed to determine pushEnvironment – this is expected behaviour if you are running a simulator")
        }
        
        return nextContext
    }
}
