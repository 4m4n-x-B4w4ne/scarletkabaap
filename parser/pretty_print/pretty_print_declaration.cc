#include <parser/common.hh>

namespace scarlet {
namespace parser {

void parser::pretty_print_declaration(
    std::shared_ptr<ast::AST_Declaration_Node> declaration) {
  if (declaration == nullptr)
    return;
  if (declaration->get_type() == ast::DeclarationType::VARIABLE) {
    std::cout << "\tVariable Declaration=(" << std::endl;
    std::cout << "\t\tidentifier=\""
              << declaration->get_declarator()->get_identifier()->get_value()
              << "\"," << std::endl;
    pretty_print_variable_declaration(
        std::static_pointer_cast<ast::AST_variable_declaration_Node>(
            declaration));
  } else {
    std::cout << "\tFunction Declaration=(" << std::endl;
    std::cout << "\t\tidentifier=\""
              << declaration->get_declarator()->get_identifier()->get_value()
              << "\"," << std::endl;
    pretty_print_function_declaration(
        std::static_pointer_cast<ast::AST_function_declaration_Node>(
            declaration));
  }
}

void parser::pretty_print_variable_declaration(
    std::shared_ptr<ast::AST_variable_declaration_Node> declaration) {
  std::cout << "\t\tStorageSpecifier="
            << ast::to_string(declaration->get_specifier()) << "," << std::endl;
  std::vector<ast::DeclarationType> derived_type =
      declaration->get_declarator()->get_derived_type();
  std::cout << "\t\ttype=" << " ";
  for (ast::DeclarationType type : derived_type) {
    std::cout << ast::to_string(type) << "(";
  }
  std::cout << ast::to_string(declaration->get_type());
  std::cout << std::string(derived_type.size(), ')');
  std::cout << "," << std::endl;
  std::cout << "\t\texp=(" << std::endl;
  pretty_print_exp(declaration->get_exp());
  std::cout << "\t\t)" << std::endl;
  std::cout << "\t)," << std::endl;
}

void parser::pretty_print_function_declaration(
    std::shared_ptr<ast::AST_function_declaration_Node> decl) {
  std::cout << "\t\tStorageSpecifier=" << ast::to_string(decl->get_specifier())
            << "," << std::endl;
  std::vector<ast::DeclarationType> derived_type =
      decl->get_declarator()->get_derived_type();
  derived_type.pop_back();
  std::cout << "\t\treturn_type=";
  for (ast::DeclarationType type : derived_type) {
    std::cout << ast::to_string(type) << "(";
  }
  std::cout << ast::to_string(decl->get_return_type());
  std::cout << std::string(derived_type.size(), ')');
  std::cout << "," << std::endl;

  std::cout << "\t\tparams=[" << std::endl;
  for (auto param : decl->get_params()) {
    std::cout << "\t\t\tParam=(" << std::endl;
    std::vector<ast::DeclarationType> derived_type_param =
        param->get_declarator()->get_derived_type();
    std::cout << "\t\t\t\ttype=";
    for (ast::DeclarationType type : derived_type_param) {
      std::cout << ast::to_string(type) << "(";
    }
    std::cout << ast::to_string(param->get_type());
    std::cout << std::string(derived_type_param.size(), ')');
    std::cout << "," << std::endl;
    std::cout << "\t\t\t\tidentifier=\""
              << param->get_declarator()->get_identifier()->get_value() << "\""
              << std::endl;
    std::cout << "\t\t\t)," << std::endl;
  }
  std::cout << "\t\t]," << std::endl;
  std::cout << "\t\tbody=[" << std::endl;
  pretty_print_block(decl->get_block());
  std::cout << "\t\t]" << std::endl;
  std::cout << "\t)," << std::endl;
}

} // namespace parser
} // namespace scarlet
