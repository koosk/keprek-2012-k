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
	cout << "!!!Hello World!!! Lets write some image out!" << endl;
	Vec3b intensity = I.at<Vec3b>(25, 25);
	uchar blue = intensity.val[0];
	uchar green = intensity.val[1];
	uchar red = intensity.val[2];
	cout << "blue=" << int(blue) << ", green=" << int(green) << ", red=" << int(red) << endl;

//	namedWindow("image", CV_WINDOW_AUTOSIZE);
//	imshow("image", I);
//	waitKey();

	bool imw = imwrite("cat_output.jpg", I);//valami nem jo
	if(imw){
		cout << "We did it!!!" << endl;
	}
	return EXIT_SUCCESS;
}
