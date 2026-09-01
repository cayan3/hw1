import java

// Looks up all binary expressions and compile time constant expressions
from BinaryExpr expr, CompileTimeConstantExpr const

// Your code here
// --------------------
where
    // Constrain "expr" to shift operands (5 points)
    (expr instanceof LeftShiftExpr or expr instanceof RightShiftExpr or expr instanceof UnsignedRightShiftExpr) and

    // Constrain "const" to be the right operand of "expr" (5 points)
    // Note that "=" is the comparison operator
    const = expr.getRightOperand() and 

    // Constrain the value of "const" to be negative or greater than 31 (5 points)
    (const.getIntValue() < 0 or const.getIntValue() > 31) and

    // Running this query after implementing the three above constraints should
    // give you 19 results, however not all of these are errors because longs
    // can be shifted by more than 31 bits. Add one more predicate constraining
    // the left hand operand to an "int". This should leave you with one result.
    // (5 points)
    (expr.getLeftOperand()).getType().hasName("int")
// --------------------

// Shows a link to the expression and the value of "const"
// You can click the result in the "expr" column to navigate to the matched line
// of code.
select expr, const.getIntValue()
