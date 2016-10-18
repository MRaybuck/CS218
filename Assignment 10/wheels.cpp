#include <cstdlib>
#include <iostream>
#include <GL/gl.h>
#include <GL/glut.h>
#include <GL/freeglut.h>

using	namespace	std;

// ----------------------------------------------------------------------
//  CS 218 -> Assignment #10
//  Wheels Program.
//  Provided main...

//  Uses openGL (which must be installed).
//  openGL installation:
//	sudo apt-get update
//	sudo apt-get upgrade
//	sudo apt-get install freeglut3-dev

//  Compilation:
//	g++ -Wall -pedantic -g -c wheels.cpp -lglut -lGLU -lGL -lm


// ----------------------------------------------------------------------
//  External functions (in seperate file).

extern "C" void drawWheels();
extern "C" int getParams(int, char* [], int *, int *, int *);

// ----------------------------------------------------------------------
//  Global variables
//	Must be GLOABBBLY accessible for THE openGL
//	display routine, drawWheels().

int	color = 0;			// draw color
int	size = 0;			// screen size
int	speed = 0;			// draw speed

// ----------------------------------------------------------------------
//  Key handler function.
//	Terminates for 'x', 'q', or ESC key.
//	Ignores all other characters.

void	keyHandler(unsigned char key, int x, int y)
{
	if (key == 'x' || key == 'q' || key == 27) {
		glutLeaveMainLoop();
		exit(0);
	}
}

// ----------------------------------------------------------------------
//  Main routine.

int main(int argc, char* argv[])
{
	int	height = 0;
	int	width = 0;

	bool	stat;

	stat = getParams(argc, argv, &speed, &color, &size);

	height = size;
	width = size;

	// Debug call for display function
	//	drawWheels();

	if (stat) {
		glutInit(&argc, argv);
		glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
		glutInitWindowSize(width, height);
		glutInitWindowPosition(200, 100);
		glutCreateWindow("CS 218 Assignment #10 - Wheels Program");
		glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
		glClear(GL_COLOR_BUFFER_BIT);
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glOrtho(-1.5, 1.5, -1.5, 1.5, 0.0, 1.0);
	
		glutKeyboardFunc(keyHandler);
		glutDisplayFunc(drawWheels);

		glutMainLoop();
	}

	return 0;
}

