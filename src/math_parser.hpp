#if !(defined MATH_PARSER_HPP)

#define MATH_PARSER_HPP

#include <iterator>
#include <string>
#include <vector>
#include <deque>
#include <stack>
#include <stdexcept>
#include <cmath>
#include <limits>
#include <algorithm>
#include <QString>
#include <QRegularExpressionMatchIterator>
#include <QDebug>

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

  class comma_error : public error {
  public:
    comma_error() : error("comma error") {
    }
  };

  class argument_error : public error {
  public:
    argument_error() : error("argument error") {
    }
  };

  //--------------------------------------------------------------------

  class token_t {
  public:
    enum class token_kind { invalid, number, op, brace_open, brace_close, func, arg_sep, var };
    token_kind kind_;
    union {
      QString str_;
      double val_;
    };
  public:
    explicit token_t(const QString &str, token_kind kind) : kind_(kind) {
      if (kind_==token_kind::number)
        throw error("invalid value in token");
      new (&str_) QString(str);
    }
    explicit token_t(double val) : kind_(token_kind::number), val_(val) {
    }
    token_t(const token_t &other) : kind_(other.kind_) {
      if (kind_!=token_kind::number)
        new (&str_) QString(other.str_);
      else
        val_=other.val_;
    }
    const QString & str() const {
      if (kind_==token_kind::number)
        throw error("invalid value in token");
      return str_;
    }
    double val() const {
      if (kind_!=token_kind::number)
        throw error("invalid value in token");
      return val_;
    }
    token_kind kind() const {
      return kind_;
    }
    ~token_t() {
      if (kind_!=token_kind::number)
        str_.~QString();
    }
  };

  inline bool operator==(const token_t &token, const QString &str) {
    return token.str()==str;
  }

  inline bool operator!=(const token_t &token, const QString &str) {
    return token.str()!=str;
  }

  inline bool operator==(const token_t &token, const char *str) {
    return token.str()==str;
  }

  inline bool operator!=(const token_t &token, const char *str) {
    return token.str()!=str;
  }

  inline bool operator==(const token_t &token, token_t::token_kind kind) {
    return token.kind()==kind;
  }

  inline bool operator!=(const token_t &token, token_t::token_kind kind) {
    return token.kind()!=kind;
  }

  //--------------------------------------------------------------------

  enum class associativity { left, right };

  //--------------------------------------------------------------------

  class arithmetic_parser {
    typedef std::deque<double> arg_list;
  public:

    typedef token_t::token_kind token_kind;
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
      using base::clear;
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

    double abs(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::abs(x[0]);
    }
    double round(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::round(x[0]);
    }
    double sin(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::sin(x[0]);
    }
    double cos(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::cos(x[0]);
    }
    double tan(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::tan(x[0]);
    }
    double asin(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::asin(x[0]);
    }
    double acos(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::acos(x[0]);
    }
    double atan(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::atan(x[0]);
    }
    double sinh(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::sinh(x[0]);
    }
    double cosh(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::cosh(x[0]);
    }
    double tanh(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::tanh(x[0]);
    }
    double asinh(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::asinh(x[0]);
    }
    double acosh(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::acosh(x[0]);
    }
    double atanh(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::atanh(x[0]);
    }
    double sqrt(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::sqrt(x[0]);
    }
    double exp(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::exp(x[0]);
    }
    double ln(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::log(x[0]);
    }
    double log(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::log10(x[0]);
    }
    double erf(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::erf(x[0]);
    }
    double erfc(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::erfc(x[0]);
    }
    double normal(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return 0.5+0.5*std::erf(0.70710678118654752440*x[0]);
    }
    double invnormal(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      double res=0;
      if (x[0]<0 or x[0]>1)
        return std::numeric_limits<double>::quiet_NaN();
      if (x[0]==0)
        return -std::numeric_limits<double>::infinity();
      if (x[0]==1)
        return -std::numeric_limits<double>::infinity();
      for (int i=0; i<128; ++i) {
        double f =0.5+0.5*std::erf(0.70710678118654752440*res)-x[0];
        double f1=0.39894228040143267794*std::exp(-0.5*res*res);
        double f2=-f1*res;
        res-=f/f1*(1-f*f2/(2*f1*f1));
        if (std::abs(f/f1)<std::numeric_limits<double>::epsilon())
          break;
      }
      return res;
    }
    double Gamma(const arg_list &x) const {
      if (x.size()!=1)
        throw argument_error();
      return std::tgamma(x[0]);
    }
    double Beta(const arg_list &x) const {
      if (x.size()!=2)
        throw argument_error();
      return std::exp(std::lgamma(x[0])+std::lgamma(x[1])-std::lgamma(x[0]+x[1]));
    }
    double binomial(const arg_list &x) const {
      if (x.size()!=2)
        throw argument_error();
      double res=std::exp(std::lgamma(x[0]+1)-std::lgamma(x[1]+1)-std::lgamma(x[0]-x[1]+1));
      if (std::round(x[0])==x[0] and std::round(x[1])==x[1])
        res=std::round(res);
      return res;
    }
    double min(const arg_list &x) const {
      if (x.size()==0)
        throw argument_error();
      return *std::min_element(x.begin(), x.end());
    }
    double max(const arg_list &x) const {
      if (x.size()==0)
        throw argument_error();
      return *std::max_element(x.begin(), x.end());
    }
    double mean(const arg_list &x) const {
      if (x.size()==0)
        throw argument_error();
      double res=0;
      for (auto v: x)
        res+=v;
      return res/x.size();
    }
    double var(const arg_list &x) const {
      if (x.size()<2)
        throw argument_error();
      double mu=mean(x);
      double res=0;
      for (auto v: x)
        res+=(v-mu)*(v-mu);
      return res/(x.size()-1);
    }
    double std(const arg_list &x) const {
      return std::sqrt(var(x));
    }

    typedef double(arithmetic_parser::*f_pointer)(const arg_list &) const;

    const std::map<QString, f_pointer> func_map=
      { {"abs",       &arithmetic_parser::abs       },
        {"round",     &arithmetic_parser::round     },
        {"sin",       &arithmetic_parser::sin       },
        {"cos",       &arithmetic_parser::cos       },
        {"tan",       &arithmetic_parser::tan       },
        {"asin",      &arithmetic_parser::asin      },
        {"acos",      &arithmetic_parser::acos      },
        {"atan",      &arithmetic_parser::atan      },
        {"sinh",      &arithmetic_parser::sinh      },
        {"cosh",      &arithmetic_parser::cosh      },
        {"tanh",      &arithmetic_parser::tanh      },
        {"asinh",     &arithmetic_parser::asinh     },
        {"acosh",     &arithmetic_parser::acosh     },
        {"atanh",     &arithmetic_parser::atanh     },
        {"sqrt",      &arithmetic_parser::sqrt      },
        {"exp",       &arithmetic_parser::exp       },
        {"ln",        &arithmetic_parser::ln        },
        {"log",       &arithmetic_parser::log       },
        {"erf",       &arithmetic_parser::erf       },
        {"erfc",      &arithmetic_parser::erfc      },
        {"normal",    &arithmetic_parser::normal    },
        {"invnormal", &arithmetic_parser::invnormal },
        {"Gamma",     &arithmetic_parser::Gamma     },
        {"Beta",      &arithmetic_parser::Beta      },
        {"binomial",  &arithmetic_parser::binomial  },
        {"min",       &arithmetic_parser::min       },
        {"max",       &arithmetic_parser::max       },
        {"mean",      &arithmetic_parser::mean      },
        {"var",       &arithmetic_parser::var       },
        {"std",       &arithmetic_parser::std       } };

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
      //   - a function argument separator
      //   - a variable name
      //   - something else, which is a syntax error
      // - ends with zero or more spaces
      static QRegularExpression words_regex(R"(\s*(([[:digit:]]+\.?[[:digit:]]*)|([-+*/^!])|([(])|([)])|([[:alpha:]]\w*(?=\())|(,)|([[:alpha:]]\w*)|(\S+))\s*)");
      token_list_t token_list;
      QRegularExpressionMatchIterator i=words_regex.globalMatch(str);
      while (i.hasNext()) {
        QRegularExpressionMatch match=i.next();
        if (match.capturedRef(2).length()>0)
          token_list.push_back(token_t(match.captured(2).toDouble()));
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
          token_list.push_back(token_t(match.captured(7), token_kind::arg_sep));
        else if (match.capturedRef(8).length()>0)
          token_list.push_back(token_t(match.captured(8), token_kind::var));
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
      std::stack<int> arg_counter;
      token_kind last_token=token_kind::invalid;
      for (const auto &t: token_list) {
        if (t==token_kind::number or t==token_kind::var)
          // numbers and variables just go to the output
          rpn.push_back(t);
        else if (t==token_kind::func) {
          // functions go to the stack
          stack.push(t);
          // put a counter for argument seperators of the argument counter stack
          arg_counter.push(0);
        } else if (t==token_kind::arg_sep) {
          // there was no corresponding function token before, throw error
          if (arg_counter.empty())
            throw comma_error();
          arg_counter.top()+=1;
          // pop all tokens from stack until opening brace is found
          while ((not stack.empty()) and stack.top()!=token_kind::brace_open) {
            rpn.push_back(stack.top());
            stack.pop();
          }
          // throw error when no corresponding opening brace was found
          if (stack.empty())
            throw brace_error();
        } else if (t==token_kind::op) {
          // check if operator is unary !
          if (t=="!")
            stack.push(t);
          // check if operator is unary + or -
          else if ((t=="+" or t=="-") and
                   (last_token==token_kind::brace_open or
                    last_token==token_kind::arg_sep or
                    last_token==token_kind::invalid) ) {
            // suppress unary + or introduce unary - as operator "_"
            if (t=="-")
              stack.push(token_t("_", token_kind::op));
          } else {
            // in case of binary operators remove operators from stack
            while (not stack.empty() and stack.top()==token_kind::op) {
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
          // opening braces just go to the stack
          stack.push(t);
        else if (t==token_kind::brace_close) {
          // pop all tokens from stack until opening brace is found
          while (not stack.empty() and stack.top()!=token_kind::brace_open) {
            rpn.push_back(stack.top());
            stack.pop();
          }
          // throw error when no corresponding opening brace was found
          if (stack.empty())
            throw brace_error();
          stack.pop();  // remove opening brace from stack
          // if pair of braces marks function arguments put out number of
          // function arguments as an extra arguments, remove function from
          // stack, remove argument counter from stack
          if (not stack.empty() and stack.top()==token_kind::func) {
            rpn.push_back(token_t(arg_counter.top()+1.));  // number of function arguments
            arg_counter.pop();
            rpn.push_back(stack.top());
            stack.pop();
          }
        }
        last_token=t.kind();
      }
      // remove remaining items from stack
      while (not stack.empty()) {
        // raise error, when there is a opening brace without matching closing brace
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
          stack.push(t.val());
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
            double res=std::tgamma(op1+1);
            if (std::round(op1)==op1)
              res=std::round(res);
            stack.push(res);
          } else
            throw syntax_error();  // this point should never be reached
        } else if (t==token_kind::func) {
          auto func=func_map.find(t.str());
          if (func==func_map.end())
            throw unknow_function();  // this point should never be reached
          arg_list x;
          int num_arguments(get(stack));
          for (int i=0; i<num_arguments; ++i)
            x.push_front(get(stack));
          f_pointer f=func->second;
          stack.push( ((*this).*(f))(x) );  // call function via member-function pointer
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
