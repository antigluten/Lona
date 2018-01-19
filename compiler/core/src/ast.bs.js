// Generated by BUCKLESCRIPT VERSION 2.1.0, PLEASE EDIT WITH CARE
'use strict';

var List        = require("bs-platform/lib/js/list.js");
var Block       = require("bs-platform/lib/js/block.js");
var Curry       = require("bs-platform/lib/js/curry.js");
var Json_decode = require("bs-json/src/Json_decode.js");

function map(f, node) {
  if (typeof node === "number") {
    return Curry._1(f, node);
  } else {
    switch (node.tag | 0) {
      case 0 : 
          return Curry._1(f, /* Return */Block.__(0, [map(f, node[0])]));
      case 3 : 
          return Curry._1(f, /* Class */Block.__(3, [
                        node[0],
                        node[1],
                        List.map((function (param) {
                                return map(f, param);
                              }), node[2])
                      ]));
      case 4 : 
          return Curry._1(f, /* Method */Block.__(4, [
                        node[0],
                        node[1],
                        List.map((function (param) {
                                return map(f, param);
                              }), node[2])
                      ]));
      case 5 : 
          return Curry._1(f, /* CallExpression */Block.__(5, [
                        map(f, node[0]),
                        List.map((function (param) {
                                return map(f, param);
                              }), node[1])
                      ]));
      case 6 : 
          return Curry._1(f, /* JSXAttribute */Block.__(6, [
                        node[0],
                        map(f, node[1])
                      ]));
      case 7 : 
          return Curry._1(f, /* JSXElement */Block.__(7, [
                        node[0],
                        List.map((function (param) {
                                return map(f, param);
                              }), node[1]),
                        List.map((function (param) {
                                return map(f, param);
                              }), node[2])
                      ]));
      case 8 : 
          return Curry._1(f, /* VariableDeclaration */Block.__(8, [map(f, node[0])]));
      case 9 : 
          return Curry._1(f, /* AssignmentExpression */Block.__(9, [
                        map(f, node[0]),
                        map(f, node[1])
                      ]));
      case 10 : 
          return Curry._1(f, /* BooleanExpression */Block.__(10, [
                        map(f, node[0]),
                        node[1],
                        map(f, node[2])
                      ]));
      case 11 : 
          return Curry._1(f, /* ConditionalStatement */Block.__(11, [
                        map(f, node[0]),
                        List.map((function (param) {
                                return map(f, param);
                              }), node[1])
                      ]));
      case 12 : 
          return Curry._1(f, /* ArrayLiteral */Block.__(12, [List.map((function (param) {
                                return map(f, param);
                              }), node[0])]));
      case 13 : 
          return Curry._1(f, /* ObjectLiteral */Block.__(13, [List.map((function (param) {
                                return map(f, param);
                              }), node[0])]));
      case 14 : 
          return Curry._1(f, /* ObjectProperty */Block.__(14, [
                        map(f, node[0]),
                        map(f, node[1])
                      ]));
      case 15 : 
          return Curry._1(f, /* Block */Block.__(15, [List.map((function (param) {
                                return map(f, param);
                              }), node[0])]));
      case 16 : 
          return Curry._1(f, /* Program */Block.__(16, [List.map((function (param) {
                                return map(f, param);
                              }), node[0])]));
      default:
        return Curry._1(f, node);
    }
  }
}

function optimizeTruthyBooleanExpression(node) {
  var booleanValue = function (sub) {
    if (typeof sub === "number" || sub.tag !== 1) {
      return /* None */0;
    } else {
      return Json_decode.optional(Json_decode.bool, sub[0][/* data */1]);
    }
  };
  if (typeof node === "number") {
    return node;
  } else if (node.tag === 10) {
    var b = node[2];
    var a = node[0];
    var boolA = booleanValue(a);
    var boolB = booleanValue(b);
    var exit = 0;
    if (node[1] !== 0) {
      return node;
    } else if (boolB) {
      if (boolB[0] !== 0) {
        return a;
      } else {
        exit = 1;
      }
    } else {
      exit = 1;
    }
    if (exit === 1) {
      if (boolA && boolA[0] !== 0) {
        return b;
      } else {
        return node;
      }
    }
    
  } else {
    return node;
  }
}

function renameIdentifiers(node) {
  if (typeof node === "number") {
    return node;
  } else if (node.tag === 2) {
    var match = node[0];
    if (match) {
      var tail = match[1];
      switch (match[0]) {
        case "layers" : 
            if (tail) {
              return /* Identifier */Block.__(2, [/* :: */[
                          List.fold_left((function (a, b) {
                                  return a + ("$" + b);
                                }), tail[0], tail[1]),
                          /* [] */0
                        ]]);
            } else {
              return node;
            }
        case "parameters" : 
            return /* Identifier */Block.__(2, [/* :: */[
                        "this",
                        /* :: */[
                          "props",
                          tail
                        ]
                      ]]);
        default:
          return node;
      }
    } else {
      return node;
    }
  } else {
    return node;
  }
}

function optimize(node) {
  return map(optimizeTruthyBooleanExpression, node);
}

function prepareForRender(node) {
  return map(renameIdentifiers, node);
}

var JavaScript = /* module */[
  /* map */map,
  /* optimizeTruthyBooleanExpression */optimizeTruthyBooleanExpression,
  /* renameIdentifiers */renameIdentifiers,
  /* optimize */optimize,
  /* prepareForRender */prepareForRender
];

exports.JavaScript = JavaScript;
/* No side effect */
