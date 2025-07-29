// RUN: heir-opt --cggi-to-tfhe-rust -cse %s | FileCheck %s

// This function computes add_one to an i8 input split into bits and returns
// the resulting i8 split into bits.
// CHECK: add_one
// CHECK-NOT: cggi
// CHECK-NOT: lwe
// CHECK-COUNT-11: tfhe_rust.apply_lookup_table
// CHECK: [[ALLOC:%.*]] = memref.alloc
// CHECK: return [[ALLOC]] : memref<8x!tfhe_rust.eui3>

#key = #lwe.key<slot_index = 0>
#preserve_overflow = #lwe.preserve_overflow<>
#app_data = #lwe.application_data<message_type = i1, overflow = #preserve_overflow>
#poly = #polynomial.int_polynomial<x>
#pspace = #lwe.plaintext_space<ring = #polynomial.ring<coefficientType = i3, polynomialModulus = #poly>, encoding = #lwe.constant_coefficient_encoding<scaling_factor = 268435456>>
#cspace = #lwe.ciphertext_space<ring = #polynomial.ring<coefficientType = i32, polynomialModulus = #poly>, encryption_type = msb, size = 742>
!pt_ty = !lwe.lwe_plaintext<application_data = #app_data, plaintext_space = #pspace>
!ct_ty = !lwe.lwe_ciphertext<application_data = #app_data, plaintext_space = #pspace, ciphertext_space = #cspace, key = #key>

module {
  func.func @add_one(%arg0: memref<8x!ct_ty>) -> memref<8x!ct_ty> {
    %true = arith.constant true
    %false = arith.constant false
    %c7 = arith.constant 7 : index
    %c6 = arith.constant 6 : index
    %c5 = arith.constant 5 : index
    %c4 = arith.constant 4 : index
    %c3 = arith.constant 3 : index
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %alloc = memref.alloc() : memref<8xi1>
    memref.store %true, %alloc[%c0] : memref<8xi1>
    memref.store %false, %alloc[%c1] : memref<8xi1>
    memref.store %false, %alloc[%c2] : memref<8xi1>
    memref.store %false, %alloc[%c3] : memref<8xi1>
    memref.store %false, %alloc[%c4] : memref<8xi1>
    memref.store %false, %alloc[%c5] : memref<8xi1>
    memref.store %false, %alloc[%c6] : memref<8xi1>
    memref.store %false, %alloc[%c7] : memref<8xi1>
    %0 = memref.load %arg0[%c0] : memref<8x!ct_ty>
    %1 = memref.load %alloc[%c0] : memref<8xi1>
    %2 = lwe.encode %1 { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %3 = lwe.trivial_encrypt %2 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %4 = lwe.encode %false { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %5 = lwe.trivial_encrypt %4 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %6 = cggi.lut3 %0, %3, %5 {lookup_table = 8 : ui8} : !ct_ty
    %7 = memref.load %arg0[%c1] : memref<8x!ct_ty>
    %8 = memref.load %alloc[%c1] : memref<8xi1>
    %9 = lwe.encode %8 { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %10 = lwe.trivial_encrypt %9 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %11 = cggi.lut3 %6, %7, %10 {lookup_table = 150 : ui8} : !ct_ty
    %12 = lwe.encode %8 { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %13 = lwe.trivial_encrypt %12 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %14 = cggi.lut3 %6, %7, %13 {lookup_table = 23 : ui8} : !ct_ty
    %15 = memref.load %arg0[%c2] : memref<8x!ct_ty>
    %16 = memref.load %alloc[%c2] : memref<8xi1>
    %17 = lwe.encode %16 { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %18 = lwe.trivial_encrypt %17 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %19 = cggi.lut3 %14, %15, %18 {lookup_table = 43 : ui8} : !ct_ty
    %20 = memref.load %arg0[%c3] : memref<8x!ct_ty>
    %21 = memref.load %alloc[%c3] : memref<8xi1>
    %22 = lwe.encode %21 { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %23 = lwe.trivial_encrypt %22 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %24 = cggi.lut3 %19, %20, %23 {lookup_table = 43 : ui8} : !ct_ty
    %25 = memref.load %arg0[%c4] : memref<8x!ct_ty>
    %26 = memref.load %alloc[%c4] : memref<8xi1>
    %27 = lwe.encode %26 { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %28 = lwe.trivial_encrypt %27 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %29 = cggi.lut3 %24, %25, %28 {lookup_table = 43 : ui8} : !ct_ty
    %30 = memref.load %arg0[%c5] : memref<8x!ct_ty>
    %31 = memref.load %alloc[%c5] : memref<8xi1>
    %32 = lwe.encode %31 { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %33 = lwe.trivial_encrypt %32 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %34 = cggi.lut3 %29, %30, %33 {lookup_table = 43 : ui8} : !ct_ty
    %35 = memref.load %arg0[%c6] : memref<8x!ct_ty>
    %36 = memref.load %alloc[%c6] : memref<8xi1>
    %37 = lwe.encode %36 { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %38 = lwe.trivial_encrypt %37 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %39 = cggi.lut3 %34, %35, %38 {lookup_table = 105 : ui8} : !ct_ty
    %40 = lwe.encode %36 { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %41 = lwe.trivial_encrypt %40 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %42 = cggi.lut3 %34, %35, %41 {lookup_table = 43 : ui8} : !ct_ty
    %43 = memref.load %arg0[%c7] : memref<8x!ct_ty>
    %44 = memref.load %alloc[%c7] : memref<8xi1>
    %45 = lwe.encode %44 { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %46 = lwe.trivial_encrypt %45 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %47 = cggi.lut3 %42, %43, %46 {lookup_table = 105 : ui8} : !ct_ty
    %48 = lwe.encode %1 { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %49 = lwe.trivial_encrypt %48 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %50 = lwe.encode %false { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %51 = lwe.trivial_encrypt %50 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %52 = cggi.lut3 %0, %49, %51 {lookup_table = 6 : ui8} : !ct_ty
    %53 = lwe.encode %16 { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %54 = lwe.trivial_encrypt %53 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %55 = cggi.lut3 %14, %15, %54 {lookup_table = 105 : ui8} : !ct_ty
    %56 = lwe.encode %21 { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %57 = lwe.trivial_encrypt %56 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %58 = cggi.lut3 %19, %20, %57 {lookup_table = 105 : ui8} : !ct_ty
    %59 = lwe.encode %26 { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %60 = lwe.trivial_encrypt %59 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %61 = cggi.lut3 %24, %25, %60 {lookup_table = 105 : ui8} : !ct_ty
    %62 = lwe.encode %31 { overflow = #preserve_overflow, plaintext_bits = 3 : index } : i1 to !pt_ty
    %63 = lwe.trivial_encrypt %62 { ciphertext_bits = 32 : index } : !pt_ty to !ct_ty
    %64 = cggi.lut3 %29, %30, %63 {lookup_table = 105 : ui8} : !ct_ty
    %alloc_0 = memref.alloc() : memref<8x!ct_ty>
    memref.store %47, %alloc_0[%c0] : memref<8x!ct_ty>
    memref.store %39, %alloc_0[%c1] : memref<8x!ct_ty>
    memref.store %64, %alloc_0[%c2] : memref<8x!ct_ty>
    memref.store %61, %alloc_0[%c3] : memref<8x!ct_ty>
    memref.store %58, %alloc_0[%c4] : memref<8x!ct_ty>
    memref.store %55, %alloc_0[%c5] : memref<8x!ct_ty>
    memref.store %11, %alloc_0[%c6] : memref<8x!ct_ty>
    memref.store %52, %alloc_0[%c7] : memref<8x!ct_ty>
    return %alloc_0 : memref<8x!ct_ty>
  }
}
