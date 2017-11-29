/**********************************************************************
Copyright (c) 2016 Advanced Micro Devices, Inc. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
********************************************************************/
#ifndef PATH_CL
#define PATH_CL

#include <../Baikal/Kernels/CL/payload.cl>

typedef struct _Path
{
    float3 throughput;
    int volume;
    int flags;
    int active;
    int extra1;
} Path;

typedef enum _PathFlags
{
    kNone = 0x0,
    kKilled = 0x1,
    kScattered = 0x2,
    kSpecularBounce = 0x4,
    kRefraction = 0x8,
    kTransparency = 0x10,
    kReflectionn = 0x20
} PathFlags;

bool Path_IsScattered(__global Path const* path)
{
    return path->flags & kScattered;
}

bool Path_IsSpecular(__global Path const* path)
{
    return path->flags & kSpecularBounce;
}

bool Path_IsAlive(__global Path const* path)
{
    return ((path->flags & kKilled) == 0);
}

void Path_ClearScatterFlag(__global Path* path)
{
    path->flags &= ~kScattered;
}

void Path_SetScatterFlag(__global Path* path)
{
    path->flags |= kScattered;
}


void Path_ClearSpecularFlag(__global Path* path)
{
    path->flags &= ~kSpecularBounce;
}

void Path_SetSpecularFlag(__global Path* path)
{
    path->flags |= kSpecularBounce;
}

void Path_Restart(__global Path* path)
{
    path->flags = 0;
}

int Path_GetVolumeIdx(__global Path const* path)
{
    return path->volume;
}

void Path_SetVolumeIdx(__global Path* path, int volume_idx)
{
    path->volume = volume_idx;
}

float3 Path_GetThroughput(__global Path const* path)
{
    float3 t = path->throughput;
    return t;
}

void Path_MulThroughput(__global Path* path, float3 mul)
{
    path->throughput *= mul;
}

void Path_Kill(__global Path* path)
{
    path->flags |= kKilled;
}

void Path_AddContribution(__global Path* path, __global float3* output, int idx, float3 val)
{
    output[idx] += Path_GetThroughput(path) * val;
}

void Path_SetRefractionFlag(__global Path* path)
{
    path->flags |= kRefraction;
}

void Path_ClearRefractionFlag(__global Path* path)
{
    path->flags &= ~kRefraction;
}

bool Path_IsRefraction(__global Path const* path)
{
    return path->flags & kRefraction;
}

void Path_SetTransparencyFlag(__global Path* path)
{
    path->flags |= kTransparency;
}

void Path_ClearTransparencyFlag(__global Path* path)
{
    path->flags &= ~kTransparency;
}

bool Path_IsTransparency(__global Path const* path)
{
    return path->flags & kTransparency;
}

void Path_SetReflectionFlag(__global Path* path)
{
    path->flags |= kReflectionn;
}

void Path_ClearReflectionFlag(__global Path* path)
{
    path->flags &= ~kReflectionn;
}

bool Path_IsReflection(__global Path const* path)
{
    return path->flags & kReflectionn;
}
#endif
