//  Modified by David Teddy, II on 1/29/2017.
//  Copyright © 2014-2017 David Teddy, II. All rights reserved.
#include "DTLockDevice.h"
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <string.h>
#include <spawn.h>
#define SBSERVPATH "/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices"
#define UIKITPATH "/System/Library/Framework/UIKit.framework/UIKit"
mach_port_t *mServicePort;
void *mSBHandler;
typedef mach_port_t* (*SBSSpringBoardServerPort)();
typedef int (*SBLockDevice)(mach_port_t* port, bool enable);

void lockDevice()
{
	void *uikit = dlopen(UIKITPATH, RTLD_LAZY);
	SBSSpringBoardServerPort servicePort = dlsym(uikit, "SBSSpringBoardServerPort");
	mServicePort = servicePort();
	dlclose(uikit);
	
	mSBHandler = dlopen(SBSERVPATH, RTLD_LAZY);
	
	SBLockDevice lockdevice = dlsym(mSBHandler, "SBLockDevice");
	
	if (lockdevice)
	{
		lockdevice(mServicePort, TRUE);
	}
	if (mSBHandler)
	{
		dlclose(mSBHandler);
	}
}
