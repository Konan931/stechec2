#pragma once

#ifdef __APPLE__
#include <pthread.h>

int pthread_timedjoin_np(pthread_t td, void **res, struct timespec *ts);
#endif
