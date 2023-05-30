# app/logic/sample_table_html_content.R

# Import R packages / functions into module
box::use(
    shiny[HTML],
)

#' @export
about_content <- function() {

  HTML(
    '
    <h4>About this application</h4>
    <p>
      This app allows users to visualise admixture as pie charts on a map. Users upload admixture proportions for each individual or site and a coordinates file containing location data. In data sets where there are multiple individuals per site, the software will calculate the average admixture proportion for each site.
    </p>

    <h4>Quick start</h4>
    <p>
      <ul>
        <li>Upload admixture file (see File Format for more info)</li>
        <li>Upload coordinates file (see File Format for more info)</li>
        <li>Click Plot Data button</li>
        <li>Adjust Map Options and re-click Plot Data button</li>
      </ul> 
    </p>

    <h4>Author</h4>
    <p>
      Tom Jenkins</br>
      tom.l.jenkins@outlook.com</br>
      https://github.com/Tom-Jenkins</br>
      https://twitter.com/tom__jenkins
    </p>


    '
    )
}
