% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lasground.r
\name{lasground}
\alias{lasground}
\alias{lasground_pmf}
\title{Classify points as ground or not ground}
\usage{
lasground(las, algorithm, ...)

lasground_pmf(las, ws, th)
}
\arguments{
\item{las}{a LAS object}

\item{algorithm}{character. The name of an algorithm. Currently \code{"pmf"} is supported
(see related sections)}

\item{...}{parameters for the algorithms. These depend on the algorithm used (see details
about the algorithms)}

\item{ws}{numeric. Sequence of windows sizes to be used in filtering ground returns.
The values must be positive and in the units of the point cloud (usually meters less
likely feets)}

\item{th}{numeric. Sequence of thresholds height above the parameterized ground surface
to be considered a ground return. The values must be positive and are in the units of
the point cloud (usually meters less likely feets)}
}
\value{
Nothing. The original LAS object is updated by reference. In the 'Classification'
column a value of 2 denotes ground according to LAS specifications.
}
\description{
Implements algorithms for segmentation of ground points. The function updates the field
\code{Classification} of the input LAS object. The points classified as 'ground' are
assigned a value of 2 according to las specifications (See the ASPRS documentation for the
\href{http://www.asprs.org/a/society/committees/standards/LAS_1_4_r13.pdf}{LAS file format}).
}
\section{Progressive morphological filter (PMF)}{


This method is an implementation of the Zhang et al. (2003) algorithm (see reference).
This is not a strict implementation of Zhang et al. This algorithm works at the point
cloud level without any rasterization process. The morphological operator is applied on
the points cloud not on a raster. Also Zhang et al. proposed some formulas (eq. 4, 5 and 7)
to compute the sequence of windows sizes and thresholds. Here these parameters are free
and up to the user. The function \link{util_makeZhangParam} enable to compute the parameter
according to the original paper.
}

\examples{
LASfile <- system.file("extdata", "Topography.laz", package="lidR")
las = readLAS(LASfile, select = "xyz")

ws = seq(3,21, 3)
th = seq(0.1, 2, length.out = length(ws))

lasground(las, "pmf", ws, th)

plot(las, color = "Classification")
}
\references{
Zhang, K., Chen, S. C., Whitman, D., Shyu, M. L., Yan, J., & Zhang, C. (2003). A progressive
morphological filter for removing nonground measurements from airborne LIDAR data. IEEE
Transactions on Geoscience and Remote Sensing, 41(4 PART I), 872–882. http:#doi.org/10.1109/TGRS.2003.810682
}
