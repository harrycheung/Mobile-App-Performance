//
// Copyright (c) 2015 Harry Cheung
//

#include "harrycheung_map_cppandroid_HCMGate.h"
#include "shared/HCMGate.h"

/*
 * Class:     harrycheung_map_cppandroid_HCMGate
 * Method:    loadGate
 * Signature: (IIDDD)J
 */
JNIEXPORT jlong JNICALL Java_harrycheung_map_cppandroid_HCMGate_loadGate
  (JNIEnv *env, jclass cls, jint gateType, jint splitNumber, jdouble latitude, jdouble longitude, jdouble bearing) {
    return (jlong)(new HCMGate(static_cast<HCMGate::Type>(gateType), splitNumber, latitude, longitude, bearing));
  }