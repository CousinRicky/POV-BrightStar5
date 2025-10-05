/* brightstar5.pov version 1.2-rc.1
 * Persistence of Vision Raytracer scene description file
 * POV-Ray Object Collection demo
 *
 * A demonstration of the BrightStar5 module: a plot of stars in the Orion
 * region, using a simple cylindrical projection.
 *
 * Copyright (C) 2017 - 2025 Richard Callwood III.  Some rights reserved.
 * This file is licensed under the terms of the GNU-LGPL.
 *
 * This library is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  Please
 * visit https://www.gnu.org/licenses/lgpl-3.0.html for the text
 * of the GNU Lesser General Public License version 3.
 *
 * Vers.  Date         Comments
 * -----  ----         --------
 *        2015-Nov-22  Initial proof-of-concept: stars are plotted.
 *        2015-Nov-25  The figure is outlined.
 *        2015-Nov-27  Stars are labeled.
 *        2016-Dec-27  Limited labeling is added to the thumbnail.
 * 1.0    2017-Feb-04  Uploaded.
 * 1.1.2  2021-Aug-16  The #version is preserved between 3.5 and 3.8, and
 *                     finishes are adapted according to the version.
 *        2025-Feb-06  The new right ascension conversion function in
 *                     brightstar5.inc is used.
 *        2025-Feb-07  A spiky shape is used to represent the stars.
 *        2025-Feb-07  The color of the star labels is changed to green.
 * 1.2    2025-Oct-05  The license is upgraded to LGPL 3.
 */
// +W600 +H800
// +W160 +H120 +Obrightstar5_thumbnail +A0.0
#version max (3.5, min (3.8, version));

#declare BSC5_Gamma = 1;

global_settings { assumed_gamma BSC5_Gamma }

#include "brightstar5.inc"

// Use any Unicode font that contains both Latin and Greek letters:
#declare S_FONT = "times.ttf" // Times New Roman; Monotype Imaging/Windows
//#declare S_FONT = "Times New Roman.ttf" // Monotype Imaging/OS X
//#declare S_FONT = "DejaVuSerif.ttf" // https://dejavu-fonts.org/
//#declare S_FONT = "DroidSerif-Regular.ttf" // Ascender Corporation
//#declare S_FONT = "LiberationSerif-Regular.ttf" // Ascender Corporation

// Image dimensions:
#if (image_width > image_height) // thumbnail dimensions (4:3 landscape)
  #declare NORTH = 12;
  #declare SOUTH = -12;
  #declare EAST = 6 + 34/60; // right ascension in hours
  #declare WEST = 4 + 26/60; // right ascension in hours
  #declare BASE_MAG = 2.5;
  #declare RLINE = 0.15;
  #declare FONT_SIZE = 3.0;
#else // dimensions of full demo (3:4 portrait)
  #declare NORTH = 22;
  #declare SOUTH = -12;
  #declare EAST = 6.35; // right ascension in hours
  #declare WEST = 4.65; // right ascension in hours
  #declare BASE_MAG = 1.25;
  #declare RLINE = 0.05;
  #declare FONT_SIZE = 1.2;
#end

camera
{ orthographic
  location <BSC5_fn_RA_to_degrees ((EAST + WEST) / 2), (NORTH + SOUTH) / 2, -10>
  right BSC5_fn_RA_to_degrees (WEST - EAST) * x
  up (NORTH - SOUTH) * y
}

light_source { -10 * z, rgb 1 parallel point_at 0 }

//============================== PLOT THE STARS ================================

#default { finish { ambient 0 diffuse 1.5 } }

#declare Star = intersection
{ prism
  { bezier_spline -1, 0, 32
    <0, 1>, <0.05, 0.15>, <0.05, 0.15>, <0.3, 0.3>,
    <0.3, 0.3>, <0.15, 0.05>, <0.15, 0.05>, <1, 0>,
    <1, 0>, <0.15, -0.05>, <0.15, -0.05>, <0.3, -0.3>,
    <0.3, -0.3>, <0.05, -0.15>, <0.05, -0.15>, <0, -1>,
    <0, -1>, -<0.05, 0.15>, -<0.05, 0.15>, -<0.3, 0.3>,
    -<0.3, 0.3>, -<0.15, 0.05>, -<0.15, 0.05>, <-1, 0>,
    <-1, 0>, <-0.15, 0.05>, <-0.15, 0.05>, <-0.3, 0.3>,
    <-0.3, 0.3>, <-0.05, 0.15>, <-0.05, 0.15>, <0, 1>
  }
  sphere { -y, 1 }
  rotate <-90, 0, 45>
  scale <1, 1, 6>
}

#declare Ix = 0;
#while (Ix < BSC5_N)
  #declare RA = BSC5_Data [Ix][BSC5_RA];
  #declare Dec = BSC5_Data [Ix][BSC5_DEC];
  #if (RA >= WEST & RA <= EAST & Dec >= SOUTH & Dec <= NORTH)
    #declare Color = BSC5_Color (BSC5_Data [Ix][BSC5_COLORBV]);
    object
    { Star
     // Scale the star according to its brightness.  The sqrt is taken because
     // brightness is represented by area, not radius.  The division by .gray
     // is for visual impression; it compensates for darker colors.
      scale sqrt
      ( BSC5_fn_Brightness (BSC5_Data [Ix][BSC5_MAG], BASE_MAG) / Color.gray
      )
      pigment { Color }
      translate <BSC5_fn_RA_to_degrees (RA), Dec, 0>
    }
  #end
  #declare Ix = Ix + 1;
#end

//=========================== SEEK THE MAIN STARS ==============================

#declare Alpha = BSC5_Seek_Bayer ("Alpha", BSC5_NO_DATA, "Ori", "");
#declare Beta = BSC5_Seek_Bayer ("Beta", BSC5_NO_DATA, "Ori", "");
#declare Gamma = BSC5_Seek_Bayer ("Gamma", BSC5_NO_DATA, "Ori", "");
#declare Delta = BSC5_Seek_Bayer ("Delta", BSC5_NO_DATA, "Ori", "");
#declare Epsilon = BSC5_Seek_Bayer ("Epsilon", BSC5_NO_DATA, "Ori", "");
#declare Zeta = BSC5_Seek_Bayer ("Zeta", BSC5_NO_DATA, "Ori", "");
#declare Eta = BSC5_Seek_Bayer ("Eta", BSC5_NO_DATA, "Ori", "");
#declare Iota = BSC5_Seek_Bayer ("Iota", BSC5_NO_DATA, "Ori", "");
#declare Kappa = BSC5_Seek_Bayer ("Kappa", BSC5_NO_DATA, "Ori", "");
#declare Lambda = BSC5_Seek_Bayer ("Lambda", BSC5_NO_DATA, "Ori", "");
#declare Mu = BSC5_Seek_Bayer ("Mu", BSC5_NO_DATA, "Ori", "");
#declare Nu = BSC5_Seek_Bayer ("Nu", BSC5_NO_DATA, "Ori", "");
#declare Xi = BSC5_Seek_Bayer ("Xi", BSC5_NO_DATA, "Ori", "");
#declare Omicron2 = BSC5_Seek_Bayer ("Omicron", 2, "Ori", "");
#declare Pi1 = BSC5_Seek_Bayer ("Pi", 1, "Ori", "");
#declare Pi2 = BSC5_Seek_Bayer ("Pi", 2, "Ori", "");
#declare Pi3 = BSC5_Seek_Bayer ("Pi", 3, "Ori", "");
#declare Pi4 = BSC5_Seek_Bayer ("Pi", 4, "Ori", "");
#declare Pi5 = BSC5_Seek_Bayer ("Pi", 5, "Ori", "");
#declare Pi6 = BSC5_Seek_Bayer ("Pi", 6, "Ori", "");
#declare Chi1 = BSC5_Seek_Bayer ("Chi", 1, "Ori", "");
#declare Chi2 = BSC5_Seek_Bayer ("Chi", 2, "Ori", "");

#declare bEri = BSC5_Seek_Bayer ("Beta", BSC5_NO_DATA, "Eri", "");
#declare zTau = BSC5_Seek_Bayer ("Zeta", BSC5_NO_DATA, "Tau", "");

//============================ OUTLINE THE FIGURE ==============================

#default
{ pigment { rgb <0, 0.16, 0.04> }
  finish { ambient #if (version >= 3.7) 0 emission #end 1 diffuse 0 }
}

#macro Connect (Star1, Star2)
  cylinder
  { < BSC5_fn_RA_to_degrees (BSC5_Data [Star1][BSC5_RA]),
      BSC5_Data [Star1][BSC5_DEC],
      10
    >,
    < BSC5_fn_RA_to_degrees (BSC5_Data [Star2][BSC5_RA]),
      BSC5_Data [Star2][BSC5_DEC],
      10
    >,
    RLINE
  }
#end

// main figure
Connect (Kappa, Zeta)
Connect (Zeta, Alpha)
Connect (Alpha, Lambda)
Connect (Lambda, Gamma)
Connect (Gamma, Delta)
Connect (Delta, Eta)
Connect (Eta, Beta)

// belt
Connect (Delta, Epsilon)
Connect (Epsilon, Zeta)

// arm and club
Connect (Mu, Nu)
Connect (Nu, Chi1)
Connect (Chi1, Chi2)
Connect (Chi2, Xi)
Connect (Xi, Mu)
Connect (Mu, Alpha)

// lion's pelt
Connect (Gamma, Pi3)
Connect (Omicron2, Pi1)
Connect (Pi1, Pi2)
Connect (Pi2, Pi3)
Connect (Pi3, Pi4)
Connect (Pi4, Pi5)
Connect (Pi5, Pi6)

//============================= LABEL THE STARS ================================

// Offsets in position so that the labels do not obscure the stars:
#if (image_width <= image_height)
  #declare Labels = array[24] // full demo
  {// <x offset, y offset, star index>
    <-1.5, -0.3, Alpha>,
    <-1.5, -0.4, Beta>,
    <0.0, 0.7, Gamma>,
    <-0.8, 0.2, Delta>,
    <-0.8, 0.4, Epsilon>,
    <-1.1, -0.3, Zeta>,
    <0.2, -0.2, Eta>,
    <0.3, -0.3, Iota>,
    <-1.0, -0.3, Kappa>,
    <0.3, -0.3, Lambda>,
    <-0.7, -0.4, Mu>,
    <0.2, -0.3, Nu>,
    <-0.6, -0.3, Xi>,
    <-1.2, -0.3, Omicron2>,
    <-1.2, -0.4, Pi1>,
    <0.2, -0.3, Pi2>,
    <0.2, -0.3, Pi3>,
    <0.2, -0.3, Pi4>,
    <0.3, -0.5, Pi5>,
    <-0.5, -1.0, Pi6>,
    <0.2, -0.1, Chi1>,
    <-0.8, -0.1, Chi2>,
    <-0.9, -1.2, bEri>,
    <0.4, -0.3, zTau>,
  }
#else
  #declare Labels = array[2] // thumbnail
  {// <x offset, y offset, star index>
    <-3.1, -0.8, Alpha>,
    <2.1, -1.6, Beta>,
  }
#end

#default
{ pigment { green 0.7 }
  finish { ambient #if (version >= 3.7) 0 emission #end 1 diffuse 0 }
}

#declare I = 0;
#while (I < dimension_size (Labels, 1))
  object
  { BSC5_Bayer_label_by_index
    ( Labels[I].z,
      // Omit "Ori," but render other constellation labels:
      strcmp (BSC5_s_Data [Labels[I].z][BSC5_CONST], "Ori"),
      no, S_FONT
    )
    scale FONT_SIZE
    translate
    < BSC5_fn_RA_to_degrees (BSC5_Data [Labels[I].z][BSC5_RA]) + Labels[I].x,
      BSC5_Data [Labels[I].z][BSC5_DEC] + Labels[I].y,
      0
    >
  }
  #declare I = I + 1;
#end

// end of brightstar5.pov
