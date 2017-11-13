import QtQuick 2.2
import Sailfish.Silica 1.0
import "../components"

Page {
  id: functions_page

  SilicaFlickable {
    anchors.fill: parent
    contentHeight: column.height

    Column {
      id: column

      width: parent.width
      spacing: 0
      PageHeader {
        title: qsTr("List of functions")
      }
      SectionHeader { text: qsTr("Basic functions") }
      FunctionDoc {
        functionText: "abs(x)"
        descriptionText: qsTr("abs_description")
      }
      FunctionDoc {
        functionText: "mod(x, y)"
        descriptionText: qsTr("mod_description")
      }
      FunctionDoc {
        functionText: "sqrt(x)"
        descriptionText: qsTr("sqrt_description")
      }
      SectionHeader { text: qsTr("Rounding functions") }
      FunctionDoc {
        functionText: "round(x)"
        descriptionText: qsTr("round_description")
      }
      FunctionDoc {
        functionText: "floor(x)"
        descriptionText: qsTr("floor_description")
      }
      FunctionDoc {
        functionText: "ceil(x)"
        descriptionText: qsTr("ceil_description")
      }
      SectionHeader { text: qsTr("Trigonometric functions") }
      FunctionDoc {
        functionText: "sin(x)"
        descriptionText: qsTr("sin_description")
      }
      FunctionDoc {
        functionText: "cos(x)"
        descriptionText: qsTr("cos_description")
      }
      FunctionDoc {
        functionText: "tan(x)"
        descriptionText: qsTr("tan_description")
      }
      FunctionDoc {
        functionText: "cot(x)"
        descriptionText: qsTr("cot_description")
      }
      SectionHeader { text: qsTr("Inverse trigonometric functions") }
      FunctionDoc {
        functionText: "asin(x)"
        descriptionText: qsTr("asin_description")
      }
      FunctionDoc {
        functionText: "acos(x)"
        descriptionText: qsTr("acos_description")
      }
      FunctionDoc {
        functionText: "atan(x), atan(y, x)"
        descriptionText: qsTr("atan_description")
      }
      FunctionDoc {
        functionText: "acot(x)"
        descriptionText: qsTr("acot_description")
      }
      SectionHeader { text: qsTr("Hyperbolic functions") }
      FunctionDoc {
        functionText: "sinh(x)"
        descriptionText: qsTr("sinh_description")
      }
      FunctionDoc {
        functionText: "cosh(x)"
        descriptionText: qsTr("cosh_description")
      }
      FunctionDoc {
        functionText: "tanh(x)"
        descriptionText: qsTr("tanh_description")
      }
      FunctionDoc {
        functionText: "coth(x)"
        descriptionText: qsTr("coth_description")
      }
      SectionHeader { text: qsTr("Inverse hyperbolic functions") }
      FunctionDoc {
        functionText: "asinh(x)"
        descriptionText: qsTr("asinh_description")
      }
      FunctionDoc {
        functionText: "acosh(x)"
        descriptionText: qsTr("acosh_description")
      }
      FunctionDoc {
        functionText: "atanh(x)"
        descriptionText: qsTr("atanh_description")
      }
      FunctionDoc {
        functionText: "acoth(x)"
        descriptionText: qsTr("acoth_description")
      }
      SectionHeader { text: qsTr("Exponential and related functions") }
      FunctionDoc {
        functionText: "exp(x)"
        descriptionText: qsTr("exp_description")
      }
      FunctionDoc {
        functionText: "ln(x)"
        descriptionText: qsTr("ln_description")
      }
      FunctionDoc {
        functionText: "log(x), log(x, b)"
        descriptionText: qsTr("log_description")
      }
      SectionHeader { text: qsTr("Error functions and related functions") }
      FunctionDoc {
        functionText: "erf(x)"
        descriptionText: qsTr("erf_description")
      }
      FunctionDoc {
        functionText: "erfc(x)"
        descriptionText: qsTr("erfc_description")
      }
      FunctionDoc {
        functionText: "normal(x)"
        descriptionText: qsTr("normal_description")
      }
      FunctionDoc {
        functionText: "invnormal(x)"
        descriptionText: qsTr("invnormal_description")
      }
      FunctionDoc {
        functionText: "Studentt(n, x)"
        descriptionText: qsTr("Studentt_description")
      }
      FunctionDoc {
        functionText: "invStudentt(n, x)"
        descriptionText: qsTr("invStudentt_description")
      }
      SectionHeader { text: qsTr("Gamma function and related functions") }
      FunctionDoc {
        functionText: "Gamma(x), Gamma(a, x)"
        descriptionText: qsTr("Gamma_description")
      }
      FunctionDoc {
        functionText: "gamma(a, x)"
        descriptionText: qsTr("gamma_description")
      }
      FunctionDoc {
        functionText: "Beta(x, y)"
        descriptionText: qsTr("Beta_description")
      }
      FunctionDoc {
        functionText: "binomial(x, y)"
        descriptionText: qsTr("binomial_description")
      }
      SectionHeader { text: qsTr("Statistical functions") }      
      FunctionDoc {
        functionText: "min(x1, x2, ...)"
        descriptionText: qsTr("min_description")
      }
      FunctionDoc {
        functionText: "max(x1, x2, ...)"
        descriptionText: qsTr("max_description")
      }
      FunctionDoc {
        functionText: "mean(x1, x2, ...)"
        descriptionText: qsTr("mean_description")
      }
      FunctionDoc {
        functionText: "var(x1, x2, ...)"
        descriptionText: qsTr("var_description")
      }
      FunctionDoc {
        functionText: "std(x1, x2, ...)"
        descriptionText: qsTr("std_description")
      }
      FunctionDoc {
        functionText: "median(x1, x2, ...)"
        descriptionText: qsTr("median_description")
      }
    }

  }

}
