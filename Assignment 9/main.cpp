// CS 218 - Provided C++ program
//	This programs calls assembly language routines.

//  Must ensure g++ compiler is installed:
//	sudo apt-get install g++

// ***************************************************************************

#include <cstdlib>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>
#include <iomanip>

using namespace std;

// ***************************************************************
//  Define program specific constants.

#define SUCCESS 0
#define NOSUCCESS 1
#define OVERMAX 2
#define INPUTOVERFLOW 3
#define ENDOFINPUT 4

// ***************************************************************
//  Prototypes for external functions.
//	The "C" specifies to use the standard C/C++ style
//	calling convention.

extern "C" int readNonaryNum(int *, char [], char [], char [], char []);
extern "C" void combSort(int[], int);
extern "C" void lstStats(int[], int, int *, int *, int *, int *, int *);
extern "C" int lstMedian(int[], int);
extern "C" int lstAverage(int[], int);
extern "C" int lstEstMedian(int[], int);
extern "C" int lstKurtosis(int[], int, int);

// ***************************************************************
//  Begin a basic C++ program (does not use any objects).

int main()
{

// --------------------------------------------------------------------
//  Declare variables and simple display header
//	By default, C++ integers are doublewords (32-bits).

	string	bars;
	bars.append(50,'-');
	static const int	MAXLENGTH = 500;
	static const int	MINLENGTH = 3;

	int	newNumber;
	int	list[MAXLENGTH];
	int	length=0;
	int	sum, ave, min, max, med;
	int	kStat;
	char	prompt[] = "Enter Value (nonary): ";
	char	errMsg1[] = "Error, invalid. Please re-enter\n";
	char	errMsg2[] = "Error, out of range. Please re-enter\n";
	char	errMsg3[] = "Error, input too long. Please re-enter.\n";

	cout << bars << endl;
	cout << "CS 218 - Assignment #9" << endl << endl;

// --------------------------------------------------------------------
//  Loop to read numbers from user

	while (readNonaryNum(&newNumber, prompt, errMsg1,
						errMsg2, errMsg3)) {

		list[length++] = newNumber;

		if (length > MAXLENGTH)
			break;
	}

// --------------------------------------------------------------------
//  Ensure some numbers were read and, if so, display results.

	if (length < MINLENGTH) {
		cout << "Error, not enough numbers entered." << endl;
		cout << "Program terminated." << endl;

	} else {

		cout << endl << bars << endl;
		cout << "Program Results" << endl << endl;

		combSort(list, length);
		lstStats(list, length, &sum, &ave, &min, &max, &med);
		kStat = lstKurtosis(list, length, ave);

		cout << "Sorted List: " << endl;
		for (int i = 0; i < length; i++) {
			cout << list[i] << "  ";
			if ( (i%10)==9 || i==(length-1) ) cout << endl;
		}

		cout << endl;
		cout << "      Sum =  " << setw(12) << sum << endl;
		cout << "  Average =  " << setw(12) << ave << endl;
		cout << "  Minimum =  " << setw(12) << min << endl;
		cout << "  Maximum =  " << setw(12) << max << endl;
		cout << "   Median =  " << setw(12) << med << endl;
		cout << " Kurtosis =  " << setw(12) << kStat << endl;
		cout << endl;

	}

// --------------------------------------------------------------------
//  All done...

	return 0;

}

