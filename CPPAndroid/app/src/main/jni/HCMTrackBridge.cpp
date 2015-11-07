//
// Copyright (c) 2015 Harry Cheung
//

#include "harrycheung_map_cppandroid_HCMTrack.h"
#include "shared/HCMGate.h"
#include "shared/HCMTrack.h"
#include <vector>

/*
 * Class:     harrycheung_map_cppandroid_HCMTrack
 * Method:    loadTrack
 * Signature: ([JJ)J
 */
JNIEXPORT jlong JNICALL Java_harrycheung_map_cppandroid_HCMTrack_loadTrack
  (JNIEnv *env, jclass cls, jlongArray array, jlong start) {
    jboolean isCopy;
    std::vector<HCMGate*> *gates = new std::vector<HCMGate*>();
    jlong *gatePtrs = (jlong *) env->GetPrimitiveArrayCritical(array, &isCopy);
    for (int i = 0; i < env->GetArrayLength(array); i++) {
      gates->push_back((HCMGate *)gatePtrs[i]);
    }
    env->ReleasePrimitiveArrayCritical(array, gatePtrs, 0);
    return (jlong)(new HCMTrack(gates, (HCMGate *)start));
  }
