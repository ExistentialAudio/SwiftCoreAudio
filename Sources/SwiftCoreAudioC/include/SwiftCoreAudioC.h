//
//  SwiftCoreAudioC.h
//  
//
//  Created by Devin Roth on 2023-06-08.
//

#ifdef __cplusplus
extern "C"  {
#endif

#ifndef SwiftCoreAudioC_h
#define SwiftCoreAudioC_h

#include <stdio.h>
#include <CoreAudio/CoreAudio.h>

// This is simply a C wrapper for CoreAudio calls since calling from Swift occationally causes the app to hang.

OSStatus SwiftCoreAudioObjectGetPropertyData(AudioObjectID inObjectID, const AudioObjectPropertyAddress * _Nonnull inAddress, UInt32 inQualifierDataSize, const void * _Nullable inQualifierData, UInt32 * _Nonnull ioDataSize, void * _Nonnull outData);


#endif /* SwiftCoreAudioC_h */

#ifdef __cplusplus
}
#endif
