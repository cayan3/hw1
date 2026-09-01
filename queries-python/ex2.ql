import python

// This predicate checks that a local variable is a parameter of a function.
predicate function_has_parameter(Function f, LocalVariable v) {
  v.isParameter() and v.getScope() = f
}

// Your code here
// --------------------

// Write a predicate that checks that a variable is a parameter of a function
// and has a default value of None. (15 points)
predicate parameter_default_none(Function f, LocalVariable v) {
  function_has_parameter(f, v) and
  exists(Parameter p |
    p.getVariable() = v and
    p.getDefault() instanceof None
  )
}

// Write a predicate that checks if a function contains a statement of the form
// `v = v or ...` and return it.
// (see the "Predicates with result" section of the handbook)
//
// This predicate must:
// - Check that v is a parameter of f (5 points).
// - Identify a statement inside the function that assigns v a value (10 points).
// - Check that the value is an Or expression (15 points).
// - Check that the first operand of the Or expression is the variable itself
//   (15 points).
// - Return the statement (10 points).
Stmt assigned_self_or_default(Function f, LocalVariable v) {
  exists(AssignStmt a, BoolExpr orExpr, Name target, Name maybeV |
    function_has_parameter(f, v) and  // 1. check that v is a parameter of f
    a = f.getAStmt() and              // 2. id a stmt inside the fn...
    a.getTarget(0) = target and       //    ...that assigns a val...
    target.getVariable() = v and      //    ...to v
    a.getValue() = orExpr and         // 3. check that the val...
    orExpr.getOperator() = "or" and   //    ...is an Or
    orExpr.getValue(0) = maybeV and   // 4. check that the first operand of the Or...
    maybeV.getVariable() = v and      //    ...is v
    result = a                        // 5. return the stmt
  )
}

// --------------------

from Function f, LocalVariable v, Stmt s
where
  parameter_default_none(f, v) and
  s = assigned_self_or_default(f, v)
select s, v
