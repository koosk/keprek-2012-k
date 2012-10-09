//============================================================================
// Name        : cproba.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C, Ansi-style
//============================================================================

#include <iostream>
#include <sstream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

using namespace std;
using namespace cv;

int main(void) {
	cv::Mat I;
	I = imread("cat.jpg", CV_LOAD_IMAGE_COLOR);
	//("cat.jpg", CV_LOAD_IMAGE_GRAYSCALE);
	cout << "!!!Hello World!!!";
	return EXIT_SUCCESS;
}
