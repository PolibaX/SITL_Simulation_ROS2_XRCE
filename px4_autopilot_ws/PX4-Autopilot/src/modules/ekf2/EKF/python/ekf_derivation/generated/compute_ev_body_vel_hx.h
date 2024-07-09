// -----------------------------------------------------------------------------
// This file was autogenerated by symforce from template:
//     function/FUNCTION.h.jinja
// Do NOT modify by hand.
// -----------------------------------------------------------------------------

#pragma once

#include <matrix/math.hpp>

namespace sym {

/**
 * This function was autogenerated from a symbolic function. Do not modify by hand.
 *
 * Symbolic function: compute_ev_body_vel_hx
 *
 * Args:
 *     state: Matrix25_1
 *
 * Outputs:
 *     H: Matrix24_1
 */
template <typename Scalar>
void ComputeEvBodyVelHx(const matrix::Matrix<Scalar, 25, 1>& state,
                        matrix::Matrix<Scalar, 24, 1>* const H = nullptr) {
  // Total ops: 60

  // Input arrays

  // Intermediate terms (13)
  const Scalar _tmp0 = 2 * state(5, 0);
  const Scalar _tmp1 = 2 * state(6, 0);
  const Scalar _tmp2 = _tmp0 * state(3, 0) - _tmp1 * state(2, 0);
  const Scalar _tmp3 = (Scalar(1) / Scalar(2)) * state(1, 0);
  const Scalar _tmp4 =
      (Scalar(1) / Scalar(2)) * _tmp0 * state(2, 0) + (Scalar(1) / Scalar(2)) * _tmp1 * state(3, 0);
  const Scalar _tmp5 = 4 * state(4, 0);
  const Scalar _tmp6 = 2 * state(1, 0);
  const Scalar _tmp7 = _tmp0 * state(0, 0) - _tmp5 * state(3, 0) + _tmp6 * state(6, 0);
  const Scalar _tmp8 = (Scalar(1) / Scalar(2)) * _tmp7;
  const Scalar _tmp9 = 2 * state(0, 0);
  const Scalar _tmp10 = _tmp0 * state(1, 0) - _tmp5 * state(2, 0) - _tmp9 * state(6, 0);
  const Scalar _tmp11 = (Scalar(1) / Scalar(2)) * _tmp10;
  const Scalar _tmp12 = (Scalar(1) / Scalar(2)) * _tmp2;

  // Output terms (1)
  if (H != nullptr) {
    matrix::Matrix<Scalar, 24, 1>& _h = (*H);

    _h.setZero();

    _h(0, 0) = -_tmp11 * state(3, 0) - _tmp2 * _tmp3 + _tmp4 * state(0, 0) + _tmp8 * state(2, 0);
    _h(1, 0) = _tmp11 * state(0, 0) - _tmp12 * state(2, 0) - _tmp3 * _tmp7 + _tmp4 * state(3, 0);
    _h(2, 0) = _tmp10 * _tmp3 - _tmp12 * state(3, 0) - _tmp4 * state(2, 0) + _tmp8 * state(0, 0);
    _h(3, 0) = -2 * std::pow(state(2, 0), Scalar(2)) - 2 * std::pow(state(3, 0), Scalar(2)) + 1;
    _h(4, 0) = _tmp6 * state(2, 0) + _tmp9 * state(3, 0);
    _h(5, 0) = _tmp6 * state(3, 0) - _tmp9 * state(2, 0);
  }
}  // NOLINT(readability/fn_size)

// NOLINTNEXTLINE(readability/fn_size)
}  // namespace sym
