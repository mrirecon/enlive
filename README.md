# ENLIVE
The scripts in this repository reproduce the
experiments of:

H. Christian M. Holme, Sebastian Rosenzweig, Frank Ong, Robin N. Wilke, Michael Lustig,  Martin Uecker.
ENLIVE: An Efficient Nonlinear Method for Calibrationless and Robust Parallel Imaging.
Scientific Reports 9:3034 (2019)

The reconstruction uses an adapted version of the
[Berkeley Advanced Reconstruction Toolbox (BART)][1].
To generate the figures, the `cfl2png` command of
[`view`][2] is used.

Finally, the resulting .png's are arranged using
`imagemagick` (tested with ImageMagick 6.9.7-4).

There is a top-level `bash`-script called `doit.sh` which should automatically generate all figures and place them in the output directory. The necessary versions of `bart` and `view` are downloaded and compiled automatically.

Please note that total runtime of all scripts is likely to exceed 12 hours. However, more than 95% of that time  is spent on the SAKE reconstructions for Figures 8 and 9.



Try it in your browser:

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/mrirecon/enlive/master?filepath=Fig01-03_smallfov.ipynb)

------

If you need further help to run these scripts, I am happy to help you.
Contact information is provided in both the paper and the preprint above.

August 30, 2017 - Christian Holme

[1]: https://mrirecon.github.io/bart
[2]: https://github.com/mrirecon/view


[![BART](./bart.svg)](https://mrirecon.github.io/bart)

