//
//  Button.swift
//  ControlledComponents
//
//  Created by Devin Abbott on 8/27/18.
//  Copyright © 2018 BitDisco, Inc. All rights reserved.
//

import AppKit
import Foundation

// MARK: - Button

open class Button: NSButton {

    // MARK: Lifecycle

    public init(titleText: String = "") {
        self.titleText = titleText

        super.init(frame: .zero)

        setUpViews()
        setUpConstraints()

        update()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public

    public var titleText: String { didSet { update() } }
    public var onPress: (() -> Void)? { didSet { update() } }

    // MARK: Private

    @objc func handlePress() {
        onPress?()
    }

    private func setUpViews() {
        action = #selector(handlePress)
        target = self

        setButtonType(.momentaryPushIn)
        imagePosition = .noImage
        bezelStyle = .rounded
    }

    private func setUpConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func update() {
        title = titleText
    }
}
