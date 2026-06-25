if exists("b:current_syntax")
  finish
endif

syn case match

" Comments
syn match   datapathLineComment    "//.*$"                       contains=@Spell
syn region  datapathBlockComment   start="/\*" end="\*/"         contains=@Spell

" Strings — triple must be defined first AND single must not start where triple does
syn region  datapathTripleString   start=+'''+ end=+'''+                       contains=datapathEscape keepend
syn region  datapathDoubleString   start=+"+ skip=+\\"+ end=+"+                contains=datapathEscape
syn region  datapathSingleString   start=+'\%(''\)\@!+ skip=+\\'+ end=+'+      contains=datapathEscape
syn match   datapathEscape         "\\." contained

" Constants
syn match   datapathNullTyped      "\<null\.\(null\|bool\|int\|float\|decimal\|timestamp\|string\|symbol\|blob\|clob\|struct\|list\|sexp\)\>"
syn keyword datapathBoolean        true false null _

" Numbers
syn match   datapathNumber         "\<-\?\d\+\(\.\d\+\)\?\>"

" Keywords (control / forms)
syn match   datapathKeyword        "(\@<=\s*\(define\|and\|or\|not\|if\|exist\|ifexist\|first\|quote\|list\|sort\|descending\|set\|count\|min\|max\|sum\|with\|struct\|view\|doc\|visible\|argument\|override\|annotation\|annotations\|field\|raw_field\|physicalInstance\|delimit\|diverge\|ground\|andp\|one\|size\|name\|url_format\|string\|path\|symbol\|decimal\|int\|timestamp\|clob\|json\|bitset\|mod\|pow\|now\)\>"

" Operators (after open paren)
syn match   datapathOperator       "(\@<=\s*\(=\|+\|\*\|\.\*\|\.\|<=\|>=\|<\|>\|/\~\)\(\s\)\@="

" Function call: (namespace::name ...) — namespaced symbol after (
syn match   datapathFunction       "(\@<=\s*\(\w\+::\)\+\w\+"

" Typed parameter: type::name (NOT after open paren)
syn match   datapathTypedParam     "\(\<\)\@=\(\w\+\)::\(\w\+\)" contains=datapathParamType,datapathParamName
syn match   datapathParamType      "\<\w\+\(::\)\@="            contained
syn match   datapathParamName      "\(::\)\@<=\w\+"             contained

" Plain identifier (variable / parameter)
syn match   datapathIdentifier     "\<[a-zA-Z_]\w*\>"

" Delimiters
syn match   datapathParen          "[()]"

" Highlight links
hi def link datapathLineComment    Comment
hi def link datapathBlockComment   Comment
hi def link datapathTripleString   String
hi def link datapathDoubleString   String
hi def link datapathSingleString   String
hi def link datapathEscape         SpecialChar
hi def link datapathNullTyped      Constant
hi def link datapathBoolean        Boolean
hi def link datapathNumber         Number
hi def link datapathKeyword        Keyword
hi def link datapathOperator       Operator
hi def link datapathFunction       Function
hi def link datapathParamType      Type
hi def link datapathParamName      Identifier
hi def link datapathIdentifier     Identifier
hi def link datapathParen          Delimiter

let b:current_syntax = "datapath"
