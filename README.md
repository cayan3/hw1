Homework 1: Syntactic Analysis With CodeQL
=================================================

### Assignment Objectives:
- Get set up and run CodeQL queries on a public GitHub project.
- Implement simple analyses with CodeQL queries.

### Handin Instructions:
Submit via the Gradescope online assignment for Homework 1: https://www.gradescope.com/courses/1367026/assignments/8469431

### Grading:
This homework is worth 100 points (with a possible 30 bonus points). The point
distribution is broken down inline with this document.

### Setup:

**Alternative 1 (GitHub Codespaces) - Recommended, requires the use of Chrome**

1. **Important:** Create a fork of this repository.
2. In the fork, open it using **GitHub Codespaces**. Make sure to select a variant with **at least 4 cores for CPU, preferably 8 cores**. A dialogue will say "This folder contains a workspace file ... <snip> ... Do you want to open it?" Click "Open Workspace".  You may receive a warning from the Git extension of too many active changes in the codeql submodule; you can ignore this warning, especially since you won't turn in this git repository.  Remember to commit changes to files you do care about before closing a codespace.
2. Inside the codespace environment, open the QL Tab on the sidebar and click **"Add a CodeQL database From an archive"**.
3. In this homework, we will analyze the following two projects:
   https://github.com/CMU-program-analysis/s2-hw1 and
   https://github.com/CMU-program-analysis/mypy-hw1. We created the CodeQL databases for these projects and included them as zip archives in this repository.
   **You must import these two archives before writing/testing your queries**. 
4. In the QL Tab, set *s2-hw1* as the default database to answer the questions for the Java analysis and *mypy-hw1* for the Python analysis.

**Alternative 2 (Locally)**
1. Download [Visual Studio Code](https://code.visualstudio.com) 
2. Install [CodeQL Extension](https://marketplace.visualstudio.com/items?itemName=github.vscode-codeql) for Visual Studio Code
3. Clone this repository. Make sure to include all submodules (`git clone https://github.com/CMU-program-analysis/hw1-yourGitHubID --recursive`)
4. In VS Code, click File > Open Workspace. Select the file `hw1.code-workspace` in your checkout of this repository.
5. Open the QL Tab on the sidebar of Visual Studio Code and click **"Add a CodeQL database From an archive"**.
6. In this homework, we will analyze the following two projects:
   https://github.com/CMU-program-analysis/s2-hw1 and
   https://github.com/CMU-program-analysis/mypy-hw1. We created the CodeQL databases for these projects and included them as zip archives in this repository.
   **You must import these two archives before writing/testing your queries**. 
7. In the QL Tab, set *s2-hw1* as the default database to answer the questions for the Java analysis and *mypy-hw1* for the Python analysis.

---

Problem 1: Java Shift analysis (25 points):
-------------------------------------------

In Java, the shift operators (`<<`, `>>`, and `>>>`) shift the bits in a value
a certain distance. [According to the Java
specification](https://docs.oracle.com/javase/specs/jls/se7/html/jls-15.html#jls-15.19),
if the type of the left-hand argument is a primitive `int`, only the lower five
bits of the right-hand argument are used as the shift distance. In other words,
the shift distance actually used is always in the range `0` to `31`,
inclusive. Thus, a programmer trying to use a shift distance outside of this
range suggests that they misunderstand of the behavior of the shift operators.

Open the file [./queries-java/ex1.ql](queries-java/ex1.ql). Complete the code by replacing `...`
with the proper code to identify all bit shift operations (`<<`, `>>`, and
`>>>`) that shift by a constant that is greater than 31 or less than 0.

The following will be helpful
references:\
[Basic Java query
example](https://codeql.github.com/docs/codeql-language-guides/basic-query-for-java-code)\
[Java AST
Reference](https://codeql.github.com/docs/codeql-language-guides/abstract-syntax-tree-classes-for-working-with-java-programs/)\
[CodeQL reference manual for Java](https://codeql.github.com/codeql-standard-libraries/java/)\
[The
"types" section of the Java
introduction](https://codeql.github.com/docs/codeql-language-guides/types-in-java/)

For a more complete reference, see the [QL Language
Handbook](https://codeql.github.com/docs/ql-language-reference/)

**To submit:**
  1. Copy/paste your query code from [./queries-java/ex1.ql](./queries-java/ex1.ql) to the first question in the Gradescope assigment.  (20 pts)
  2. Take a screenshot or picture of the results of running the query successfully.  You should have 1 result on the S2 repository if you've implemented the query correctly. (5 pts)

---

Problem 2: Python `v = v or default_value` (75 points)
------------------------------------------------------

Default arguments to Python are evaluated once when the function is
defined. This leads to a common error when the default arguments are mutable
(credit for this example goes to [The Hitchhiker's Guide to
Python](https://docs.python-guide.org/writing/gotchas/#mutable-default-arguments))

```
def append_to(element, to=[]):
    to.append(element)
    return to

my_list = append_to(12)
print(my_list)
# Prints "[12]"

my_other_list = append_to(42)
print(my_other_list)
# Prints "[12, 42]" instead of "[42]"
```

The standard solution to this is to instead use `None` as a default value and
initialize to a new copy of a mutable default value inside of the function:

```
def append_to(element, to=None):
    if to is None:
        to = []
    to.append(element)
    return to
```


A clever alternative to this pattern takes advantage of the combination of
short-circuit evaluation and the fact that `None` is "falsy" to make the code
more concise:

```
def append_to(element, to=None):
    to = to or []
    to.append(element)
    return to
```

In this example, if `to` is a "falsy" value like `None` it is initialized to an
empty list, otherwise its value is kept. However, this code is subtly different
from the explicit comparison to `None`. If `to` is passed a "falsy" value that
does not implement `append()` (e.g., `0`, `False`), the former code will fail
with a `AttributeError`, while the latter will happily assign a default value
and continue, which can lead to difficult-to-find bugs.

In this problem, you will implement an analysis to find instances of this
pattern in the [MyPy](https://github.com/python/mypy) project. The check you
will implement has two parts:
1. Identify parameters of functions that have a default value of `None`.
2. For those parameters, identify statements inside of the containing function
   of the form `x = x or ...`.


The [QL Language Handbook](https://codeql.github.com/docs/ql-language-reference/)
will be helpful for this problem, particularly the sections on
[predicates](https://codeql.github.com/docs/ql-language-reference/predicates/) and
[exists](https://codeql.github.com/docs/ql-language-reference/formulas/#exists).

The starter code is in [./queries-python/ex2.ql](./queries-python/ex2.ql). You should run this query on the
**mypy-hw1** database; if your
implementation is correct you should have 43 results.

**To submit:**
  1. copy/paste your completed query code from [./queries-python/ex2.ql](./queries-python/ex2.ql) to the third question in the Gradescope assigment.  (70 pts)
  2. Take a screenshot or picture of the results of running the query successfully.  You should have 43 results on the mypy repository if you've implemented the query correctly. (5 pts)

---


Bonus: Find and report a bug in open-source software (up to 30 points):
-----------------------------------------------------------------------

For bonus credit, find a bug in an open-source project using CodeQL and submit
an issue to the project's issue tracker on GitHub. For credit you must:

1. Use a CodeQL query to identify a bug (either one of the above or another *you
   write yourself*), and include the query and a screenshot of the results to the appropriate question on Gradescope.

2. Submit an issue to the project's issue tracker with a description of the bug,
   and provide a link to the issue. **Make sure to check the project's
   guidelines and follow them when submitting a bug report.**

Complete the above two tasks *by the homework deadline* for an extra **20 bonus
points** (no extensions will be given for the bonus). If the developers of a
project acknowledge your report as a bug or patch it any time before the end of
the semester we will add an extra **10 bonus points** (just let us know so we
can adjust your grade).

### Rules:

Our goal is for you to make high-quality contributions to open-source projects
using program analysis, so we ask that you follow some rules when submitting bug
reports. We will not award bonus points to submissions that do not follow these
rules:

- Be sure to understand the bug you are submitting to the issue tracker. Not all
  matching instances of the above analyses are bugs, and blindly submitting
  analysis results as bugs without understanding the context is often
  counterproductive.

- Please only submit one bug report for this bonus. Do not spam issue trackers
  with bugs in an attempt to get extra points.

- Be nice.
