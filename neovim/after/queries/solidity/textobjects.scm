(function_definition
  body: (function_body)? @function.inner) @function.outer

(contract_declaration
  body: (contract_body)? @class.inner) @class.outer
