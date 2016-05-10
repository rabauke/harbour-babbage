#if !(defined MATH_PARSER_HPP)

#define MATH_PARSER_HPP

#include <iterator>
#include <string>
#include <vector>
#include <stack>
#include <stdexcept>
#include <cmath>
#include <QString>
#include <QRegularExpressionMatchIterator>


namespace math_parser {

  class error : public std::runtime_error {
    using std::runtime_error::runtime_error;
  };

  class syntax_error : public error {
  public:
    syntax_error() : error("syntax error") {
    }
  };

  class unknow_function : public error {
  public:
    unknow_function() : error("unknow function") {
    }
  };

  class unknow_variable : public error {
  public:
    unknow_variable(const std::string &var) : error("unknow variable "+var) {
    }
  };

  class brace_error : public error {
  public:
    brace_error() : error("brace error") {
    }
  };

  class argument_error : public error {
  public:
    argument_error() : error("argument error") {
    }
  };

  //--------------------------------------------------------------------

  template<typename T>
  class base_token_t {
    QString str_;
    T kind_;
  public:
    explicit base_token_t(const QString &str, T kind) : str_(str), kind_(kind) {
    }
    const QString & str() const {
      return str_;
    }
    T kind() const {
      return kind_;
    }
  };

  template<typename T>
  bool operator==(const base_token_t<T> &token, const QString &str) {
    return token.str()==str;
  }

  template<typename T>
  bool operator==(const base_token_t<T> &token, const char *str) {
    return token.str()==str;
  }

  template<typename T>
  bool operator==(const base_token_t<T> &token, const T &kind) {
    return token.kind()==kind;
  }

  //--------------------------------------------------------------------

  enum class associativity { left, right };

  //--------------------------------------------------------------------

  class arithmetic_parser {
  public:

    enum class token_kind { invalid, number, op, brace_open, brace_close, func, var };

    typedef base_token_t<token_kind> token_t;
    typedef std::vector<token_t> token_list_t;
    class var_map_t : private std::map<QString, double> {
      typedef std::map<QString, double> base;
    public:
      using base::iterator;
      using base::const_iterator;
      using base::value_type;
      using base::size_type;
      using base::base;
      using base::begin;
      using base::end;
      using base::find;
      using base::at;
      using base::operator[];
      std::pair<iterator, bool> insert(const QString &var, double val) {
        return base::insert(std::make_pair(var, val));
      }
    };

  private:
    const std::map<QString, associativity> associativity_map=
    { {"+", associativity::left},
      {"-", associativity::left},
      {"*", associativity::left},
      {"/", associativity::left},
      {"^", associativity::right},
      {"_", associativity::left},
      {"!", associativity::right} };

    const std::map<QString, int> precedence_map=
    { {"+", 1},
      {"-", 1},
      {"*", 2},
      {"/", 2},
      {"^", 4},
      {"_", 3},
      {"!", 5} };

    double abs  (double x) const { return std::abs(x); }
    double sin  (double x) const { return std::sin(x); }
    double cos  (double x) const { return std::cos(x); }
    double tan  (double x) const { return std::tan(x); }
    double asin (double x) const { return std::asin(x); }
    double acos (double x) const { return std::acos(x); }
    double atan (double x) const { return std::atan(x); }
    double sinh (double x) const { return std::sinh(x); }
    double cosh (double x) const { return std::cosh(x); }
    double tanh (double x) const { return std::tanh(x); }
    double asinh(double x) const { return std::asinh(x); }
    double acosh(double x) const { return std::acosh(x); }
    double atanh(double x) const { return std::atanh(x); }
    double sqrt (double x) const { return std::sqrt(x); }
    double exp  (double x) const { return std::exp(x); }
    double ln   (double x) const { return std::log(x); }
    double log  (double x) const { return std::log10(x); }
    double erf  (double x) const { return std::erf(x); }
    double erfc (double x) const { return std::erfc(x); }
    double Gamma(double x) const { return std::tgamma(x); }
    double round(double x) const { return std::round(x); }

    typedef double (arithmetic_parser::*f_pointer)(double) const;

    const std::map<QString, f_pointer> func_map=
    { {"abs",   &arithmetic_parser::abs},
      {"sin",   &arithmetic_parser::sin},
      {"cos",   &arithmetic_parser::cos},
      {"tan",   &arithmetic_parser::tan},
      {"asin",  &arithmetic_parser::asin},
      {"acos",  &arithmetic_parser::acos},
      {"atan",  &arithmetic_parser::atan},
      {"sinh",  &arithmetic_parser::sinh},
      {"cosh",  &arithmetic_parser::cosh},
      {"tanh",  &arithmetic_parser::tanh},
      {"asinh", &arithmetic_parser::asinh},
      {"acosh", &arithmetic_parser::acosh},
      {"atanh", &arithmetic_parser::atanh},
      {"sqrt",  &arithmetic_parser::sqrt},
      {"exp",   &arithmetic_parser::exp},
      {"ln",    &arithmetic_parser::ln},
      {"erf",   &arithmetic_parser::erf},
      {"erfc",  &arithmetic_parser::erfc},
      {"Gamma", &arithmetic_parser::Gamma},
      {"round", &arithmetic_parser::round} };

  public:
    // split string into a list of tokens and determine token category
    token_list_t tokenize(const QString &str) const {
      // regular expression to separate tokens
      //
      // - starts with zero or more spaces
      // - continues with either
      //   - a number
      //   - an operator
      //   - an opening brace
      //   - a closing brace
      //   - a function name (follwed by a opening brace)
      //   - a variable name
      //   - something else, which is a syntax error
      // - ends with zero or more spaces
      static QRegularExpression words_regex(R"(\s*(([[:digit:]]+\.?[[:digit:]]*)|([-+*/^!])|([(])|([)])|([[:alpha:]]\w*(?=\())|([[:alpha:]]\w*)|(\S+))\s*)");
      //static std::regex words_regex(R"(\s*(([[:digit:]]+\.?[[:digit:]]*)|([-+*/^!])|([(])|([)])|([[:alpha:]]\w*(?=\())|([[:alpha:]]\w*)|(\S+))\s*)",
      //                              std::regex::optimize);
      token_list_t token_list;
      //auto words_end=std::sregex_iterator();
      QRegularExpressionMatchIterator i=words_regex.globalMatch(str);
      //for (std::sregex_iterator i(str.begin(), str.end(), words_regex, std::regex_constants::match_continuous), i_end=std::sregex_iterator(); i!=i_end; ++i) {
      while (i.hasNext()) {
          QRegularExpressionMatch match=i.next();
          if (match.capturedRef(2).length()>0)
            token_list.push_back(token_t(match.captured(2), token_kind::number));
          else if (match.capturedRef(3).length()>0)
            token_list.push_back(token_t(match.captured(3), token_kind::op));
          else if (match.capturedRef(4).length()>0)
            token_list.push_back(token_t(match.captured(4), token_kind::brace_open));
          else if (match.capturedRef(5).length()>0)
            token_list.push_back(token_t(match.captured(5), token_kind::brace_close));
          else if (match.capturedRef(6).length()>0) {
              if (func_map.count(match.captured(6))>0)
                token_list.push_back(token_t(match.captured(6), token_kind::func));
              else
                throw unknow_function();
            } else if (match.capturedRef(7).length()>0)
            token_list.push_back(token_t(match.captured(7), token_kind::var));
          else
            throw syntax_error();
        }
      return token_list;
    }

    // convert token list from infix notation into postfix notation
    // using Dijkstra's shunting-yard algorithm
    token_list_t tokenlist_to_rpn(const token_list_t &token_list) const {
      token_list_t rpn;
      rpn.reserve(token_list.size());
      std::stack<token_t> stack;
      token_kind last_token=token_kind::invalid;
      for (const auto &t: token_list) {
          if (t==token_kind::number or t==token_kind::var)
            rpn.push_back(t);
          else if (t==token_kind::func)
            stack.push(t);
          else if (t==token_kind::op) {
              // check if operator is unary + or -
              if (t=="!")
                stack.push(t);
              else if ((t=="+" or t=="-") and
                       (last_token==token_kind::invalid or
                        last_token==token_kind::brace_open) ) {
                  // suppress unary + or introduce unary - as operator "_"
                  if (t=="-")
                    stack.push(token_t("_", token_kind::op));
                } else {
                  while ((not stack.empty()) and stack.top()==token_kind::op) {
                      if ( (associativity_map.at(t.str())==associativity::left and
                            precedence_map.at(t.str())<=precedence_map.at(stack.top().str())) or
                           (associativity_map.at(t.str())==associativity::right and
                            precedence_map.at(t.str())<precedence_map.at(stack.top().str())) )  {
                          rpn.push_back(stack.top());
                          stack.pop();
                        } else
                        break;
                    }
                  stack.push(t);
                }
            } else if (t==token_kind::brace_open)
            stack.push(t);
          else if (t==token_kind::brace_close) {
              if (last_token==token_kind::brace_open)
                throw syntax_error();
              while (not stack.empty() and not (stack.top()==token_kind::brace_open)) {
                  rpn.push_back(stack.top());
                  stack.pop();
                }
              if (stack.empty())
                throw brace_error();
              stack.pop();
              if (not stack.empty() and stack.top()==token_kind::func) {
                  rpn.push_back(stack.top());
                  stack.pop();
                }
            }
          last_token=t.kind();
        }
      while (not stack.empty()) {
          if (stack.top()==token_kind::brace_open)
            throw brace_error();
          rpn.push_back(stack.top());
          stack.pop();
        }
      return rpn;
    }

  private:
    double get(std::stack<double> &stack) const {
      if (stack.empty())
        throw argument_error();
      double res(stack.top());
      stack.pop();
      return res;
    }
  public:

    double value(const token_list_t &token_list, const var_map_t &vars=var_map_t()) const {
      if (token_list.empty())
        return 0;
      std::stack<double> stack;
      for (const auto &t: token_list) {
          if (t==token_kind::number)
            stack.push(t.str().toDouble());
          else if(t==token_kind::var) {
              auto v=vars.find(t.str());
              if (v!=vars.end())
                stack.push(v->second);
              else
                throw unknow_variable(t.str().toStdString());
            } else if (t==token_kind::op) {
              if (t=="_") {  // unary minus
                  double op1=get(stack);
                  stack.push(-op1);
                } else if (t=="+") {  // binary plus
                  double op2=get(stack);
                  double op1=get(stack);
                  stack.push(op1+op2);
                } else if (t=="-") {  // binary minus
                  double op2=get(stack);
                  double op1=get(stack);
                  stack.push(op1-op2);
                } else if (t=="*") {  // multiplication
                  double op2=get(stack);
                  double op1=get(stack);
                  stack.push(op1*op2);
                } else if (t=="/") {  // division
                  double op2=get(stack);
                  double op1=get(stack);
                  stack.push(op1/op2);
                } else if (t=="^") {  // exponentiation
                  double op2=get(stack);
                  double op1=get(stack);
                  stack.push(std::pow(op1, op2));
                } else if (t=="!") {  // factorial
                  double op1=get(stack);
                  stack.push(std::tgamma(op1+1));
                } else
                throw syntax_error();  // this point should never be reached
            } else if (t==token_kind::func) {
              auto func=func_map.find(t.str());
              if (func!=func_map.end()) {
                  double op1=get(stack);
                  f_pointer f=func->second;
                  stack.push( ((*this).*(f))(op1) );  // call function via member-function pointer
                } else
                throw unknow_function();  // this point should never be reached
            }
        }
      if (stack.size()!=1)
        throw syntax_error();  // ill-formed rpn formula
      return get(stack);
    }

    double value(const QString &str, const var_map_t &vars=var_map_t()) {
      return value(tokenlist_to_rpn(tokenize(str)), vars);
    }

  };

}

#endif
