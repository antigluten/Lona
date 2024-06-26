//
//  LGCSyntax+Unification.swift
//  Logic
//
//  Created by Devin Abbott on 5/28/19.
//  Copyright © 2019 BitDisco, Inc. All rights reserved.
//

import Foundation

extension LGCSyntaxNode {
    public class UnificationContext {
        public var constraints: [Unification.Constraint] = []
        public var nodes: [UUID: Unification.T] = [:]
        public var patternTypes: [UUID: Unification.T] = [:]
        
        public init() {}
        
        private var typeNameGenerator = NameGenerator(prefix: "?")
        
        func makeGenericName() -> String {
            return typeNameGenerator.next()
        }
        
        func makeEvar() -> Unification.T {
            return .evar(makeGenericName())
        }
    }
    
    private func specificIdentifierType(
        scopeContext: Compiler.ScopeContext,
        unificationContext: UnificationContext,
        identifierId: UUID
    ) -> Unification.T {
        if let patternId = scopeContext.identifierToPattern[identifierId], let scopedType = unificationContext.patternTypes[patternId] {
            return scopedType.replacingGenericsWithEvars(getName: unificationContext.makeGenericName)
        } else {
            return unificationContext.makeEvar()
        }
    }
    
    public func makeUnificationContext(
        scopeContext: Compiler.ScopeContext,
        initialContext: UnificationContext = UnificationContext()
    ) -> UnificationContext {
        let traversalConfig = TraversalConfig(order: TraversalOrder.pre)
        
        return reduce(config: traversalConfig, initialResult: initialContext) { result, node, config in
            config.needsRevisitAfterTraversingChildren = true
            
            switch (config.isRevisit, node) {
            case (true, .statement(.branch(id: _, condition: let condition, block: _))):
                result.nodes[condition.uuid] = .cons(name: "Boolean")
                
                return result
//            case (false, .declaration(.record(id: _, name: let functionName, declarations: let declarations))):
//                
//                var parameterTypes: [Unification.T] = []
//                
//                declarations.forEach { declaration in
//                    switch declaration {
//                    case .variable(id: _, name: let pattern, annotation: let annotation, initializer: _):
//                        guard let annotation = annotation else { break }
//                        
//                        let annotationType = annotation.unificationType(genericsInScope: [:]) { result.makeGenericName() }
//                        
//                        parameterTypes.append(annotationType)
//                        
//                        result.nodes[pattern.uuid] = annotationType
//                        //                        result.constraints.append(Unification.Constraint(annotationType, result.nodes[defaultValue.uuid]!))
//                        result.patternTypes[pattern.uuid] = annotationType
//                    default:
//                        break
//                    }
//                }
//                
//                let returnType: Unification.T = .cons(name: functionName.name, parameters: [])
//                let functionType: Unification.T = .fun(arguments: parameterTypes, returnType: returnType)
//                
//                result.nodes[functionName.uuid] = functionType
//                result.patternTypes[functionName.uuid] = functionType
//                
//                break
//            case (false, .declaration(.enumeration(_, name: let functionName, genericParameters: let genericParameters, cases: let enumCases))):
//                let genericNames: [String] = genericParameters.compactMap { param in
//                    switch param {
//                    case .parameter(_, name: let pattern):
//                        return pattern.name
//                    case .placeholder:
//                        return nil
//                    }
//                }
//                
//                var genericInScope: [String: String] = [:]
//                genericNames.forEach { name in
//                    genericInScope[name] = result.makeGenericName()
//                }
//                
//                let universalTypes = genericNames.map { name in Unification.T.gen(genericInScope[name]!) }
//                
//                let returnType: Unification.T = .cons(name: functionName.name, parameters: universalTypes)
//                
//                enumCases.forEach { enumCase in
//                    switch enumCase {
//                    case .placeholder:
//                        break
//                    case .enumerationCase(_, name: let pattern, associatedValueTypes: let associatedValueTypes):
//                        let parameterTypes: [Unification.T] = associatedValueTypes.compactMap { annotation in
//                            switch annotation {
//                            case .placeholder:
//                                return nil
//                            default:
//                                return annotation.unificationType(genericsInScope: genericInScope) { result.makeGenericName() }
//                            }
//                        }
//                        
//                        let functionType: Unification.T = .fun(arguments: parameterTypes, returnType: returnType)
//                        
//                        result.nodes[pattern.uuid] = functionType
//                        result.patternTypes[pattern.uuid] = functionType
//                    }
//                }
//
//                break
//            case (false, .declaration(.function(id: _, name: let functionName, returnType: let returnTypeAnnotation, genericParameters: let genericParameters, parameters: let parameters, block: _))):
//                
//                let genericNames: [String] = genericParameters.compactMap { param in
//                    switch param {
//                    case .parameter(_, name: let pattern):
//                        return pattern.name
//                    case .placeholder:
//                        return nil
//                    }
//                }
//                
//                var genericInScope: [String: String] = [:]
//                genericNames.forEach { name in
//                    genericInScope[name] = result.makeGenericName()
//                }
//                
//                var parameterTypes: [Unification.T] = []
//                
//                parameters.forEach { parameter in
//                    switch parameter {
//                    case .parameter(id: _, externalName: _, localName: let pattern, annotation: let annotation, defaultValue: _):
//                        let annotationType = annotation.unificationType(genericsInScope: genericInScope) { result.makeGenericName() }
//                        
//                        parameterTypes.append(annotationType)
//                        
//                        result.nodes[pattern.uuid] = annotationType
//                        //                        result.constraints.append(Unification.Constraint(annotationType, result.nodes[defaultValue.uuid]!))
//                        result.patternTypes[pattern.uuid] = annotationType
//                    default:
//                        break
//                    }
//                }
//                
//                let returnType = returnTypeAnnotation.unificationType(genericsInScope: genericInScope) { result.makeGenericName() }
//                let functionType: Unification.T = .fun(arguments: parameterTypes, returnType: returnType)
//                
//                result.nodes[functionName.uuid] = functionType
//                result.patternTypes[functionName.uuid] = functionType
//
//                break
//            case (true, .declaration(.variable(id: _, name: let pattern, annotation: let annotation, initializer: let initializer))):
//                guard let initializer = initializer, let annotation = annotation else {
//                    config.ignoreChildren = true
//                    return result
//                }
//                
//                if annotation.isPlaceholder {
//                    config.ignoreChildren = true
//                    return result
//                }
//                
//                let annotationType = annotation.unificationType(genericsInScope: [:]) { result.makeGenericName() }
//                
//                result.nodes[pattern.uuid] = annotationType
//                
//                // TODO: If this doesn't exist, we probably need to implement another node
//                if let initializerType = result.nodes[initializer.uuid] {
//                    result.constraints.append(Unification.Constraint(annotationType, initializerType))
//                } else {
//                    Swift.print("WARNING: No initializer type for \(initializer.uuid)")
//                }
//                
//                result.patternTypes[pattern.uuid] = annotationType
//                
//                return result
//            case (true, .expression(.identifierExpression(id: _, identifier: let identifier))):
//                let type = self.specificIdentifierType(scopeContext: scopeContext, unificationContext: result, identifierId: identifier.uuid)
//                
//                result.nodes[node.uuid] = type
//                result.nodes[identifier.uuid] = type
//                
//                return result
//            case (true, .expression(.functionCallExpression(id: _, expression: let expression, arguments: let arguments))):
//                let calleeType = result.nodes[expression.uuid]!
//                
//                // Unify against these to enforce a function type
//                let placeholderReturnType = result.makeEvar()
//                let placeholderArgTypes = arguments.map { _ in result.makeEvar() }
//                let placeholderFunctionType: Unification.T = .fun(arguments: placeholderArgTypes, returnType: placeholderReturnType)
//                
//                result.constraints.append(.init(calleeType, placeholderFunctionType))
//                
//                result.nodes[node.uuid] = placeholderReturnType
//                
//                let argumentValues = arguments.map { $0.expression }
//                
//                zip(placeholderArgTypes, argumentValues).forEach { (argType, argValue) in
//                    result.constraints.append(Unification.Constraint(argType, result.nodes[argValue.uuid]!))
//                }
//                
//                return result
//            case (false, .expression(.memberExpression)):
//                // The only supported children are identifiers currently, and we will handle them here when we revisit them
//                config.ignoreChildren = true
//                break
//            case (true, .expression(.memberExpression)):
//                let type = self.specificIdentifierType(scopeContext: scopeContext, unificationContext: result, identifierId: node.uuid)
//                
//                result.nodes[node.uuid] = type
//                
//                return result
//            case (true, .expression(.literalExpression(id: _, literal: let literal))):
//                result.nodes[node.uuid] = result.nodes[literal.uuid]!
//                
//                return result
//            case (true, .literal(.boolean)):
//                result.nodes[node.uuid] = .cons(name: "Boolean")
//                
//                return result
//            case (true, .literal(.number)):
//                result.nodes[node.uuid] = .cons(name: "Number")
//                
//                return result
//            case (true, .literal(.string)):
//                result.nodes[node.uuid] = .cons(name: "String")
//                
//                return result
//            case (true, .literal(.color)):
//                result.nodes[node.uuid] = .cons(name: "CSSColor")
//                
//                return result
            default:
                break
            }
            
            return result
        }
    }
}
