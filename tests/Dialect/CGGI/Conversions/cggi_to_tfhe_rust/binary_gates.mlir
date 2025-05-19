// RUN: heir-opt --cggi-decompose-operations --cggi-to-tfhe-rust -cse %s | FileCheck %s --check-prefixes=CHECK,CHECK-COMMON
// RUN: heir-opt --cggi-to-tfhe-rust -cse %s | FileCheck %s --check-prefixes=CHECK-GATES,CHECK-COMMON

#encoding = #lwe.unspecified_bit_field_encoding<cleartext_bitwidth = 3>
!ct_ty = !lwe.lwe_ciphertext<encoding = #encoding>
!pt_ty = !lwe.lwe_plaintext<encoding = #encoding>
// CHECK-COMMON: @binary_gates
// CHECK-COMMON-SAME: %[[sks:.*]]: [[sks_ty:!tfhe_rust.server_key]], %[[arg1:.*]]: [[ct_ty:!tfhe_rust.eui3]], %[[arg2:.*]]: [[ct_ty]]
func.func @binary_gates(%arg1: !ct_ty, %arg2: !ct_ty) -> (!ct_ty) {
  // CHECK-DAG: %[[v0:.*]] = tfhe_rust.generate_lookup_table %[[sks]] {truthTable = 8 : ui4}
  // CHECK-DAG: %[[v1:.*]] = tfhe_rust.scalar_left_shift %[[sks]], %[[arg2]] {shiftAmount = 1 : index}
  // CHECK-DAG: %[[v2:.*]] = tfhe_rust.add %[[sks]], %[[v1]], %[[arg1]]
  // CHECK: %[[v3:.*]] = tfhe_rust.apply_lookup_table %[[sks]], %[[v2]], %[[v0]]
  // CHECK-GATES: %[[v0:.*]] = tfhe_rust.bitand %[[sks]], %[[arg1]], %[[arg2]]
  %0 = cggi.and %arg1, %arg2 : !ct_ty

  // CHECK: %[[v4:.*]] = tfhe_rust.generate_lookup_table %[[sks]] {truthTable = 14 : ui4}
  // CHECK: %[[v5:.*]] = tfhe_rust.apply_lookup_table %[[sks]], %[[v2]], %[[v4]]
  // (reuses shifted inputs from the AND)
  // CHECK-GATES: %[[v1:.*]] = tfhe_rust.bitor %[[sks]], %[[arg1]], %[[arg2]]
  %1 = cggi.or %arg1, %arg2 : !ct_ty

  // CHECK-COMMON: %[[notConst:.*]] = arith.constant 1 : i3
  // CHECK-COMMON: %[[v6:.*]] = tfhe_rust.create_trivial %[[sks]], %[[notConst]]
  // CHECK: %[[v7:.*]] = tfhe_rust.sub %[[sks]], %[[v6]], %[[v5]]
  // CHECK-GATES: %[[v2:.*]] = tfhe_rust.sub %[[sks]], %[[v6]], %[[v1]]
  %2 = cggi.not %1 : !ct_ty

  // CHECK: %[[v9:.*]] = tfhe_rust.scalar_left_shift %[[sks]], %[[v3]] {shiftAmount = 1 : index}
  // CHECK: %[[v10:.*]] = tfhe_rust.add %[[sks]], %[[v9]], %[[v7]]
  // CHECK: %[[v8:.*]] = tfhe_rust.generate_lookup_table %[[sks]] {truthTable = 6 : ui4}
  // CHECK: %[[v11:.*]] = tfhe_rust.apply_lookup_table %[[sks]], %[[v10]], %[[v8]]
  // CHECK-GATES: %[[v3:.*]] = tfhe_rust.bitxor %[[sks]], %[[v2]], %[[v0]]
  %3 = cggi.xor %2, %0 : !ct_ty

  // CHECK: return %[[v11]]
  // CHECK-GATES: return %[[v3]]
  return %3 : !ct_ty
}
