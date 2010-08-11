/*
	Copyright 2003-2008 Laura Dickey

	This file is part of AlphaBaby.

	AlphaBaby is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	Foobar is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Foobar; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, 
	Boston, MA  02111-1307  USA

	You may contact the author at: alphababy.mac@gmail.com
*/


#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/time.h>

#define RAND_POLY	0x89384f19
#define RAND_TAB_SIZE	128

typedef unsigned int word32;

word32 g_rand_tab[RAND_TAB_SIZE];
word32 g_rand_seed = 0;
word32 g_rand_cnt = 0;

inline word32
rand_internal(word32 oldseed)
{
	word32	xor;

	xor = 0;
	if(oldseed & 1) {
		xor = RAND_POLY;
	}
	return ((oldseed >> 1) ^ xor);
}

void
rand_init(int rand_seed)
{
	word32	seed;
	int	i;

	seed = rand_seed;
	for(i = 0; i < 5; i++) {
		/* throw a few away */
		seed = rand_internal(seed);
	}
	for(i = 0; i < RAND_TAB_SIZE; i++) {
		seed = rand_internal(seed);
		g_rand_tab[i] = seed;
	}
	g_rand_seed = seed;
	g_rand_cnt = 0;
}

void
rand_init_from_time()
{
	struct timeval timeval_st;

	(void)gettimeofday(&timeval_st, 0);
	rand_init(timeval_st.tv_sec + timeval_st.tv_usec);
}

word32
rand_get_rand()
{
	word32	seed;
	word32	ret;
	word32	cnt;
	int	idx;

	if(g_rand_seed == 0) {
		rand_init_from_time();
	}

	seed = g_rand_seed;
	cnt = g_rand_cnt;

	idx = (seed ^ cnt ^ (seed >> 15)) & (RAND_TAB_SIZE - 1);
	ret = g_rand_tab[idx];
	seed = rand_internal(seed);
	g_rand_tab[idx] = seed;
	g_rand_seed = seed;
	g_rand_cnt = cnt + 1;

	return ret;
}

int
rand_get_max(int max)
{
	return (rand_get_rand() % (max+1));
}

int
rand_get_range(int min, int max)
{
	return (rand_get_max(max - min) + min);
}

