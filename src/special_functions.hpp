#ifndef SPECIAL_FUNCTIONS_HPP

#define SPECIAL_FUNCTIONS_HPP

#include <limits>
#include <cmath>
#include <algorithm>
#include <utility>
#include <cerrno>

namespace math {

  using std::abs;
  using std::sqrt;
  using std::pow;
  using std::exp;

  using std::numeric_limits;

  // --- natural logarithm -------------------------------------------

  inline float ln(float x) {
    return std::log(x);
  }

  inline double ln(double x) {
    return std::log(x);
  }

  inline long double ln(long double x) {
    return std::log(x);
  }

  // --- log-Gamma function ------------------------------------------

  inline float ln_Gamma(float x) {
    return std::lgamma(x);
  }

  inline double ln_Gamma(double x) {
    return std::lgamma(x);
  }

  inline long double ln_Gamma(long double x) {
    return std::lgamma(x);
  }

  // --- Beta function -----------------------------------------------

  inline float Beta(float x, float y) {
    return exp(ln_Gamma(x) + ln_Gamma(y) - ln_Gamma(x + y));
  }

  inline double Beta(double x, double y) {
    return exp(ln_Gamma(x) + ln_Gamma(y) - ln_Gamma(x + y));
  }

  inline long double Beta(long double x, long double y) {
    return exp(ln_Gamma(x) + ln_Gamma(y) - ln_Gamma(x + y));
  }

  // --- Gamma function ----------------------------------------------

  inline float Gamma(float x) {
    return std::tgamma(x);
  }

  inline double Gamma(double x) {
    return std::tgamma(x);
  }

  inline long double Gamma(long double x) {
    return std::tgamma(x);
  }

  // --- incomplete Gamma functions ----------------------------------

  namespace detail {

    // compute incomplete Gamma function
    //
    //  gamma(a, x) = Int(exp(-t)*t^(a-1), t=0..x)
    //
    // or
    //
    //  P(a, x) = gamma(a, x) / Gamma(a)
    //
    // by series expansion
    template<typename T, bool by_Gamma_a>
    T GammaP_ser(T a, T x) {
      const int itmax{32};
      const T eps{T{4} * numeric_limits<T>::epsilon()};
      if (x < eps)
        return T{0};
      T xx{T{1} / a}, n{a}, sum{xx};
      int i{0};
      do {
        ++n;
        ++i;
        xx *= x / n;
        sum += xx;
      } while (abs(xx) > eps * abs(sum) and i < itmax);
      if (by_Gamma_a)
        return exp(-x + a * ln(x) - math::ln_Gamma(a)) * sum;
      return exp(-x + a * ln(x)) * sum;
    }

    // compute complementary incomplete Gamma function
    //
    //  Gamma(a, x) = Int(exp(-t)*t^(a-1), t=x..oo)
    //
    // or
    //
    //  Q(a, x) = Gamma(a, x) / Gamma(a) = 1 - P(a, x)
    //
    // by continued fraction
    template<typename T, bool by_Gamma_a>
    T GammaQ_cf(T a, T x) {
      const T itmax{T{32}};
      const T eps{T{4} * numeric_limits<T>::epsilon()};
      const T min{T{4} * numeric_limits<T>::min()};
      // set up for evaluating continued fraction by modied Lentz's method
      T del, ai, bi{x + T{1} - a}, ci{T{1} / min}, di{T{1} / bi}, h{di}, i{T{0}};
      do {  // iterate
        ++i;
        ai = -i * (i - a);
        bi += T{2};
        di = ai * di + bi;
        if (abs(di) < min)
          di = min;
        ci = bi + ai / ci;
        if (abs(ci) < min)
          ci = min;
        di = T{1} / di;
        del = di * ci;
        h *= del;
      } while ((abs(del - T{1}) > eps) and i < itmax);
      if (by_Gamma_a)
        return exp(-x + a * ln(x) - math::ln_Gamma(a)) * h;
      return exp(-x + a * ln(x)) * h;
    }

    // P(a, x) and gamma(a, x)
    template<typename T, bool by_Gamma_a>
    T GammaP(T a, T x) {
      if (x < T{0} or a <= T{0})
        return numeric_limits<T>::signaling_NaN();
      if (by_Gamma_a) {
        if (x < a + T{1})
          return GammaP_ser<T, by_Gamma_a>(a, x);
        return T{1} - GammaQ_cf<T, by_Gamma_a>(a, x);
      }
      if (x < a + T{1})
        return GammaP_ser<T, by_Gamma_a>(a, x);
      return math::Gamma(a) - GammaQ_cf<T, by_Gamma_a>(a, x);
    }

    // Q(a, x) and Gamma(a, x)
    template<typename T, bool by_Gamma_a>
    T GammaQ(T a, T x) {
      if (x < T{0} or a <= T{0})
        return numeric_limits<T>::signaling_NaN();
      if (by_Gamma_a) {
        if (x < a + T{1})
          return T{1} - GammaP_ser<T, by_Gamma_a>(a, x);
        return GammaQ_cf<T, by_Gamma_a>(a, x);
      }
      if (x < a + T{1})
        return math::Gamma(a) - GammaP_ser<T, by_Gamma_a>(a, x);
      return GammaQ_cf<T, by_Gamma_a>(a, x);
    }

  }  // namespace detail

  // P(x, a)
  inline float GammaP(float a, float x) {
    return detail::GammaP<float, true>(a, x);
  }

  inline double GammaP(double a, double x) {
    return detail::GammaP<double, true>(a, x);
  }

  inline long double GammaP(long double a, long double x) {
    return detail::GammaP<long double, true>(a, x);
  }

  // Q(x, a)
  inline float GammaQ(float a, float x) {
    return detail::GammaQ<float, true>(a, x);
  }

  inline double GammaQ(double a, double x) {
    return detail::GammaQ<double, true>(a, x);
  }

  inline long double GammaQ(long double a, long double x) {
    return detail::GammaQ<long double, true>(a, x);
  }

  // gamma(x, a)
  inline float inc_gamma(float a, float x) {
    return detail::GammaP<float, false>(a, x);
  }

  inline double inc_gamma(double a, double x) {
    return detail::GammaP<double, false>(a, x);
  }

  inline long double inc_gamma(long double a, long double x) {
    return detail::GammaP<long double, false>(a, x);
  }

  // Gamma(x, a)
  inline float cinc_gamma(float a, float x) {
    return detail::GammaQ<float, false>(a, x);
  }

  inline double cinc_gamma(double a, double x) {
    return detail::GammaQ<double, false>(a, x);
  }

  inline long double cinc_gamma(long double a, long double x) {
    return detail::GammaQ<long double, false>(a, x);
  }

  namespace detail {

    template<typename T>

    T inv_GammaP(T a, T p) {
      const T eps = sqrt(numeric_limits<T>::epsilon()), a1 = a - T{1}, glna = math::ln_Gamma(a),
              lna1 = ln(a1), afac = exp(a1 * (lna1 - T{1}) - glna);
      T x, t;
      // initial guess
      if (a > T{1}) {
        const T pp{p < T{1} / T{2} ? p : T{1} - p};
        t = sqrt(-T{2} * ln(pp));
        x = static_cast<T>((2.30753 + t * 0.27061) / (1.0 + t * (0.99229 + t * 0.04481)) - t);
        x = p < T{1} / T{2} ? -x : x;
        x = std::max(T{1} / T{1000},
                     a * pow(T{1} - T{1} / (T{9} * a) - x / (T{3} * sqrt(a)), T{3}));
      } else {
        t = static_cast<T>(1.0 - a * (0.253 + a * 0.12));
        x = p < t ? (pow(p / t, T{1} / a)) : (T{1} - ln(T{1} - (p - t) / (T{1} - t)));
      }
      // refinement by Halley's method
      for (int i = 0; i < 16; ++i) {
        if (x < T{0}) {
          x = T{0};
          break;
        }
        const T err{GammaP<T, true>(a, x) - p};
        if (a > T{1})
          t = afac * exp(-(x - a1) + a1 * (ln(x) - lna1));
        else
          t = exp(-x + a1 * ln(x) - glna);
        const T u = err / t;
        t = u / (T{1} - std::min(T{1}, u * ((a - T{1}) / x - T{1})) / T{2});
        x -= t;
        x = x <= T{0} ? (x + t) / T{2} : x;
        if (abs(t) < eps * x)
          break;
      }
      return x;
    }

  }  // namespace detail

  // inverse of GammaP
  inline float inv_GammaP(float a, float p) {
    return detail::inv_GammaP(a, p);
  }

  inline double inv_GammaP(double a, double p) {
    return detail::inv_GammaP(a, p);
  }

  inline long double inv_GammaP(long double a, long double p) {
    return detail::inv_GammaP(a, p);
  }

  // see Applied Statistics (1973), vol.22, no.3, pp.409--411
  // algorithm AS 63
  namespace detail {

    template<typename T>
    T Beta_I(T x, T p, T q, T norm) {
      using std::swap;
      if (p <= 0 or q <= 0 or x < 0 or x > 1) {
        errno = EDOM;
        return numeric_limits<T>::quiet_NaN();
      }
      const T eps{4 * numeric_limits<T>::epsilon()};
      T psq{p + q}, cx{1 - x};
      bool flag{p < psq * x};
      if (flag) {
        // use  I(x, p, q) = 1-I(1-x, q, p)
        swap(x, cx);
        swap(p, q);
      }
      T term{1}, i{1}, y{1}, rx{x / cx}, temp{q - i};
      int s{static_cast<int>(q + cx * psq)};
      if (s == 0)
        rx = x;
      while (true) {
        term *= temp * rx / (p + i);
        y += term;
        temp = abs(term);
        if (temp <= eps and temp <= eps * y)
          break;
        i++;
        s--;
        if (s >= 0) {
          temp = q - i;
          if (s == 0)
            rx = x;
        } else {
          temp = psq;
          psq++;
        }
      }
      y *= exp(p * ln(x) + (q - 1) * ln(cx)) / p / norm;
      if (flag)
        y = 1 - y;
      return y;
    }

  }  // namespace detail

  inline float Beta_I(float x, float p, float q, float norm) {
    return detail::Beta_I(x, p, q, norm);
  }

  inline float Beta_I(float x, float p, float q) {
    return detail::Beta_I(x, p, q, Beta(p, q));
  }

  inline double Beta_I(double x, double p, double q, double norm) {
    return detail::Beta_I(x, p, q, norm);
  }

  inline double Beta_I(double x, double p, double q) {
    return detail::Beta_I(x, p, q, Beta(p, q));
  }

  inline long double Beta_I(long double x, long double p, long double q, long double norm) {
    return detail::Beta_I(x, p, q, norm);
  }

  inline long double Beta_I(long double x, long double p, long double q) {
    return detail::Beta_I(x, p, q, Beta(p, q));
  }

}  // namespace math

#endif  // SPECIAL_FUNCTIONS_HPP
