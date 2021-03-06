% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lassnags.r
\name{lassnags}
\alias{lassnags}
\alias{lassnags_wing}
\title{Snag classification}
\usage{
lassnags(las, algorithm, ...)

lassnags_wing(las, neigh_radii = c(1.5, 1, 2), low_int_thrsh = 50,
  uppr_int_thrsh = 170, pt_den_req = 3, bbpr_thresholds = NULL)
}
\arguments{
\item{las}{An object of the class \code{LAS}}

\item{algorithm}{character. The name of an algorithm. At present, can only be \code{"wing2015"}.
(see sections relevant to each algorithm).}

\item{...}{parameters for the algorithms. These depend on the algorithm used.}

\item{neigh_radii}{numeric. A vector of three radii used in quantifying local-area centered
neighborhoods. See Wing et al. (2015) reference page 171 and Figure 4. Defaults are 1.5,
1, and 2 for the sphere, small cylinder and large cylinder neighborhoods, respectively.}

\item{low_int_thrsh}{numeric. The lower intensity threshold filtering value. See Wing
et al. (2015) page 171. Default is 50.}

\item{uppr_int_thrsh}{numeric. The upper intensity threshold filtering value. See Wing
et al. (2015) page 171. Default is 170.}

\item{pt_den_req}{numeric. Point density requirement based on plot-level point density
defined classes. See Wing et al. (2015) page 172. Default is 3.}

\item{bbpr_thresholds}{matrix. A 3x4 matrix providing the four average BBPR values for
each of the three neighborhood (sphere, small cylinder and large cylinder neighborhoods)
to be used in for conditional assessments and classification into the following four snag
classes: 1) general snag 2) small snag 3) live crown edge snag 4) high canopy
cover snag. See Wing et al. (2015) page 172 and Table 2. This matrix must be provided by
the user.\cr\cr
The current implementation is known to use a large amount of memory for storing the N x k
integer matrix returning the near neighbor indices for each point in the point cloud.
Improvements are possible in future package versions.}
}
\value{
Nothing, the point cloud is updated by reference.
}
\description{
Snag classification/segmentation using with several possible algorithms (see details).
The function attributes to each point of the point cloud either a number identifying a
snag class (\code{snagCls} column). The classification/segmentation is done at the point
cloud level and there is currently only one algorithm implemented (which uses LiDAR intensity
thresholds and specified neighborhoods to differentiate bole and branch from foliage points
(see details).
}
\section{Wing et al. 2016}{

This is an automated filtering algorithm that utilizes three dimensional neighborhood
lidar point-based intensity and density statistics to remove lidar points associated with
live trees and retain lidar points associated with snags developed by Wing et al (2015)
(see references).\cr\cr
Note that this algorithm strictly performs a classification based on user input while
the original publication's methods also included a segmentation step and some pre-
(filtering for first and single returns only) and post- process (filtering for only the
snag classified points prior to segmentation) tasks which are now expected to be performed
by the user. Also, this implementation may have some differences compared with the original
method due to potential mis-interpretation of the Wing et al. manuscript, specifically
Table 2 where they present four groups of conditional assessments with their required
neighborhood point density and average BBPR values (BBPR = branch and bole point ratio;
PDR = point density requirement).\cr\cr
This algorithim arrtibutes each point in the point cloud (\code{snagCls} column) into the following five snag
classes: \cr
0) live tree - not a snag\cr
1) general snag - the broadest range of snag point situations\cr
2) small snag - isolated snags with lower point densities\cr
3) live crown edge snag - snags located directly adjacent or intermixing with live trees crowns, or\cr
4) high canopy cover snag - snags protruding above live canopy in dense conditions (e.g., canopy cover >= 55\%)
}

\examples{
\dontrun{
LASfile <- system.file("extdata", "MixedConifer.laz", package="lidR")
las = readLAS(LASfile, select = "xyzi", filter="-keep_first") # Wing also included -keep_single

# For the Wing2015 method, supply a matrix of snag BranchBolePtRatio conditional
# assessment thresholds (see Wing et al. 2015, Table 2, pg. 172)
BBPRthrsh_mat <- matrix(c(0.80, 0.80, 0.70,
                          0.85, 0.85, 0.60,
                          0.80, 0.80, 0.60,
                          0.90, 0.90, 0.55),
                          nrow =3, ncol = 4)

# Run snag classification and assign classes to each point
lassnags(las, algorithm = "wing2015", bbpr_thresholds = BBPRthrsh_mat)

# Plot it all, tree and snag points...
plot(las, color="snagCls", colorPalette = rainbow(5))

# Filter and plot snag points only
snags = lasfilter(las, snagCls > 0)
plot(snags, color="snagCls", colorPalette = rainbow(5)[-1])

# Wing et al's (2015) methods ended with performing tree segmentation on the
# classified and filtered point cloud using the watershed method
}

}
\references{
Wing, Brian M.; Ritchie, Martin W.; Boston, Kevin; Cohen, Warren B.; Olsen, Michael J. 2015.
Individual snag detection using neighborhood attribute filtered airborne lidar data. Remote
Sensing of Environment. 163: 165-179 https://doi.org/10.1016/j.rse.2015.03.013\cr\cr
}
\author{
Andrew Sánchez Meador and Jean-Romain Roussel
}
