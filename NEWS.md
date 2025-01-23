## mapmixture v1.2.0.

* **Feature**. The `pie_size` argument now accepts a single value or a vector of values the same length as the number of sites. This allows users to plot pie of different sizes for different sites. 

* **Issue #28**. Changing the order of items in the legend. Fixed an issue when there are 10 or more clusters named cluster1, cluster2, ..., cluster10, clusterN. The main change is in the `func_process_input_data.R` script, whereby the renaming of cluster columns is now cluster01, cluster02, ..., instead of cluster1, cluster2, ..., to make sure the order is the same as the input.

* **Shiny app**. Package dependencies for the Shiny app only are now on the Suggest list of dependencies rather than the Imports list. When `launch_mapmixture()` is executed, the function will check the dependencies are installed or ask the user to install them.

* **Structure plot**. A permanent change in the default plotting of individuals on the structure plot. Previously, the individual column was sorted alphabetically, but users have indicated it is more ideal to preserve the original order of individuals for each site in the admixture data file. This is now the default behaviour for `structure_plot()`.

## mapmixture 1.1.4

* Added arguments to change the border colour and size of polygons. E.g. `basemap_border = TRUE`, `basemap_border_col = "black"`, `basemap_border_lwd = 0.1`. (#18)

* Added argument to not display site labels in structure plot (`display_site_labels = FALSE`).

* Changed R dependency to address issue #23.

## mapmixture 1.1.3

* Add argument `site_labels_angle` to optionally change the angle of the site labels in admixture structure plots (#15).
* Fix to #16 where the size of single-coloured pies (circles) were smaller than multi-coloured pies. This occured when the admixture file format 1 contained both fixed genotypes (0 and 1 for a cluster) and admixed genotypes (e.g. 0.5, 0.25, 0.25).
* Changed the default pie size when coordinate reference system is WGS 84 (EPSG:4326) to be more like the pie sizes of projected coordinate reference systems.
* Add argument `pie_border_col` to optionally change the colour of the pie segment borders.

## mapmixture 1.1.2

* To comply with CRAN policy, the high resolution basemap originally distributed with mapmixture v1.1.1 has been replaced with the medium resolution basemap distributed with the `rnaturalearthdata` package, which `mapmixture` now imports as default for the `mapmixture()` function. See the `mapmixture` GitHub example page for the single line of code needed to import the high resolution basemap from the `rnaturalearthhires` package.
* Added extra arguments to customise scatter plot site divider lines.
* Minor updates to documentation.

## mapmixture 1.1.1

* First release on CRAN.
