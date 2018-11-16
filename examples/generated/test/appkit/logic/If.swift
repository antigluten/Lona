import AppKit
import Foundation

// MARK: - If

public class If: NSBox {

  // MARK: Lifecycle

  public init(_ parameters: Parameters) {
    self.parameters = parameters

    super.init(frame: .zero)

    setUpViews()
    setUpConstraints()

    update()
  }

  public convenience init(enabled: Bool) {
    self.init(Parameters(enabled: enabled))
  }

  public convenience init() {
    self.init(Parameters())
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public var enabled: Bool {
    get { return parameters.enabled }
    set { parameters.enabled = newValue }
  }

  public var parameters: Parameters { didSet { update() } }

  // MARK: Private

  private func setUpViews() {
    boxType = .custom
    borderType = .noBorder
    contentViewMargins = .zero
  }

  private func setUpConstraints() {
    translatesAutoresizingMaskIntoConstraints = false
  }

  private func update() {
    fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    if enabled {
      fillColor = Colors.red500
    }
  }
}

// MARK: - Parameters

extension If {
  public struct Parameters: Equatable {
    public var enabled: Bool

    public init(enabled: Bool) {
      self.enabled = enabled
    }

    public init() {
      self.init(enabled: false)
    }

    public static func ==(lhs: Parameters, rhs: Parameters) -> Bool {
      return lhs.enabled == rhs.enabled
    }
  }
}

// MARK: - Model

extension If {
  public struct Model: LonaViewModel, Equatable {
    public var parameters: Parameters
    public var type: String {
      return "If"
    }

    public init(_ parameters: Parameters) {
      self.parameters = parameters
    }

    public init(enabled: Bool) {
      self.init(Parameters(enabled: enabled))
    }

    public init() {
      self.init(enabled: false)
    }
  }
}
