" Syntax highlighting for kori configuration files (YAML with /skill: tokens)

if exists('b:current_syntax')
  finish
endif

" Load YAML syntax first
runtime! syntax/yaml.vim
syntax reset

" Add kori-specific syntax patterns
" /skill: followed by alphanumeric/underscore/hyphen
syntax match koriSkill /\/skill:[a-zA-Z0-9_-]*/ contains=koriSkillName
syntax match koriSkillName /[a-zA-Z0-9_-]\+/ contained

" Comments
syntax match koriComment /#.*$/
syntax match koriTodo /\v(TODO|FIXME|NOTE|HACK|WARN)(ING)?:/ containedin=koriComment

" Define highlight groups
hi def link koriSkill     Special
hi def link koriSkillName Identifier
hi def link koriComment   Comment
hi def link koriTodo      Todo

" Ensure syntax is loaded
let b:current_syntax = 'kori'

echo "Syntax loaded: kori"
