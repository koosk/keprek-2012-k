//============================================================================
// Name        : felezoPont.cpp
// Author      : Ozsvar Zoltan
// Version     : 0.1
// Copyright   : Your copyright notice
// Description : FelezoPont algoritmus
//============================================================================



#include <iostream>
#include <sstream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <cv.h>
#include <highgui.h>
#include <math.h>

#define PI 3.14159265

using namespace std;

/*
 * felezopont algoritmus, info: - http://www.inf.u-szeged.hu/oktatas/jegyzetek/KubaAttila/grafika_html/szgrafika/raszter.html
 */

cv::Mat MidpointLine(int x0,int y0,int x1,int y1, cv::Mat matrix){
	int dx, dy, incrE, incrNE, x, y, d;

    dx = x1-x0;
    dy = y1-y0;
    d = 2*dy-dx;
    incrE = 2*dy;
    incrNE = 2*(dy-dx);
    x = x0;
    y = y0;

    matrix.at<bool>(x,y)=1;
    while (x < x1){
        if (d <= 0){

             d = d + incrE;
             x = x + 1;
        }
        else
        {
             d = d + incrNE;
             x = x + 1;
             y = y + 1;
        }
        matrix.at<bool>(x,y)=1;
     }
    return matrix;
}


/*

input: képméret(csak az egyik dimenzio, mivel negyzetes a matrix)
		sugarak száma,
		vetítési irányok száma,
		vetítési irány sorszáma,
		[pixel sorszáma, sugár sorszáma]
output: a kep dimenzioival megegyezu meretu binarismatrix, ahol 1esek jelolik azokat a pixeleket amelyeket erint az adott vetito sugar

*/

inline cv::Mat felezoPontAlg(int kepMeret, int sugarakSzama, int vetIranySzama, int vetIranySorSzama, int sugarSorSzama, int sugarakKozottiTavolsag=1){
	cv::Mat eredmeny(kepMeret, kepMeret, CV_8U);

	float fokLepes = 360 / vetIranySzama; 			//megadja, hogy hany fokos lepesek vannak az adott vetuleteknel
	float irany = fokLepes * vetIranySorSzama; 		//hogy fokos szogbol erkezik a sugar
	float m = sin(irany*PI/180);
	//float B = vetIranySorSzama*fokLepes/360; //y=mx+B. 0 sorszamnal a y=0+B;  y=
	int B=sugarakKozottiTavolsag*sugarSorSzama;


	std::cout << "keplet: y=" << m << "x+" << B*sugarSorSzama << std::endl;

	int y1=0;
	int x1=0;
	int x2=0;
	int y2=0;

	//vegig meg az x-en
	for(x1=0; x1<kepMeret; x1++){
		y1=m*x1+B;
		x2=x1+1;
		y2=m*x2+B;
	//	std::cout << "y1: " << y1 << "="<< m << "*" << x1 << "+" << B << std::endl;
	//	std::cout << "y2: " << y1 << "="<< m << "*" << x2 << "+" << B << std::endl;

		if(y2<kepMeret)
		eredmeny=MidpointLine(x1,y1,x2,y2,eredmeny);
	}

	return eredmeny;
}


//		képméret(csak az egyik dimenzio, mivel negyzetes a matrix)
//		sugarak száma,
//		vetítési irányok száma,
//		vetítési irány sorszáma,
//		[pixel sorszáma, sugár sorszáma]

//PELDA
//
//int main(int argc, char** argv) {
//	cv::Mat matrix=felezoPontAlg(10,10,10,1,6,1);
//	std::cout << matrix << std::endl;
//
//}

