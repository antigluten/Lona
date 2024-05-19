//
//  Checkbox.swift
//  ControlledComponents
//
//  Created by Devin Abbott on 8/27/18.
//  Copyright © 2018 BitDisco, Inc. All rights reserved.
//

import AppKit
import Foundation

// MARK: - Checkbox

open class Checkbox: NSButton {

    // MARK: Lifecycle

    public convenience init(titleText: String = "") {
        self.init(frame: .zero)

        self.titleText = titleText
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)

        setUpViews()
        setUpConstraints()

        update()
    }

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        setUpViews()
        setUpConstraints()

        update()
    }

    // MARK: Public

    public var titleText: String = "" { didSet { update() } }

    public var onChangeValue: ((Bool) -> Void)?

    public var value: Bool {
        get { return state == .on }
        set { state = newValue ? .on : .off }
    }

    public var usesIntrinsicHeight: Bool {
        get { return heightConstraint?.isActive ?? false }
        set { heightConstraint?.isActive = newValue }
    }

    // MARK: Private

    private var heightConstraint: NSLayoutConstraint?

    @objc private func handleChange() {
        let newValue = value

        // Revert the value to before it was toggled
        value = !value

        // This view's owner should update the `value` if needed
        onChangeValue?(newValue)
    }

    private func setUpViews() {
        setButtonType(.switch)
        action = #selector(handleChange)
        target = self
    }

    private func setUpConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        heightConstraint = heightAnchor.constraint(equalToConstant: intrinsicContentSize.height)
        heightConstraint?.isActive = true
    }

    private func update() {
        title = titleText
    }
}
