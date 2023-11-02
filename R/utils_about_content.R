#' About Tab Content
#'
#' @noRd
#' @description Return HTML string containing content for the About tabPanel
#' @importFrom htmltools HTML

about_content <- function() {

  HTML(
    '
    </br>
    <h4 class="text-primary">About Mapmixture</h4>
    <p>
      Mapmixture allows users to visualise admixture as pie charts on a map. Users upload admixture proportions for each individual or site, and a coordinates file containing location data. In data sets where there are multiple individuals per site, the software will calculate the average admixture proportion for each site.
    </p>

    <h4 class="text-primary">Quick start</h4>
    <p>
      <ul>
        <li>Upload admixture file (see File Format for more info)</li>
        <li>Upload coordinates file (see File Format for more info)</li>
        <li>Click Plot Map button</li>
        <li>Adjust Map Options and re-click Plot Map button</li>
        <li>To download the map, click the download icon (top-right corner), choose download options (png, jpeg or pdf), then click the Download button</li>
      </ul>
    </p>

    <h4 class="text-primary">Defaults</h4>
    <p>
      <strong>CRS:</strong> WGS 84 / Pseudo-Mercator coordinate reference system (EPSG: 3857).</br>
      <strong>Map boundary:</strong> Bounding box of all the latitude and longitude points in the coordinates file. If invalid xmin, xmax, ymin or ymax boundary limits are entered, the former default bounding box is used.</br>
      <strong>Scales:</strong> A north arrow and scalebar is added to the map.
    </p>

    <h4 class="text-primary">Developer</h4>
    <p>
      Tom Jenkins</br>
      tom.l.jenkins@outlook.com</br>
      https://github.com/Tom-Jenkins</br>
      https://twitter.com/tom__jenkins
    </p>
    '
  )
}
