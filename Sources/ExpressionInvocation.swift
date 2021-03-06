// The MIT License
//
// Copyright (c) 2015 Gwendal Roué
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import Foundation

struct ExpressionInvocation {
    let expression: Expression
    
    func invoke(with context: Context) throws -> MustacheBox {
        return try evaluate(context: context, expression: expression)
    }
    
    private func evaluate(context: Context, expression: Expression) throws -> MustacheBox {
        switch expression {
        case .ImplicitIterator:
            // {{ . }}
            
            return context.topBox
            
        case .Identifier(let identifier):
            // {{ identifier }}
            
            return context.mustacheBox(forKey: identifier)

        case .Scoped(let baseExpression, let identifier):
            // {{ <expression>.identifier }}
            
            return try evaluate(context: context, expression: baseExpression).mustacheBox(forKey: identifier)
            
        case .Filter(let filterExpression, let argumentExpression, let partialApplication):
            // {{ <expression>(<expression>) }}
            
            let filterBox = try evaluate(context: context, expression: filterExpression)
            
            guard let filter = filterBox.filter else {
                if filterBox.isEmpty {
                    throw MustacheError(kind: .RenderError, message: "Missing filter")
                } else {
                    throw MustacheError(kind: .RenderError, message: "Not a filter")
                }
            }
            
            let argumentBox = try evaluate(context: context, expression: argumentExpression)
            return try filter(box: argumentBox, partialApplication: partialApplication)
        }
    }
}
