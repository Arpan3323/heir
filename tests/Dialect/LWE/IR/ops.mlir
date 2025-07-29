// RUN: heir-opt %s | FileCheck %s

!Z1095233372161_i64_ = !mod_arith.int<1095233372161 : i64>
!Z65537_i64_ = !mod_arith.int<65537 : i64>

!rns_L0_ = !rns.rns<!Z1095233372161_i64_>

#ring_Z65537_i64_1_x1024_ = #polynomial.ring<coefficientType = !Z65537_i64_, polynomialModulus = <1 + x**1024>>
#ring_rns_L0_1_x1024_ = #polynomial.ring<coefficientType = !rns_L0_, polynomialModulus = <1 + x**1024>>

#full_crt_packing_encoding = #lwe.full_crt_packing_encoding<scaling_factor = 0>
#key = #lwe.key<>

#modulus_chain_L5_C0_ = #lwe.modulus_chain<elements = <1095233372161 : i64, 1032955396097 : i64, 1005037682689 : i64, 998595133441 : i64, 972824936449 : i64, 959939837953 : i64>, current = 0>

#plaintext_space = #lwe.plaintext_space<ring = #ring_Z65537_i64_1_x1024_, encoding = #full_crt_packing_encoding>

#ciphertext_space_L0_ = #lwe.ciphertext_space<ring = #ring_rns_L0_1_x1024_, encryption_type = lsb>
#ciphertext_space_L0_D10_ = #lwe.ciphertext_space<ring = #ring_rns_L0_1_x1024_, encryption_type = lsb, size = 10>

!pt = !lwe.lwe_plaintext<application_data = <message_type = i3>, plaintext_space = #plaintext_space>
!ct = !lwe.lwe_ciphertext<application_data = <message_type = i3>, plaintext_space = #plaintext_space, ciphertext_space = #ciphertext_space_L0_, key = #key, modulus_chain = #modulus_chain_L5_C0_>
!sk = !lwe.lwe_secret_key<key = #key, ring = #ring_rns_L0_1_x1024_>

func.func @test_encrypt(%arg0: tensor<32xi3>, %arg1: !sk) -> !ct {
  %0 = lwe.rlwe_encode %arg0 {encoding = #full_crt_packing_encoding, ring = #ring_Z65537_i64_1_x1024_} : tensor<32xi3> -> !pt
  // CHECK: lwe.rlwe_encrypt
  %1 = lwe.rlwe_encrypt %0, %arg1 : (!pt, !sk) -> !ct
  return %1 : !ct
}
