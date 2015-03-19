//
// Copyright (c) 2015 Harry Cheung
//

#include "harrycheung_map_cppandroid_HCMSessionManager.h"
#include "shared/HCMSessionManager.h"

/*
 * Class:     harrycheung_map_cppandroid_HCMSessionManager
 * Method:    start
 * Signature: (JD)V
 */
JNIEXPORT void JNICALL Java_harrycheung_map_cppandroid_HCMSessionManager_start
  (JNIEnv *env, jobject obj, jlong trackPtr, jdouble startTime) {
    HCMSessionManager::instance->start((HCMTrack *)trackPtr, startTime);
  }

/*
 * Class:     harrycheung_map_cppandroid_HCMSessionManager
 * Method:    gps
 * Signature: (DDDDD)V
 */
JNIEXPORT void JNICALL Java_harrycheung_map_cppandroid_HCMSessionManager_gps
  (JNIEnv *env, jobject obj, jdouble latitude, jdouble longitude, jdouble speed, jdouble bearing, jdouble timestamp) {
    HCMSessionManager::instance->gps(latitude, longitude, speed, bearing, 5.0, 5.0, timestamp);
  }

/*
 * Class:     harrycheung_map_cppandroid_HCMSessionManager
 * Method:    end
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_harrycheung_map_cppandroid_HCMSessionManager_end
  (JNIEnv *env, jobject obj) {
    HCMSessionManager::instance->end();
  }
