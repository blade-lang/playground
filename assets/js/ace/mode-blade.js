define("ace/mode/blade_highlight_rules",["require","exports","module","ace/lib/oop","ace/mode/text_highlight_rules"], function(require, exports, module){/* ***** BEGIN LICENSE BLOCK *****
 * Distributed under the BSD license:
 *
 * Copyright (c) 2012, Ajax.org B.V.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Ajax.org B.V. nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL AJAX.ORG B.V. BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ***** END LICENSE BLOCK ***** */
"use strict";
var oop = require("../lib/oop");
var TextHighlightRules = require("./text_highlight_rules").TextHighlightRules;
var BladeHighlightRules = function () {
    this.$rules = {
        start: [{
                token: "keyword.other.import.blade",
                regex: /^\w*\bimport\b/,
                push: [{
                        token: "punctuation.terminator.blade",
                        regex: /$/,
                        next: "pop"
                    }, {
                        include: "#strings"
                    }, {
                        include: "#comments"
                    }, {
                        token: "keyword.other.import.blade",
                        regex: /\bas\b/
                    }, {
                        defaultToken: "meta.declaration.blade"
                    }]
            }, {
                include: "#comments"
            }, {
                include: "#punctuations"
            }, {
                include: "#anotations"
            }, {
                include: "#keywords"
            }, {
                include: "#constants-and-special-vars"
            }, {
                include: "#strings"
            }],
        "#annotations": [{
                token: "storage.type.annotation.blade",
                regex: /@[a-zA-Z0-9_]+/
            }, {
                token: "meta.structure.dictionary.key.blade",
                regex: /[a-zA-Z0-9_]+:/
            }, {
                token: "string.regexp.blade",
                regex: /(?:'|")[\/~@](?![*+?])(?:[^\r$\[\/\\]|\\.|\[(?:[^\r$\]\\]|\\.)*\])+\2(?:[imsxuADUJ]+)?\1/
            }],
        "#block": [{
                token: "meta.block.empty.blade",
                regex: /\{\}/
            }, {
                todo: {
                    token: "punctuation.section.scope.begin.blade",
                    regex: /\{/,
                    push: [{
                            token: "punctuation.section.scope.end.blade",
                            regex: /\}/,
                            next: "pop"
                        }, {
                            include: "$self"
                        }]
                }
            }, {
                todo: {
                    token: "punctuation.section.scope.begin.blade",
                    regex: /\(/,
                    push: [{
                            token: "punctuation.section.scope.end.blade",
                            regex: /\)/,
                            next: "pop"
                        }, {
                            include: "$self"
                        }]
                }
            }, {
                token: "meta.bracket.square.blade",
                regex: /\[|\]/
            }, {
                token: "meta.brace.square.blade",
                regex: /\{|\}/
            }, {
                token: "meta.brace.open.blade",
                regex: /\{/
            }, {
                token: "meta.brace.close.blade",
                regex: /\}/
            }],
        "#comments": [{
                token: "punctuation.definition.comment.blade",
                regex: /\/\*\*\//
            }, {
                include: "#comments-doc-oldschool"
            }, {
                include: "#comments-doc"
            }, {
                include: "#comments-inline"
            }],
        "#comments-block": [{
                token: "comment.block.blade",
                regex: /\/\*/,
                push: [{
                        token: "comment.block.blade",
                        regex: /\*\//,
                        next: "pop"
                    }, {
                        include: "#comments-block"
                    }, {
                        defaultToken: "comment.block.blade"
                    }]
            }],
        "#comments-doc": [{
                todo: {
                    begin: "\\/\\*",
                    name: "comment.block.documentation.blade",
                    patterns: [{
                            include: "#decorators"
                        }],
                    while: "^\\s*\\*\\/"
                }
            }],
        "#comments-doc-oldschool": [{
                token: "comment.block.documentation.blade",
                regex: /\/\*/,
                push: [{
                        token: "comment.block.documentation.blade",
                        regex: /\*\//,
                        next: "pop"
                    }, {
                        include: "#comments-doc-oldschool"
                    }, {
                        include: "#comments-block"
                    }, {
                        include: "#decorators"
                    }, {
                        defaultToken: "comment.block.documentation.blade"
                    }]
            }],
        "#comments-inline": [{
                include: "#comments-block"
            }, {
                token: "comment.line.number-sign.blade",
                regex: /#.*$/
            }],
        "#constants-and-special-vars": [{
                token: "constant.language.blade",
                regex: /(?<!\$)\b(?:true|false|nil)\b(?!\$)/
            }, {
                token: "variable.language.blade",
                regex: /(?<!\$)\b(?:self|parent)\b(?!\$)|__[a-zA-Z_0-9]+__/
            }, {
                token: "constant.numeric.blade",
                regex: /(?<!\$)\b(?:0b[0-1]*|0c[0-7]*|0x[0-9a-fA-F]*|(?:[0-9]+\.?[0-9]*|\.[0-9]+)(?:(?:e|E)(?:\+|-)?[0-9]+)?)\b(?!\$)/
            }, {
                token: "support.class.blade",
                regex: /(?<![a-zA-Z0-9_$])[_$]*[A-Z][a-zA-Z0-9_$]*/
            }, {
                token: ["entity.name.function.blade", "text"],
                regex: /([_\$]*[a-z][a-zA-Z0-9_\$]*)(\s*\()/
            }],
        "#decorators": [{
                token: "variable.other.name.blade",
                regex: /@[a-zA-Z_]+/
            }],
        "#keywords": [{
                token: "storage.modifier.cast.blade",
                regex: /(?<!\$)\bas\b(?!\$)/
            }, {
                token: "keyword.control.catch-exception.blade",
                regex: /(?<!\$)\b(?:catch|raise|assert)\b(?!\$)/
            }, {
                token: "keyword.control.blade",
                regex: /(?<!\$)\b(?:break|when|continue|default|do|else|for|if|in|return|using|while|iter)\b(?!\$)/
            }, {
                token: "keyword.operator.boolean.blade",
                regex: /(?<!\$)\b(?:or|and)\b(?!\$)/
            }, {
                token: "storage.type.declarations.blade",
                regex: /(?<!\$)\b(?:var|class|def)\b(?!\$)/
            }, {
                token: "keyword.operator.blade",
                regex: /(?<!\$)\bis\!?\b(?!\$)/
            }, {
                token: "keyword.operator.conditional.blade",
                regex: /\?\?/
            }, {
                token: "keyword.operator.bitwise.blade",
                regex: /<<|>>>?|~|\^|\||&/
            }, {
                token: "keyword.operator.assignment.bitwise.blade",
                regex: /(?:&|\^|\||<<|>>>?)=/
            }, {
                token: "keyword.operator.comparison.blade",
                regex: /==|!=|<<?=?|>=?|>>>?=?|\.{2,3}/
            }, {
                token: "keyword.operator.assignment.arithmetic.blade",
                regex: /(?:[+*\/%-]|\~)=/
            }, {
                token: "keyword.operator.assignment.blade",
                regex: /=/
            }, {
                token: "keyword.operator.increment-decrement.blade",
                regex: /\-\-|\+\+/
            }, {
                token: "keyword.operator.arithmetic.blade",
                regex: /\-|\+|\*|\/|\~\/|%|\*\*/
            }, {
                token: "keyword.operator.binary.blade",
                regex: /!/
            }, {
                token: "storage.modifier.blade",
                regex: /(?<!\$)\bstatic\b(?!\$)/
            }, {
                token: "keyword.other.type.primitive.blade",
                regex: /(?<!\$)\becho\b(?!\$)/
            }, {
                token: "constant.language.blade",
                regex: /(?<!\$)\b__(?:args|file|root)__\b(?!\$)/
            }],
        "#punctuation": [{
                token: "meta.punctuation.semicolon.blade",
                regex: /;/
            }, {
                token: "meta.punctuation.comma.blade",
                regex: /,/
            }, {
                token: "meta.punctuation.terminator.blade",
                regex: /$/
            }, {
                token: "meta.punctuation.dot.blade",
                regex: /\./
            }],
        "#string-interpolation": [{
                token: [
                    "text",
                    "text",
                    "variable.parameter.blade",
                    "text"
                ],
                regex: /(\$)(\{)([^{}]+)(\})/
            }, {
                token: "constant.character.escape.blade",
                regex: /\\./
            }],
        "#strings": [{
                token: "string.interpolated.double.blade",
                regex: /(?<!\|r)"/,
                push: [{
                        token: "string.interpolated.double.blade",
                        regex: /"/,
                        next: "pop"
                    }, {
                        token: "string.interpolated.double.blade",
                        regex: /$/
                    }, {
                        include: "#string-interpolation"
                    }, {
                        defaultToken: "string.interpolated.double.blade"
                    }]
            }, {
                token: "string.interpolated.single.blade",
                regex: /(?<!\|r)'/,
                push: [{
                        token: "string.interpolated.single.blade",
                        regex: /'/,
                        next: "pop"
                    }, {
                        token: "string.interpolated.single.blade",
                        regex: /$/
                    }, {
                        include: "#string-interpolation"
                    }, {
                        defaultToken: "string.interpolated.single.blade"
                    }]
            }]
    };
    this.normalizeRules();
};
BladeHighlightRules.metaData = {
    fileTypes: ["b"],
    firstLineMatch: "^#!/.*\\bblade\\b",
    name: "Blade",
    scopeName: "source.blade"
};
oop.inherits(BladeHighlightRules, TextHighlightRules);
exports.BladeHighlightRules = BladeHighlightRules;

});

define("ace/mode/folding/cstyle",["require","exports","module","ace/lib/oop","ace/range","ace/mode/folding/fold_mode"], function(require, exports, module){"use strict";
var oop = require("../../lib/oop");
var Range = require("../../range").Range;
var BaseFoldMode = require("./fold_mode").FoldMode;
var FoldMode = exports.FoldMode = function (commentRegex) {
    if (commentRegex) {
        this.foldingStartMarker = new RegExp(this.foldingStartMarker.source.replace(/\|[^|]*?$/, "|" + commentRegex.start));
        this.foldingStopMarker = new RegExp(this.foldingStopMarker.source.replace(/\|[^|]*?$/, "|" + commentRegex.end));
    }
};
oop.inherits(FoldMode, BaseFoldMode);
(function () {
    this.foldingStartMarker = /([\{\[\(])[^\}\]\)]*$|^\s*(\/\*)/;
    this.foldingStopMarker = /^[^\[\{\(]*([\}\]\)])|^[\s\*]*(\*\/)/;
    this.singleLineBlockCommentRe = /^\s*(\/\*).*\*\/\s*$/;
    this.tripleStarBlockCommentRe = /^\s*(\/\*\*\*).*\*\/\s*$/;
    this.startRegionRe = /^\s*(\/\*|\/\/)#?region\b/;
    this._getFoldWidgetBase = this.getFoldWidget;
    this.getFoldWidget = function (session, foldStyle, row) {
        var line = session.getLine(row);
        if (this.singleLineBlockCommentRe.test(line)) {
            if (!this.startRegionRe.test(line) && !this.tripleStarBlockCommentRe.test(line))
                return "";
        }
        var fw = this._getFoldWidgetBase(session, foldStyle, row);
        if (!fw && this.startRegionRe.test(line))
            return "start"; // lineCommentRegionStart
        return fw;
    };
    this.getFoldWidgetRange = function (session, foldStyle, row, forceMultiline) {
        var line = session.getLine(row);
        if (this.startRegionRe.test(line))
            return this.getCommentRegionBlock(session, line, row);
        var match = line.match(this.foldingStartMarker);
        if (match) {
            var i = match.index;
            if (match[1])
                return this.openingBracketBlock(session, match[1], row, i);
            var range = session.getCommentFoldRange(row, i + match[0].length, 1);
            if (range && !range.isMultiLine()) {
                if (forceMultiline) {
                    range = this.getSectionRange(session, row);
                }
                else if (foldStyle != "all")
                    range = null;
            }
            return range;
        }
        if (foldStyle === "markbegin")
            return;
        var match = line.match(this.foldingStopMarker);
        if (match) {
            var i = match.index + match[0].length;
            if (match[1])
                return this.closingBracketBlock(session, match[1], row, i);
            return session.getCommentFoldRange(row, i, -1);
        }
    };
    this.getSectionRange = function (session, row) {
        var line = session.getLine(row);
        var startIndent = line.search(/\S/);
        var startRow = row;
        var startColumn = line.length;
        row = row + 1;
        var endRow = row;
        var maxRow = session.getLength();
        while (++row < maxRow) {
            line = session.getLine(row);
            var indent = line.search(/\S/);
            if (indent === -1)
                continue;
            if (startIndent > indent)
                break;
            var subRange = this.getFoldWidgetRange(session, "all", row);
            if (subRange) {
                if (subRange.start.row <= startRow) {
                    break;
                }
                else if (subRange.isMultiLine()) {
                    row = subRange.end.row;
                }
                else if (startIndent == indent) {
                    break;
                }
            }
            endRow = row;
        }
        return new Range(startRow, startColumn, endRow, session.getLine(endRow).length);
    };
    this.getCommentRegionBlock = function (session, line, row) {
        var startColumn = line.search(/\s*$/);
        var maxRow = session.getLength();
        var startRow = row;
        var re = /^\s*(?:\/\*|\/\/|--)#?(end)?region\b/;
        var depth = 1;
        while (++row < maxRow) {
            line = session.getLine(row);
            var m = re.exec(line);
            if (!m)
                continue;
            if (m[1])
                depth--;
            else
                depth++;
            if (!depth)
                break;
        }
        var endRow = row;
        if (endRow > startRow) {
            return new Range(startRow, startColumn, endRow, line.length);
        }
    };
}).call(FoldMode.prototype);

});

define("ace/mode/blade",["require","exports","module","ace/lib/oop","ace/mode/text","ace/mode/blade_highlight_rules","ace/mode/folding/cstyle"], function(require, exports, module){/* ***** BEGIN LICENSE BLOCK *****
 * Distributed under the BSD license:
 *
 * Copyright (c) 2012, Ajax.org B.V.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Ajax.org B.V. nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL AJAX.ORG B.V. BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ***** END LICENSE BLOCK ***** */
"use strict";
var oop = require("../lib/oop");
var TextMode = require("./text").Mode;
var BladeHighlightRules = require("./blade_highlight_rules").BladeHighlightRules;
var FoldMode = require("./folding/cstyle").FoldMode;
var Mode = function () {
    this.HighlightRules = BladeHighlightRules;
    this.foldingRules = new FoldMode();
};
oop.inherits(Mode, TextMode);
(function () {
    this.$id = "ace/mode/blade";
}).call(Mode.prototype);
exports.Mode = Mode;

});                (function() {
                    window.require(["ace/mode/blade"], function(m) {
                        if (typeof module == "object" && typeof exports == "object" && module) {
                            module.exports = m;
                        }
                    });
                })();
            