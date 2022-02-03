//
//  Onboarding.swift
//  MyLibrary
//
//  Created by Birkyboy on 13/01/2022.
//

import UIKit

struct Onboarding {
    let image: UIImage
    let title: String
    let subtitle: String
}

extension Onboarding {
    static let pages: [Onboarding] = [Onboarding(image: Images.Onboarding.referencing,
                                                 title: Text.Onboarding.referenceBookTitle,
                                                 subtitle: Text.Onboarding.referenceBookSubtitle),
                                      Onboarding(image: Images.Onboarding.searching,
                                                 title: Text.Onboarding.searchBookTitle,
                                                 subtitle: Text.Onboarding.searchBookSubtitle),
                                      Onboarding(image: Images.Onboarding.sharing,
                                                 title: Text.Onboarding.shareBookTitle,
                                                 subtitle: Text.Onboarding.shareBookSubtitle)]
}
