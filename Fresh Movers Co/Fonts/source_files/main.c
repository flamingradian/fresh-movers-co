// SPDX-License-Identifier: (MIT or OFL-1.1)
/*
 * Inefficient pixelated font generator. It is not recommended to use this to
 * generate fonts for high-performing applications.
 *
 * Copyright (c) 2023, Richard Acayan.
 */

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define BPP 4
#define WIDTH 8
#define HEIGHT 12
#define N_SYMS 95

const char *const names[N_SYMS] = {
	"space",
	"exclam",
	"quotedbl",
	"numbersign",
	"dollar",
	"percent",
	"ampersand",
	"quotesingle",
	"parenleft",
	"parenright",
	"asterisk",
	"plus",
	"comma",
	"hyphen",
	"period",
	"slash",
	"zero",
	"one",
	"two",
	"three",
	"four",
	"five",
	"six",
	"seven",
	"eight",
	"nine",
	"colon",
	"semicolon",
	"less",
	"equal",
	"greater",
	"question",
	"at",
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
	"bracketleft",
	"backslash",
	"bracketright",
	"asciicircum",
	"underscore",
	"grave",
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
	"braceleft",
	"bar",
	"braceright",
	"asciitilde",
};

void convert_pix(int x, int y)
{
	int left, right, top, bottom;

	left = x * 1000 / 8;
	right = (x + 1) * 1000 / 8;
	top = 800 - (y * 800 / 12);
	bottom = 800 - ((y + 1) * 800 / 12);

	printf("%d %d m 25\n"
	       " %d %d l 25\n"
	       " %d %d l 25\n"
	       " %d %d l 25\n"
	       " %d %d l 25\n",
	       left, top,
	       right, top,
	       right, bottom,
	       left, bottom,
	       left, top);
}

void convert_sym(char *buf, int sym)
{
	int i, j;

	printf("StartChar: %s\n"
	       "Encoding: %d %d 94\n"
	       "Width: 1000\n"
	       "VWidth: 0\n"
	       "Flags: HW\n"
	       "LayerCount: 2\n"
	       "Fore\n"
	       "SplineSet\n", names[sym], sym + 32, sym + 32);

	for (i = 0; i < HEIGHT; i++) {
		for (j = 0; j < WIDTH; j++) {
			if (buf[i * WIDTH * BPP + j * BPP + 3])
				convert_pix(j, i);
		}
	}

	printf("EndSplineSet\n"
	       "EndChar\n\n");
}

int main()
{
	char *buf;
	int fd, i;

	buf = malloc(BPP * WIDTH * HEIGHT * N_SYMS);

	fd = open("font.raw", O_RDONLY);

	read(fd, buf, BPP * WIDTH * HEIGHT * N_SYMS);

	for (i = 0; i < N_SYMS; i++)
		convert_sym(&buf[BPP * WIDTH * HEIGHT * i], i);
}
