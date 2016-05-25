import QtQuick 2.0
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
      FunctionDoc {
        functionText: "abs(x)"
        descriptionText: qsTr("abs_description")
      }
      FunctionDoc {
        functionText: "round(x)"
        descriptionText: qsTr("round_description")
      }
      FunctionDoc {
        functionText: "floor(x)"
        descriptionText: qsTr("foor_description")
      }
      FunctionDoc {
        functionText: "ceil(x)"
        descriptionText: qsTr("ceil_description")
      }
      FunctionDoc {
        functionText: "mod(x, y)"
        descriptionText: qsTr("mod_description")
      }
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
        functionText: "asin(x)"
        descriptionText: qsTr("asin_description")
      }
      FunctionDoc {
        functionText: "acos(x)"
        descriptionText: qsTr("acos_description")
      }
      FunctionDoc {
        functionText: "atan(x)"
        descriptionText: qsTr("atan_description")
      }
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
        functionText: "sqrt(x)"
        descriptionText: qsTr("sqrt_description")
      }
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
        functionText: "Gamma(x)"
        descriptionText: qsTr("Gamma_description")
      }
      FunctionDoc {
        functionText: "Beta(x, y)"
        descriptionText: qsTr("Beta_description")
      }
      FunctionDoc {
        functionText: "binomial(x, y)"
        descriptionText: qsTr("binomial_description")
      }
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
    }

  }

}
