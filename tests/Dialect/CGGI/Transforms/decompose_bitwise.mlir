// RUN: heir-opt --cggi-decompose-operations %s | FileCheck %s

#encoding = #lwe.unspecified_bit_field_encoding<cleartext_bitwidth = 3>
!ct_ty = !lwe.lwe_ciphertext<encoding = #encoding>

// CHECK: @and
// CHECK-SAME: %[[arg0:.*]]: ![[ct:.*]], %[[arg1:.*]]: ![[ct]]
func.func @and(%arg0: !ct_ty, %arg1: !ct_ty) -> !ct_ty {
  // CHECK: %[[shift:.*]] = cggi.sshl %[[arg1]] {shiftAmount = 1 : index}
  // CHECK: %[[add:.*]] = lwe.add %[[shift]], %[[arg0]]
  // CHECK: %[[pbs:.*]] = cggi.programmable_bootstrap %[[add]] {lookup_table = 8 : ui4}
  // CHECK: return %[[pbs]]
  %r1 = cggi.and %arg0, %arg1 {lookup_table = 8 : ui8} : !ct_ty
  return %r1 : !ct_ty
}

// CHECK: @xor
// CHECK-SAME: %[[arg0:.*]]: ![[ct:.*]], %[[arg1:.*]]: ![[ct]]
func.func @xor(%arg0: !ct_ty, %arg1: !ct_ty) -> !ct_ty {
  // CHECK: %[[shift:.*]] = cggi.sshl %[[arg1]] {shiftAmount = 1 : index}
  // CHECK: %[[add:.*]] = lwe.add %[[shift]], %[[arg0]]
  // CHECK: %[[pbs:.*]] = cggi.programmable_bootstrap %[[add]] {lookup_table = 6 : ui4}
  // CHECK: return %[[pbs]]
  %r1 = cggi.xor %arg0, %arg1 : !ct_ty
  return %r1 : !ct_ty
}

// CHECK: @or
// CHECK-SAME: %[[arg0:.*]]: ![[ct:.*]], %[[arg1:.*]]: ![[ct]]
func.func @or(%arg0: !ct_ty, %arg1: !ct_ty) -> !ct_ty {
  // CHECK: %[[shift:.*]] = cggi.sshl %[[arg1]] {shiftAmount = 1 : index}
  // CHECK: %[[add:.*]] = lwe.add %[[shift]], %[[arg0]]
  // CHECK: %[[pbs:.*]] = cggi.programmable_bootstrap %[[add]] {lookup_table = 14 : ui4}
  // CHECK: return %[[pbs]]
  %r1 = cggi.or %arg0, %arg1 {coefficients = array<i32: 3, 6>, lookup_table = 68 : index} : !ct_ty
  return %r1 : !ct_ty
}
