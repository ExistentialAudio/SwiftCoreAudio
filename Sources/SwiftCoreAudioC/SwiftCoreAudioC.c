//
//  SwiftCoreAudioC.c
//  
//
//  Created by Devin Roth on 2023-06-08.
//

#include "SwiftCoreAudioC.h"

OSStatus SwiftCoreAudioObjectGetPropertyData(AudioObjectID inObjectID, const AudioObjectPropertyAddress * _Nonnull inAddress, UInt32 inQualifierDataSize, const void * _Nullable inQualifierData, UInt32 * _Nonnull ioDataSize, void * _Nonnull outData)
{
    return AudioObjectGetPropertyData(inObjectID, inAddress, inQualifierDataSize, inQualifierData, ioDataSize, outData);
}
