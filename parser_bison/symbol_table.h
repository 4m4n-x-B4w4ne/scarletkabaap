// symbol_table.h
#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <map>
#include <string>

struct identifier_info {
  std::string storage_class = "UNSPECIFIED";
  std::string type = "";
  std::string usage = "";
};

// Declare the symbol table
extern std::map<std::string, identifier_info> symbol_table;

#endif // SYMBOL_TABLE_H
